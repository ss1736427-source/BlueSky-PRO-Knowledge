import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
VERIFICATION = ROOT / "verification"
sys.path.insert(0, str(VERIFICATION))

from evidence_session import EvidenceSession
from evidence_adapter import AutopilotTelemetrySourceAdapter


def main(executable: str) -> None:
    with tempfile.TemporaryDirectory() as tmp:
        output = Path(tmp) / "events.jsonl"
        subprocess.run([executable, str(output)], check=True)
        events = [json.loads(line) for line in output.read_text().splitlines() if line.strip()]
        assert len(events) == 1
        event = events[0]
        assert event["context"]["flight_record_id"] == "FLIGHT-RECORD-PH4-INT-014"
        assert event["context"]["vehicle_id"] == "UAV-SIL-014"

        session = EvidenceSession(
            evidence_root=Path(tmp) / "evidence",
            evidence_domain_ids=["EC-01"],
            requirement_id="SYS-INT-001",
            test_method_id="TM-PH4-INT-014",
            test_case_id="TC-PH4-INT-014",
            configuration_id="CFG-PH4-INT-014-SIL",
            evidence_class="SIL_FIXTURE",
            flight_record_id="FLIGHT-RECORD-PH4-INT-014",
            mission_id="MISSION-PH4-INT-014",
        )
        session.record(AutopilotTelemetrySourceAdapter(), event)
        result = session.finalize()
        assert result["status"] == "VALID"

    print("PH4_INT_014_EVIDENCE_SESSION: PASS")
    print("sil_execution_to_evidence=PASS")
    print("verification_status=SIL_FIXTURE_ONLY")


if __name__ == "__main__":
    main(sys.argv[1])
