# BlueSky PRO — NOTAM Prohibited-Zone Validation

**ID:** PLAN-VAL-002  
**Status:** DRAFT  
**Scope:** Phase B — Flight Planning Core

## Purpose

Deterministically verify that route waypoints are outside active NOTAM-defined prohibited zones before a route can be accepted as a valid planning candidate.

## Boundary

NOTAM data is an external, versioned planning input. The validator does not fetch NOTAMs, interpret free-form NOTAM text, authorize flight, change readiness, bypass safety, or command an aircraft.

The upstream NOTAM adapter is responsible for converting an authoritative NOTAM source into a normalized snapshot containing geometry, validity interval, altitude limits, restriction type, source identity and snapshot version.

## Required checks

1. Route references a NOTAM snapshot when NOTAM avoidance is required.
2. The snapshot is valid for the route evaluation time.
3. Every route waypoint is tested against every active prohibited zone whose altitude band overlaps the waypoint altitude.
4. A waypoint inside an active prohibited zone produces a deterministic rejection finding containing the NOTAM identifier and waypoint identifier.
5. Missing, invalid or stale NOTAM input is never silently treated as an empty airspace.

## Geometry

The initial normalized geometry supports circles and polygons. Geodesic conversion/projection belongs to the adapter; the validator receives latitude/longitude in the canonical route model.

## Scope limitation

This block validates waypoint containment. Segment intersection with a prohibited zone is a separate deterministic check and must be implemented before route acceptance can claim full NOTAM corridor compliance.

## Authority

The result is observational/planning validation only. It does not mutate the Route, readiness, safety, authorization or execution state.
