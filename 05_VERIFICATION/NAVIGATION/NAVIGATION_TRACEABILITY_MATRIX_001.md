---
id: NAVIGATION-TRACEABILITY-MATRIX-001
type: navigation_traceability_matrix
status: working_baseline
authority: derived_from_navigation_state_model_rules_algorithm_verification_model
---

# BlueSky PRO — Navigation Traceability Matrix

## 1. Назначение

Единая рабочая матрица трассируемости блока Navigation.

Матрица **не создаёт новую базу требований**. Она связывает существующие authoritative records, инженерные правила, алгоритмы, математическую спецификацию, модули, интерфейсы и verification.

## 2. Authority chain

```text
OFFICIAL REGULATORY SOURCES
        ↓
CERTIFICATION BASIS
        ↓
MASTER REQUIREMENTS REGISTER
        ↓
SYSTEM REQUIREMENTS SPECIFICATION
        ↓
SYSTEM ARCHITECTURE BASELINE
        ↓
NAVIGATION STATE MODEL
        ↓
NAVIGATION RULES
        ↓
NAVIGATION ALGORITHM
        ↓
NAVIGATION MATHEMATICAL SPECIFICATION
        ↓
MODULE SPECIFICATION
        ↓
HMI / INTERFACE
        ↓
VERIFICATION
        ↓
EVIDENCE
```

Правило: документ нижнего уровня не становится authoritative только потому, что он создан позднее.

## 3. Authoritative records

| Объект | Authoritative record |
|---|---|
| System requirements | `01_REQUIREMENTS/SYSTEM/MASTER_REQUIREMENTS_REGISTER.md` |
| System requirements presentation/specification | `01_REQUIREMENTS/SYSTEM/SYSTEM_REQUIREMENTS_SPECIFICATION.md` |
| Regulatory sources | `01_REQUIREMENTS/REGULATORY/REGULATORY_SOURCE_REGISTER.md` |
| Regulatory clause applicability | `01_REQUIREMENTS/REGULATORY/REGULATORY_CLAUSE_MAPPING_001.md` |
| Certification basis | `06_CERTIFICATION/BASIS/` |
| Safety requirements | `01_REQUIREMENTS/SAFETY/SAFETY_REQUIREMENTS_BASELINE.md` |
| System architecture | `02_ARCHITECTURE/SYSTEM/SYSTEM_ARCHITECTURE_BASELINE.md` |
| Interface control | `02_ARCHITECTURE/INTERFACES/INTERFACE_CONTROL_DOCUMENT.md` |
| Navigation state | `03_SYSTEM/NAVIGATION/NAVIGATION_STATE_MODEL.md` |
| Navigation rules | `03_SYSTEM/NAVIGATION/NAVIGATION_RULES.md` |
| Navigation algorithm | `03_SYSTEM/NAVIGATION/NAVIGATION_ALGORITHM.md` |
| Navigation mathematics | `03_SYSTEM/NAVIGATION/NAVIGATION_MATHEMATICAL_SPECIFICATION_001.md` |
| Navigation verification model | `05_VERIFICATION/NAVIGATION/NAVIGATION_VERIFICATION_MODEL.md` |
| Navigation test vectors | `05_VERIFICATION/NAVIGATION/TEST_VECTORS/NAVIGATION_TEST_VECTORS_001.md` |

## 4. Module allocation

| Module | Module specification | Existing engineering basis | Verification allocation | Status |
|---|---|---|---|---|
| Position | `03_SYSTEM/NAVIGATION/NAVIGATION_POSITION_MODULE_SPECIFICATION.md` | State Model / Rules / Algorithm / ICD | NAV-V06, V08–V12, V16, V20; NAV-TV-006, 007, 010 | RECONCILIATION |
| Velocity / Speed | `03_SYSTEM/NAVIGATION/NAVIGATION_VELOCITY_SPEED_MODULE_SPECIFICATION.md` | State Model / Rules / Algorithm / Mathematics | NAV-V01–V04, V08–V12, V15–V17, V19, V20 | RECONCILIATION |
| Heading | `03_SYSTEM/NAVIGATION/NAVIGATION_HEADING_MODULE_SPECIFICATION.md` | State Model / Rules / Algorithm / Mathematics | integration and quality cases; exact allocation pending | RECONCILIATION |
| Track / Course | `03_SYSTEM/NAVIGATION/NAVIGATION_TRACK_COURSE_MODULE_SPECIFICATION.md` | State Model / Rules / Algorithm / Mathematics | NAV-V01–V04, V06–V12, V15–V20 | RECONCILIATION |
| Wind | `03_SYSTEM/NAVIGATION/NAVIGATION_WIND_MODULE_SPECIFICATION.md` | State Model / Rules / Algorithm / Mathematics | wind influence, quality, return and ETA cases; exact IDs pending | RECONCILIATION |

## 5. Existing rule → algorithm → verification

| Rule | Engineering basis | Verification | Module allocation | Disposition |
|---|---|---|---|---|
| N-001 Planned ≠ Actual | `NAVIGATION_STATE_MODEL` / state construction | NAV-V20 | Position, Velocity, Heading, Track/Course, Wind | COVERED |
| N-002 Course / Heading / Track distinct | State Model / reference-frame relationship | NAV-V01, V02, V06 | Heading, Track/Course | COVERED; numerical convention open |
| N-003 Bearing distinct | Navigation semantics | V3 | Track/Course / Navigation State | COVERED |
| N-004 Airspeed ≠ Groundspeed | Wind relationship | NAV-V01…V04 | Velocity/Speed, Wind | COVERED; formula verification pending |
| N-005 Drift derived | Derived navigation values | V3, V4 | Track/Course / Wind | COVERED; exact convention open |
| N-006 Reference Frame explicit | Reference frame | NAV-V02, V3 | Position, Heading, Track/Course | COVERED; project convention pending |
| N-007 Provenance | Source validation | V1, V5 | All Navigation modules | COVERED |
| N-008 Navigation ≠ Execution Authority | Safety boundary | NAV-V18 | All Navigation modules | COVERED |
| N-009 Actual ↔ Planned | Deviation calculation | NAV-V06, V07 | Position, Velocity, Track/Course | COVERED |
| N-010 Route/WP version context | Route/WP state | NAV-V07 | Position, Track/Course | COVERED |
| N-011 Measured / Estimated / Derived / Predicted | State construction | NAV-V20 | All modules | COVERED |
| N-012 Quality states | Source validation / quality | NAV-V08…V12 | All modules | COVERED; thresholds open |
| N-013 Common Navigation State | Integration | V6 | All modules | COVERED |
| N-014 Dynamic Return uses Actual State | Feasibility / Dynamic Return | NAV-V15 | Position, Velocity, Track/Course, Wind | COVERED; formula details open |
| N-015 Individual UAV state | Multi-UAV | NAV-V19 | All applicable modules | COVERED |
| N-016 Material change → revalidation | Runtime adaptation | NAV-V16, V17 | Navigation block | COVERED |
| N-017 Map/WP Table common state | Route/WP integration | NAV-V07 | Position, Track/Course | COVERED |
| N-018 Safety priority | Safety boundary | NAV-V18 | Navigation block | COVERED |
| N-019 AI has no execution authority | Safety / authorization | NAV-V18 | Navigation block / AI integration | COVERED |
| N-020 Knowledge provenance | Traceability | Evidence chain | Navigation documentation | COVERED |

## 6. Requirement reconciliation rule

Navigation material must be compared against the existing requirements baseline before a new requirement is created.

```text
NAVIGATION STATEMENT
        ↓
SEARCH MASTER REQUIREMENTS REGISTER
        ↓
SEARCH SAFETY REQUIREMENTS
        ↓
CHECK REGULATORY APPLICABILITY
        ↓
CHECK ARCHITECTURE
        ↓
KEEP AS EXISTING / DERIVED
OR
MERGE WITH EXISTING REQUIREMENT
OR
IDENTIFY REAL GAP
OR
IDENTIFY CONFLICT
```

`GAP` is a finding requiring investigation, not a requirement category by itself.

## 7. Regulatory linkage rule

Regulatory material is not copied into module specifications as if it were a module requirement.

```text
Official source / clause
→ regulated object
→ BlueSky role
→ system boundary
→ applicability
→ requirement / interface constraint
→ design allocation
→ verification
```

If a clause applies to an external object, it remains an external constraint/interface consideration and is not silently converted into an internal Navigation function.

## 8. Architecture linkage

Navigation module allocation is subordinate to the existing system architecture.

```text
System Architecture
        ↓
Navigation block
        ↓
Navigation modules
```

No module specification may silently create:

- a new system block;
- a new execution authority;
- a new safety authority;
- a new regulatory responsibility.

## 9. Verification linkage

Verification definitions are not evidence.

```text
Requirement / design statement
        ↓
Verification method
        ↓
Test case / test vector
        ↓
Execution
        ↓
Result
        ↓
Controlled evidence
```

Until execution evidence exists, the item remains `NOT VERIFIED`.

## 10. Cross-module semantic baseline

The existing Navigation State Model is the common semantic authority for the following distinctions:

```text
PLANNED ≠ ACTUAL ≠ SIMULATED

Course ≠ Heading ≠ Track ≠ Bearing

Airspeed ≠ Groundspeed

Measured ≠ Estimated ≠ Derived ≠ Predicted

Navigation State ≠ Execution Authority
```

Individual module specifications must reference these semantics rather than establish competing definitions.

## 11. Open engineering parameters

These are currently open engineering/design items and are **not automatically GAPs**:

- coordinate reference system;
- altitude datum;
- units and precision;
- freshness/stale thresholds;
- quality transition thresholds;
- source priority/fusion policy;
- mathematical conventions/signs;
- exact interface schemas and timing;
- HMI thresholds/presentation;
- exact requirement allocation after reconciliation;
- certification clause applicability where not yet established.

Each item must eventually receive:

```text
source
→ decision
→ rationale
→ affected modules
→ verification
```

## 12. Required completion sequence

```text
1. Existing documentation inventory
2. Semantic reconciliation
3. Requirement reconciliation
4. Regulatory applicability check
5. Architecture allocation
6. Module design
7. Interface allocation
8. HMI allocation
9. Verification allocation
10. Evidence after execution
11. Module completion review
12. Navigation block completion review
```

## 13. Current decision

The current Navigation module specifications are **derived design records**, not replacements for the authoritative requirement, architecture, rules, algorithm, mathematical or verification records.

The immediate task is to reconcile them with those existing records and eliminate duplication or conflicting definitions before declaring any module complete.

## 14. Navigation completion gate

Navigation is complete only when:

```text
[ ] all modules mapped to architecture
[ ] all applicable requirements allocated
[ ] no duplicate requirement authority exists
[ ] regulatory applicability established where applicable
[ ] common semantics consistent
[ ] interfaces controlled
[ ] HMI allocated
[ ] verification mapped
[ ] evidence status controlled
[ ] open parameters resolved or formally accepted
[ ] master index updated
```

**Status: WORKING BASELINE**
