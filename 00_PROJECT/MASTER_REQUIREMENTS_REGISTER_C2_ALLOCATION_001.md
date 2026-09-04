---
id: MASTER-REQUIREMENTS-C2-ALLOCATION-001
type: requirements_allocation
status: working_draft
system: BlueSky PRO
source: C2_CLAUSE_LEVEL_MAPPING_001.md
---

# BLUE SKY PRO — C2 REQUIREMENTS ALLOCATION 001

## 1. Purpose

Controlled allocation of the C2 regulatory mapping into the project requirements hierarchy. This register does not replace the authoritative regulatory sources and does not constitute an approved certification basis.

## 2. Traceability chain

```text
REGULATORY CLAUSE
→ REGULATORY REQUIREMENT
→ BLUE SKY REQUIREMENT
→ ARCHITECTURE / SAFETY / ICD
→ VERIFICATION
→ EVIDENCE
```

## 3. C2 allocation

| Requirement ID | Source | Requirement statement | Allocation | Verification |
|---|---|---|---|---|
| SYS-C2-001 | №142 | BlueSky shall maintain an explicit C2 operational mode and expose its state to the flight-management functions. | FLIGHT / C2 | analysis + test |
| SYS-C2-002 | №142 | BlueSky shall continuously monitor the configured C2 path and distinguish normal, degraded and lost states. | C2 / INTEGRATION | analysis + test |
| SYS-C2-003 | №142 | BlueSky shall apply the approved C2 QoS parameters without inventing regulatory numeric thresholds. | C2 / CONFIGURATION | inspection + test |
| SYS-C2-004 | №142 | For PROVIDER-C2, BlueSky shall enforce the defined service-area and interface boundary. | INTEGRATION / ICD | inspection + integration test |
| SYS-C2-005 | №142 | BlueSky shall record C2 state transitions and relevant events in the controlled journal. | HUB / JOURNAL | test + log inspection |
| SYS-C2-006 | №142 | On loss or unacceptable degradation of C2, BlueSky shall invoke the approved contingency behaviour defined by the applicable operational and safety requirements. | FLIGHT / SAFETY | scenario test |
| SYS-C2-007 | №142 | BlueSky shall preserve the cause/status distinction for C2 failures where required for subsequent analysis. | HUB / SAFETY | test + evidence review |
| SYS-C2-008 | №142 | BlueSky C2-related functions shall use a common controlled time reference for event ordering and traceability. | SYSTEM / HUB | analysis + test |

## 4. Boundary rule

`DIRECT-C2` means the BlueSky-controlled C2 function/interface is inside the system boundary. `PROVIDER-C2` means the external provider remains responsible for its service while BlueSky verifies and manages the defined interface obligations.

## 5. Open allocation items

- Final numerical C2 performance limits: OPEN.
- Exact certification-object applicability: OPEN.
- Allocation of contingency behaviour to flight-control software versus external aircraft system: OPEN.
- Final ICD parameter set: OPEN.
- Verification acceptance criteria: OPEN pending approved requirements baseline.

## 6. Next controlled work

```text
C2 allocation
→ SAFETY allocation
→ ICD parameter baseline
→ VERIFICATION acceptance criteria
→ REQUIREMENTS TRACEABILITY MATRIX
```

No item is marked COMPLIANT until the applicable source, requirement baseline and verification evidence are controlled.
