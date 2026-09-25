# Multi-UAV Conflict Resolution

**ID:** PLAN-MULTI-005  
**Status:** BASELINED

Deterministic pre-flight resolution of calculated multi-UAV conflicts.

## Contract

Conflict resolution occurs on the ground, before the affected UAVs start. The component consumes versioned 4D trajectories and an already calculated conflict result through the existing detector.

Resolution order:
1. retain a clear plan;
2. temporal conflicts may be resolved by the existing start-delay sequencer;
3. for a same-altitude crossing that remains conflicting, apply the vertical profile rule;
4. right-by-course UAV: +1 m;
5. left-by-course UAV: -1 m;
6. apply the offset only to the affected pre-planned conflict segment;
7. return to the original profile after the segment;
8. re-run continuous 4D conflict detection;
9. unresolved residual conflict remains a hard planning/readiness blocker.

The 1 m value is the vertical maneuver step. For equal initial altitudes it produces a nominal 2 m vertical difference. It is not a universal regulatory separation requirement.

The resolver does not issue in-flight commands and does not modify authorization, safety, readiness or execution state. It only produces versioned corrected trajectory candidates. A correction is accepted only if altitude limits are satisfied and the continuous conflict recheck is clear.

Ambiguous right/left course geometry is not guessed; it produces an unresolved result.

## Lineage

Each corrected trajectory retains its original dependency identity and appends a deterministic vertical-resolution dependency. Superseded trajectory variants remain historical; only the current consolidated result is an active planning input.

## Architecture

4D TRAJECTORIES → CONFLICT DETECTION → CONFLICT RESOLUTION → CONFLICT RECHECK → CANDIDATE COMPARISON → SELECTED ROUTE SET → FLIGHT PROFILE → FINAL INTEGRITY → READY
