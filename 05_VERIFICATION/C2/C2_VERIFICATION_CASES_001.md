---
id: C2-VERIFICATION-CASES-001
type: c2_verification_case_definitions
status: controlled_working_draft
system: BlueSky PRO
basis: C2-ICD-BASELINE-001; C2-SAFETY-ALLOCATION-001; VERIFICATION-PLAN-001
authority: MASTER-REQUIREMENTS-REGISTER-001
---

# BLUE SKY PRO — C2 VERIFICATION CASE DEFINITIONS 001

## 1. Purpose

Define the controlled verification cases allocated to the C2 interface and safety records. This document defines case identity, scope and expected verification outcomes; it does not record execution, pass/fail results or evidence.

The cases address the existing `IV-C2-001..IV-C2-008` allocation and do not create new system or safety requirements.

## 2. Control boundary

The cases verify BlueSky responsibilities within `IF-C2-001`. Provider-side infrastructure and service obligations remain external unless the approved certification scope assigns them to BlueSky.

Quantitative acceptance values remain `TBD` until the applicable operational/certification basis establishes them. No case in this record declares compliance.

## 3. Case definitions

| Case ID | Existing allocation | Objective | Method | Status |
|---|---|---|---|---|
| C2-V01 | IV-C2-001 | Verify the controlled C2 message/state schema and required fields are identified and processed consistently. | Inspection + integration test | DEFINED |
| C2-V02 | IV-C2-002 | Verify units and semantic meaning of C2 parameters are explicit and interpreted consistently. | Inspection + analysis | DEFINED |
| C2-V03 | IV-C2-003 | Verify timestamps, common time reference and freshness handling support ordering and validity decisions. | Analysis + test | DEFINED |
| C2-V04 | IV-C2-004 | Verify validity and quality information is evaluated before safety-significant C2 state is accepted. | Test + failure injection | DEFINED |
| C2-V05 | IV-C2-005 | Verify NORMAL, DEGRADED, LOST and RESTORED transitions follow controlled criteria and are not silently conflated. | Scenario test | DEFINED |
| C2-V06 | IV-C2-006 | Verify missing, invalid, stale, delayed, duplicated, out-of-order, conflicting, corrupted and unauthorized inputs produce the allocated safe response. | Failure injection + scenario test | DEFINED |
| C2-V07 | IV-C2-007 | Verify DIRECT-C2 and PROVIDER-C2 responsibilities are distinguished at the controlled interface boundary. | Inspection + integration test | DEFINED |
| C2-V08 | IV-C2-008 | Verify incompatible or unexpected interface versions are detected and handled under configuration control. | Inspection + integration test | DEFINED |

## 4. Current basis and qualitative acceptance criteria

The following allocation completes the current traceability pass without promoting
candidate requirements to the authoritative master register. `C2-REQ-*` and
`SYS-C2-*` references remain subordinate to the controlled records identified
below.

| Case | Current requirement/design basis | Qualitative acceptance criterion |
|---|---|---|
| C2-V01 | `C2-REQ-001`; `SYS-C2-001`; `IF-C2-001`; `C2-142-001`, `C2-142-003` | The controlled message/state fields, direction and operating-mode distinction are identified, processed consistently, and rejected or reported when structurally invalid. |
| C2-V02 | `C2-REQ-003`; `SYS-C2-003`; `IF-C2-001` data model and units; `C2-142-004`, `C2-142-011`, `C2-142-013`, `C2-142-014` | Each exercised parameter has an explicit unit and semantic meaning; incompatible or ambiguous interpretation is detected rather than accepted as valid input. |
| C2-V03 | `C2-REQ-008`; `SYS-C2-008`; `C2-F-005`; `IF-C2-001` timestamp/freshness allocation | Events and state data can be ordered using the controlled time reference, and stale or temporally invalid data is not accepted as current. |
| C2-V04 | `C2-REQ-002`, `C2-REQ-003`; `SYS-C2-002`, `SYS-C2-003`; `C2-F-001`, `C2-F-004`; `C2-142-018`, `C2-142-020` | Validity and quality are evaluated before safety-significant state use; invalid or stale status produces the allocated degraded, rejected, or quarantined handling. |
| C2-V05 | `C2-REQ-002`, `C2-REQ-006`; `C2-F-001`, `C2-F-002`, `C2-F-003`; `C2-142-018`, `C2-142-024`, `C2-142-025` | NORMAL, DEGRADED, LOST and RESTORED transitions are distinguishable, observable, time-ordered, and follow the allocated transition and recovery logic. |
| C2-V06 | `C2-REQ-005`, `C2-REQ-006`; `C2-F-001..005`; `IF-C2-001` failure handling | Each listed abnormal input produces a deterministic response covered by the allocated safety/interface behaviour, with no unsafe silent fallback to normal operation. |
| C2-V07 | `C2-REQ-004`; `SYS-C2-004`; `IF-C2-001` DIRECT-C2/PROVIDER-C2 allocation; `C2-142-001`, `C2-142-003`, `C2-142-017` | The two operating profiles and their responsibility boundaries are distinguishable; provider-side obligations are not represented as BlueSky implementation evidence. |
| C2-V08 | `C2-REQ-004`, `C2-REQ-005`; `IF-C2-001` version/configuration control | An incompatible or unexpected interface version is detected, prevented from unvalidated use, and handled through the controlled compatibility or safe-response path. |

The criteria above are qualitative. No latency, continuity, availability,
integrity, loss-detection, recovery, or coverage value is inferred by this
record; such values remain `TBD` pending the applicable approved
operational/certification basis.

## 5. Common case controls

Each case shall identify before execution:

```text
Requirement/design basis
Configuration ID
System/software version
Interface version
Test environment
Inputs/dataset
Acceptance criteria
Reviewer
```

Execution records shall separately capture:

```text
Actual result
Pass/fail disposition
Anomalies
Evidence ID
Review record
```

Unknown values remain `TBD`; they are not treated as passing defaults.

## 6. Traceability

```text
C2-V01 → IF-C2-001 → C2-142-004/011/013/014 (where applicable)
C2-V02 → IF-C2-001 → controlled units/semantics allocation
C2-V03 → IF-C2-001 → C2-F-005 / SYS-C2-008
C2-V04 → IF-C2-001 → C2-F-001 / C2-F-004 / SYS-C2-003
C2-V05 → IF-C2-001 → C2-F-001 / C2-F-002 / C2-F-003
C2-V06 → IF-C2-001 → C2-F-001..005 and allocated safe response
C2-V07 → IF-C2-001 → DIRECT-C2 / PROVIDER-C2 boundary
C2-V08 → IF-C2-001 → controlled version/configuration allocation
```

The exact requirement linkage remains subordinate to the authoritative master register and the applicable approved baseline.

## 7. Evidence gate

```text
CASE DEFINITION: controlled by this record
EXECUTION RESULT: not created
EVIDENCE: not created
VERIFICATION STATUS: ALLOCATED / NOT VERIFIED
```

No `PASSED`, `VERIFIED` or certification claim is made by this document.

## 8. Remaining controlled actions

1. Establish the controlled test configuration and environment for each case
   using `C2-VERIFICATION-CONFIGURATION-001` / `C2-VER-CFG-001`.
2. Carry the reconciled requirement/design basis from
   `C2-RECONCILIATION-PASS-003` into each execution result.
3. Execute the cases and create separate result/evidence records.
4. Update the verification register and evidence index from the resulting records.

**Status: CONTROLLED WORKING DRAFT — CASE DEFINITIONS COMPLETE; EXECUTION OPEN.**
