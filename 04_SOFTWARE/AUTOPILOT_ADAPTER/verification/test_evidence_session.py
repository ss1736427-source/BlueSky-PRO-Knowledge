import json
import tempfile
import unittest
from pathlib import Path

from evidence_adapter import C2LinkSourceAdapter
from evidence_session import EvidenceSession


class TestEvidenceSession(unittest.TestCase):
    def test_source_to_package_flow(self):
        with tempfile.TemporaryDirectory() as tmp:
            run_dir = Path(tmp) / "COM-TEST-001"
            session = EvidenceSession(
                run_dir,
                "COM-TEST-001",
                requirement_ids=["SYS-C2-006"],
                test_method_id="METHOD-COM-001",
                test_method_revision="A",
                test_case_id="CASE-COM-001",
                test_case_revision="A",
                configuration_id="CFG-DEMO-001",
                configuration={"configuration_id": "CFG-DEMO-001"},
                flight_record_id="FLIGHT-DEMO-001",
                data_class="DEMONSTRATION",
            )
            session.record(
                C2LinkSourceAdapter(),
                {
                    "timestamp_ms": 1000,
                    "parameter": "link_latency_ms",
                    "value": 42.5,
                    "unit": "ms",
                    "source": "demo-c2",
                },
            )
            manifest, anchor, report = session.finalize()

            record = json.loads((run_dir / "record.json").read_text(encoding="utf-8"))
            self.assertEqual(record["test_run_id"], "COM-TEST-001")
            self.assertEqual(record["data_class"], "DEMONSTRATION")
            self.assertEqual(record["configuration_id"], "CFG-DEMO-001")
            self.assertEqual(record["flight_record_id"], "FLIGHT-DEMO-001")
            self.assertEqual(record["test_case_id"], "CASE-COM-001")
            self.assertEqual(record["sources"], [{"source_type": "C2_LINK"}])
            self.assertEqual(len(record["events"]), 1)
            self.assertTrue(manifest.exists())
            self.assertTrue(anchor.exists())
            self.assertTrue(report.exists())


if __name__ == "__main__":
    unittest.main()
