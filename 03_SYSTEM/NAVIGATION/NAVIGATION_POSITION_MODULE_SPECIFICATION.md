---
id: NAVIGATION-POSITION-MODULE-001
type: navigation_module_specification
status: draft_for_agreement
authority: derived_from_navigation_state_model_rules_algorithm_icd
---

# BlueSky PRO — Navigation / Position Module Specification

## 1. Purpose

Определить первый детализируемый модуль блока Navigation — `Position` — без введения неподтверждённых требований и без изменения общей архитектурной границы.

## 2. Responsibility

Модуль Position отвечает за представление текущего положения БВС в навигационном состоянии и передачу его потребителям с сохранением качества и происхождения данных.

Модуль не определяет:

- выполнение команд БВС;
- разрешение на выполнение миссии;
- Safety Gate;
- Authorization;
- самостоятельное изменение маршрута;
- самостоятельное управление БВС.

Это соответствует установленной границе `Navigation State ≠ Execution Authority`.

## 3. Position data model

Минимальная логическая запись:

```text
Position
├── value
├── horizontalReference
├── verticalReference
├── units
├── timestamp
├── source
├── freshness
├── validity
└── confidence
```

Точный состав полей API и внутреннего storage является предметом Software Design.

## 4. Source semantics

Position может поступать из одного или нескольких навигационных источников.

Для каждого существенного значения необходимо сохранять:

```text
source
 timestamp
 freshness
 validity
 confidence
```

Источник не считается достоверным только из-за наличия значения.

При нескольких источниках результат должен сохранять возможность восстановить происхождение исходных значений и итогового результата.

Алгоритм выбора приоритетного источника и fusion пока не фиксируется.

## 5. Reference frame / coordinate model

До отдельного согласования не фиксируется конкретный CRS.

Обязательными атрибутами остаются:

```text
horizontal CRS = TBD
vertical reference / altitude datum = TBD
axis convention = TBD
units = TBD
precision = TBD
valid range = TBD
```

Запрещается молча преобразовывать или смешивать координаты разных reference frames.

## 6. Position quality state

Модуль должен поддерживать состояния:

```text
VALID
DEGRADED
STALE
INVALID
UNAVAILABLE
CONFLICTING
```

Переходы и численные thresholds не определяются до отдельного согласования requirements/design.

Критически важное правило:

```text
INVALID / STALE / UNAVAILABLE
        ≠
VALID
```

Система должна передавать downstream consumers состояние качества, а не только координаты.

## 7. Planned / Actual / Simulated

Position должен быть различим по контексту:

```text
PLANNED
SIMULATED
ACTUAL
```

`SIMULATED` и `PLANNED` не становятся `ACTUAL` без фактического подтверждения.

Actual Position должна иметь timestamp и provenance.

## 8. Route / Mission context

При использовании Position для расчёта отклонения или навигационного контекста должны быть доступны идентификаторы контекста:

```text
Mission ID
Route ID
Route Version
Active WP
WP Version
Navigation State Timestamp
```

Это необходимо для исключения сравнения Actual Position с устаревшей версией маршрута.

## 9. Data flow

```text
External / UAV Navigation Source
             ↓
       Position Input
             ↓
        Source Check
             ↓
      Quality Assessment
             ↓
       Navigation State
             ↓
   ┌─────────┼──────────┐
   ↓         ↓          ↓
 Route     Mission    Safety Validation
 Planning    /HMI          / other consumers
```

Position Module не является конечным authority layer.

## 10. Interfaces

Предварительные интерфейсы по действующему ICD:

```text
IF-NAV-xxx  Navigation internal/external interface
IF-HW-001   Aviation system ↔ UAV / onboard equipment
IF-NAV-001  Aviation system ↔ Navigation sources
```

Точные Interface IDs, transport, protocol, schema, timing и failure behaviour должны быть назначены в ICD после согласования design.

## 11. Downstream consumers

Position используется как часть Navigation State для:

```text
Route Planning
Dynamic Return
Collision Avoidance
Mission Calculation
Mission Execution context
Multi-UAV Coordination
Map / Dashboard
Safety Validation
```

Каждый consumer получает семантически определённые данные, включая quality/provenance, когда они существенны.

## 12. Failure behaviour

### Missing

Если Position отсутствует:

```text
Position unavailable
→ quality = UNAVAILABLE
→ impact assessment
```

### Stale

Если Position перестала удовлетворять установленному freshness criterion:

```text
quality = STALE
→ impact assessment
```

### Invalid

При признании значения недействительным:

```text
quality = INVALID
→ value не рассматривается как VALID
→ defined downstream response
```

### Conflicting

При наличии противоречащих источников:

```text
sources preserved
→ conflict detected
→ source/fusion policy
→ impact assessment
```

Конкретная policy остаётся TBD.

## 13. Safety boundary

Position failure не должен скрываться от Validation/Safety цепочки:

```text
Position
 ↓
Validation
 ↓
Navigation State Quality
 ↓
Readiness / Safety assessment
 ↓
Safety Gate
```

Модуль не принимает самостоятельно safety decision, если такая authority ему не выделена.

## 14. HMI allocation

Для оператора Position должна представляться как часть общего навигационного состояния, а не как необработанный поток внутренних технических полей.

Минимально пользователь должен иметь возможность понять:

- текущее положение БВС;
- актуальность положения;
- наличие деградации навигации, если она влияет на эксплуатационное решение;
- связь положения с активной миссией/маршрутом.

Точный layout, размеры, typography, цветовая семантика и interaction model определяются на HMI-проработке соответствующего блока и не должны противоречить утверждённой общей HMI-концепции.

## 15. Verification mapping

Связанные существующие проверки:

```text
NAV-TV-006  Cross-track geometry
NAV-TV-007  Along-track geometry
NAV-TV-010  Coordinate reference
NAV-V06     Route deviation
NAV-V08     Stale navigation
NAV-V09     Invalid navigation
NAV-V10     Missing critical input
NAV-V11     Conflicting sources
NAV-V12     Degraded source
NAV-V16     Material runtime change
NAV-V20     Planned / Simulated / Actual
```

Часть проверок зависит от ещё не утверждённых CRS, datum, precision и quality thresholds.

## 16. Regulatory applicability

На текущем уровне анализа не переносим в Position требования к внешним объектам или организациям.

Приказ Минтранса №142 относится к функционированию линий C2 и контролю БАС; его применимость к конкретному Position interface определяется через System Boundary и роль соответствующего интерфейса. Он не является основанием автоматически превращать весь Navigation Position model в отдельный нормативный набор требований.

Regulatory applicability для каждого конкретного требования должна пройти цепочку:

```text
Official clause
→ regulated object
→ BlueSky role
→ system boundary
→ applicability
→ requirement/interface constraint
```

## 17. Open items

```text
NAV-POS-OPEN-001  Horizontal CRS
NAV-POS-OPEN-002  Vertical reference / datum
NAV-POS-OPEN-003  Units
NAV-POS-OPEN-004  Precision / storage precision
NAV-POS-OPEN-005  Valid range
NAV-POS-OPEN-006  Freshness thresholds
NAV-POS-OPEN-007  Degraded thresholds
NAV-POS-OPEN-008  Source priority
NAV-POS-OPEN-009  Multi-source fusion
NAV-POS-OPEN-010  Confidence calculation
NAV-POS-OPEN-011  Exact interface schema
NAV-POS-OPEN-012  Timing / latency
```

Открытый вопрос не считается GAP автоматически. Сначала устанавливается его основание и необходимость.

## 18. Completion gate

Position Module может считаться `DESIGN-READY` после закрытия:

```text
[ ] responsibility
[ ] data semantics
[ ] source/provenance
[ ] quality model
[ ] coordinate/reference model
[ ] interfaces
[ ] failure behaviour
[ ] safety allocation
[ ] HMI allocation
[ ] verification cases
[ ] requirement traceability
```

Фактическая implementation начинается после прохождения соответствующего design gate.

## 19. Status

**DRAFT_FOR_AGREEMENT**

Новых SYS-REQ данным документом не создаётся.

Следующий модуль Navigation:

```text
VELOCITY / SPEED
```
