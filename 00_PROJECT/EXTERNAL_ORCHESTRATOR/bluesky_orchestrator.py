#!/usr/bin/env python3
"""BlueSky PRO external development orchestrator.

Polls main, waits for CI for the exact SHA, then invokes a configurable
external agent after a five-second grace period. Exit code 42 means that a
user decision is required and the loop must stop.
"""
from __future__ import annotations

import json
import os
import shlex
import subprocess
import sys
import time
from pathlib import Path
from urllib.request import Request, urlopen
from urllib.error import HTTPError, URLError

REPO = os.getenv("BS_REPO", "ss1736427-source/BlueSky-PRO-Knowledge")
BRANCH = os.getenv("BS_BRANCH", "main")
POLL_SECONDS = int(os.getenv("BS_POLL_SECONDS", "5"))
CI_GRACE_SECONDS = int(os.getenv("BS_CI_GRACE_SECONDS", "5"))
STATE_FILE = Path(os.getenv("BS_STATE_FILE", ".bluesky_orchestrator_state.json"))
AGENT_COMMAND = os.getenv("BS_AGENT_COMMAND", "").strip()
API = "https://api.github.com"


def gh_get(path: str):
    token = os.getenv("GITHUB_TOKEN", "").strip()
    if not token:
        raise RuntimeError("GITHUB_TOKEN is not set")
    req = Request(API + path, headers={
        "Accept": "application/vnd.github+json",
        "Authorization": f"Bearer {token}",
        "X-GitHub-Api-Version": "2022-11-28",
        "User-Agent": "BlueSky-PRO-External-Orchestrator",
    })
    with urlopen(req, timeout=20) as response:
        return json.load(response)


def load_state():
    if not STATE_FILE.exists():
        return {"last_main_sha": None, "verified_sha": None, "decision_required": False}
    return json.loads(STATE_FILE.read_text(encoding="utf-8"))


def save_state(state):
    tmp = STATE_FILE.with_suffix(".tmp")
    tmp.write_text(json.dumps(state, indent=2, ensure_ascii=False), encoding="utf-8")
    tmp.replace(STATE_FILE)


def main_sha():
    return gh_get(f"/repos/{REPO}/commits/{BRANCH}")["sha"]


def ci_state(sha):
    runs = gh_get(f"/repos/{REPO}/actions/runs?head_sha={sha}&per_page=20").get("workflow_runs", [])
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
    if not AGENT_COMMAND:
        print("AGENT: not configured; verified CI reached.")
        return 42
    env = os.environ.copy()
    env.update({
        "BS_CURRENT_SHA": sha,
        "BS_CI_REASON": reason,
        "BS_REPO": REPO,
        "BS_BRANCH": BRANCH,
        "BS_PROTOCOL": "00_PROJECT/GITHUB_DEVELOPMENT_PROTOCOL.md",
        "BS_WORKING_RULES": "00_PROJECT/BLUE_SKY_PRO_WORKING_RULES.md",
    })
    return subprocess.run(shlex.split(AGENT_COMMAND, posix=(os.name != "nt")), env=env).returncode


def loop():
    state = load_state()
    print(f"BlueSky PRO orchestrator: {REPO}@{BRANCH}")
    while True:
        try:
            sha = main_sha()
            if state.get("decision_required"):
                print("STOP: user decision required")
                return 42
            if sha != state.get("last_main_sha"):
                state["last_main_sha"] = sha
                save_state(state)
                print(f"NEW MAIN SHA: {sha}")
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
            time.sleep(POLL_SECONDS)
        except (HTTPError, URLError, TimeoutError, RuntimeError, KeyError, json.JSONDecodeError) as exc:
            print(f"ORCHESTRATOR ERROR: {exc}", file=sys.stderr)
            time.sleep(POLL_SECONDS)


if __name__ == "__main__":
    raise SystemExit(loop())
