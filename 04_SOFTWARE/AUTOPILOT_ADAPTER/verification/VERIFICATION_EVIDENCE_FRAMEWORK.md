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
  manifest.sha256
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

## 7. Source integration

The recorder is deliberately source-neutral. A source adapter shall translate incoming data into the common event model without changing the evidence storage contract.

The first integration boundary is:

`BlueSky / Autopilot / C2 / Equipment / External Instrument → Source Adapter → Evidence Recorder`

Supported source categories are:

- `AUTOPILOT_TELEMETRY` — telemetry from the autopilot;
- `C2_LINK` — command-and-control channel measurements;
- `EQUIPMENT` — installed equipment parameters and equipment logs;
- `GNSS_RTK_NTRIP` — navigation/reference data;
- `WEATHER` — weather observations;
- `MEASUREMENT_INSTRUMENT` — external calibrated instruments;
- `BLUESKY_EVENT` — internal BlueSky events;
- `OPERATOR_EVENT` — operator-entered factual events.

The source adapter must preserve source identity and original timestamp. It must not silently transform a measured value into a different parameter or unit.

## 8. Flight Record integration

`Flight Record (полная запись полёта)` and `Test Record (запись испытания)` remain separate records with explicit linkage.

A physical or simulated flight used for verification shall carry:

- `test_run_id` — identifier of the verification execution;
- `flight_record_id` — identifier of the flight record;
- system/build version;
- vehicle identity;
- equipment configuration;
- relevant C2/autopilot log references.

The verification record may reference a Flight Record, but must not overwrite it. This permits operational flight history and certification evidence to remain independently controlled.

## 9. C2 and Equipment evidence

For communication testing, the evidence package shall be able to preserve both:

1. BlueSky-observed C2 events and derived statistics;
2. original C2/radio/modem/equipment logs supplied by the equipment source.

For equipment testing, the same principle applies: the recorder stores the observed parameter stream and references the original equipment record where available.

## 10. Configuration Record — запись конфигурации

Before execution, the test record shall capture the configuration identity needed to reproduce the test context. The record shall support at least:

- BlueSky software/build version;
- autopilot and firmware version;
- vehicle identity;
- installed equipment and versions/identifiers where applicable;
- communication configuration;
- measurement equipment;
- test method/test case revisions.

Configuration is evidence context, not a substitute for an approved configuration-control process.

## 11. Prototype storage and export

The prototype provides:

1. machine-readable JSON record;
2. CSV table for engineering analysis;
3. Markdown report for human review;
4. manifest for evidence integrity;
5. preserved raw event stream;
6. integrity anchor for the manifest;
7. an `evidence/` area for original supporting files.

Later certification-document generation shall consume these controlled records rather than manually re-entering measured values.

## 12. Evidence package lifecycle

`INIT → COLLECT → FINALIZE → VERIFY → EXPORT → ARCHIVE`

- `INIT` creates the unique test identity and controlled metadata.
- `COLLECT` appends raw events and associates supporting files.
- `FINALIZE` closes the execution and generates processed outputs.
- `VERIFY` checks completeness, hashes and status consistency.
- `EXPORT` produces the package for engineering and certification documentation.
- `ARCHIVE` preserves the package as the evidence baseline for that execution.

No step changes a physical test result without an explicit controlled action.

## 13. Integrity

At finalization the framework calculates SHA-256 hashes (криптографическая контрольная сумма) for controlled files and writes them to `manifest.json` together with file size and relative path.

A separate `manifest.sha256` file records the SHA-256 of the completed manifest. The manifest is therefore the integrity index for the package, while the sidecar hash provides a simple external integrity check.

## 14. Traceability

The framework is linked to the existing requirement matrix, especially:

- `SYS-005` — operational traceability;
- `SYS-C2-006` — record link events;
- `LOG-001` — acquire autopilot/telemetry logs;
- `LOG-002` — replay operational data;
- `LOG-003` — complete Flight Record;
- `VAL-001` — automated verification;
- `VAL-002..005` — staged verification through real UAV;
- `VAL-006` — regression after interface changes.

The implementation shall preserve a direct reference from each verification record to the applicable requirement and test method/case revision.

## 15. Separation of responsibilities

The collection mechanism records facts. The approved test procedure defines acceptance criteria. The certification package uses approved results and evidence. The logger must not invent, alter or silently downgrade results.

## 16. Future physical-test integration

Source adapters may later feed the same recorder from autopilot telemetry, C2 link statistics, equipment logs, GNSS/RTK/NTRIP data, weather measurements, external measurement instruments, operator events and BlueSky internal events.

The storage and export contract remains unchanged.

## 17. Certification preparation rule

The framework prepares evidence; it does not declare regulatory compliance by itself. Applicable requirements, approved test methods, acceptance limits and final certification conclusions remain under the project verification/certification process.
