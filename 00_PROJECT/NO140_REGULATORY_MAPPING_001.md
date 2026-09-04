---
id: NO140-REG-MAPPING-001
type: regulatory_clause_mapping
status: controlled_working_draft
system: BlueSky PRO
source_document: Приказ Минтранса России от 21.04.2025 № 140
---

# BLUE SKY PRO — №140 REGULATORY MAPPING 001

## 1. Назначение

Clause-level applicability/interface mapping приказа №140 до переноса применимых положений в системные требования.

Документ не является юридическим заключением и не заменяет утверждённый certification basis.

## 2. Нормативный статус

Приказ №140 утверждает ФАП «Требования к посадочным площадкам, предназначенным для взлёта, посадки, руления и стоянки гражданских воздушных судов». Вступил в силу 01.09.2025, действует до 01.09.2031 и отменил приказ №69.

## 3. Allocation model

DIRECT — BlueSky непосредственно реализует/контролирует функцию.

INTERFACE — BlueSky принимает/проверяет контролируемые данные или обеспечивает интерфейс.

EXTERNAL — функция находится вне BlueSky и фиксируется как external dependency/constraint.

CONDITIONAL — applicability зависит от certification object, intended operation, типа БВС/БАС и операционной конфигурации.

## 4. Clause-level applicability matrix — первый проход

| Clause | Предмет регулирования | Applicability | BlueSky allocation | Действие |
|---|---|---|---|---|
| §1 | Обязательность Правил для владельцев посадочных площадок | CONDITIONAL | EXTERNAL / INTERFACE | определить роль площадки в operational concept |
| §2 | Исключения для разовой/ограниченной эксплуатации площадки | CONDITIONAL | INTERFACE | учитывать статус применимости площадки |
| §3 | Приоритет требований эксплуатационной документации ВС | CONDITIONAL | INTERFACE | учитывать приоритетные ограничения aircraft configuration |
| §4 | Использование площадки для разных видов ВС | CONDITIONAL | INTERFACE | связать тип площадки с допустимой конфигурацией |
| §6–§9 | Поверхность ВПП/летного поля и нагрузка | CONDITIONAL | EXTERNAL / INPUT | принимать только подтверждённые параметры |
| §10–§16 | Геометрия ВПП, полосы безопасности, уклоны | CONDITIONAL | INPUT / VALIDATION | использовать в проверках только при установленной applicability |
| §17–§22 | Стоянки, руление, маркировка и безопасность | CONDITIONAL | INTERFACE / CONSTRAINT | выделить только необходимые для BlueSky ограничения |
| §23–§26 | Входные маркеры ВПП | CONDITIONAL | EXTERNAL | не создавать SYS-REQ без установленной обязанности |
| §32–§37 | Ветроуказатель и условия его применения | CONDITIONAL | INPUT / EXTERNAL | определить необходимость данных ветра |
| §38–§43 | Поверхности ограничения препятствий и заход | CONDITIONAL / HIGH RELEVANCE | SAFETY / FLIGHT PLANNING | определить требования к obstacle/profile checks |
| §44–§63 | FATO/TLOF и безопасность вертолётных площадок | CONDITIONAL | INTERFACE / VALIDATION | применять только к соответствующей конфигурации |
| §64–§96 | Стоянки, РД, маркировка и ветроуказатель вертолётных площадок | CONDITIONAL | EXTERNAL / INPUT | выделить необходимые параметры |
| §97–§107 | Посадочные площадки в акватории | CONDITIONAL | INTERFACE / EXTERNAL | определить применимость для соответствующего operation |

## 5. Первичная граница BlueSky

Физические требования к покрытию, несущей способности, маркерам, буям, ветроуказателям и конструкции площадки не переводятся автоматически в требования ПО.

Рабочая модель:

EXTERNAL COMPLIANCE CONDITION → REGISTERED LANDING-SITE DATA → BLUE SKY VALIDATION / PLANNING INPUT

Наиболее релевантная для BlueSky область — использование характеристик площадки и ограничений препятствий в Flight Planning и проверках допустимости профиля. Статус пока CONDITIONAL.

## 6. Кандидатные производные требования

| ID | Кандидатное требование | Basis | Status |
|---|---|---|---|
| N140-REQ-001 | Хранить идентифицированный набор характеристик посадочной площадки, используемых системой. | §1–4 | CANDIDATE |
| N140-REQ-002 | Учитывать применимые ограничения посадочной площадки при формировании и валидации маршрута. | §6–16, §38–43 | CANDIDATE |
| N140-REQ-003 | Обеспечивать трассируемость параметров площадки до источника/конфигурации. | §3, §6–16 | CANDIDATE |
| N140-REQ-004 | Не интерпретировать отсутствие данных о физическом соответствии площадки как доказательство соответствия ФАП. | §1–3 | CANDIDATE / SAFETY |
| N140-REQ-005 | Учитывать применимые геометрические и obstacle constraints площадки при проверке плана. | §38–43 | CANDIDATE / SAFETY |
| N140-REQ-006 | Различать нормативное ограничение, подтверждённый параметр площадки и вычисляемую проверку BlueSky. | §1–3 | CANDIDATE / TRACEABILITY |

## 7. Safety implications

incorrect / stale landing-site data → incorrect planning constraint → invalid route/profile acceptance → safety risk.

Для производных требований предусмотреть идентификацию источника, актуальность, конфигурационную привязку, обработку отсутствующих данных и запрет молчаливого принятия неизвестного параметра.

## 8. Verification strategy

Inspection; Analysis; Test; Integration Test; Evidence Review.

Численные acceptance criteria не вводятся до установления applicability и соответствующего certification/system basis.

## 9. Traceability target

№140 / clause → applicability decision → certification requirement, if applicable → SYS-REQ, if allocated → interface → safety/design → verification → evidence.

## 10. Open gaps

- Окончательная applicability №140 к certification object — OPEN.
- Intended operation — OPEN.
- Перечень реально используемых BlueSky параметров площадки — OPEN.
- Источник/authority каждого параметра — OPEN.
- Геометрический алгоритм obstacle/approach constraints — OPEN.
- Сопоставление с существующими SYS-REQ — OPEN.
- Verification Case IDs — OPEN.
- Evidence records — OPEN.

## 11. Baseline status

**CONTROLLED WORKING DRAFT — NOT BASELINED**

Следующий этап: сопоставить N140-REQ-001…006 с существующим MASTER_REQUIREMENTS_REGISTER.md; использовать существующие SYS-REQ при наличии соответствия и создавать новый ID только при отсутствии подходящей записи.
