# BlueSky PRO — Route Calculation & Optimization Specification

**Status:** WORKING BASELINE  
**Position:** PHASE 8 — Mission Planning / Route Calculation

## 1. Core principle

**Canonical planning pipeline:** BlueSky performs each required evaluation once at the stage where its required inputs exist. Spatial/hard constraints are resolved before route comparison; wind converts route candidates into time-dependent trajectories; multi-UAV conflict/separation is evaluated on those 4D trajectories; candidate comparison is performed only on candidates that remain feasible. Final validation verifies the selected result and changed-input impact rather than repeating the same calculations.

BlueSky separates **task/coverage planning** from **dynamic flight-parameter calculation**.

The planner generates route candidates using deterministic search algorithms and resolves spatial hard constraints before comparison. Candidates are assigned to compatible UAVs, then wind/performance evaluation converts them into time-dependent trajectories with ground speed, time and energy. Multi-UAV conflict/separation is evaluated on these 4D trajectories. Only candidates that remain feasible are compared and the route set is selected. Final validation checks result integrity and material input changes; it does not blindly repeat the complete planning pipeline.

```text
TASK / COVERAGE REQUIREMENT
          ↓
KNOWN CONSTRAINTS + TERRAIN + AIRSPACE / NOTAM
          ↓
ROUTE SEARCH / CANDIDATE GENERATION
          ↓
SPATIAL HARD-CONSTRAINT FILTER
          ↓
ROUTE CANDIDATES
          ↓
UAV CAPABILITY / FLEET ALLOCATION
          ↓
WIND + VEHICLE PERFORMANCE → 4D TRAJECTORIES
          ↓
MULTI-UAV CONFLICT / SEPARATION CHECK
          ↓
CANDIDATE COMPARISON / OBJECTIVE
          ↓
SELECTED ROUTE SET
          ↓
FINAL INTEGRITY / CHANGE-IMPACT VALIDATION
```

## 2. Planning inputs

Stable inputs include mission objective, area/targets, coverage pattern, overlap, mandatory waypoints, terrain/DEM, fixed obstacles, restricted areas, UAV capabilities, payload capabilities, fleet availability, performance limits, battery/resource state and safety margins.

Dynamic inputs include wind by position/altitude, weather, temporary restrictions, traffic information where available, current vehicle state, actual energy consumption and C2 condition.

## 3. Coverage-first planning

For survey, mapping, inspection and similar tasks:

```text
MISSION AREA
     ↓
TASK DECOMPOSITION
     ↓
COVERAGE CELLS / TRACKS / TARGETS
     ↓
CONSTRAINT FILTER
     ↓
ROUTABLE GRAPH
```

The planner distinguishes required coverage, prohibited areas, mandatory points and sequencing constraints.

## 4. Graph model

Where appropriate, BlueSky represents the feasible environment as a weighted graph. Nodes may represent waypoints, coverage points, turns, altitude layers, launch/recovery points and transitions between coverage cells. Edges represent feasible flight segments.

Edge cost is evaluated only for feasible edges. Depending on the mission objective profile it can contain:

`distance + wind-adjusted time + wind-adjusted energy + operational cost`

Hard safety and regulatory constraints are feasibility constraints, not cost weights. A prohibited/restricted edge is removed from the search graph; no finite penalty may make it selectable.

For the default route-planning profile, geometric distance is the primary objective and wind-adjusted time/energy are secondary objectives. For an explicitly configured efficiency profile, the optimizer may select a slightly longer legal route when the wind-adjusted operational cost is lower. The objective profile and weights/tolerances are versioned inputs, not hidden optimizer behavior.

## 5. Dijkstra decision

**Dijkstra is retained as the deterministic reference route-search algorithm.**

For a graph with non-negative edge costs, Dijkstra finds the least-cost path under the defined cost model and is deterministic/reproducible. It is therefore valuable as a reference implementation and fallback.

However, Dijkstra alone is not the complete BlueSky optimizer: it does not inherently perform coverage decomposition, multi-UAV assignment, nonlinear energy modelling or dynamic replanning.

## 6. Recommended algorithm architecture

Use a **hybrid, deterministic-first architecture**:

```text
MISSION
  ↓
COVERAGE GENERATOR
  ↓
CONSTRAINT GRAPH
  ↓
ROUTE SEARCH
 ├── Dijkstra — reference / fallback
 └── A* — interchangeable acceleration where valid
  ↓
ROUTE CANDIDATES
  ↓
MULTI-UAV ALLOCATION / CAPABILITY FILTER
  ↓
WIND + FLIGHT-PERFORMANCE → 4D TRAJECTORIES
  ↓
CONFLICT / SEPARATION CHECK
  ↓
MULTI-OBJECTIVE OPTIMIZATION
  ↓
CORRECTION / LOCAL RE-OPTIMIZATION
  ↓
FINAL ROUTES
```

Current UAV path-planning literature continues to identify Dijkstra and A* as important classical graph-search methods, while hybrid approaches are used when energy, dynamic environments and multi-UAV coordination must also be handled. citeturn0search1turn0search2

**Decision:** do not replace Dijkstra with one monolithic AI/metaheuristic algorithm. Keep Dijkstra as the reference result; use A* as an interchangeable search backend where it gives measurable performance improvement. Higher-level optimization remains responsible for coverage, allocation, energy and wind.

## 7. Fleet distribution and candidate ownership

After spatial route candidate generation and before 4D conflict evaluation:

```text
TASK SEGMENTS
     ↓
CAPABILITY FILTER
     ↓
UAV CANDIDATES
     ↓
ASSIGNMENT / BALANCING
     ↓
UAV-01 route
UAV-02 route
UAV-03 route
```

Assignment considers payload capability, endurance/energy, performance, battery/resource state, C2 availability, regulatory restrictions, launch/recovery constraints and mission priority. Separation is evaluated later on the resulting 4D trajectories, once wind/performance has established timing.

## 8. Wind-aware trajectory evaluation

**Wind participates in route selection when wind-aware planning is enabled.**

The evaluator resolves the wind vector along each candidate segment against the assigned UAV's airspeed/performance model and produces ground speed, traversal time and energy. This creates the 4D trajectory needed for multi-UAV conflict/separation evaluation. Wind therefore affects candidate feasibility and comparison without requiring a second independent flight-parameter calculation for the same data.

The baseline route remains a deterministic reference. Wind-aware optimization produces a traceable candidate/variant rather than silently replacing the baseline.

## 9. Selected-route profile

The selected route is compiled into the Flight Profile using the already calculated 4D trajectory inputs. No second independent wind calculation is performed unless the source data, UAV configuration or route materially changes.

For every segment and relevant altitude, BlueSky uses the wind vector together with the aircraft air-relative velocity to determine ground velocity and track.

```text
AIRCRAFT AIRSPEED VECTOR
          +
     WIND VECTOR
          ↓
    GROUND VECTOR
          ↓
 ground speed / track
          ↓
     segment time
          ↓
    energy estimate
```

The calculation updates heading/track, ground speed, segment time, ETA, energy consumption, remaining reserve and return/contingency feasibility.

Wind speed and direction materially affect UAV flight time and energy; recent reviews specifically identify wind as an important factor in energy-aware UAV path planning. citeturn0search4turn0search5

## 10. Multi-UAV conflict and separation

Multi-UAV conflict is evaluated on the wind-adjusted 4D trajectories after route candidates are assigned to compatible UAVs. The check uses spatial separation, altitude separation and temporal overlap. A conflict is a violation of the configured separation envelope; physical collision is the limiting case.

The conflict result is a feasibility result, not a soft optimization penalty for safety-critical separation. Conflict resolution may use the existing candidate set, sequencing/start delay or controlled re-planning. A second conflict calculation is required only when a correction materially changes geometry, speed, altitude or timing.

This keeps the algorithm non-redundant: route geometry is checked once, wind/performance is calculated once, and the resulting 4D trajectories are checked for conflicts once per candidate state.

## 11. Wind as feasibility constraint

Wind may also be a hard feasibility condition. Examples include maximum allowable wind, crosswind/headwind limits, minimum achievable ground speed, energy-reserve limits, or vehicle-specific operating envelopes. A candidate violating such a condition is rejected before route selection.

Thus the architecture is:

**hard constraints → feasible graph → distance/wind-aware optimization → detailed vehicle verification → Correction/re-optimization if required.**

## 11. Corrections

The baseline route remains the reference mission solution. Updated wind produces a traceable Correction rather than an unexplained route replacement.

```text
BASELINE
   ↓
CURRENT WIND
   ↓
RECALCULATION
   ↓
CORRECTION
   ↓
COMPARE
 ├─ within limits → continue
 └─ outside limits → re-optimize
```

The Correction records the reason, input-data version, affected segments and resulting change.

## 12. Re-optimization triggers

Full or partial re-optimization may be triggered by excessive wind, insufficient energy reserve, new restrictions, changed terrain/obstacle information, UAV state/capability changes, material C2 degradation or traffic/safety conditions.

## 13. Energy model

Energy calculation is a separate service from graph search. The edge evaluator receives vehicle configuration, payload, flight state, weather and segment geometry and returns estimated time and energy cost.

Conceptually:

`E_segment = f(distance, airspeed, ground_speed, altitude, climb/descent, mass, payload, propulsion, wind, temperature, configuration)`

The model supports battery degradation and installed-equipment effects previously defined for BlueSky. Energy-aware UAV research models energy as a function of trajectory, vehicle state and environmental factors including wind. citeturn0search4

## 14. Mission objective

BlueSky does not hard-code one universal optimization objective. Mission templates select the objective profile, for example:

- minimum energy;
- minimum time;
- maximum coverage;
- punctual ETA;
- maximum payload capability;
- balanced multi-objective operation.

A representative objective is:

`J = wE·E + wT·T + wD·D + wR·Risk + wM·MissionPenalty`

Safety/regulatory hard constraints cannot be traded away by reducing a weight.

## 15. Role of Dijkstra

**Dijkstra:** deterministic graph search, least-cost path under the edge model, reference result and fallback.

**Coverage generator:** converts mission intent into coverage elements.

**Fleet allocator:** distributes work between compatible UAVs.

**Wind/performance engine:** calculates actual heading, ground speed, time and energy under current conditions.

**Optimizer:** compares feasible variants against the mission objective.

**Correction engine:** responds to changing conditions and preserves traceability.

## 16. Verification

Required reference scenarios include obstacles, restricted areas, mandatory waypoints, Dijkstra reference paths, wind from principal directions, variable wind by segment/altitude, energy reserve limits, payload-dependent performance, multi-UAV allocation, dynamic correction and deterministic replay/regression.

## 17. Gate

PHASE 8 is complete only when BlueSky can:

1. convert mission intent into a routable coverage/task structure;
2. generate a deterministic baseline route or route set;
3. distribute the task among compatible UAVs;
4. apply current wind and recalculate flight parameters;
5. evaluate time and energy feasibility;
6. issue traceable Corrections;
7. re-optimize when required;
8. produce a versioned mission ready for the autopilot integration layer.

## 18. Decision record

**Baseline:** Dijkstra remains the deterministic reference algorithm.

**Optimization architecture:** Dijkstra/A* are route-search backends inside a larger optimizer; coverage decomposition, fleet allocation, wind-aware edge evaluation, detailed vehicle-performance verification and dynamic correction are separate stages.

**Restriction behavior:** active prohibited/restricted geometry is excluded from the feasible search graph. The optimizer must generate legal detours rather than route through a restricted zone and penalize the crossing.

**Default objective:** minimum geometric distance among feasible routes, with wind-adjusted time/energy as secondary criteria. An explicitly versioned mission objective may permit a longer route when its wind-adjusted operational cost is lower.

**Wind:** wind is an optimization input when required by the mission profile, not merely a post-flight calculation.

**AI:** may later assist higher-level optimization or Corrections, but must remain behind a defined contract and cannot silently replace the deterministic reference without verification evidence.
