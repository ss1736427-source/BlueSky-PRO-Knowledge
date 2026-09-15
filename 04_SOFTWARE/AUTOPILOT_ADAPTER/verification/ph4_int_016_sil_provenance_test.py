#!/usr/bin/env python3
from __future__ import annotations

import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
VERIFICATION = ROOT / "04_SOFTWARE" / "AUTOPILOT_ADAPTER" / "verification"
sys.path.insert(0, str(VERIFICATION))

from evidence_adapter import AutopilotTelemetrySourceAdapter
from evidence_session import EvidenceSession


class Ph4Int016SilProvenanceTest(unittest.TestCase):
    def test_protocol_execution_reaches_evidence_session(self) -> None:
        binary = Path(__file__).resolve().parents[1] / "build" / "ph4_int_016_mavlink2_sil_provenance_fixture"
        if not binary.exists():
            binary = Path("build/autopilot-adapter/ph4_int_016_mavlink2_sil_provenance_fixture").resolve()
        self.assertTrue(binary.exists(), f"fixture binary missing: {binary}")

        line = subprocess.check_output([str(binary)], text=True).strip()
        parts = line.split("|", 8)
        self.assertEqual(parts[0], "PH4_INT_016")
        timestamp_ms = int(parts[1])
        flight_record_id, vehicle_id, command_id, state = parts[2:6]
        protocol, protocol_version, frame = parts[6:9]
        self.assertGreater(timestamp_ms, 0)
        self.assertEqual(protocol, "MAVLink2")
        self.assertEqual(protocol_version, "2")
        self.assertTrue(frame.startswith("MAVLINK2|CMD_ACK|"))

        with tempfile.TemporaryDirectory() as tmp:
            run_dir = Path(tmp) / "run"
            session = EvidenceSession(
                run_dir,
                "TEST-RUN-PH4-INT-016",
                evidence_domain_ids=["EC-17"],
                requirement_ids=["REQ-INT-MAVLINK2-SIL-PROVENANCE"],
                test_method_id="TM-PH4-INT-016",
                test_case_id="TC-PH4-INT-016",
                configuration_id="CFG-SIL-MAVLINK2-016",
                configuration={"evidence_class": "SIL_FIXTURE_ONLY", "protocol": protocol, "protocol_version": protocol_version},
                flight_record_id=flight_record_id,
                mission_id="MISSION-016",
            )
            session.record(AutopilotTelemetrySourceAdapter(), {
                "timestamp_ms": timestamp_ms,
                "parameter": "execution_state",
                "value": state,
                "unit": "state",
                "source": "AUTOPILOT_TELEMETRY",
                "quality": "FIXTURE",
                "context": {
                    "protocol": protocol,
                    "protocol_version": protocol_version,
                    "protocol_frame": frame,
                    "execution_source": "SIL_FIXTURE",
                    "vehicle_id": vehicle_id,
                    "command_id": command_id,
                },
            })
            session.finalize()

            record = json.loads((run_dir / "record.json").read_text(encoding="utf-8"))
            event = json.loads((run_dir / "events.jsonl").read_text(encoding="utf-8").splitlines()[0])
            self.assertEqual(record["flight_record_id"], flight_record_id)
            self.assertEqual(record["lifecycle_state"], "ARCHIVE")
            self.assertEqual(event["context"]["flight_record_id"], flight_record_id)
            self.assertEqual(event["context"]["execution_source"], "SIL_FIXTURE")
            self.assertEqual(event["context"]["protocol"], "MAVLink2")


if __name__ == "__main__":
    unittest.main()
