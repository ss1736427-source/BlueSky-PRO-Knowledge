#!/usr/bin/env python3
"""Build a controlled evidence package from a recorder session directory.

The recorder session remains untouched. The builder creates the package,
preserves the raw event stream, derives a minimal processed table, writes the
integrity manifest, and validates the package before returning it.
"""

from __future__ import annotations

import csv
import hashlib
import json
import shutil
from pathlib import Path
from typing import Any

from evidence_package_validator import REQUIRED_FILES, validate_package


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def build_evidence_package(
    session_dir: Path,
    package_dir: Path,
    *,
    data_class: str,
    requirement_ids: list[str],
    test_method_id: str,
    test_case_id: str,
    evidence_domain_ids: list[str],
) -> Path:
    """Create and validate a portable evidence package from one session."""
    session_dir = Path(session_dir)
    package_dir = Path(package_dir)
    package_dir.mkdir(parents=True, exist_ok=True)

    source_record = json.loads((session_dir / "record.json").read_text(encoding="utf-8"))
    events_source = session_dir / "events.jsonl"
    events = [json.loads(line) for line in events_source.read_text(encoding="utf-8").splitlines() if line.strip()]

    record: dict[str, Any] = dict(source_record)
    record.update(
        {
            "data_class": data_class,
            "requirement_ids": requirement_ids,
            "test_method_id": test_method_id,
            "test_case_id": test_case_id,
            "sources": sorted({event.get("source_id", "") for event in events if event.get("source_id")}),
            "evidence_domain_ids": sorted({event.get("evidence_domain_id", "") for event in events if event.get("evidence_domain_id")}),
        }
    )
    (package_dir / "record.json").write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    (package_dir / "events.jsonl").write_bytes(events_source.read_bytes())

    with (package_dir / "processed.csv").open("w", newline="", encoding="utf-8") as stream:
        writer = csv.DictWriter(stream, fieldnames=["timestamp", "source", "domain", "parameter", "value", "unit"])
        writer.writeheader()
        for event in events:
            writer.writerow(
                {
                    "timestamp": event.get("timestamp_utc", ""),
                    "source": event.get("source_id", ""),
                    "domain": event.get("evidence_domain_id", ""),
                    "parameter": event.get("parameter", ""),
                    "value": event.get("value", ""),
                    "unit": event.get("unit", ""),
                }
            )

    evidence_dir = package_dir / "evidence"
    evidence_dir.mkdir(exist_ok=True)
    shutil.copy2(events_source, evidence_dir / "raw_events.jsonl")
    (package_dir / "report.md").write_text(
        "# Evidence Package\n\n"
        f"- test_run_id: `{record.get('test_run_id', '')}`\n"
        f"- configuration_id: `{record.get('configuration_id', '')}`\n"
        f"- data_class: `{data_class}`\n"
        f"- source_events: {len(events)}\n\n"
        "This package contains source-preserving evidence and derived processing. "
        "It does not constitute regulatory acceptance.\n",
        encoding="utf-8",
    )

    manifest_entries = []
    for relative in (*REQUIRED_FILES[:3], "report.md", "evidence/raw_events.jsonl"):
        path = package_dir / relative
        manifest_entries.append({"path": relative, "sha256": _sha256(path)})
    (package_dir / "manifest.json").write_text(json.dumps({"files": manifest_entries}, indent=2) + "\n", encoding="utf-8")
    (package_dir / "manifest.sha256").write_text(_sha256(package_dir / "manifest.json") + "  manifest.json\n", encoding="utf-8")

    errors = validate_package(package_dir)
    if errors:
        raise ValueError("invalid evidence package: " + "; ".join(errors))
    return package_dir
