# BlueSky PRO — Canonical Route Model

**ID:** PLAN-DATA-001
**Status:** BASELINED
**Scope:** Phase B — Flight Planning Core

## Purpose

Define the canonical route representation used between mission planning, constraint validation, optimization, flight-profile calculation and later vehicle-specific compilation.

## Authority

The Route model is a deterministic planning-domain object. It does not authorize flight, change readiness, bypass safety, or command an aircraft.

## Relationship

`MISSION VERSION → ROUTE CANDIDATE(S) → VALIDATED ROUTE → FLIGHT PROFILE → VEHICLE-SPECIFIC COMPILATION`

A route is always traceable to the Mission Version that produced it.

## Minimum model

- immutable route identity and version;
- Mission ID and Mission Version;
- ordered waypoints;
- explicit altitude per waypoint;
- mandatory waypoint flag;
- route segments with source/target identity and geometry summary;
- hard route constraints;
- terrain/airspace/weather/wind snapshot references;
- generator and generator-version lineage;
- calculation-input version.

## Design rules

1. A route candidate may be generated before it is validated.
2. Mandatory constraints are feasibility conditions, not optimization weights.
3. External data is referenced by versioned snapshots; stale or missing inputs are not silently substituted.
4. A route change that materially changes geometry, altitude, constraints or planning inputs creates a new route version.
5. Wind remains an explicit environmental reference and may trigger recalculation or re-optimization.
6. Vehicle-specific executable semantics are created only after route validation and later compilation.
7. AI may propose route variants later, but the canonical Route object is accepted only through deterministic validation and the existing proposal/safety/authorization boundaries.

## Interactive profile synchronization

The flight profile, waypoint table and map are synchronized editing surfaces over the canonical mission/route data. Profile edits must update the canonical route candidate, trigger validation and the required recalculation, then publish a consistent result to all dependent views. UI-local state and display preferences are not authoritative storage for route constraints.

See the approved [Interactive Flight Profile — Data Synchronization and Recalculation](../../02_SYSTEM/Design/Interface/Interactive%20Flight%20Profile%20%E2%80%94%20Data%20Synchronization%20and%20Recalculation.md) requirement.

## Next block

Implement deterministic **Route Constraint Validation** against the canonical Route model, followed by terrain/obstacle and airspace adapters.
