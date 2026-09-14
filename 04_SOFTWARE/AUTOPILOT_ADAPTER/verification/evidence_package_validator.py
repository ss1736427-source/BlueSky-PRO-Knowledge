#!/usr/bin/env python3
"""Validate the controlled BlueSky PRO evidence-package boundary.

This validator checks package structure, traceability identifiers, evidence
classification, raw-event presence, manifest integrity and certification
index consistency. It does not decide regulatory acceptance.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path
from typing import Any

REQUIRED_FILES = (
    "record.json",
    "events.jsonl",
    "processed.csv",
    "manifest.json",
    "manifest.sha256",
    "report.md",
)
ALLOWED_CLASSES = {
    "PHYSICAL_VERIFICATION",
    "BENCH",
    "REPLAY",
    "DEVELOPMENT",
    "DEMONSTRATION",
    "SYNTHETIC",
}


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def _nonempty(value: Any) -> bool:
    return isinstance(value, str) and bool(value.strip())


def _event_value(event: dict[str, Any], *names: str) -> Any:
    for name in names:
        if name in event:
            return event[name]
    return None


def validate_package(run_dir: Path) -> list[str]:
    run_dir = Path(run_dir)
    errors: list[str] = []

    for relative in REQUIRED_FILES:
        if not (run_dir / relative).is_file():
            errors.append(f"missing:{relative}")

    record_path = run_dir / "record.json"
    if not record_path.is_file():
        return errors

    try:
        record = json.loads(record_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        errors.append(f"record.json:{exc}")
        return errors

    for field in ("test_run_id", "configuration_id"):
        if not _nonempty(record.get(field)):
            errors.append(f"record:{field}")

    if not _nonempty(record.get("data_class")):
        errors.append("record:data_class")
    elif record["data_class"] not in ALLOWED_CLASSES:
        errors.append(f"record:data_class:unsupported:{record['data_class']}")

    if not record.get("requirement_ids"):
        errors.append("record:requirement_ids")
    if not _nonempty(record.get("test_method_id")):
        errors.append("record:test_method_id")
    if not _nonempty(record.get("test_case_id")):
        errors.append("record:test_case_id")
    if not record.get("sources"):
        errors.append("record:sources")
    if not record.get("evidence_domain_ids"):
        errors.append("record:evidence_domain_ids")

    events_path = run_dir / "events.jsonl"
    if events_path.is_file():
        try:
            lines = [line for line in events_path.read_text(encoding="utf-8").splitlines() if line.strip()]
            if not lines:
                errors.append("events.jsonl:empty")
            for number, line in enumerate(lines, 1):
                event = json.loads(line)
                required_aliases = {
                    "timestamp": ("timestamp", "timestamp_utc"),
                    "source": ("source", "source_id"),
                    "parameter": ("parameter",),
                    "value": ("value",),
                    "unit": ("unit",),
                }
                for field, aliases in required_aliases.items():
                    if _event_value(event, *aliases) is None:
                        errors.append(f"events.jsonl:{number}:missing:{field}")
                if _event_value(event, "evidence_domain_id", "domain") is None:
                    errors.append(f"events.jsonl:{number}:missing:evidence_domain_id")
        except (OSError, json.JSONDecodeError) as exc:
            errors.append(f"events.jsonl:{exc}")

    manifest_path = run_dir / "manifest.json"
    if manifest_path.is_file():
        try:
            manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
            entries = manifest.get("files")
            if not isinstance(entries, list):
                errors.append("manifest.json:files")
            else:
                for entry in entries:
                    relative = entry.get("path")
                    expected = entry.get("sha256")
                    if not _nonempty(relative) or not _nonempty(expected):
                        errors.append("manifest.json:invalid-entry")
                        continue
                    target = run_dir / relative
                    if not target.is_file():
                        errors.append(f"manifest.json:missing:{relative}")
                    elif sha256_file(target) != expected:
                        errors.append(f"manifest.json:hash-mismatch:{relative}")
        except (OSError, json.JSONDecodeError) as exc:
            errors.append(f"manifest.json:{exc}")

    manifest_sha_path = run_dir / "manifest.sha256"
    if manifest_sha_path.is_file() and manifest_path.is_file():
        try:
            text = manifest_sha_path.read_text(encoding="utf-8").strip()
            expected_manifest_sha = sha256_file(manifest_path)
            match = re.match(r"^([0-9a-fA-F]{64})\\s+manifest\\.json$", text)
            if not match:
                errors.append("manifest.sha256:format")
            elif match.group(1).lower() != expected_manifest_sha:
                errors.append("manifest.sha256:hash-mismatch:manifest.json")
        except OSError as exc:
            errors.append(f"manifest.sha256:{exc}")

    index_path = run_dir / "certification_evidence_index.json"
    if index_path.is_file():
        try:
            index = json.loads(index_path.read_text(encoding="utf-8"))
            if index.get("test_run_id") != record.get("test_run_id"):
                errors.append("certification_index:test_run_id")
            if index.get("configuration_id") != record.get("configuration_id"):
                errors.append("certification_index:configuration_id")
            if index.get("data_class") != record.get("data_class"):
                errors.append("certification_index:data_class")
        except (OSError, json.JSONDecodeError) as exc:
            errors.append(f"certification_index:{exc}")

    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate a BlueSky PRO evidence package")
    parser.add_argument("run_dir", type=Path)
    args = parser.parse_args()
    errors = validate_package(args.run_dir)
    if errors:
        print("FAIL")
        for error in errors:
            print(error)
        return 1
    print("PASS: evidence package integrity and traceability baseline")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
