---
id: C2-RECONCILIATION-PASS-002
type: controlled_reconciliation_result
status: controlled_working_draft
system: BlueSky PRO
authority: MASTER-REQUIREMENTS-REGISTER-001
basis: C2-CLAUSE-LEVEL-MAPPING-001
---

# BLUE SKY PRO — C2 RECONCILIATION PASS 002

## 1. Цель прохода

Проверить C2-кандидаты по цепочке:

`Regulatory clause → applicability → existing requirement → safety → architecture/interface → verification`

Правило: существующий `SYS-REQ-*` имеет приоритет. Кандидат не становится новым системным требованием без доказанного функционального GAP.

## 2. Проверенные controlled records

- `MASTER_REQUIREMENTS_REGISTER.md`
- `SYSTEM_REQUIREMENTS_SPECIFICATION.md`
- `C2_CLAUSE_LEVEL_MAPPING_001.md`
- `C2_REGULATORY_REQUIREMENTS_BASELINE_001.md`
- `C2_ICD_BASELINE_001.md`
- `C2_SAFETY_ALLOCATION_001.md`
- `C2_TEXT_RECONCILIATION_001.md`
- `C2_REQUIREMENTS_RECONCILIATION_001.md`
- `C2_VERIFICATION_RECONCILIATION_001.md`
- `BLUE_SKY_DECISIONS_LOG.md`
- `REQUIREMENTS_INVENTORY.md`

## 3. Result

| C2 item | Current disposition | Decision |
|---|---|---|
| C2-REQ-001 / C2 mode | DERIVED / OVERLAP | покрывается DEC-012 и существующей архитектурной границей; новый SYS-REQ не создавать |
| C2-REQ-002 / state monitoring | DERIVED / MERGE | распределить через существующий degradation/safety контур; новый SYS-REQ не создавать |
| C2-REQ-003 / quality parameters | PARTIAL | требуется контролируемая количественная основа; GAP не доказан |
| C2-REQ-004 / provider boundary | DERIVED | покрывается DEC-012 и IF-C2-001; обязанности provider остаются внешними |
| C2-REQ-005 / cause/status | DERIVED / OVERLAP | покрывается C2 safety allocation и существующим degradation handling |
| C2-REQ-006 / loss response | MERGE CANDIDATE | использовать SYS-REQ-081/086/093 + SAF allocation; новый SYS-REQ не создавать |
| C2-REQ-007 / event recording | GAP CANDIDATE | требуется проверка полного controlled wording существующего data/archive requirement |
| C2-REQ-008 / common time base | PARTIAL / GAP CHECK | IF-C2-001 уже требует timestamp/temporal validity; отдельный SYS-REQ пока не создавать |
| C2-REQ-009 / authority boundary | DERIVED / MERGE | покрывается существующим Safety Gate / authority chain |
| C2-REQ-010 / operator warning | GAP CANDIDATE | требуется проверка полного controlled wording существующего HMI requirement |

## 4. Confirmed existing architecture

`DEC-012` устанавливает `DIRECT-C2` и `PROVIDER-C2` и не назначает BlueSky автоматически поставщиком C2.

`C2_ICD_BASELINE_001.md` устанавливает `IF-C2-001` и выделяет state, quality, command/telemetry status, failure/recovery, temporal validity, security и version/configuration aspects.

## 5. Safety allocation

`C2_SAFETY_ALLOCATION_001.md` уже содержит:

- `C2-F-001` degradation;
- `C2-F-002` complete loss;
- `C2-F-003` intermittent C2;
- `C2-F-004` invalid/stale status;
- `C2-F-005` time-reference inconsistency.

Следовательно, эти failure modes не создают автоматически новые safety IDs.

## 6. Verification allocation

Существующий C2 verification контур включает:

```text
IV-C2-001 schema
IV-C2-002 units/semantics
IV-C2-003 timestamp/freshness
IV-C2-004 validity/quality
IV-C2-005 state transitions
IV-C2-006 failure injection/safe response
IV-C2-007 DIRECT-C2/PROVIDER-C2 boundary
IV-C2-008 version compatibility
```

`VP-008` относится к C2 degradation и находится в плановом состоянии. Поэтому наличие verification allocation не означает `VERIFIED`.

## 7. Quantitative gate

Не фиксировать произвольные значения для:

- latency;
- continuity;
- availability;
- integrity;
- loss-detection time;
- recovery time;
- coverage margin.

Значение допускается в baseline только после установления источника, applicability, system allocation и verification method.

## 8. Master Register impact

```text
NEW SYS-REQ: 0
NEW SAF-REQ: 0
RENAMING: 0
RENUMBERING: 0
BASELINE CHANGES: 0
```

На основании этого прохода изменение authoritative `MASTER_REQUIREMENTS_REGISTER.md` не требуется.

## 9. Remaining controlled actions

Только два пункта требуют дополнительной проверки полного controlled wording:

1. C2 event recording (`C2-REQ-007`);
2. operator C2 warning/display (`C2-REQ-010`).

Если существующее требование покрывает функцию — `KEEP/DERIVED/MERGE`. Если покрытие отсутствует — только тогда создаётся новый requirement через controlled change.

## 10. Boundary rule

Требования к внешним объектам, включая физические посадочные площадки и обязанности их владельцев, не являются требованиями к системе управления/планирования BlueSky PRO. Они могут учитываться только как external condition, constraint, input или documentation item при доказанной связи с системой.

## 11. Gate result

**C2 RECONCILIATION PASS 002: NO PROVEN SYSTEM REQUIREMENT GAP.**

`C2-REQ-007` и `C2-REQ-010` остаются candidate gaps до exact wording review.

## 12. Status

**CONTROLLED WORKING DRAFT — NOT BASELINED**
