---
id: NAVIGATION-BASELINE-RECON-001
type: navigation_baseline_reconciliation
status: working
authority: MASTER-REQUIREMENTS-REGISTER-001 / SYSTEM-ARCHITECTURE-BASELINE / Navigation working set
---

# BlueSky PRO — Navigation Baseline Reconciliation

## 1. Назначение

Документ связывает уже существующую документацию Navigation и фиксирует, какой документ выполняет какую роль. Он не создаёт самостоятельную базу требований и не заменяет существующие документы.

## 2. Authoritative hierarchy

```text
MASTER REQUIREMENTS REGISTER
        ↓
SYSTEM REQUIREMENTS SPECIFICATION
        ↓
SYSTEM ARCHITECTURE
        ↓
NAVIGATION STATE MODEL
        ↓
NAVIGATION RULES
        ↓
NAVIGATION ALGORITHM
        ↓
NAVIGATION MATHEMATICAL SPECIFICATION
        ↓
MODULE SPECIFICATIONS
        ↓
HMI / INTERFACES
        ↓
VERIFICATION
        ↓
EVIDENCE
```

Регуляторная ветвь проходит отдельно:

```text
OFFICIAL REGULATORY SOURCE
        ↓
REGULATORY SOURCE REGISTER
        ↓
CLAUSE MAPPING / APPLICABILITY
        ↓
CERTIFICATION BASIS
        ↓
REQUIREMENT
        ↓
DESIGN / VERIFICATION / EVIDENCE
```

## 3. Existing Navigation documents

| Layer | Document | Role | Status |
|---|---|---|---|
| Knowledge | `00_PROJECT/KNOWLEDGE/NAVIGATION_KNOWLEDGE_REVIEW_001.md` | исходная инженерная сверка знаний | existing |
| Knowledge | `00_PROJECT/Самолетовождение_Черный_Кораблин_1973_KNOWLEDGE_BASE.md` | технический источник знаний | existing |
| Knowledge | `03_SYSTEM/NAVIGATION/Navigation_Knowledge_Map.md` | карта знаний | existing |
| State | `03_SYSTEM/NAVIGATION/NAVIGATION_STATE_MODEL.md` | единая модель Navigation State | existing |
| Rules | `03_SYSTEM/NAVIGATION/NAVIGATION_RULES.md` | инженерные правила | existing |
| Algorithm | `03_SYSTEM/NAVIGATION/NAVIGATION_ALGORITHM.md` | алгоритмическая логика | existing |
| Mathematics | `03_SYSTEM/NAVIGATION/NAVIGATION_MATHEMATICAL_SPECIFICATION_001.md` | математическая база | existing |
| Module | `03_SYSTEM/NAVIGATION/NAVIGATION_POSITION_MODULE_SPECIFICATION.md` | Position | draft |
| Module | `03_SYSTEM/NAVIGATION/NAVIGATION_VELOCITY_SPEED_MODULE_SPECIFICATION.md` | Velocity / Speed | draft |
| Module | `03_SYSTEM/NAVIGATION/NAVIGATION_HEADING_MODULE_SPECIFICATION.md` | Heading | draft |
| Module | `03_SYSTEM/NAVIGATION/NAVIGATION_TRACK_COURSE_MODULE_SPECIFICATION.md` | Track / Course | draft |
| Module | `03_SYSTEM/NAVIGATION/NAVIGATION_WIND_MODULE_SPECIFICATION.md` | Wind | draft |
| Traceability | `05_VERIFICATION/NAVIGATION/NAVIGATION_TRACEABILITY_MATRIX_001.md` | Rule/algorithm → verification | working baseline |
| Verification | `05_VERIFICATION/NAVIGATION/NAVIGATION_VERIFICATION_MODEL.md` | модель проверки | existing |
| Test vectors | `05_VERIFICATION/NAVIGATION/TEST_VECTORS/NAVIGATION_TEST_VECTORS_001.md` | test vectors | existing |

## 4. Requirement linkage

Authoritative requirement identity:

`01_REQUIREMENTS/SYSTEM/MASTER_REQUIREMENTS_REGISTER.md`

Specification representation:

`01_REQUIREMENTS/SYSTEM/SYSTEM_REQUIREMENTS_SPECIFICATION.md`

Navigation candidate family:

`NAV-REQ-*`

Current rule:

```text
NAV-REQ candidate
        ↓
compare with existing SYS-REQ / SAF-REQ
        ↓
compare with Navigation rules/state/algorithm
        ↓
compare with regulatory basis
        ↓
KEEP / DERIVED / MERGE / GAP / CONFLICT
```

Until this comparison is complete, the module specifications do not promote candidate requirements to baseline.

## 5. Safety linkage

Navigation does not receive execution authority.

Required chain:

```text
Navigation State
→ Validation
→ Readiness
→ Safety Gate
→ Authorization
→ Execution
```

Any Navigation degradation is therefore an input to the applicable validation/safety logic and not an independent command authority.

## 6. Module relationship matrix

| Module | Primary source | Main related modules | Main consumers |
|---|---|---|---|
| Position | Navigation State Model / Rules / Algorithm | Velocity, Track/Course, Reference Frames, Quality | Planning, Safety, Flight, HMI |
| Velocity / Speed | Navigation State Model / Rules / Algorithm / Mathematics | Position, Wind, Heading, Track/Course | Planning, Return, Safety, Flight |
| Heading | Navigation State Model / Rules / Algorithm | Position, Velocity, Wind, Track/Course | Planning, Flight, Safety |
| Track / Course | Navigation State Model / Rules / Algorithm / Mathematics | Position, Velocity, Heading, Wind | Planning, Flight, Safety |
| Wind | Navigation State Model / Rules / Algorithm / Mathematics | Position, Velocity, Heading, Track/Course | Planning, ETA, Energy, Return |

## 7. What is already established

The existing Navigation State Model establishes the semantic separation of:

```text
PLANNED
ACTUAL
DERIVED
QUALITY
```

and distinguishes:

```text
Course ≠ Heading ≠ Track ≠ Bearing
Airspeed ≠ Groundspeed
Navigation State ≠ Execution Authority
```

The Navigation Traceability Matrix already links rules/algorithm statements to verification coverage and states that no new SYS-REQ is created solely from Navigation work. Therefore module specifications must use these existing semantics rather than redefine them independently.

## 8. What is not yet closed

The following are engineering parameters/open items, not automatically GAPs:

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

## 9. Required reconciliation action

Before Navigation is declared complete:

```text
1. Compare existing requirements with NAV-REQ candidates.
2. Allocate each confirmed requirement to the correct Navigation function/module.
3. Link each module to its parent architectural element.
4. Link each module to existing rules/algorithm/math records.
5. Link each verification reference to the applicable requirement/design item.
6. Add new verification only where existing coverage is insufficient.
7. Link HMI allocation without duplicating the common HMI design system.
8. Record regulatory applicability only when source/clause and system boundary are established.
9. Close or formally accept open engineering parameters.
10. Update Master Document Index.
```

## 10. Completion rule

A Navigation module is not complete because a specification file exists.

It becomes `DESIGN-READY` only when its relationships are established:

```text
requirement
↕
architecture
↕
module
↕
rule / algorithm / mathematics
↕
interface
↕
HMI allocation
↕
verification
↕
evidence
```

## 11. Current decision

The existing Navigation documentation is retained and connected by this map. No document is designated as a replacement merely because a newer module specification exists.

The next work is **reconciliation and completion of existing material**, not uncontrolled creation of parallel documents.

**Status: WORKING**
