#!/usr/bin/env python3
from __future__ import annotations
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent / "verification"
sys.path.insert(0, str(ROOT))
from evidence_adapter import AutopilotTelemetrySourceAdapter, C2LinkSourceAdapter
from evidence_session import EvidenceSession


def main() -> int:
    fixture = Path(sys.argv[1])
    with tempfile.TemporaryDirectory() as tmp:
        raw = Path(tmp) / "direct_results.jsonl"
        run_dir = Path(tmp) / "RUN-PH4-INT-007"
        result = subprocess.run([str(fixture), str(raw)], capture_output=True, text=True)
        assert result.returncode == 0, result.stdout + result.stderr
        session = EvidenceSession(run_dir, "RUN-PH4-INT-007", evidence_domain_ids=["EC-01"], configuration_id="CFG-PH4-INT-007", mission_id="MISSION-FIXTURE-007", session_id="SES-PH4-INT-007", data_class="DEMONSTRATION")
        for line in raw.read_text(encoding="utf-8").splitlines():
            event = json.loads(line)
            adapter = C2LinkSourceAdapter() if event["source"] == "C2_LINK" else AutopilotTelemetrySourceAdapter()
            session.record(adapter, event)
        session.finalize()
        record = json.loads((run_dir / "record.json").read_text(encoding="utf-8"))
        assert record["lifecycle_state"] == "ARCHIVE"
        events = [json.loads(x) for x in (run_dir / "events.jsonl").read_text(encoding="utf-8").splitlines() if x]
        assert len(events) == 5
        assert any(e["value"] == "REJECTED" and e["source"] == "AUTOPILOT_ADAPTER" for e in events)
        assert any(e["value"] == "REJECTED" and e["source"] == "C2_LINK" for e in events)
        assert any(e["context"].get("reason") == "AUTOPILOT_NOT_CONNECTED" for e in events)
        assert any(e["context"].get("reason") == "CREDENTIAL_REFERENCE_REQUIRED" for e in events)
        assert all(e["context"]["session_id"] == "SES-PH4-INT-007" for e in events)
    print("PH4_INT_007_EVIDENCE_SESSION_CHAIN: PASS")
    print("actual_adapter_c2_results=PASS")
    print("evidence_session_package=PASS")
    print("provenance_preserved=PASS")
    print("verification_status=FIXTURE_ONLY")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
