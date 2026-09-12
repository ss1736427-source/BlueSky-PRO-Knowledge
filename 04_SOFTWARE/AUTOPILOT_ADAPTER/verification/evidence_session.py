#!/usr/bin/env python3
"""Small orchestration layer connecting source adapters to evidence storage."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Mapping

from evidence_adapter import SourceAdapter
from evidence_recorder import append_event, finalize


class EvidenceSession:
    """Collect facts from one or more sources into one test run."""

    def __init__(
        self,
        run_dir: Path,
        test_run_id: str,
        *,
        evidence_domain_ids: list[str] | None = None,
        requirement_ids: list[str] | None = None,
        test_method_id: str | None = None,
        test_method_revision: str | None = None,
        test_case_id: str | None = None,
        test_case_revision: str | None = None,
        configuration_id: str | None = None,
        configuration: Mapping[str, Any] | None = None,
        flight_record_id: str | None = None,
        data_class: str = "DEMONSTRATION",
    ) -> None:
        if not test_run_id.strip():
            raise ValueError("test_run_id must not be empty")
        self.run_dir = Path(run_dir)
        self.run_dir.mkdir(parents=True, exist_ok=True)
        self.record_path = self.run_dir / "record.json"
        record = {
            "test_run_id": test_run_id,
            "status": "IN_PROGRESS",
            "data_class": data_class,
            "evidence_domain_ids": evidence_domain_ids or [],
            "requirement_ids": requirement_ids or [],
            "test_method_id": test_method_id,
            "test_method_revision": test_method_revision,
            "test_case_id": test_case_id,
            "test_case_revision": test_case_revision,
            "configuration_id": configuration_id,
            "flight_record_id": flight_record_id,
            "configuration": dict(configuration or {}),
            "started_at_ms": None,
            "ended_at_ms": None,
            "events": [],
            "sources": [],
        }
        self.record_path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        (self.run_dir / "events.jsonl").touch()

    def record(self, adapter: SourceAdapter, source_record: Mapping[str, Any]) -> None:
        event = adapter.normalize(source_record)
        append_event(self.run_dir, event.as_dict())
        record = json.loads(self.record_path.read_text(encoding="utf-8"))
        source = adapter.source_metadata()
        if source not in record["sources"]:
            record["sources"].append(source)
        self.record_path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    def finalize(self):
        return finalize(self.run_dir)
