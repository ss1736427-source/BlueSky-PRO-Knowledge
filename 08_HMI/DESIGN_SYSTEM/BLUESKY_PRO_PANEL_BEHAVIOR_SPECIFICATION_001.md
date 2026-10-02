---
id: HMI-PANEL-BEHAVIOR-001
type: hmi_panel_behavior_specification
status: working_reference
system: BlueSky PRO
source: 2026-09-19 controlled HMI consolidation
---

# BlueSky PRO — Panel Behavior Specification

## 1. Scope

This document consolidates the panel behavior established during the 2026-09-19 HMI work. It defines behavior, not final pixel geometry.

The screen is treated as six functional levels:

1. TOP / HEADER PANEL
2. LEFT PANEL
3. CENTER / FLIGHT CHART
4. RIGHT PANEL
5. UAV STATUS / LOCAL CONTEXT
6. BOTTOM TOOLBAR / NAVIGATION

The Center / Flight Chart is the primary workspace and is not a conventional side panel.

## 2. Global panel behavior

### 2.1 Independent components

Each panel is an independent UI component with:
- stable UI-ID;
- purpose;
- displayed information;
- states;
- actions;
- min/preferred/max size;
- hide/show rules;
- role applicability;
- related requirements.

### 2.2 Visibility states

Supported conceptual states:
- OPEN / EXPANDED
- COLLAPSED / HIDDEN
- CONTEXTUAL
- TEMPORARILY SURFACED

Hiding changes presentation only. It does not delete data, stop acquisition, alter calculations, or change mission state.

### 2.3 State synchronization

A panel-control button must always represent the actual panel state.

`Panel State ↔ Toolbar State ↔ Workspace State`

A panel must not be visually closed while its control indicates OPEN, or vice versa.

### 2.4 Configuration

Panel configuration controls which supported information blocks/tools are displayed inside that panel.

- Configuration is independent per panel.
- Hidden tools remain available.
- Enabling a tool does not change mission logic.
- Newly enabled tools follow the panel's established layout order.
- Configuration persists for the operator/device context.
- Safety-critical warnings cannot be made inaccessible by filtering.
- Required critical states may be surfaced temporarily regardless of normal filtering.

Panel configuration is distinct from Bottom Toolbar configuration.

### 2.5 Adaptive sizing

The container adapts to its content within defined min/preferred/max bounds.

For the Left Panel:
- growth is vertical, top-to-bottom;
- newly added tools/templates are appended at the bottom;
- existing order is not changed automatically;
- adaptation changes the container size, not the established visual style of individual items.

### 2.6 Map priority

When side panels are hidden or collapsed, the released space belongs to the Flight Chart. The map remains the dominant working area.

## 3. TOP / HEADER PANEL

### Role

Permanent compact aggregate mission/system status.

### Behavior

- remains visible during normal operation;
- stays compact;
- presents mission-wide state and key time parameters;
- secondary information is contextual rather than permanently crowded into the header;
- warning state in the header is synchronized with the Right Panel warning state.

### Functional content

The working architecture includes:
- BlueSky PRO identity;
- Mission Status;
- ETD;
- TOT;
- TRIP;
- ETA;
- WARNING;
- compact system/link state as applicable;
- operator context.

Individual UAV telemetry is not duplicated into the aggregate mission header.

## 4. LEFT PANEL

### Role

**Миссии** — контекст миссии, выбор шаблона и создание миссии. Видимые подписи панели и её инструментов отображаются на русском языке.

### Behavior

- opened by the assigned Bottom Toolbar control;
- same control closes/collapses it;
- toolbar control state follows actual panel state;
- panel remains compact and content-sized;
- the panel title is `Миссии`; the list provides mission-template selection and creation;
- other available templates remain accessible through the existing list/menu;
- selecting a hidden template makes it visible and active/highlighted;
- new tools/templates are appended at the bottom.

### Mission template visibility and selection

- **Automatic mission:** show the mission context and only the templates actually assigned to that mission. Hide all other available templates from the active mission view. This makes the mission composition immediately legible.
- **Manual mission creation:** show the available template catalogue. The operator may select one template or combine several templates.
- Each selected template contributes its own planning scaffold to the Flight Chart. The operator combines/edits these scaffolds on the map into one mission composition.
- After the operator completes the combined composition, submit it to the same core mission-planning pipeline used for an automatically composed mission.
- The only replaced stage is **automatic template selection/assignment**: manual creation uses the operator's explicit template selection instead. All subsequent planning, constraint checks, routing, wind/performance calculations, 4D trajectory verification, conflict resolution, readiness and safety gates remain the same.
- Manual selection does not bypass validation, authorization, feasibility checks or operator approval. A selected template is an input to planning, not permission to fly.
- In manual creation mode, selection is multi-select. The UI must distinguish selected templates from merely available templates.
- Do not display the full catalogue as if every template were part of an existing automatic mission.

### Mission creation action

- A dedicated `СОЗДАТЬ МИССИЮ` button is pinned to the bottom of the Left Panel, filled with controlled green `#64FF00`, with centered dark text.
- The button remains in the same bottom position when the current mission is hidden; hiding the mission hides its context and template list, not this action. Do not show an extra hidden-state placeholder or restore button in the panel body; the title-bar `+` remains the restore control.
- Activating it collapses the previous mission context and switches the workspace map to a clean manual-creation state. The previous mission is not deleted.
- During creation mode, the template list remains available for selection. The active creation is marked as manual (`M`); its immutable full ID is assigned by the mission-creation/core layer when the mission record is created.
- The fixed button is not a template item and must not appear in or reorder with the template list.

### Mission context

- Show a compact mission identifier using only type and sequence: `A-001` (automatic) or `M-001` (manual); omit the `№` symbol and the `BS`/date prefix in collapsed display.
- Clicking the compact identifier toggles the full immutable ID, e.g. `BS-260920-A-001`; clicking again returns to compact form.
- Place the compact mission ID and concise mission-purpose summary on one horizontal line. Keep `СКРЫТЬ` as a separate, right-aligned action on that same line.
- The summary is derived from the operator's aggregated task description and supplied by the mission/task aggregation layer; the UI must not invent task details.
- Truncate the summary with an ellipsis when needed. Expanding the full ID may reduce the summary's available width, but the ID and `СКРЫТЬ` action must remain legible and must not overlap.

`СКРЫТЬ`:
- automatically saves current mission state first;
- hides the current mission from Flight Chart and collapses its panel context;
- keeps the bottom-pinned `СОЗДАТЬ МИССИЮ` action visible and fixed;
- deletes no data.

`+`:
- restores a hidden mission;
- restores the saved state and the same Mission ID;
- is a mission-context restore mechanism, not a duplicate-ID mechanism.

Delete remains a separate explicit operation.

### Mission ID

Created immediately after mission creation.

Format:
`BS-YYMMDD-T-NNN`

- `BS` — BlueSky
- `YYMMDD` — date
- `T` — M Manual / A Automatic
- `NNN` — sequential number for that date

Mission ID is immutable through save, hide, restore and editing. Manual corrections to an automatic mission do not change A to M.

### Close behavior

Left Panel closes through:
- its Bottom Toolbar button;
- double-click in the map area;
- automatic closure at mission start.

A single map click does not close it.

## 4A. Automatic multi-UAV task allocation and mission tabs

### Allocation authority

- For an automatically composed mission, the mission-planning/allocation layer proposes and applies the initial distribution of selected templates across available, eligible UAVs.
- The operator is not asked to approve a successful routine allocation. Allocation is an internal planning step, not a separate operator confirmation gate.
- The allocator must return an explicit assignment per participating UAV: UAV identity, source template/task, assigned role or sector/side, and the corresponding route/route version.
- A template may be assigned to multiple UAVs. Each assignment must explain the division of work (for example, north/south/west slope); repeating only the template title is insufficient.
- The UI displays the allocation result; it must not invent task names, sectors, or assignments. Missing/ambiguous assignment data is shown as unavailable, not fabricated.
- If the allocator cannot produce a feasible, complete assignment, or detects unresolved constraints/conflicts, it raises a specific exception and requests operator intervention with the reason and available corrective choices.
- Successful allocation does not bypass route validation, airspace/NOTAM constraints, vehicle feasibility, readiness, safety gates, required permissions, or the applicable operator authorization to execute.

### Mission tabs

Each compact, adaptive UAV tab displays, in order:
1. sequence number;
2. assigned task/template;
3. assigned sector, side, or role;
4. UAV tail number.

If several UAVs share a template, the template label may repeat, while sector/role differentiates each tab. Selecting a tab selects that UAV's own route, waypoint table, and flight profile. The Flight Chart remains the mission-wide view and shows all assigned UAV routes together, with distinguishable UAV/route labels. Selection may emphasize one route without removing the others.

### Initial allocation vs. in-flight redistribution

Initial task allocation during mission planning is automatic as described above. This does not conflict with the separate controlled operation required for redistribution after mission start or in response to an operational decision. In-flight redistribution must be explicitly assessed, validated, and recorded; it is not silently performed by the local recommendation layer.

The current QML allocation records are Design Studio preview fixtures only. Production assignment records must be supplied by the mission-planning/allocation layer and linked to authoritative per-UAV routes. The HMI preview is not evidence that the allocator or route generation is implemented.

## 5. CENTER / FLIGHT CHART

### Role

Primary workspace.

### Behavior

The Flight Chart receives the maximum practical workspace and visually dominates the screen.

Operational spatial information belongs here:
- route;
- waypoints;
- UAV positions;
- restrictions / zones;
- NOTAM;
- weather/wind;
- active/optimal route;
- completed/uncompleted route;
- mandatory waypoints;
- spatial warnings;
- 2D / Terrain / 3D and Flight Profile overlays where applicable.

Map controls and route editing remain spatial operations, not replacements for panel content.

## 6. RIGHT PANEL

### Role

Operational control, checklist, warnings and readiness.

Detailed current telemetry belongs to the UAV Panel. Spatial operational information belongs to the map. Non-immediate technical/history/archive information belongs to Administration / Technical State / Logs.

### Operational readiness tools: WEATHER and NOTAM

The Right Panel includes two dedicated operational tools:

- **WEATHER** — weather conditions relevant to the planned route and time window, including wind and gusts, direction, temperature, precipitation and visibility where data are available. The assessment must use the limits of the assigned UAV and mission. A material change in weather/forecast triggers revalidation.
- **NOTAM / AIRSPACE** — current notices and airspace restrictions evaluated against the mission route, altitude and time window. The result identifies relevant notices, route intersections, effective periods/altitudes and whether an authorization is required.

Each tool has a compact status row and an expandable detail state. Details must identify data source, retrieval/update time, validity/freshness and the assessment result. Missing or stale data must never be presented as a successful check.

Until the live data providers and route-assessment services are integrated, the HMI must explicitly show that data are unavailable and the check has not been completed. Design-time examples are not operational evidence.

### Conditional WEATHER / NOTAM presentation

WEATHER and NOTAM are not persistent status cards on the INFORMATION panel. Their details are surfaced to the pilot only when the authoritative route-planning/revalidation result marks the corresponding item as requiring pilot attention—for example, when weather constraints prevent automatic route completion, a NOTAM/airspace restriction intersects the proposed route, or an unresolved condition requires a pilot decision.

When the route is automatically composed and validated successfully, and neither source requires pilot action, the WEATHER/NOTAM cards and their related alert messages remain hidden from the panel. The system retains source data and check results in the relevant subsystem/journal; the panel does not repeat routine successful checks.

The HMI must consume explicit planner outputs such as `weatherPilotAttentionRequired` and `notamPilotAttentionRequired`. It must not infer an issue merely because weather/NOTAM data exist, nor infer success from missing data. If unavailable or stale data prevent the planner from validating the route, the planning/safety layer must return a pending/blocked result and an explicit attention requirement where pilot action is needed. These flags are currently HMI interface properties; they are not yet connected to the production planner.

### Readiness checklist

The checklist contains these ten checks:

1. Mission definition
2. UAV allocation
3. Route validation
4. NOTAM / Airspace
5. Weather
6. Terrain / Obstacles
7. Battery / Payload
8. C2 / GNSS
9. Permissions
10. Final validation

Each item uses one of four states: `PASS`, `WARNING`, `FAIL`, or `PENDING`. The displayed count is calculated from the checklist model and authoritative check results; it must not be hard-coded. Until authoritative results are connected, items remain `PENDING`. The HMI must not infer a pass from missing data or from the presence of a UI element.

### Normal action hierarchy

1. CHECKLIST
2. INFORMATION — system messages and required operator actions
3. Mission Readiness
4. contextual VALIDATE MISSION after automatic re-check
5. SEND FLIGHT PLAN
6. START MISSION when fully ready

RETURN is not a normal Right Panel action.

### Compact content and panel control node

- CHECKLIST shows only items that are not `PASS`. The header counter continues to report completed checks against the total; completed routine checks are not repeated as individual rows.
- INFORMATION overview shows only events requiring operator attention/intervention, including critical failures and active warnings. Routine informational changes already handled by the system remain in the journal/audit trail and are omitted from the panel overview.
- Checklist, WEATHER/NOTAM details, and INFORMATION detail content adapt to their content within the space available between the panel header and ATC work area. When content exceeds the available height, the content area scrolls; it must not paint over adjacent cards or ATC controls.
- Panel settings are organized in expandable branches in the panel control node: `MONITORING` (Checklist, Weather, NOTAM, Information), `MISSION CONTROL` (Readiness, Validation, Send Flight Plan, Start Mission), and `MAP` (Map Alerts). Each tool retains an independent enable/disable control.
- The settings list itself scrolls when its expanded branches exceed the available popup height. Group expansion and tool enablement are configuration state only and do not alter mission or safety state.
### Warning behavior

Header WARNING remains synchronized with active warning state; the Right Panel presents system events in INFORMATION.

INFORMATION displays system failures, changes and warnings. Each message has a stable event identity and severity, and may specify whether pilot intervention is required.

- A new warning updates the Header WARNING state and is surfaced in INFORMATION.
- Selecting a message opens its detail.
- If pilot intervention is required, the message provides an entry to the contextual pilot-action area.
- After reading and explicitly confirming, the message is removed from the INFORMATION overview only.
- Acknowledgement does not delete the event, alter system state or count as completion of the required intervention.
- With no unacknowledged messages, the INFORMATION body remains empty; do not display a success/“all clear” message.
- Serious/critical warnings may also appear as a large alert over the map. The event remains in the Journal/Audit trail.

The current QML uses preview examples. Production messages, durable acknowledgement state, event journaling and actual intervention routing must be supplied by the system event/journal and operational workflow layers.

### Manual mission validation

- When manual mission creation starts, the Right Panel displays a dedicated pulsing green `ВАЛИДАЦИЯ МИССИИ` action.
- The action remains visible while the operator assembles the mission from selected template scaffolds on the Flight Chart.
- It is not actionable until the map/mission editor reports that the combined composition is complete.
- The operator must explicitly press the action. This emits a manual-validation request to the common planning workflow.
- Once the request is dispatched, the action immediately disappears and is not offered again for that creation pass.
- The request enters the same downstream planning, validation, constraints, route/performance, trajectory/conflict and readiness process as an automatically composed mission. Only template selection differs.
- The HMI action is a workflow trigger, not proof that validation succeeded. Readiness and safety state must be set only from authoritative core results.
- The current Flight Chart is a structural placeholder. Its completion signal is an integration point; actual completion detection and dispatch into the planning core require the map editor/core implementation.

### Automatic validation

Relevant readiness-affecting changes trigger automatic revalidation, including route/WP, UAV/configuration, battery/resource, equipment, weather/forecast, restrictions/NOTAM and other relevant inputs.

When validation succeeds and operator confirmation is required:
- `VALIDATE MISSION` appears;
- its outline uses the defined dynamic breathing green treatment;
- after confirmation it stops and disappears.

When validation fails, the corresponding warning/error is shown.

### Readiness and safety invariants

- NOTAM/airspace checks are evaluated against route geometry, altitude and mission time, not merely by detecting that notices exist.
- Weather is evaluated against the assigned UAV and task constraints. A relevant change triggers revalidation.
- Every external result carries its source, timestamp and freshness/validity status.
- Missing, stale or inconclusive inputs are `PENDING` or `WARNING`, never `PASS`.
- Critical restrictions, C2 failures or insufficient energy reserve block the relevant readiness transition. INFORMATION acknowledgement cannot clear a safety block.
- For multi-UAV missions, checks are associated with each assigned UAV; mission readiness aggregates all required per-UAV and mission-wide results.
- HMI status is a representation of authoritative subsystem results. It cannot override Safety, grant permissions or independently authorize execution.

### Start Mission

`START MISSION` is not green by default. It becomes active only when current readiness and required checklist/validation conditions are satisfied. A readiness-invalidating change returns it to the non-ready/disabled state.

## 7. UAV STATUS / LOCAL CONTEXT

### Role

Current state and decision context of individual UAVs.

The UAV Panel carries detailed current telemetry and mission progress that should not be duplicated in the aggregate header.

When a specific UAV requires an operational decision:
1. warning outline appears around the affected UAV/card;
2. operator selects the UAV;
3. local context opens;
4. telemetry and problem reason are shown;
5. system performs preliminary assessment;
6. concise recommendation with relevant reasoning factors is shown;
7. operator decides;
8. local context collapses.

Local decision options:
- `RETURN`
- `ПРОДОЛЖИТЬ ПОЛЁТ`

The system recommends; the operator decides. The recommendation is not itself a flight command.

The assessment may consider telemetry, detected deviation, battery/resource, remaining distance/time, route and mission state, weather, communications, feasibility of return/continuation and mission-completion impact.

If redistribution is required, it is a separate controlled mission operation and is not silently performed by the recommendation layer.

Journal/Audit records the event, assessment factors, recommendation, operator decision and resulting action.

## 8. BOTTOM TOOLBAR / NAVIGATION

### Role

Persistent workspace/tool navigation and panel control.

### Behavior

- controls panel visibility;
- provides access to configured tools;
- reflects actual panel state;
- uses a distinct configuration mechanism from per-panel tool configuration;
- maintains the established tool order unless explicitly reordered;
- does not become a duplicate telemetry dashboard.

### Strict enabled-button invariant

ENABLE in Bottom Toolbar configuration is a hard visibility guarantee:

- an enabled workspace context MUST have a corresponding button on the Bottom Toolbar;
- drag/reorder operations may change position only;
- clicking an enabled button activates the context but cannot remove the button;
- persistence/load/model refresh must restore every enabled button;
- only an explicit DISABLE action may remove a workspace button;
- if an internal model/projection inconsistency occurs, the runtime must restore missing enabled buttons before completing the reorder operation.

## 9. Overlay / Context behavior

Context panels are used for local decisions and secondary information.

They:
- appear only when context requires them;
- preserve the underlying mission state;
- collapse after completion of the contextual interaction;
- do not silently change mission state unless an explicit operator action and controlled operation do so.

## 10. Safety boundary

The HMI represents:

`MISSION → VALIDATION → READINESS → SAFETY GATE → OPERATOR APPROVAL → EXECUTION`

HMI, planning, optimization, AI and simulation do not bypass safety authority.

## 11. Status and source boundary

This is a working reference derived from the controlled 2026-09-19 HMI commits. It is not a certification approval and does not freeze final geometry, typography or pixel dimensions.


## 12. Right Panel implementation scope — WEATHER / NOTAM

Implementation is staged:

1. Update the Right Panel HMI with WEATHER and NOTAM tools, compact statuses, detail states, the ten-item readiness checklist and explicit unavailable/pending states.
2. Define data contracts for weather, NOTAM/airspace, source metadata, timestamps, freshness and route-assessment results.
3. Integrate the authoritative weather, restriction, planning and telemetry sources.
4. Verify safety behavior and tests for route/NOTAM intersections, effective time/altitude, stale or missing data, weather changes, C2 loss and insufficient energy reserve.

The current HMI change implements the presentation layer only. Live providers, route evaluation, authoritative checklist state and Safety integration remain separate work and must not be represented as complete.
