---
id: C2-CONTROLLED-BASELINE-STATUS-001
type: c2_baseline_status
status: controlled_working_record
system: BlueSky PRO
---

# BLUE SKY PRO — C2 CONTROLLED BASELINE STATUS 001

## 1. Результат прохода

Проведена проверка C2-цепочки по существующим рабочим материалам:

```text
Приказ №142
→ clause mapping
→ C2 candidates
→ existing requirements
→ ICD
→ Safety
→ HMI
→ Verification
```

## 2. Решение по candidate allocation

Кандидатные записи `C2-CAND-*` не получают статус `SYS-REQ` автоматически.

Текущий controlled disposition:

| Candidate | Disposition | Action |
|---|---|---|
| C2-CAND-001 | DERIVED | сохранить как derived allocation до exact reconciliation |
| C2-CAND-002 | DERIVED | связать с существующим C2/Safety контуром; не дублировать |
| C2-CAND-003 | PARTIAL / CONTROLLED BASIS IDENTIFIED | использовать SYS-C2-003, C2-142-004/011/013/014, IF-C2-001 и IV-C2-004; количественные значения не назначать без утверждённой operational/certification basis |
| C2-CAND-004 | DERIVED | сохранить как interface/system allocation |
| C2-CAND-005 | DERIVED | использовать существующий logging/evidence контур |
| C2-CAND-006 | MERGE/SCOPE REVIEW | не создавать новый SYS-REQ; проверить operational responsibility |
| C2-CAND-007 | DERIVED / COVERED | использовать controlled cause/status distinction и существующую diagnostics/safety allocation |
| C2-CAND-008 | DERIVED / COVERED | использовать controlled common time reference и существующий IF-C2-001 |

## 3. Baseline decision

```text
NEW SYS-REQ: 0
NEW SAF-REQ: 0
RENUMBERING: 0
MASTER REGISTER: no change
```

Ни один кандидат не переводится в baseline без доказанного функционального gap и полного набора:

```text
source
→ applicability
→ responsibility
→ requirement
→ interface/design allocation
→ verification
→ evidence
```

## 4. Verification gate

Статус C2 verification остаётся `ALLOCATED / NOT VERIFIED`, пока соответствующие проверки фактически не выполнены и evidence не зарегистрировано.

Наличие verification procedure само по себе не является evidence of compliance.

## 5. Scope gate

Внешние объекты и обязанности не переводятся в BlueSky system requirements.

В частности, требования к физическим посадочным площадкам и их владельцам остаются вне system requirement boundary; они могут учитываться только в соответствующем external/operational documentation контуре, если это необходимо для конкретного certification object.

## 6. Следующий controlled action

Сохранить quantitative closure hold по оставшемуся вопросу:

1. `C2-CAND-003` — наличие контролируемой основы для количественных C2 quality/QoS parameters.

Контролируемая qualitative basis подтверждена через clause mapping, `SYS-C2-003`, `IF-C2-001` и `IV-C2-004`. До утверждения source-specific quantitative values `MASTER_REQUIREMENTS_REGISTER.md` не изменяется.

## 7. Authoritative rule

`MASTER_REQUIREMENTS_REGISTER.md` остаётся единственным authoritative register идентификаторов требований. Рабочие C2 documents не создают вторую независимую базу требований.
