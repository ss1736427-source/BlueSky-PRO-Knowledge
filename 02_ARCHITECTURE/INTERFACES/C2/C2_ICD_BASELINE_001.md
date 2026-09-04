---
id: C2-ICD-BASELINE-001
type: c2_interface_control_baseline
status: controlled_working_draft
system: BlueSky PRO
basis: REG-013 / C2 clause-level mapping
---

# BLUE SKY PRO — C2 INTERFACE CONTROL BASELINE

## 1. Purpose

This document allocates the C2 requirements identified from the regulatory mapping to the controlled interface model. It does not replace the master requirements register or the ICD; it provides the C2-specific integration baseline for subsequent traceability and verification.

## 2. Authority and boundary

```text
BlueSky
├─ C2 monitoring
├─ C2 state interpretation
├─ C2-related safety logic
├─ C2 event recording
└─ controlled interface to external C2 provider

External C2 provider / network
└─ provider-side infrastructure and service obligations
```

The boundary between BlueSky and a provider-side C2 service remains an interface boundary unless the certification scope explicitly assigns provider functions to BlueSky.

## 3. C2 interface record

### IF-C2-001 — Primary C2 Interface

| Field | Working allocation |
|---|---|
| Owner | TBD |
| Provider | DIRECT-C2: BlueSky/external station; PROVIDER-C2: external C2 provider |
| Consumer | BlueSky C2 subsystem / safety functions |
| Direction | Bidirectional |
| Transport | TBD |
| Protocol | TBD |
| Data model | Controlled C2 message/state model, TBD |
| Units | Explicit per parameter |
| Reference frame | Explicit where positional data is exchanged |
| Timestamp | Required for safety-significant state/events |
| Validity | Required |
| Quality | Required where applicable |
| Freshness | Required where applicable |
| Failure behaviour | Reject / degrade / revalidate / safe response according to allocated requirement |
| Security | Authentication/integrity properties TBD by security architecture |
| Version | TBD |
| Configuration | Controlled |
| Verification | IV-C2-001..IV-C2-008 |

## 4. C2 state model

The minimum working state vocabulary is:

```text
NORMAL
DEGRADED
LOST
RESTORED
```

The transition rules shall be allocated to system requirements and safety requirements. A degraded state must not be silently treated as a lost state, and a restored state must not be treated as valid until the defined recovery criteria are satisfied.

## 5. Data classes

The interface shall distinguish at minimum:

```text
C2 connection state
C2 quality / availability
Command status
Telemetry status
Failure / recovery state
Provider-side status where applicable
Timestamp / temporal validity
Authentication / integrity status where applicable
```

No safety-significant state may be accepted without sufficient validity information to determine whether it is usable.

## 6. Failure handling

The interface shall explicitly address:

```text
missing
invalid
stale
delayed
duplicated
out-of-order
conflicting
corrupted
unauthorized
unexpected version
```

The selected response shall be deterministic and traceable to the applicable requirement. Undefined failure behaviour is a verification gap, not an implicit normal state.

## 7. DIRECT-C2 / PROVIDER-C2 allocation

### DIRECT-C2

BlueSky shall process the C2 interface associated with the direct communication path within its declared system boundary.

### PROVIDER-C2

BlueSky shall distinguish provider-side service state from its own system state and shall consume only the provider information allocated to the interface. Provider infrastructure requirements remain external unless explicitly included in the certification scope.

## 8. Requirement allocation

| Requirement | Interface | Allocation |
|---|---|---|
| SYS-REQ-080 | IF-C2-001 | KEEP / existing requirement linkage |
| SYS-REQ-081 | IF-C2-001 | KEEP / safety-related failure handling |
| SYS-REQ-082 | IF-C2-001 | KEEP / safe mission completion |
| SYS-REQ-085 | IF-C2-001 | KEEP / safety authority priority |
| SYS-REQ-086 | IF-C2-001 | KEEP / graceful degradation |
| SYS-REQ-091 | IF-C2-001 | KEEP / critical latency |
| SYS-REQ-092 | IF-C2-001 | KEEP / recovery |
| SYS-REQ-093 | IF-C2-001 | KEEP / controlled recovery |

Derived interface records remain subordinate to the existing SYS-REQ identities and do not create duplicate requirement identities.

## 9. Verification allocation

```text
IV-C2-001  Data format and schema
IV-C2-002  Units / semantics
IV-C2-003  Timestamp and freshness
IV-C2-004  Validity and quality
IV-C2-005  State transition behaviour
IV-C2-006  Failure injection and safe response
IV-C2-007  DIRECT-C2 / PROVIDER-C2 boundary
IV-C2-008  Version compatibility
```

Acceptance values remain TBD until the applicable requirement, certification basis, architecture allocation and safety analysis establish them.

## 10. Configuration control

The C2 interface is a controlled configuration item. Changes to protocol, semantics, units, timing, state transitions, failure handling or security properties require impact assessment and re-verification.

## 11. Status and next gate

**Status: CONTROLLED WORKING DRAFT — NOT BASELINED.**

Next gate:

```text
C2 ICD
→ SRS allocation
→ Safety allocation
→ Verification cases
→ Evidence index
→ Baseline decision
```
