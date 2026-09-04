---
id: C2-REQUIREMENTS-RECONCILIATION-001
type: requirements_reconciliation
status: controlled_working_draft
system: BlueSky PRO
authority: MASTER-REQUIREMENTS-REGISTER-001
basis: C2-CLAUSE-LEVEL-MAPPING-001
---

# BLUE SKY PRO — C2 REQUIREMENTS RECONCILIATION 001

## 1. Назначение

Сопоставить C2-кандидаты, выведенные из приказа Минтранса России №142, с уже существующими требованиями проекта. Цель — не создать вторую базу требований, а определить `KEEP / DERIVED / MERGE / GAP / CONFLICT`.

## 2. Authority

```text
MASTER_REQUIREMENTS_REGISTER.md
        ↓
C2 reconciliation
        ↓
SRS / Safety / ICD / Verification
```

Existing requirement IDs имеют приоритет. Новые C2 IDs не становятся authoritative только из-за наличия в C2 mapping.

## 3. Исходные C2-кандидаты

| Candidate | Смысл | Preliminary disposition |
|---|---|---|
| C2-REQ-001 | C2 mode/configuration | DERIVED / compare with existing SYS-REQ |
| C2-REQ-002 | C2 degradation | MERGE candidate; compare with SYS-REQ-086/093 |
| C2-REQ-003 | C2 loss/recovery | MERGE/GAP candidate; compare with SYS-REQ-081/086/093 and safety records |

## 4. Regulatory-derived allocation

| Mapping | Candidate requirement implication | Allocation | Status |
|---|---|---|---|
| C2-142-001 | support DIRECT-C2 / PROVIDER-C2 | C2 architecture + ICD | DERIVED |
| C2-142-002 | account for direct-C2 coverage | C2/mission constraint | DERIVED |
| C2-142-003 | Provider-C2 network interface | external interface | DERIVED |
| C2-142-004 | use required C2 characteristics | C2 requirements | GAP until quantitative basis confirmed |
| C2-142-005 | controlled C2 data set/update model | ICD | DERIVED |
| C2-142-006 | select C2 mode before flight | mission preparation | DERIVED |
| C2-142-007 | support applicable C2 technologies | architecture | CONDITIONAL |
| C2-142-009 | provider service request data | provider interface | INTERFACE |
| C2-142-010 | validate route against provider coverage | planning/C2 interface | DERIVED |
| C2-142-011 | consume provider QoS characteristics | interface | CONDITIONAL / EXTERNAL values |
| C2-142-012..015 | provider status/QoS and pilot information | interface + HMI | DERIVED |
| C2-142-016..017 | security responsibility split | security/interface boundary | DERIVED |
| C2-142-018 | continuous C2 state monitoring | system + safety | DERIVED |
| C2-142-019 | provider control-message exchange | provider interface | EXTERNAL/INTERFACE |
| C2-142-020 | provide C2 quality assessment to pilot | HMI/system | DERIVED |
| C2-142-021 | record significant C2 events | journal/evidence | DERIVED |
| C2-142-022 | provider failure act | external evidence | EXTERNAL |
| C2-142-023 | operator notification on C2 loss | operational interface | EXTERNAL action; BlueSky support only if allocated |
| C2-142-024 | classify C2 fault causes | diagnostics/safety | DERIVED |
| C2-142-025 | provider loss-decision timing | external/provider interface | EXTERNAL/INTERFACE |

## 5. Existing requirement reuse

Known authoritative records from the Master Register are preserved:

```text
SYS-REQ-080  Dynamic Task Reallocation
SYS-REQ-081  UAV Failure Tolerance
SYS-REQ-082  Safe Mission Completion
SYS-REQ-085  Safety-Critical Priority
SYS-REQ-086  Graceful Degradation
SYS-REQ-091  Critical Latency
SYS-REQ-092  Redundant HUB Resource Recovery
SYS-REQ-093  Controlled Resource Recovery
```

These records are the first comparison targets for C2 degradation, recovery, continuity, resource and safety behaviour.

## 6. Preliminary disposition matrix

| C2 candidate | Existing requirement(s) to compare | Decision now | Reason |
|---|---|---|---|
| C2-REQ-001 | SYS-REQ-083 and architecture/C2 records | DERIVED | mode selection may be an allocation of existing architecture rather than a new requirement |
| C2-REQ-002 | SYS-REQ-086, SYS-REQ-093 | MERGE candidate | degradation/recovery behaviour is already covered at system level |
| C2-REQ-003 | SYS-REQ-081, SYS-REQ-086, SYS-REQ-093, safety records | MERGE/GAP | loss-of-C2 needs exact wording and safety allocation before deciding whether a gap exists |

## 7. Quantitative criteria

No numerical C2 threshold is baselined by this reconciliation.

The following remain `TBD` pending approved basis:

- transaction time;
- continuity;
- availability/readiness;
- integrity;
- loss-detection timing;
- restoration timing;
- coverage margin.

A provider-side value is not converted into a BlueSky design requirement unless responsibility and system boundary justify that allocation.

## 8. Safety reconciliation

C2 loss/degradation is not treated as an isolated communication feature. It is linked to the existing safety chain:

```text
C2 State
→ Mission State
→ Safety Assessment
→ Safe Response
→ Authorization / Execution
```

Existing decisions remain authoritative, including C2 degradation logic and Dynamic Return. No C2 candidate may bypass the established safety/authorization chain.

## 9. Verification reconciliation

Existing verification records shall be reused when they provide equivalent coverage.

```text
Equivalent existing TEST
→ LINK

No equivalent coverage
→ NEW TEST CASE

Changed requirement
→ IMPACT + REGRESSION REVIEW
```

A requirement cannot become `VERIFIED` without controlled evidence.

## 10. Current decisions

```text
KEEP:
  existing SYS-REQ IDs and architecture decisions

DERIVED:
  C2 functions/interfaces that are needed to express existing or newly justified behaviour

MERGE:
  candidate degradation/recovery content where existing SYS-REQ already provides coverage

GAP:
  only after exact wording, scope and verification coverage prove missing behaviour

CONFLICT:
  none established by this pass
```

## 11. Next controlled action

Before changing authoritative requirements:

```text
1. Read exact current text of affected SYS-REQ.
2. Compare against C2 candidate wording.
3. Check existing SAF-REQ / ARCH-DEC / TEST links.
4. Determine KEEP / DERIVED / MERGE / GAP / CONFLICT.
5. Only then update MASTER_REQUIREMENTS_REGISTER.
6. Propagate accepted changes to SRS, Safety, ICD and Verification.
```

## 12. Status

**CONTROLLED WORKING DRAFT — NOT BASELINED**
