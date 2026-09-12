from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[3]
FLEET = ROOT / "03_FLEET"

REQUIRED = {
    "BLUESKY-UNIVERSAL-ADAPTER-CONTRACT-001": FLEET / "BLUESKY_UNIVERSAL_ADAPTER_CONTRACT_001.md",
    "BLUESKY-CANONICAL-VEHICLE-EQUIPMENT-SCHEMA-001": FLEET / "BLUESKY_CANONICAL_VEHICLE_EQUIPMENT_SCHEMA_001.md",
    "BLUESKY-ADAPTER-CONFORMANCE-MATRIX-001": FLEET / "BLUESKY_ADAPTER_CONFORMANCE_MATRIX_001.md",
    "BLUESKY-ADAPTER-CONTRACT-TEST-STUB-001": FLEET / "BLUESKY_ADAPTER_CONTRACT_TEST_STUB_001.md",
    "BLUESKY-ADAPTER-CONFIGURATION-BASELINE-001": FLEET / "BLUESKY_ADAPTER_CONFIGURATION_BASELINE_001.md",
    "BLUESKY-ADAPTER-CONFORMANCE-CHECKLIST-001": FLEET / "BLUESKY_ADAPTER_CONFORMANCE_CHECKLIST_001.md",
}

EXPECTED_LINKS = {
    "BLUESKY-UNIVERSAL-ADAPTER-CONTRACT-001": [
        "BLUESKY-CANONICAL-VEHICLE-EQUIPMENT-SCHEMA-001",
        "BLUESKY-ADAPTER-CONFORMANCE-MATRIX-001",
        "BLUESKY-ADAPTER-CONTRACT-TEST-STUB-001",
        "BLUESKY-ADAPTER-CONFIGURATION-BASELINE-001",
        "BLUESKY-ADAPTER-CONFORMANCE-CHECKLIST-001",
    ],
    "BLUESKY-ADAPTER-CONFORMANCE-MATRIX-001": [
        "BLUESKY-UNIVERSAL-ADAPTER-CONTRACT-001",
        "BLUESKY-CANONICAL-VEHICLE-EQUIPMENT-SCHEMA-001",
        "BLUESKY-ADAPTER-CONTRACT-TEST-STUB-001",
    ],
    "BLUESKY-ADAPTER-CONTRACT-TEST-STUB-001": [
        "BLUESKY-ADAPTER-CONFORMANCE-MATRIX-001",
        "BLUESKY-CANONICAL-VEHICLE-EQUIPMENT-SCHEMA-001",
        "BLUESKY-ADAPTER-CONFIGURATION-BASELINE-001",
    ],
    "BLUESKY-ADAPTER-CONFIGURATION-BASELINE-001": [
        "BLUESKY-ADAPTER-CONTRACT-TEST-STUB-001",
        "BLUESKY-CANONICAL-VEHICLE-EQUIPMENT-SCHEMA-001",
    ],
    "BLUESKY-ADAPTER-CONFORMANCE-CHECKLIST-001": [
        "BLUESKY-UNIVERSAL-ADAPTER-CONTRACT-001",
        "BLUESKY-CANONICAL-VEHICLE-EQUIPMENT-SCHEMA-001",
        "BLUESKY-ADAPTER-CONFORMANCE-MATRIX-001",
        "BLUESKY-ADAPTER-CONTRACT-TEST-STUB-001",
        "BLUESKY-ADAPTER-CONFIGURATION-BASELINE-001",
    ],
}

FORBIDDEN_INTERNAL_TERMS = (
    "getPayload",
    "payloadFeatures",
    "PayloadState",
    "UAV / PAYLOAD",
)

errors = []

for artifact_id, path in REQUIRED.items():
    if not path.is_file():
        errors.append(f"missing artifact: {artifact_id} -> {path}")
        continue

    text = path.read_text(encoding="utf-8")
    if f"id: {artifact_id}" not in text:
        errors.append(f"missing controlled id: {artifact_id} -> {path}")

    for linked_id in EXPECTED_LINKS.get(artifact_id, []):
        if linked_id not in text:
            errors.append(f"missing reference: {artifact_id} -> {linked_id}")

for path in (ROOT / "04_SOFTWARE/AUTOPILOT_ADAPTER").rglob("*"):
    if path.resolve() == Path(__file__).resolve():
        continue
    if not path.is_file() or path.suffix not in {".hpp", ".cpp", ".yaml", ".md"}:
        continue
    text = path.read_text(encoding="utf-8")
    for term in FORBIDDEN_INTERNAL_TERMS:
        if term in text:
            errors.append(f"forbidden internal terminology: {term} -> {path}")

if errors:
    print("ADAPTER_CHAIN_CONSISTENCY: FAIL")
    for error in errors:
        print(f"- {error}")
    sys.exit(1)

print("ADAPTER_CHAIN_CONSISTENCY: PASS")
print(f"validated_artifacts={len(REQUIRED)}")
print("real_test_evidence=NOT_CHECKED")
print("verification_status=NOT_GRANTED")
