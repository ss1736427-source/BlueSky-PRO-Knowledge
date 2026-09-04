---
id: NO140-REG-MAPPING-001
type: regulatory_clause_mapping
status: controlled_working_draft
system: BlueSky PRO
source: REGULATORY_SOURCE_REGISTER.md
---

# BLUE SKY PRO — №140 REGULATORY MAPPING 001

## 1. Назначение

Зафиксировать рабочую applicability/interface mapping для приказа Минтранса России №140 до переноса применимых положений в системные требования.

Документ не является заключением о юридической применимости и не заменяет утверждённый certification basis.

## 2. Объект анализа

Приказ №140 рассматривается только в пределах функций и интерфейсов, которые могут находиться в границе BlueSky PRO. Требования к внешним участникам не превращаются автоматически в требования программного обеспечения.

## 3. Allocation model

```text
DIRECT
→ BlueSky обязан непосредственно реализовать/контролировать функцию.

INTERFACE
→ BlueSky должен обеспечить определённый контролируемый интерфейс или проверить входные данные.

EXTERNAL
→ функция находится вне BlueSky; фиксируется как external dependency/constraint.

CONDITIONAL
→ applicability зависит от certification object, intended operation, оборудования и архитектуры.
```

## 4. Working records

| ID | Нормативный источник | Предварительная связь с BlueSky | Applicability | Следующее действие |
|---|---|---|---|---|
| N140-M-001 | Приказ №140 | operational / infrastructure interface | CONDITIONAL | выделить конкретные пункты и определить объект регулирования |
| N140-M-002 | Приказ №140 | interface with external aviation infrastructure | CONDITIONAL | определить входы/выходы и владельца каждого интерфейса |
| N140-M-003 | Приказ №140 | operational information used by flight planning | CONDITIONAL | определить, какие данные действительно потребляет BlueSky |
| N140-M-004 | Приказ №140 | checks/constraints exposed to operator | CONDITIONAL | определить allocation в requirements/HMI |
| N140-M-005 | Приказ №140 | external operational responsibility | EXTERNAL | зафиксировать границу ответственности без переноса реализации в BlueSky |

## 5. Требования к дальнейшему разбору

Для каждого применимого пункта необходимо установить:

```text
Source
Clause
Regulatory object
Applicability rationale
BlueSky boundary
Requirement ID
Interface ID
Safety relation
Verification method
Evidence
Status
```

## 6. Запрет на преждевременную нормализацию

До завершения clause-level review нельзя:

- объявлять весь приказ №140 применимым к BlueSky;
- переносить внешний нормативный текст в SYS-REQ без applicability rationale;
- назначать численные критерии без нормативного или системного основания;
- считать интерфейсную связь доказательством соответствия.

## 7. Traceability target

```text
№140 / clause
→ applicability decision
→ certification requirement where applicable
→ SYS-REQ
→ interface allocation
→ safety/design
→ verification
→ evidence
```

## 8. Status

**CONTROLLED WORKING DRAFT — NOT BASELINED**

Следующий обязательный проход: получить clause-level текст приказа №140, выполнить постатейную applicability matrix и только после этого сформировать производные требования.
