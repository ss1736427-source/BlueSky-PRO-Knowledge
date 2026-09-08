---
id: SYS-REQ-053
type: system_requirement
title: ривязка страхования к операции
status: draft
criticality: critical
verification_method: analysis
derives_from:
  - "[[NORM-REQ-004]]"
---

# SYS-REQ-053 — ривязка страхования к операции

## Requirement

Страхование должно быть связано с конкретной операцией, а не только с карточкой С.

Связь должна включать:

- Operator;
- UAV / BAS;
- Mission;
- MTOM;
- Operating Area;
- Operating Conditions;
- Insurance Policy;
- Regulatory Assessment.

иссия не должна получать статус Ready, если обязательное страхование отсутствует, истекло или не соответствует требованиям операции.

сли страхование для конкретной операции законодательством не требуется, система не должна блокировать миссию только по причине отсутствия полиса.
## Traceability

- [[NORM-REQ-004]]




