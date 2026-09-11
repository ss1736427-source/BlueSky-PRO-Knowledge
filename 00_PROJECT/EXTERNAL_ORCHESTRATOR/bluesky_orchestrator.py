#!/usr/bin/env python3
"""BlueSky PRO external development orchestrator."""
from __future__ import annotations

import json
import os
import subprocess
import sys
import time
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

REPO = os.getenv("BS_REPO", "ss1736427-source/BlueSky-PRO-Knowledge")
BRANCH = os.getenv("BS_BRANCH", "main")
POLL_SECONDS = int(os.getenv("BS_POLL_SECONDS", "1"))
CI_GRACE_SECONDS = int(os.getenv("BS_CI_GRACE_SECONDS", "5"))
AGENT_CONTINUE_SECONDS = int(os.getenv("BS_AGENT_CONTINUE_SECONDS", "5"))
GH_TIMEOUT_SECONDS = int(os.getenv("BS_GH_TIMEOUT_SECONDS", "20"))
STATE_FILE = Path(os.getenv("BS_STATE_FILE", ".bluesky_orchestrator_state.json"))
ADAPTER = Path(os.getenv("BS_AGENT_ADAPTER", Path(__file__).with_name("agent_adapter.ps1")))
CI_PATH_PREFIXES = ("04_SOFTWARE/PLANNING/",)
CI_WORKFLOW_PATH = ".github/workflows/planning-benchmark.yml"


def gh_get(path: str):
    """Read a GitHub API endpoint without requiring a GITHUB_TOKEN.

    Public repositories are read directly over HTTPS. GitHub CLI remains a
    fallback for authenticated/private-repository setups.
    """
    url = "https://api.github.com/" + path.lstrip("/")
    request = Request(url, headers={"Accept": "application/vnd.github+json", "User-Agent": "BlueSky-PRO-orchestrator"})
    try:
        with urlopen(request, timeout=GH_TIMEOUT_SECONDS) as response:
            return json.loads(response.read().decode("utf-8"))
    except (HTTPError, URLError, TimeoutError) as direct_error:
        try:
            result = subprocess.run(
                ["gh", "api", path, "--hostname", "github.com"],
                check=True,
                capture_output=True,
                text=True,
                encoding="utf-8",
                timeout=GH_TIMEOUT_SECONDS,
            )
        except FileNotFoundError as exc:
            raise RuntimeError(f"Direct GitHub API failed ({direct_error}); GitHub CLI is not installed or not in PATH") from exc
        except subprocess.TimeoutExpired as exc:
            raise RuntimeError(f"GitHub API failed and GitHub CLI timed out after {GH_TIMEOUT_SECONDS}s: {path}") from exc
        except subprocess.CalledProcessError as exc:
            detail = (exc.stderr or exc.stdout or "GitHub CLI request failed").strip()
            raise RuntimeError(f"Direct GitHub API failed ({direct_error}); GitHub CLI request failed: {detail}") from exc
        try:
            return json.loads(result.stdout)
        except json.JSONDecodeError as exc:
            raise RuntimeError("GitHub CLI returned invalid JSON") from exc


def load_state():
    if not STATE_FILE.exists():
        return {"last_main_sha": None, "verified_sha": None, "decision_required": False}
    return json.loads(STATE_FILE.read_text(encoding="utf-8"))


def save_state(state):
    tmp = STATE_FILE.with_suffix(".tmp")
    tmp.write_text(json.dumps(state, indent=2, ensure_ascii=False), encoding="utf-8")
    tmp.replace(STATE_FILE)


def main_commit():
    print("Checking GitHub main...", flush=True)
    return gh_get(f"repos/{REPO}/commits/{BRANCH}")


def workflow_required_for_commit(commit):
    files = commit.get("files", [])
    changed = [f.get("filename", "") for f in files]
    return any(p.startswith(CI_PATH_PREFIXES) for p in changed) or CI_WORKFLOW_PATH in changed


def ci_state(sha):
    runs = gh_get(f"repos/{REPO}/actions/runs?head_sha={sha}&per_page=20").get("workflow_runs", [])
    runs = [r for r in runs if r.get("head_branch") == BRANCH and r.get("head_sha") == sha]
    if not runs:
        return "UNVERIFIED", "No CI run for this SHA"
    runs.sort(key=lambda r: r.get("created_at", ""), reverse=True)
    run = runs[0]
    if run.get("status") != "completed":
        return "RUNNING", f"{run.get('name', 'workflow')}: {run.get('status')}"
    if run.get("conclusion") == "success":
        return "PASS", f"{run.get('name', 'workflow')}: success"
    return "FAIL", f"{run.get('name', 'workflow')}: {run.get('conclusion') or 'unknown'}"


def invoke_agent(sha, reason):
    if not ADAPTER.exists():
        raise RuntimeError(f"Agent adapter not found: {ADAPTER}")
    env = os.environ.copy()
    env.update({
        "BS_CURRENT_SHA": sha,
        "BS_CI_REASON": reason,
        "BS_REPO": REPO,
        "BS_BRANCH": BRANCH,
        "BS_PROTOCOL": "00_PROJECT/GITHUB_DEVELOPMENT_PROTOCOL.md",
        "BS_WORKING_RULES": "00_PROJECT/BLUE_SKY_PRO_WORKING_RULES.md",
    })
    return subprocess.run(
        ["powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", str(ADAPTER)],
        env=env,
    ).returncode


def run_agent_and_record(state, sha, reason):
    rc = invoke_agent(sha, reason)
    if rc == 42:
        state["decision_required"] = True
        save_state(state)
        print("STOP: agent requested user decision", flush=True)
        return 42
    if rc != 0:
        print(f"AGENT returned {rc}; retrying", flush=True)
    else:
        print(f"AGENT completed for {sha[:12]}; continuing automatically", flush=True)
    return rc


def loop():
    state = load_state()
    print(f"BlueSky PRO orchestrator: {REPO}@{BRANCH}", flush=True)
    print(f"Polling: {POLL_SECONDS}s; CI grace: {CI_GRACE_SECONDS}s; agent continuation: {AGENT_CONTINUE_SECONDS}s", flush=True)
    last_agent_sha = None
    last_agent_time = 0.0
    while True:
        try:
            commit = main_commit()
            sha = commit["sha"]
            is_new_sha = sha != state.get("last_main_sha")
            if is_new_sha:
                state["last_main_sha"] = sha
                state["verified_sha"] = None
                state["decision_required"] = False
                state["ci_required"] = workflow_required_for_commit(commit)
                save_state(state)
                print(f"NEW MAIN SHA: {sha}", flush=True)
                print(f"CI REQUIRED: {state['ci_required']}", flush=True)
                last_agent_sha = None
                last_agent_time = 0.0
            elif state.get("decision_required"):
                print("STOP: user decision required for current SHA", flush=True)
                return 42

            ci_required = bool(state.get("ci_required", True))
            if ci_required:
                status, detail = ci_state(sha)
                print(f"{sha[:12]} CI={status} ({detail})", flush=True)
                if status == "PASS" and sha != state.get("verified_sha"):
                    state["verified_sha"] = sha
                    save_state(state)
                    time.sleep(CI_GRACE_SECONDS)
                    last_agent_sha = sha
                    last_agent_time = time.monotonic()
                    rc = run_agent_and_record(state, sha, "CI passed for the exact current main SHA; continue the next unambiguous technical step.")
                    if rc == 42:
                        return 42
                elif status == "FAIL":
                    print("STOP: current SHA has failing CI", flush=True)
                    return 1
                elif status == "PASS" and sha == state.get("verified_sha") and last_agent_sha == sha and time.monotonic() - last_agent_time >= AGENT_CONTINUE_SECONDS:
                    last_agent_time = time.monotonic()
                    rc = run_agent_and_record(state, sha, "Continue the next unambiguous technical step. Do not wait for a new user command when no decision is required.")
                    if rc == 42:
                        return 42
            elif sha != state.get("verified_sha"):
                print(f"{sha[:12]} CI=NOT_REQUIRED (workflow path filters do not require planning CI for this commit)", flush=True)
                state["verified_sha"] = sha
                save_state(state)
                time.sleep(CI_GRACE_SECONDS)
                last_agent_sha = sha
                last_agent_time = time.monotonic()
                rc = run_agent_and_record(state, sha, "No planning CI run is required for the exact current SHA by the workflow path filters; continue the next unambiguous technical step.")
                if rc == 42:
                    return 42
            elif last_agent_sha == sha and time.monotonic() - last_agent_time >= AGENT_CONTINUE_SECONDS:
                last_agent_time = time.monotonic()
                rc = run_agent_and_record(state, sha, "Continue the next unambiguous technical step. Do not wait for a new user command when no decision is required.")
                if rc == 42:
                    return 42
            time.sleep(POLL_SECONDS)
        except (RuntimeError, KeyError, json.JSONDecodeError) as exc:
            print(f"ORCHESTRATOR ERROR: {exc}", file=sys.stderr, flush=True)
            time.sleep(POLL_SECONDS)


if __name__ == "__main__":
    raise SystemExit(loop())
