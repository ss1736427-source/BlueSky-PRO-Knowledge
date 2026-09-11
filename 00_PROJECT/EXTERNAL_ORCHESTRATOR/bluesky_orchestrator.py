#!/usr/bin/env python3
"""BlueSky PRO external development orchestrator.

Polls main, determines whether the repository CI workflow is triggered by the
exact SHA, waits for that SHA's CI when required, then invokes the Windows
agent adapter after a five-second grace period. Exit code 42 means that a
user decision is required and the loop must stop for the current SHA.
"""
from __future__ import annotations

import json
import os
import subprocess
import sys
import time
from pathlib import Path

REPO = os.getenv("BS_REPO", "ss1736427-source/BlueSky-PRO-Knowledge")
BRANCH = os.getenv("BS_BRANCH", "main")
POLL_SECONDS = int(os.getenv("BS_POLL_SECONDS", "5"))
CI_GRACE_SECONDS = int(os.getenv("BS_CI_GRACE_SECONDS", "5"))
GH_TIMEOUT_SECONDS = int(os.getenv("BS_GH_TIMEOUT_SECONDS", "20"))
STATE_FILE = Path(os.getenv("BS_STATE_FILE", ".bluesky_orchestrator_state.json"))
ADAPTER = Path(os.getenv("BS_AGENT_ADAPTER", Path(__file__).with_name("agent_adapter.ps1")))
CI_PATH_PREFIXES = ("04_SOFTWARE/PLANNING/",)
CI_WORKFLOW_PATH = ".github/workflows/planning-benchmark.yml"


def gh_get(path: str):
    """Read a GitHub API endpoint using the authenticated GitHub CLI."""
    env = os.environ.copy()
    # Never allow gh to stop the orchestrator waiting for an interactive prompt.
    env["GH_PROMPT_DISABLED"] = "1"
    try:
        result = subprocess.run(
            ["gh", "api", path],
            check=True,
            capture_output=True,
            text=True,
            encoding="utf-8",
            timeout=GH_TIMEOUT_SECONDS,
            env=env,
        )
    except FileNotFoundError as exc:
        raise RuntimeError("GitHub CLI (gh) is not installed or is not in PATH") from exc
    except subprocess.TimeoutExpired as exc:
        raise RuntimeError(f"GitHub CLI request timed out after {GH_TIMEOUT_SECONDS}s: {path}") from exc
    except subprocess.CalledProcessError as exc:
        detail = (exc.stderr or exc.stdout or "GitHub CLI request failed").strip()
        raise RuntimeError(f"GitHub CLI request failed: {detail}") from exc

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
    return gh_get(f"repos/{REPO}/commits/{BRANCH}")


def workflow_required_for_commit(commit):
    """Return whether planning-benchmark.yml is triggered by this commit."""
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


def loop():
    state = load_state()
    print(f"BlueSky PRO orchestrator: {REPO}@{BRANCH}", flush=True)
    print(f"Polling: {POLL_SECONDS}s; CI grace: {CI_GRACE_SECONDS}s", flush=True)
    while True:
        try:
            print("Checking GitHub main...", flush=True)
            commit = main_commit()
            sha = commit["sha"]

            # A user-decision stop belongs to the SHA that caused it. A new
            # main commit clears the stop automatically so the next cycle can run.
            is_new_sha = sha != state.get("last_main_sha")
            if is_new_sha:
                state["last_main_sha"] = sha
                state["verified_sha"] = None
                state["decision_required"] = False
                state["ci_required"] = workflow_required_for_commit(commit)
                save_state(state)
                print(f"NEW MAIN SHA: {sha}")
                print(f"CI REQUIRED: {state['ci_required']}")
            elif state.get("decision_required"):
                print("STOP: user decision required for current SHA")
                return 42

            ci_required = bool(state.get("ci_required", True))
            if ci_required:
                status, detail = ci_state(sha)
                print(f"{sha[:12]} CI={status} ({detail})")
                if status == "PASS" and sha != state.get("verified_sha"):
                    state["verified_sha"] = sha
                    save_state(state)
                    time.sleep(CI_GRACE_SECONDS)
                    rc = invoke_agent(sha, "CI passed for the exact current main SHA; continue the next unambiguous technical step.")
                    if rc == 42:
                        state["decision_required"] = True
                        save_state(state)
                        print("STOP: agent requested user decision")
                        return 42
                    if rc != 0:
                        print(f"AGENT returned {rc}; retrying")
                elif status == "FAIL":
                    print("STOP: current SHA has failing CI")
                    return 1
            elif sha != state.get("verified_sha"):
                print(f"{sha[:12]} CI=NOT_REQUIRED (workflow path filters do not require planning CI for this commit)")
                state["verified_sha"] = sha
                save_state(state)
                time.sleep(CI_GRACE_SECONDS)
                rc = invoke_agent(sha, "No planning CI run is required for the exact current SHA by the workflow path filters; continue the next unambiguous technical step.")
                if rc == 42:
                    state["decision_required"] = True
                    save_state(state)
                    print("STOP: agent requested user decision")
                    return 42
                if rc != 0:
                    print(f"AGENT returned {rc}; retrying")
            time.sleep(POLL_SECONDS)
        except (RuntimeError, KeyError, json.JSONDecodeError) as exc:
            print(f"ORCHESTRATOR ERROR: {exc}", file=sys.stderr, flush=True)
            time.sleep(POLL_SECONDS)


if __name__ == "__main__":
    raise SystemExit(loop())
