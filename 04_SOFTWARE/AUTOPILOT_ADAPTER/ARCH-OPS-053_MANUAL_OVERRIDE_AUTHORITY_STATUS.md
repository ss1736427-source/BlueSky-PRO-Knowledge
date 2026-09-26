# ARCH-OPS-053 — Manual / Override Authority Boundary

**Status:** CONTROLLED IMPLEMENTATION PREPARATION  
**Evidence boundary:** `SIL_BOUNDARY_ONLY`

## Purpose

Prepare the next unresolved P0 integration boundary after G0-08 without changing the existing safety-reconciliation semantics.

## Existing authority contract

The Universal Autopilot API already defines the normalized authority states:

- `AUTONOMOUS_MISSION`
- `GUIDED_MANUAL_SUPERVISED`
- `FAILSAFE`
- `RETURN_RECOVERY`
- `EMERGENCY_ABORT`
- `COMMUNICATION_LOST`

The autopilot integration baseline states that the onboard flight controller remains authoritative for real-time stabilization and onboard failsafe execution. BlueSky is the mission-planning and supervisory layer.

## Controlled boundary

The implementation shall:

1. represent the current normalized authority state explicitly;
2. accept only commands permitted by the current authority state and applicable capabilities;
3. distinguish BlueSky supervisory commands from RC/manual control and onboard failsafe behavior;
4. produce deterministic rejection when authority is unavailable or conflicting;
5. preserve an auditable authority transition/result record;
6. never infer that loss of BlueSky connectivity transfers flight-control authority to the ground system.

## Non-goals

This slice shall not:

- reimplement autopilot stabilization or flight-control logic;
- define vendor-specific RC switch semantics;
- invent regulatory authority precedence;
- issue direct low-level actuator commands;
- replace onboard failsafe behavior;
- claim HIL, real-UAV, or certification evidence.

## Verification preparation

The controlled SIL fixture shall cover, at minimum:

1. autonomous mission authority permits applicable mission execution;
2. manual-supervised authority is represented explicitly;
3. failsafe authority blocks conflicting supervisory execution;
4. emergency-abort authority blocks non-abort operational commands;
5. communication-lost state does not imply transfer of flight-control authority;
6. unsupported authority state is handled deterministically.

## Dependency

G0-08 / ARCH-OPS-052 remains an earlier verification gate. This document does not close or bypass that gate; it only freezes the next implementation boundary already defined by the existing architecture.

## Evidence boundary

No SIL, SITL, HIL, physical-UAV, operational, or certification evidence is claimed by this record.
