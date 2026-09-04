---
id: C2-VERIFICATION-ACCEPTANCE-001
type: verification_acceptance_criteria
status: draft_for_agreement
system: BlueSky PRO
basis: C2-SYSTEM-REQUIREMENTS-BASELINE-001
---

# BLUE SKY PRO — C2 VERIFICATION ACCEPTANCE CRITERIA 001

## 1. Purpose

Defines the verification structure for the candidate C2 requirements. It intentionally separates verification method from final numerical acceptance limits.

## 2. Acceptance principle

A C2 requirement is not marked `VERIFIED` merely because the function exists. Verification shall demonstrate the requirement under the applicable configuration and operational state and shall produce controlled evidence.

Where a numerical limit is not yet established by the approved requirements/certification baseline, the acceptance value is `TBD` and the verification case remains open.

## 3. Verification matrix

| Requirement | Verification objective | Method | Evidence | Acceptance |
|---|---|---|---|---|
| C2-REQ-001 | Confirm explicit C2 mode is configured and exposed to dependent functions. | Inspection + Test | configuration record + test log | Correct mode is identified and consumed by dependent function; numeric criteria TBD. |
| C2-REQ-002 | Confirm NORMAL/DEGRADED/LOST determination. | Analysis + Test | test scenarios + event log | Each defined state is correctly detected and transitions are recorded. |
| C2-REQ-003 | Confirm configured C2 parameters are applied. | Inspection + Test | configuration baseline + test results | Approved parameter set is applied; values TBD until baseline approval. |
| C2-REQ-004 | Confirm PROVIDER-C2 boundary handling. | Inspection + Integration Test | ICD + integration test record | Service availability/boundary is validated according to approved interface criteria. |
| C2-REQ-005 | Confirm diagnostic distinction where source data exist. | Analysis + Test | injected-fault scenarios + logs | Available diagnostic information is preserved without unsupported attribution. |
| C2-REQ-006 | Confirm approved contingency response. | Scenario Test | safety scenario report + event log | Correct approved response occurs for each defined C2 state and mission state. |
| C2-REQ-007 | Confirm controlled C2 event recording. | Test + Log Inspection | journal extract + integrity record | Required C2 transitions/actions are present and time-ordered. |
| C2-REQ-008 | Confirm common time reference. | Analysis + Test | synchronization analysis + timestamped logs | Events can be correctly ordered within the approved timing accuracy; value TBD. |
| C2-REQ-009 | Confirm AI/optimization cannot bypass safety authority. | Analysis + Scenario Test | authority-chain test + design evidence | Safety gate remains authoritative under C2 degradation/loss. |
| C2-REQ-010 | Confirm operator visibility of C2 state/warning. | Inspection + Safety/HMI Test | HMI test record | State and required warning are visible in the approved operator workflow. |

## 4. Required test scenarios

At minimum, the future verification set shall cover:

1. NORMAL → DEGRADED → NORMAL.
2. NORMAL → LOST → approved recovery/contingency state.
3. DEGRADED → LOST.
4. LOST → RESTORED.
5. Provider-side service degradation in PROVIDER-C2.
6. Network-path degradation.
7. Ground-station/transmitter-side degradation where represented by the system boundary.
8. On-board C2 endpoint degradation where represented by the system boundary.
9. C2 state transition during mission execution.
10. C2 state transition during return.
11. C2 state transition while AI/optimization activity is present.
12. C2 event ordering and journal integrity.

## 5. Evidence chain

```text
Requirement ID
→ Verification Case ID
→ Test/Analysis Record
→ Raw Result
→ Assessment
→ Evidence ID
→ Configuration/Build ID
```

## 6. Configuration control

Verification shall identify the tested:

- BlueSky software version;
- configuration baseline;
- C2 mode;
- connected external systems/provider, if applicable;
- aircraft configuration, where relevant;
- test environment;
- test data set.

## 7. Open acceptance values

The following remain `TBD` until established by the applicable certification/operational baseline:

- C2 availability;
- continuity;
- integrity;
- latency / transaction timing;
- synchronization accuracy;
- degradation thresholds;
- loss thresholds;
- recovery criteria.

No unsupported numerical value is to be inserted merely to close a verification record.

## 8. Traceability destination

Final verification records shall be linked into:

`REQUIREMENTS_TRACEABILITY_MATRIX.md`

and

`VERIFICATION_EVIDENCE_INDEX.md`.
