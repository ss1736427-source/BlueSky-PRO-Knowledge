# BlueSky PRO — Interactive Flight Profile: Data Synchronization and Recalculation

**Status:** APPROVED REQUIREMENT  
**Scope:** Mission planning HMI, canonical route model, validation and recalculation  
**Applies to:** Flight profile, waypoint table, map and all calculation data flows

## 1. System requirement

The flight profile is a fully interactive mission-editing surface, equivalent in editing authority to the map and waypoint table. It is not a standalone visualization and must not maintain an independent authoritative route.

Any supported edit made in the profile must be applied to the canonical mission/route data model and propagated to every dependent view and calculation flow.

## 2. Synchronized views

The following representations must reflect the same current route state:

- flight profile;
- waypoint/flight-parameter table;
- active map and route geometry;
- mission calculation inputs and derived values;
- validation results, warnings and mission readiness state.

No view may silently retain stale values after an edit or recalculation.

## 3. Editing behavior

- Selecting a waypoint or route-profile point selects the corresponding canonical waypoint.
- Editing a waypoint altitude in the profile updates that waypoint's altitude in the table and map.
- Editing the same waypoint in the table or map updates the profile.
- Creating or moving a mandatory waypoint/constraint in the profile updates the canonical route data and all corresponding representations.
- A mandatory altitude is a route constraint, not merely a graphical marker or user-interface preference.
- Edits to one waypoint must not unintentionally modify other waypoints. Any downstream changes made by the planner must be explicit outputs of recalculation.

## 4. Validation and recalculation transaction

Every edit that can affect the route or its calculated properties must initiate this controlled sequence:

1. Apply the edit to a route candidate / working mission version.
2. Validate input values and mandatory constraints.
3. Revalidate affected route constraints, including applicable airspace/restrictions, terrain and obstacles, mission/task requirements, vehicle limits, wind/environmental inputs, and conflicts with other UAV routes.
4. Recalculate affected route and mission values, including segment course, distance, altitude, air/ground speed where applicable, segment and total time, ETO/ETA, energy/battery estimates, and other dependent values.
5. Publish the resulting current route/profile/table/map state and validation/readiness results together.
6. Preserve traceability to the mission version, route version, calculation-input version and environmental-data snapshots.

The implementation may use incremental recalculation where dependencies allow it, but the published result must be internally consistent. If a full recalculation is required, it must be performed before the edited route is presented as validated.

## 5. Invalid or incomplete edits

- An edit that fails validation must not silently become the accepted/validated route.
- The interface must identify the failed constraint or missing/stale input.
- The system must retain the last valid route state or clearly distinguish the unvalidated candidate from it.
- Readiness must be recalculated from the validation result; editing must never directly force a READY state or bypass safety/authorization gates.

## 6. Data authority and persistence

- The canonical route/mission model is authoritative; UI-local models are presentation/editing buffers only.
- User display preferences (for example, visible columns or column order) must not be used as storage for operational route constraints.
- Mandatory waypoint identity and altitude belong to the mission/route data model and must persist with the applicable mission/route version.
- Accepted changes create a traceable new mission/route version when required by the canonical route-versioning rules.
- Previously archived mission versions remain immutable.

## 7. Acceptance criteria

1. Changing a waypoint altitude in the profile updates the same waypoint in the table and map.
2. Changing the altitude in the table or map updates the profile.
3. Adding, moving or selecting a mandatory profile point updates the canonical route constraint and its corresponding table/map representation.
4. Each operational edit triggers validation and the required recalculation of dependent values.
5. Course, distance, speeds, segment time, ETO/ETA, trip time and energy values shown across views agree with the same calculation result.
6. An invalid edit produces an explicit validation result and cannot be represented as a validated/READY route.
7. Other waypoints remain unchanged unless the planner explicitly changes them as a reported result of recalculation.
8. All views update from one consistent route/calculation version; stale values are not silently displayed as current.
9. Route changes and accepted results remain traceable; archived versions are not overwritten.

## 8. Architectural boundary

The HMI initiates edits and presents results. It does not independently implement authoritative route validation, safety decisions, flight authorization or vehicle commands. These remain with the relevant planning, validation and safety components.

## Related canonical specification

See [Canonical Route Model (PLAN-DATA-001)](../../../02_SYSTEM_DESIGN/PLANNING/FLIGHT_PLANNING_CANONICAL_ROUTE_MODEL_001.md) and [Flight Profile Interaction](Flight%20Profile%20Interaction.md).
