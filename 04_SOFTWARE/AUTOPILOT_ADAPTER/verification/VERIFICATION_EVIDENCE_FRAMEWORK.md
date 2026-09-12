# BlueSky PRO — Verification & Evidence Framework

**Status:** IMPLEMENTATION BASELINE — P0
**Purpose:** prepare the project to conduct long, evidence-driven verification campaigns without redesigning the system when physical testing begins.

## 1. Scope

The framework covers collection, storage, integrity protection, analysis inputs, export and traceability of verification data. It is designed for bench, SIL/HIL and real-UAV testing, while allowing the present prototype to operate with synthetic/demo data only.

No physical test result is created by the prototype. Until an actual test is performed, the verification result remains `PENDING` or `NOT_PERFORMED`.

## 2. Controlled chain

`Requirement → Test Method → Test Case → Configuration → Execution → Raw Data → Processed Data → Result → Evidence Package → Certification Reference`

## 3. Test identity

Every execution receives a unique `test_run_id`. The record shall retain:

- requirement IDs;
- test method and revision;
- test case and revision;
- system/build version;
- vehicle identity;
- equipment configuration;
- autopilot/firmware/protocol versions;
- measurement equipment, where applicable;
- operator/organization fields required by the approved procedure;
- start/end time;
- location and environmental conditions, when applicable;
- execution status.

## 4. Data layers

### 4.1 Raw Data — исходные данные

Values exactly as received from a source, with timestamp, parameter name, value, unit, source and optional quality/status.

Raw data is append-only for an active record and is never replaced by calculated values.

### 4.2 Processed Data — обработанные данные

Derived values such as minimum, maximum, average, duration, packet-loss statistics or other approved calculations. Each derived result references its source data and calculation definition.

### 4.3 Evidence — доказательства

Files and records that substantiate the result: raw logs, exported measurements, configuration snapshots, screen/video captures, reports and integrity manifest.

## 5. Prototype storage

The prototype uses a portable evidence directory:

```text
TEST_RUN_ID/
  record.json
  events.jsonl
  processed.csv
  evidence/
  manifest.json
  report.md
```

`events.jsonl` is the primary append-only event stream. JSON Lines (JSONL — один JSON-объект на строку) allows long-running collection without keeping the whole log in memory.

## 6. Event minimum

Each event contains:

- `timestamp_ms`;
- `parameter`;
- `value`;
- `unit`;
- `source`;
- optional `quality`;
- optional `context`.

The model is intentionally extensible so new telemetry or measurement parameters do not require a redesign of the evidence container.

## 7. Integrity

At finalization the framework calculates SHA-256 hashes (криптографическая контрольная сумма) for controlled files and writes them to `manifest.json` together with file size and relative path.

The manifest is itself hashed and recorded as the package integrity anchor.

## 8. Export

The prototype provides:

1. machine-readable JSON record;
2. CSV table for engineering analysis;
3. Markdown report for human review;
4. manifest for evidence integrity;
5. preserved raw event stream.

Later certification-document generation shall consume these controlled records rather than manually re-entering measured values.

## 9. Traceability

The framework is linked to the existing requirement matrix, especially:

- `SYS-005` — operational traceability;
- `SYS-C2-006` — record link events;
- `LOG-001` — acquire autopilot/telemetry logs;
- `LOG-002` — replay operational data;
- `LOG-003` — complete Flight Record;
- `VAL-001` — automated verification;
- `VAL-002..005` — staged verification through real UAV;
- `VAL-006` — regression after interface changes.

## 10. Separation of responsibilities

The collection mechanism records facts. The approved test procedure defines acceptance criteria. The certification package uses approved results and evidence. The logger must not invent, alter or silently downgrade results.

## 11. Future physical-test integration

Source adapters may later feed the same recorder from:

- autopilot telemetry;
- C2 link statistics;
- equipment logs;
- GNSS/RTK/NTRIP data;
- weather measurements;
- external measurement instruments;
- operator events;
- BlueSky internal events.

The storage and export contract remains unchanged.

## 12. Certification preparation rule

The framework prepares evidence; it does not declare regulatory compliance by itself. Applicable requirements, approved test methods, acceptance limits and final certification conclusions remain under the project verification/certification process.
