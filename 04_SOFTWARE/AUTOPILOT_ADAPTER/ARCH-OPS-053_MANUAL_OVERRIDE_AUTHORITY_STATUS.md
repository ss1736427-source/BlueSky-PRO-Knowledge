# ARCH-OPS-053 — Manual / Override Authority Boundary

**Status:** CONTROLLED IMPLEMENTATION PREPARATION — AUTHORITY POLICY DECISION REQUIRED  
**Evidence boundary:** `SIL_BOUNDARY_ONLY`

## Purpose

Define the explicit authority gate between BlueSky supervisory actions, RC/manual control, and onboard autopilot failsafe/recovery behavior.

## Existing authority states

The Universal Autopilot API defines:

- `AUTONOMOUS_MISSION`
- `GUIDED_MANUAL_SUPERVISED`
- `FAILSAFE`
- `RETURN_RECOVERY`
- `EMERGENCY_ABORT`
- `COMMUNICATION_LOST`

The onboard flight controller retains real-time stabilization and onboard failsafe authority. Loss of BlueSky connectivity does not transfer flight-control authority to BlueSky or another ground component.

## Required policy decision

Before implementing command admission, the project must approve a deterministic matrix mapping each authority state to permitted command classes and rejection behavior.

The implementation must not infer:
- whether BlueSky supervisory commands remain admissible during guided/manual control;
- which commands, if any, are admissible during return/recovery;
- whether emergency-abort requests are accepted in each state and how they map to autopilot-native actions;
- precedence when RC/manual input, BlueSky supervision, and onboard failsafe indications conflict.

## Non-negotiable fail-safe boundaries

- `COMMUNICATION_LOST` never implies transfer of flight-control authority.
- BlueSky does not replace onboard stabilization or failsafe behavior.
- Unknown or contradictory authority state must not authorize a command.
- Every decision and rejection must be deterministic and auditable.
- No vendor-specific RC switch semantics or low-level actuator commands are introduced by this slice.

## Next step

Obtain approval for the authority-state × command-class matrix. Then implement the gate and SIL tests against that approved matrix. Until then, ARCH-OPS-053 remains specified but not implemented.
