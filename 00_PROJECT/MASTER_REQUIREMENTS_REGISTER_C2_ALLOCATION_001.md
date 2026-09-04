---
id: MASTER-REQUIREMENTS-C2-ALLOCATION-001
type: requirements_allocation
status: working_draft
system: BlueSky PRO
source: C2_CLAUSE_LEVEL_MAPPING_001.md
---

# BLUE SKY PRO — C2 REQUIREMENTS ALLOCATION 001

## 1. Purpose

Controlled allocation of the C2 regulatory mapping into the project requirements hierarchy. This document is a working allocation record; it does not replace the authoritative `MASTER_REQUIREMENTS_REGISTER.md`, regulatory sources, or an approved certification basis.

## 2. Traceability chain

```text
REGULATORY CLAUSE
→ APPLICABILITY
→ REGULATORY REQUIREMENT
→ EXISTING BLUE SKY REQUIREMENT / DERIVED REQUIREMENT
→ ARCHITECTURE / SAFETY / ICD
→ VERIFICATION
→ EVIDENCE
```

## 3. Candidate allocation

The following are **candidate derived records**, not new authoritative SYS-REQ identities. Existing SYS-REQ records have priority and must be reconciled before any baseline change.

| Candidate | Source | Requirement implication | Allocation | Verification | Disposition |
|---|---|---|---|---|---|
| C2-CAND-001 | №142 | explicit C2 operational mode/state | FLIGHT / C2 | analysis + test | DERIVED / compare existing |
| C2-CAND-002 | №142 | monitor C2 path and distinguish normal/degraded/lost | C2 / INTEGRATION | analysis + test | MERGE candidate |
| C2-CAND-003 | №142 | apply approved C2 QoS parameters | C2 / CONFIGURATION | inspection + test | GAP only if existing coverage is absent |
| C2-CAND-004 | №142 | enforce defined PROVIDER-C2 service/interface boundary | INTEGRATION / ICD | inspection + integration test | DERIVED |
| C2-CAND-005 | №142 | record C2 state transitions and relevant events | HUB / JOURNAL | test + log inspection | DERIVED / compare existing |
| C2-CAND-006 | №142 | invoke approved contingency behaviour on C2 loss/degradation | FLIGHT / SAFETY | scenario test | MERGE candidate |
| C2-CAND-007 | №142 | preserve cause/status distinction for C2 failures | HUB / SAFETY | test + evidence review | DERIVED / compare existing |
| C2-CAND-008 | №142 | use common controlled time reference | SYSTEM / HUB | analysis + test | DERIVED / compare existing |

## 4. Existing requirement priority

Before creating or changing a `SYS-REQ-*`, compare the candidate against the existing authoritative records, including where relevant:

```text
SYS-REQ-080
SYS-REQ-081
SYS-REQ-082
SYS-REQ-085
SYS-REQ-086
SYS-REQ-091
SYS-REQ-092
SYS-REQ-093
```

Candidate records do not override these identities.

## 5. Boundary rule

`DIRECT-C2` means the BlueSky-controlled C2 function/interface is inside the system boundary.

`PROVIDER-C2` means the external provider remains responsible for its service while BlueSky manages and verifies only the defined interface obligations inside the BlueSky boundary.

Provider infrastructure and provider internal implementation are not BlueSky SYS-REQ unless the certification scope explicitly assigns those functions to BlueSky.

## 6. Open allocation items

- Final numerical C2 performance limits: OPEN.
- Exact certification-object applicability: OPEN.
- Allocation of contingency behaviour to flight-control software versus external aircraft system: OPEN.
- Final ICD parameter set: OPEN.
- Verification acceptance criteria: OPEN pending approved requirements baseline.

## 7. Consolidation rule

```text
CANDIDATE
→ exact wording comparison
→ scope comparison
→ source / basis check
→ safety impact check
→ architecture / ICD check
→ existing verification check
→ KEEP / DERIVED / MERGE / GAP / CONFLICT
```

Only a proven `GAP` may justify creation of a new authoritative requirement.

## 8. Next controlled work

```text
C2 allocation
→ exact existing SYS-REQ reconciliation
→ SAFETY allocation
→ ICD parameter baseline
→ VERIFICATION acceptance criteria
→ REQUIREMENTS TRACEABILITY MATRIX
```

No item is marked `COMPLIANT` or `BASELINED` until the applicable source, requirement decision and controlled verification evidence exist.
