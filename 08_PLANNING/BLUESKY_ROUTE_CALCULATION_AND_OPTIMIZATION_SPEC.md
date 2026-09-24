# BlueSky PRO — Route Calculation & Optimization Specification

**Status:** CURRENT WORKING BASELINE**
**Position:** PHASE 9 — Mission Planning / Route Calculation and Optimization

## 1. Governing calculation principle

> **Each calculation is performed once at the architectural level where all inputs required for that result are available. The versioned result is reused by all downstream stages. Recalculation occurs only when an input or dependency capable of changing that result changes.**

This specification is the current planning baseline. Superseded intermediate planning sequences are not active design inputs.

Planning is therefore dependency-driven rather than a chain of repeated independent checks.

Every material calculation result should carry:
- input snapshot/version;
- algorithm/calculation version;
- dependency hash or equivalent;
- affected object/segment/candidate IDs;
- timestamp;
- provenance/evidence references.

## 2. Canonical planning pipeline

```text
MISSION / COVERAGE
        ↓
CONSTRAINED SPATIAL SEARCH
  airspace / NOTAM / terrain /
  obstacles / altitude / mandatory points
        ↓
ROUTE CANDIDATES
        ↓
UAV CAPABILITY / ASSIGNMENT
        ↓
WIND + VEHICLE PERFORMANCE
        ↓
4D TRAJECTORIES
        ↓
MULTI-UAV CONFLICT / SEPARATION
        ↓
CANDIDATE COMPARISON / OPTIMIZATION
        ↓
SELECTED ROUTE SET
        ↓
FLIGHT PROFILE
        ↓
FINAL INTEGRITY / CHANGE-IMPACT CHECK
```

### Sequence rule

1. The route search operates on the constrained spatial environment. Active restricted/prohibited geometry, terrain/obstacle constraints, altitude limits and mandatory-point requirements are incorporated into feasibility during candidate generation.
2. The result is a set of spatially feasible route candidates; obviously forbidden corridors are not generated as selectable routes.
3. Compatible UAVs are assigned before wind/performance evaluation because vehicle characteristics affect the resulting trajectory.
4. Wind and vehicle performance are calculated once for each relevant route/UAV state. This produces ground speed, track, traversal time, energy and the 4D trajectory used downstream.
5. Multi-UAV conflict/separation is evaluated on those wind-adjusted 4D trajectories using spatial, altitude and temporal overlap.
6. Only feasible candidates proceed to objective comparison and optimization.
7. The selected route set is compiled into the flight profile using already calculated trajectory/performance results.
8. Final validation verifies integrity and material input changes. It does not repeat the entire planning calculation.

## 2.3 Flight Chart as the visual representation of the planning environment

The Flight Chart is the primary planning instrument and shall display the same current environment snapshot used by constrained spatial search.

The map shall visually represent, as applicable, NOTAM, airspace restrictions, terrain/obstacles, altitude-dependent and time-dependent restrictions and other hard spatial constraints. The visualization is presentation of the canonical environment model; it does not create a second restriction dataset or perform an independent planning calculation.

The operator must be able to visually understand the relationship between the open space, restrictions and the route being constructed. Selecting a restriction may expose its identity, source, validity, altitude limits and snapshot/version.

If the displayed environment becomes stale, the Flight Chart shall indicate that state rather than silently presenting it as current.

## 3. Coverage-first planning

For survey, mapping, inspection and similar tasks:

```text
MISSION AREA
     ↓
TASK DECOMPOSITION
     ↓
COVERAGE CELLS / TRACKS / TARGETS
     ↓
CONSTRAINED SPATIAL SEARCH
     ↓
ROUTE CANDIDATES
```

The planner distinguishes required coverage, prohibited areas, mandatory points and sequencing constraints.

## 4. Constraint graph and route search

Where appropriate, BlueSky represents the feasible environment as a weighted graph.

Nodes may represent:
- waypoints;
- coverage points;
- turns;
- altitude layers;
- launch/recovery points;
- transitions between coverage cells.

Edges represent spatially feasible flight segments.

Hard safety and regulatory constraints are **feasibility conditions**, not optional cost weights. A candidate that violates an applicable hard constraint is not made acceptable by a lower distance, time or energy cost.

Dijkstra remains the deterministic reference/fallback search algorithm. A* may be used as an interchangeable acceleration backend where its result is demonstrably equivalent under the same graph and objective contract.

The route search stage must not be duplicated by a second independent route generator inside the optimizer.

## 5. Route candidate result

Each route candidate is a versioned object containing, as applicable:
- mission ID/version;
- route ID/version;
- ordered waypoints and segments;
- spatial feasibility result;
- constraint/airspace/NOTAM/terrain snapshot references;
- generator and algorithm versions;
- calculation input version;
- dependency identity;
- provenance.

The candidate is reusable by downstream stages until one of its dependencies changes.

## 6. UAV capability and assignment

Assignment is performed after spatial candidate generation and before wind/performance evaluation.

The capability filter considers, as applicable:
- aircraft capability;
- payload/equipment capability;
- endurance/energy/resource state;
- performance limits;
- C2 availability;
- launch/recovery constraints;
- regulatory constraints;
- mission requirements.

A change in UAV assignment invalidates only calculations dependent on that UAV for the affected candidate; it does not require regeneration of unrelated spatial routes.

## 7. Wind and vehicle performance

Wind is a dynamic planning input. For each assigned route/UAV state, the performance stage combines:
- route geometry;
- altitude profile;
- vehicle configuration;
- payload;
- air-relative performance;
- wind vector by location/altitude;
- relevant environmental conditions.

The output is the single authoritative planning result for downstream trajectory-dependent calculations:

```text
AIR-RELATIVE PERFORMANCE + WIND
              ↓
      GROUND VECTOR / TRACK
              ↓
         GROUND SPEED
              ↓
        SEGMENT TRAVERSAL TIME
              ↓
         ENERGY ESTIMATE
              ↓
        4D TRAJECTORY
```

The 4D trajectory contains the temporal information required for multi-UAV conflict/separation analysis.

If wind makes a candidate infeasible because of a hard vehicle/environmental limit, that candidate is rejected or the affected planning state is regenerated. The system does not perform an independent second wind calculation elsewhere.

## 8. Multi-UAV conflict and separation

Conflict/separation is a feasibility calculation over the already generated 4D trajectories.

Inputs include:
- spatial trajectory;
- altitude;
- time;
- UAV identity;
- applicable separation envelope;
- relevant state uncertainty/tolerance.

Conflict is a feasibility condition, not a soft optimization penalty.

Resolution may use:
- an existing feasible candidate;
- sequencing/start delay;
- controlled local replanning.

A resolution triggers recalculation only of the dependencies it changes. For example, a start delay changes timing and conflict evaluation; it does not require rebuilding unchanged route geometry.

Physical collision is the limiting case of insufficient separation. Safety-significant separation requirements remain under the established safety/authorization architecture.

## 9. Candidate comparison and optimization

Only candidates that have passed all required feasibility stages are compared.

Objective profiles may include:
- minimum energy;
- minimum time;
- minimum distance;
- punctual ETA;
- maximum coverage;
- payload/equipment objective;
- balanced multi-objective operation.

Hard safety/regulatory constraints cannot be traded away by objective weights.

A representative objective may be:

`J = wE·E + wT·T + wD·D + wR·Risk + wM·MissionPenalty`

The optimizer consumes already calculated distance, time, energy, trajectory and feasibility results. It does not independently recompute them.

For materially comparable candidates, wind-adjusted time/energy can determine the selected solution even when geometric distance is not the only objective. The objective profile and tolerances are versioned.

## 10. Correction and local re-optimization

A material input change creates a traceable Correction.

Examples:
- new restriction → affected spatial candidates and downstream dependents;
- terrain change → affected spatial candidates and downstream dependents;
- wind change → wind/performance, 4D trajectories, conflict and comparison;
- UAV configuration change → affected assignment/performance/trajectory/conflict/comparison;
- start delay → timing/conflict/comparison;
- objective change → comparison only.

The correction engine uses dependency information to invalidate and recompute only affected results.

## 11. Calculation reuse and cache contract

Calculation reuse is an architectural requirement, not merely a performance optimization.

A reusable result is valid when:
- its input snapshot is unchanged;
- its algorithm/calculation version is unchanged;
- its dependency set is unchanged;
- required source/evidence validity remains acceptable.

A result becomes stale when a relevant dependency changes.

The dependency graph should support at least:

```text
SPATIAL INPUTS
   ↓
ROUTE GEOMETRY / FEASIBILITY
   ↓
UAV ASSIGNMENT
   ↓
WIND + PERFORMANCE
   ↓
4D TRAJECTORY
   ↓
CONFLICT / SEPARATION
   ↓
CANDIDATE COMPARISON
   ↓
SELECTED SOLUTION
   ↓
FLIGHT PROFILE
```

No downstream module should recreate an upstream result solely because it needs the same value.

## 12. Final integrity validation

Final validation checks:
- object/version identity;
- dependency consistency;
- required source freshness;
- no material input changed without propagation;
- selected candidate remains feasible;
- mission/route/profile references are consistent.

Final validation is a contract/integrity check. It is not a second execution of spatial routing, wind modelling or conflict analysis.

## 13. Verification requirements

Reference scenarios shall include:
- obstacles and terrain constraints;
- restricted/prohibited areas;
- NOTAM validity windows and altitude bands;
- mandatory waypoints;
- Dijkstra reference paths;
- A* equivalence where used;
- wind from principal directions;
- variable wind by segment/altitude;
- wind-driven candidate infeasibility;
- energy reserve limits;
- payload/configuration-dependent performance;
- multi-UAV trajectory conflict;
- staggered-start resolution;
- dependency-driven partial recalculation;
- unchanged-input result reuse;
- deterministic replay/regression.

## 14. Decision record

**Current baseline:** constrained spatial candidate generation → UAV assignment → single wind/performance calculation → 4D trajectories → multi-UAV conflict/separation → feasible-candidate comparison → selected route set → flight profile → final integrity/change-impact validation.

**Architectural rule:** one calculation, one authoritative result, downstream reuse, dependency-driven invalidation.

**AI:** may later assist candidate generation, comparison or Corrections only through the established proposal/validation/safety/authorization boundaries. AI does not become the authoritative calculation or execution path.
