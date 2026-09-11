---
id: VERIFICATION-REGISTER-001
type: verification_register
status: draft_for_agreement
version: 0.2
parent: VERIFICATION
authority: NAVIGATION_VERIFICATION_MODEL-001; NAVIGATION_TEST_VECTORS-001
---

# BlueSky PRO — Verification Register

## 1. Назначение

Единый реестр идентичности verification cases проекта. Реестр не является реестром результатов испытаний и не заменяет Evidence.

Правило:

```text
ONE VERIFICATION CASE
→ ONE STABLE ID
→ CONTROLLED DEFINITION
→ MANY REQUIREMENT / DESIGN RELATIONSHIPS
```

## 2. Граница

Реестр отделяет:

```text
Verification Case Definition
≠
Test Execution Result
≠
Evidence
```

Наличие записи `READY` не означает, что проверка выполнена.

## 3. Источник идентичности

Первичные verification IDs, уже определённые в Navigation Verification Model, сохраняются:

```text
NAV-V01 … NAV-V20
```

Математические тестовые векторы имеют отдельную идентичность:

```text
NAV-TV-001 … NAV-TV-010
```

`NAV-V*` и `NAV-TV-*` не объединяются в один набор ID.

## 4. Verification hierarchy

```text
Requirement / Design Basis
        ↓
Verification Method
        ↓
Verification Case
        ↓
Test Vector / Dataset
        ↓
Execution
        ↓
Result
        ↓
Evidence
```

## 5. Current controlled Navigation cases

| ID | Case | Basis | Status |
|---|---|---|---|
| NAV-V01 | No wind | Navigation Verification Model | DEFINED |
| NAV-V02 | Crosswind | Navigation Verification Model | DEFINED |
| NAV-V03 | Headwind | Navigation Verification Model | DEFINED |
| NAV-V04 | Tailwind | Navigation Verification Model | DEFINED |
| NAV-V05 | Changing wind | Navigation Verification Model | DEFINED |
| NAV-V06 | Route deviation | Navigation Verification Model | DEFINED |
| NAV-V07 | WP transition | Navigation Verification Model | DEFINED |
| NAV-V08 | Stale navigation | Navigation Verification Model | DEFINED |
| NAV-V09 | Invalid navigation | Navigation Verification Model | DEFINED |
| NAV-V10 | Missing critical input | Navigation Verification Model | DEFINED |
| NAV-V11 | Conflicting sources | Navigation Verification Model | DEFINED |
| NAV-V12 | Degraded source | Navigation Verification Model | DEFINED |
| NAV-V13 | Communication degradation | Navigation Verification Model | DEFINED |
| NAV-V14 | Energy degradation | Navigation Verification Model | DEFINED |
| NAV-V15 | Dynamic Return degradation | Navigation Verification Model | DEFINED |
| NAV-V16 | Material runtime change | Navigation Verification Model | DEFINED |
| NAV-V17 | Revalidation required | Navigation Verification Model | DEFINED |
| NAV-V18 | Safety rejection | Navigation Verification Model | DEFINED |
| NAV-V19 | Multi-UAV | Navigation Verification Model | DEFINED |
| NAV-V20 | Planned vs Simulated vs Actual | Navigation Verification Model | DEFINED |

## 6. Current Navigation test vectors

| ID | Function | Source document | Status |
|---|---|---|---|
| NAV-TV-001 | Ground velocity | NAVIGATION_TEST_VECTORS_001 | READY |
| NAV-TV-002 | Groundspeed | NAVIGATION_TEST_VECTORS_001 | READY |
| NAV-TV-003 | Track | NAVIGATION_TEST_VECTORS_001 | READY |
| NAV-TV-004 | WCA | NAVIGATION_TEST_VECTORS_001 | READY |
| NAV-TV-005 | Drift | NAVIGATION_TEST_VECTORS_001 | READY |
| NAV-TV-006 | Cross-track error | NAVIGATION_TEST_VECTORS_001 | READY |
| NAV-TV-007 | Along-track position | NAVIGATION_TEST_VECTORS_001 | READY |
| NAV-TV-008 | ETA | NAVIGATION_TEST_VECTORS_001 | READY |
| NAV-TV-009 | Return feasibility | NAVIGATION_TEST_VECTORS_001 | REQUIRES ENERGY MODEL |
| NAV-TV-010 | Coordinate reference | NAVIGATION_TEST_VECTORS_001 | REQUIRES CRS BASELINE |

## 7. Reconciliation rule

Before adding a new verification ID:

```text
SEARCH THIS REGISTER
        ↓
SEARCH EXISTING VERIFICATION DOCUMENTS
        ↓
CHECK WHETHER COVERAGE ALREADY EXISTS
        ↓
LINK EXISTING CASE
OR
IDENTIFY REAL COVERAGE GAP
        ↓
CREATE NEW CASE ONLY IF GAP IS CONFIRMED
```

No duplicate case is created merely because a new module specification appears.

## 8. Requirement traceability

Each case must eventually identify its actual requirement/design basis.

The current Navigation requirement allocation is maintained in:

`05_VERIFICATION/NAVIGATION/NAVIGATION_REQUIREMENT_ALLOCATION_001.md`

That allocation is a working reconciliation record and does not promote candidate requirements to authoritative status.

Until reconciliation is complete, no unconfirmed `NAV-REQ-*` or other candidate ID is promoted to authoritative requirement linkage.

Required fields:

```text
Verification ID
Requirement ID / Design ID
Basis document
Verification method
Input / dataset
Expected result
Acceptance criterion
Execution configuration
Result
Evidence reference
Reviewer
Status
Change ID
```

Unknown values are `TBD`.

## 9. Verification methods

Allowed project methods include:

```text
TEST
ANALYSIS
INSPECTION
SIMULATION
DEMONSTRATION
```

The selected method must be appropriate to the verification objective.

## 10. Status model

```text
IDENTIFIED
DEFINED
READY
EXECUTED
PASSED
FAILED
BLOCKED
SUPERSEDED
WITHDRAWN
```

`PASSED` requires recorded execution result and evidence reference.

## 11. Evidence rule

```text
Verification Case
→ Execution
→ Result
→ Evidence
```

A verification definition, mathematical relation, or documented expected result is not evidence of execution.

## 12. Navigation allocation

The current Navigation Verification Model is the source for the twenty `NAV-V*` case definitions. The Navigation Test Vectors document is the source for the ten `NAV-TV-*` deterministic mathematical vectors.

The controlled relationship is:

```text
MASTER-REQUIREMENTS-REGISTER-001
        ↓
NAVIGATION-REQUIREMENT-ALLOCATION-001
        ↓
NAVIGATION-TRACEABILITY-MATRIX-001
        ↓
NAV-V* / NAV-TV-*
        ↓
Execution
        ↓
Evidence
```

These documents are linked through the register; their contents are not duplicated here.

## 13. C2 verification allocation

The C2 verification case definitions are controlled in:

`05_VERIFICATION/C2/C2_VERIFICATION_CASES_001.md`

The stable case identities are:

```text
C2-V01 … C2-V08
```

They map to the existing interface allocations `IV-C2-001..IV-C2-008`. The cases are `DEFINED`; no execution result, evidence or verification claim exists yet.

The execution configuration is controlled in:

`05_VERIFICATION/C2/C2_VERIFICATION_CONFIGURATION_001.md`

The configuration record is `C2-VER-CFG-001`, linked to `CI-007` and `BL-VER`.
It is `PLANNED`; no execution result or evidence is implied.

## 14. Audit findings — initial pass

```text
V-REG-001  Verification Register was not previously present as a dedicated controlled identity register.
V-REG-002  NAV-V01..NAV-V20 exist as case definitions in NAVIGATION_VERIFICATION_MODEL.
V-REG-003  NAV-TV-001..NAV-TV-010 exist as mathematical vectors in NAVIGATION_TEST_VECTORS_001.
V-REG-004  Execution evidence is not implied by DEFINED / READY status.
V-REG-005  Exact requirement allocation for Navigation cases remains pending reconciliation with MASTER-REQUIREMENTS-REGISTER.
V-REG-006  Navigation requirement allocation is maintained as a separate working record and does not create requirement authority.
```

## 15. Completion gate

```text
[ ] all existing verification IDs inventoried
[ ] duplicates checked
[ ] requirement/design basis assigned
[ ] verification method assigned
[ ] test vectors/datasets linked
[ ] acceptance criteria controlled
[ ] execution status controlled
[ ] evidence linked after execution
[ ] regression impact linked to change control
[ ] certification-relevant verification identified
[ ] master index updated
```

## 15. Status

**DRAFT_FOR_AGREEMENT**

This register establishes verification identity and traceability control. It does not declare any requirement or verification as completed merely by registration.
