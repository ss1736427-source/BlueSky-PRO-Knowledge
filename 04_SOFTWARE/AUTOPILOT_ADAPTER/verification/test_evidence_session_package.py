import json
from pathlib import Path

from certification_export import export_certification_index
from evidence_adapter import AutopilotTelemetrySourceAdapter
from evidence_package_validator import validate_package
from evidence_session import EvidenceSession


def test_session_finalize_verifies_and_exports(tmp_path: Path):
    run_dir = tmp_path / "run"
    session = EvidenceSession(
        run_dir,
        "TR-SESSION-001",
        evidence_domain_ids=["EC-09"],
        requirement_ids=["REQ-09-001"],
        test_method_id="TM-09-001",
        test_case_id="TC-09-001",
        configuration_id="CFG-09-001",
        data_class="DEMONSTRATION",
    )
    session.record(AutopilotTelemetrySourceAdapter(), {
        "timestamp_ms": 1000,
        "parameter": "ground_speed",
        "value": 20.0,
        "unit": "m/s",
        "source": "SRC-09",
    })

    session.finalize()

    record = json.loads((run_dir / "record.json").read_text(encoding="utf-8"))
    index = json.loads((run_dir / "certification_evidence_index.json").read_text(encoding="utf-8"))
    assert record["lifecycle_state"] == "ARCHIVE"
    assert record["status"] == "ANALYZED"
    assert index["test_run_id"] == "TR-SESSION-001"
    assert validate_package(run_dir) == []


def test_export_rejects_invalid_package(tmp_path: Path):
    run_dir = tmp_path / "invalid"
    run_dir.mkdir()
    (run_dir / "record.json").write_text(json.dumps({"test_run_id": "X"}), encoding="utf-8")
    try:
        export_certification_index(run_dir)
    except ValueError as exc:
        assert "Invalid evidence package" in str(exc)
    else:
        raise AssertionError("invalid package was exported")
