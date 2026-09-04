---
id: CERTIFICATION-BASIS-WORKING-REGISTER-001
type: certification_basis_working_register
status: controlled_working_draft
jurisdiction: Russian Federation
system: BlueSky PRO
source_register: REGULATORY_SOURCE_REGISTER.md
basis_document: CERTIFICATION_BASIS.md
---

# BLUE SKY PRO — CERTIFICATION BASIS WORKING REGISTER

## 1. Назначение

Рабочий регистр связывает нормативные источники проекта с формируемым certification basis и фиксирует состояние applicability analysis до утверждения конкретного сертификационного базиса.

Документ не является утверждённым органом сертификации certification basis.

## 2. Обязательная цепочка

```text
REGULATORY SOURCE REGISTER
        ↓
SOURCE / CLAUSE
        ↓
OBJECT OF REGULATION
        ↓
BLUE SKY ROLE / SYSTEM BOUNDARY
        ↓
APPLICABILITY
        ↓
CERTIFICATION REQUIREMENT
        ↓
MEANS OF COMPLIANCE
        ↓
VERIFICATION
        ↓
EVIDENCE
```

## 3. Рабочий набор источников

| ID | Source | BlueSky relation | Applicability status | Next action |
|---|---|---|---|---|
| CB-SRC-001 | Воздушный кодекс РФ | DIRECT / INTERFACE / CONDITIONAL | IN REVIEW | выделить конкретные статьи и положения, относящиеся к BlueSky boundary |
| CB-SRC-002 | Федеральный закон от 29.09.2025 №360-ФЗ | CERTIFICATION PROCESS | IN REVIEW | проверить актуальную редакцию изменённых положений ст. 37 и их процессуальное значение |
| CB-SRC-003 | ФАП-21, приказ Минтранса №184 | CONDITIONAL / CERTIFICATION PROCESS | IN REVIEW | определить применимость к конкретному certification object и составу BlueSky |
| CB-SRC-004 | НЛГ Л-БАС, приказ Росавиации №1186-П | CONDITIONAL | OPEN | сопоставить с типом БВС, MTOM и intended operation |
| CB-SRC-005 | НЛГ БАС-ВТ, издание 2 | CONDITIONAL | OPEN | определить применимость к A-VT |
| CB-SRC-006 | НЛГ БАС-СТ, издание 2 | CONDITIONAL | OPEN | определить применимость к A-FW |
| CB-SRC-007 | НЛГ УИ-БАС | CONDITIONAL | OPEN | определить applicability remote identification equipment/function |
| CB-SRC-008 | НЛГ АЗН-УВД | CONDITIONAL | OPEN | определить applicability по operational concept, airspace и оборудованию |
| REG-013 | Приказ Минтранса №142 | DIRECT + INTERFACE | IN REVIEW | выделить требования к C2 functions/interface и трассировать в SRS/ICD/Safety |
| REG-017 | Приказ Минтранса №140 | INTERFACE / CONDITIONAL | OPEN | определить набор landing-site data и checks внутри BlueSky |
| REG-018 | Приказ Минтранса №312 | INTERFACE / CONDITIONAL | OPEN | определить operational/infrastructure interface requirements |
| REG-019 | Приказ №367 | CONDITIONAL / EXTERNAL INTERFACE | OPEN | определить применимость к maintenance/support scope BlueSky |
| REG-020 | Приказ №354 | CONDITIONAL / INTERFACE | OPEN | определить применимость к equipment-check interface |

## 4. Configuration A

Текущий проектный профиль:

```text
CONFIGURATION-A
MTOM ≤30 kg
A-MR / A-FW / A-VT
```

Порог MTOM не используется как самостоятельное доказательство applicability всех нормативных требований.

Для каждой конфигурации необходимо установить минимум:

- aircraft type;
- MTOM;
- intended operation;
- operating environment;
- external pilot concept;
- C2 concept;
- navigation;
- remote identification;
- ATM / surveillance equipment;
- flight-control architecture;
- safety concept.

## 5. C2 boundary

Для BlueSky сохраняются два режима:

```text
DIRECT-C2
PROVIDER-C2
```

При формировании certification requirements необходимо разделять:

- функции BlueSky;
- контролируемый интерфейс с C2 provider;
- функции и ответственность внешнего C2 provider;
- оборудование и инфраструктуру внешнего участника.

Потеря или деградация C2 рассматривается как системное состояние, связанное с Safety и Dynamic Return, а не только как коммуникационная ошибка.

## 6. Результат текущего прохода

Подтверждено:

1. Certification Basis является отдельным нормативно-техническим уровнем и не должен заменяться перечнем SYS-REQ.
2. Applicability должна определяться до переноса внешнего нормативного требования в требование BlueSky.
3. Configuration A ≤30 kg не объявляется автоматически mandatory type-certification target.
4. C2 boundary должен быть разделён на DIRECT-C2 и PROVIDER-C2.
5. Требования, относящиеся к внешним объектам, переводятся в интерфейсные/эксплуатационные ограничения только в пределах установленной ответственности BlueSky.

## 7. Незакрытые вопросы

| GAP | Состояние | Причина |
|---|---|---|
| Конкретный certification object | OPEN | требуется окончательная фиксация объекта и границ |
| Applicability НЛГ по A-MR/A-FW/A-VT | OPEN | зависит от конкретного типа БВС и intended operation |
| Полная clause-level выборка из нормативных источников | IN WORK | требуется последовательная детализация |
| C2 certification boundary | IN WORK | необходимо завершить clause-level mapping по №142 и ст. 78.1 |
| Окончательный certification target | OPEN | зависит от установленного certification object и применимости |

## 8. Следующая обязательная работа

```text
CLAUSE-LEVEL REGULATORY MAPPING
→ CERTIFICATION BASIS
→ CONFIGURATION / APPLICABILITY
→ COMPLIANCE MATRIX
→ CERTIFICATION REQUIREMENTS BASELINE
```

Следующий проход должен добавлять в этот регистр конкретные положения источников, не подменяя их общими формулировками.
