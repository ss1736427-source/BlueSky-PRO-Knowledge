from __future__ import annotations

import hashlib
import json
from pathlib import Path

import pytest

from certification_export import export_certification_index
from evidence_package_validator import validate_package


def _write_package(root: Path) -> None:
    record = {
        "test_run_id": "TR-EXPORT-001",
        "configuration_id": "CFG-EXPORT-001",
        "data_class": "DEVELOPMENT",
        "requirement_ids": ["REQ-001"],
        "test_method_id": "TM-001",
        "test_case_id": "TC-001",
        "sources": ["SRC-01"],
        "evidence_domain_ids": ["EC-01"],
    }
    (root / "record.json").write_text(json.dumps(record), encoding="utf-8")
    (root / "events.jsonl").write_text(
        json.dumps({"timestamp": 1, "parameter": "link", "value": 1, "unit": "state", "source": "SRC-01"}) + "\n",
        encoding="utf-8",
    )
    (root / "processed.csv").write_text("parameter,value\nlink,1\n", encoding="utf-8")
    (root / "report.md").write_text("# Result\n", encoding="utf-8")
    (root / "evidence").mkdir()
    (root / "evidence" / "source.log").write_text("raw\n", encoding="utf-8")
    files = []
    for relative in ("record.json", "events.jsonl", "processed.csv", "report.md", "evidence/source.log"):
        path = root / relative
        files.append({"path": relative, "sha256": hashlib.sha256(path.read_bytes()).hexdigest()})
    (root / "manifest.json").write_text(json.dumps({"files": files}), encoding="utf-8")
    (root / "manifest.sha256").write_text("manifest placeholder\n", encoding="utf-8")


def test_export_requires_valid_package(tmp_path: Path) -> None:
    _write_package(tmp_path)
    output = export_certification_index(tmp_path)
    index = json.loads(output.read_text(encoding="utf-8"))
    assert index["test_run_id"] == "TR-EXPORT-001"
    assert index["configuration_id"] == "CFG-EXPORT-001"


def test_export_rejects_tampered_package(tmp_path: Path) -> None:
    _write_package(tmp_path)
    (tmp_path / "processed.csv").write_text("parameter,value\nlink,99\n", encoding="utf-8")
    assert "manifest.json:hash-mismatch:processed.csv" in validate_package(tmp_path)
    with pytest.raises(ValueError, match="hash-mismatch:processed.csv"):
        export_certification_index(tmp_path)
