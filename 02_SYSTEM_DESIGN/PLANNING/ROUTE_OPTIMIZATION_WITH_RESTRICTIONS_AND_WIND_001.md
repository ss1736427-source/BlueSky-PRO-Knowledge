# BlueSky PRO — Deterministic Route Optimization with Restrictions and Wind

**ID:** PLAN-OPT-001  
**Status:** BASELINED  
**Scope:** Phase B — Flight Planning Core

## Objective

Generate a feasible route that bypasses active restricted/prohibited zones and minimizes route distance, while using the wind field as a deterministic secondary operational cost.

## Optimization order

1. Hard constraints first: restricted/prohibited areas, terrain/clearance, altitude limits, mandatory waypoints and other route constraints make a candidate infeasible; they are never converted into a soft penalty.
2. Primary objective: minimum geometric route distance among feasible candidates.
3. Wind-aware tie-break/secondary objective: minimize wind-adjusted travel cost/time for candidates with materially comparable distance.
4. Deterministic tie-break: stable route/node identifiers.

This preserves the user's minimum-distance requirement while ensuring wind is not ignored. A future mission objective profile may explicitly change the objective order for energy/time missions; that must be versioned and traceable.

## NOTAM / restriction behavior

The optimizer must not route through a restricted zone merely because doing so is shorter. Restricted geometry is removed from the feasible search space before optimization. If the direct path intersects a prohibited zone, the graph/search layer must generate a detour around the zone and compare feasible alternatives by the objective order above.

## Wind behavior

Wind is an environmental snapshot, never an authorization source. For each candidate segment the optimizer derives a deterministic wind-adjusted traversal metric from segment geometry, altitude, estimated traversal time and the referenced wind snapshot.

The default planning objective is lexicographic: hard feasibility first, then minimum geometric distance, then wind-adjusted time/energy among materially comparable routes. An explicitly configured efficiency objective may permit a longer legal route when its wind-adjusted operational cost is lower. The active objective profile, weights and tolerances are versioned inputs.

Wind can also make a candidate infeasible through vehicle-specific limits such as maximum wind, crosswind, minimum ground speed or energy reserve. Such candidates are rejected, not penalized.

Missing or stale wind input cannot silently become a zero-wind assumption when the selected planning profile requires wind.

## Output

The optimizer returns the selected route plus objective metrics, input snapshot/version references, optimizer ID/version, objective-profile version and candidate-selection rationale. The result remains a planning artifact and does not mutate readiness, safety, authorization or execution state. It does not mutate readiness, safety, authorization or execution state.

## Required next implementation blocks

- segment-level restricted-zone intersection;
- restriction-aware graph/search;
- wind field adapter and deterministic edge cost;
- optimizer contract test proving a direct prohibited crossing is rejected and a legal detour is selected;
- wind test proving the selected route changes when wind changes the relative traversal cost.
