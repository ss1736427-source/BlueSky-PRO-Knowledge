---
id: HMI-UI-TRACE-001
type: ui_traceability_working_register
status: draft_for_agreement
system: BlueSky PRO
---

# BlueSky PRO — UI Traceability Working Register

Назначение: связать элементы рабочего интерфейса с проектными требованиями и функциональными областями без превращения UI в источник safety authority.

| UI-ID | Element | Functional allocation | Requirement source | Status |
|---|---|---|---|---|
| UI-HEADER-001 | Header | system status / telemetry | HMI / DATA | REVIEW |
| UI-HEADER-C2 | C2 state | C2 | C2-REQ-001…010 | DRAFT |
| UI-MAP-001 | Flight Chart | navigation / mission | NAV / RTE / WP | REVIEW |
| UI-MAP-ROUTE | Route | route planning | RTE | CANDIDATE |
| UI-MAP-WP | Waypoint | route geometry | WP | CANDIDATE |
| UI-MAP-ZONES | Restricted areas | safety / regulatory | SAFETY / regulatory | REVIEW |
| UI-MISSION-001 | Mission Templates | mission creation | MIS | REVIEW |
| UI-MISSION-ANALYSIS | Mission Analysis | validation / readiness | MIS / RDY / HMI | REVIEW |
| UI-INSTRUMENTS-001 | Instruments | flight state | HMI / DATA | REVIEW |
| UI-ATC-001 | ATC / communication | C2 / external interaction | C2 | DRAFT |
| UI-UAV-001 | UAV Status | vehicle state | UAV / DATA | REVIEW |
| UI-UAV-READY | Ready state | readiness | RDY | CANDIDATE |
| UI-ACTION-START | Start Mission | execution gate | SAFETY / RDY / MIS | CRITICAL REVIEW |
| UI-ACTION-VALIDATE | Validate Mission | validation | MIS / SAFETY | REVIEW |
| UI-ACTION-UPLOAD | Upload to UAV | mission transfer | integration / C2 | REVIEW |
| UI-ACTION-RTH | Return to Home | return / safety | RET / SAFETY | CANDIDATE |
| UI-NAV-001 | Bottom Navigation | context switching | HMI architecture | REVIEW |

## Safety authority boundary

Рабочий UX должен визуально отражать последовательность:

`MISSION → VALIDATION → READINESS → SAFETY GATE → OPERATOR APPROVAL → EXECUTION`

Planning, optimization, AI, simulation и HMI не должны обходить safety authority.

## Map-specific trace notes

Из проектной наработки карты необходимо предусмотреть:

- пройденный и предстоящий путь разными цветами;
- настройку цвета, толщины и прозрачности пути;
- направление движения на маршруте;
- настройку указателей направления;
- отображение препятствий с высотой;
- отображение опасных превышений рельефа более 15 м;
- гибкий масштаб;
- фактическое положение;
- 2D / Terrain / 3D;
- provider adapter и возможность Local Data;
- независимость map provider от Mission/HMI/Flight/Safety ядра.

## Offline / data continuity candidates

Следующие элементы должны быть учтены в UX, но пока не считаются утверждённым baseline:

- Offline Mission Package;
- Offline Continuity;
- Local Result Retention;
- Synchronization State;
- Controlled Synchronization;
- KML Import;
- KML Preview / Validation;
- Geometry-to-Mission Separation.

## Rule

Этот register используется для проектирования и проверки интерфейса. Если требование изменяется, UI trace обновляется после reconciliation. Новые requirement IDs без согласования не создаются.
