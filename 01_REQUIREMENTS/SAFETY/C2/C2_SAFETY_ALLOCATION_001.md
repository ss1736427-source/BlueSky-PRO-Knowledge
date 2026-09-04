---
id: C2-SAFETY-ALLOCATION-001
type: safety_requirements_allocation
status: working_draft
system: BlueSky PRO
source: C2_CLAUSE_LEVEL_MAPPING_001.md
---

# BLUE SKY PRO — C2 SAFETY ALLOCATION 001

## 1. Purpose

Allocate C2-related failure conditions to the BlueSky safety model without assigning unsupported quantitative thresholds.

## 2. Safety-relevant states

```text
C2 NORMAL
C2 DEGRADED
C2 LOST
C2 RESTORED
```

Each transition shall be observable, time-ordered and recorded where required by the approved system behaviour.

## 3. Failure conditions

| ID | Condition | Safety effect to analyse | Required response |
|---|---|---|---|
| C2-F-001 | degradation of C2 quality | loss of reliable command/monitoring | transition to DEGRADED and evaluate contingency criteria |
| C2-F-002 | complete C2 loss | inability to receive/confirm commands | invoke approved lost-C2 behaviour |
| C2-F-003 | intermittent C2 | unstable command/monitoring availability | prevent unsafe oscillation between states; apply hysteresis defined in requirements |
| C2-F-004 | invalid/stale C2 status | incorrect system-state assessment | reject or quarantine invalid status and maintain safe state |
| C2-F-005 | time-reference inconsistency | incorrect event ordering / stale-state decisions | use controlled common time reference |

## 4. Allocation principle

BlueSky shall not assume responsibility for an external C2 provider's internal implementation. Where PROVIDER-C2 is used, the safety allocation is limited to the defined interface, detection, reaction and evidence obligations of BlueSky.

## 5. Verification

Safety allocation shall be verified by:

- requirements inspection;
- failure-mode analysis;
- interface/integration tests;
- lost-C2 scenario tests;
- event-log evidence review.

Quantitative acceptance criteria remain OPEN until derived from the approved requirements/certification baseline.

## 6. Next step

Feed the allocation into the controlled ICD and verification baseline, then update the master traceability matrix.
