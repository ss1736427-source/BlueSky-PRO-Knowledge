# IF-COMMAND — Command Execution

**Priority:** P0  
**Status:** BASELINED — implementation contract

## Purpose

Define the complete lifecycle of an operational command between BlueSky and the selected vehicle/autopilot while preserving safety, authorization, idempotency and auditability.

## Flow

```text
Operator / Mission Engine / Automation
                 ↓
          COMMAND REQUEST
                 ↓
       AUTHORITY + SAFETY GATE
                 ↓
          C2 / Vehicle API
                 ↓
        Autopilot Adapter
                 ↓
       MAV_CMD / OEM API
                 ↓
             AUTOPILOT
                 ↓
       ACK / PROGRESS / RESULT
                 ↓
       Normalized Command State
                 ↓
             BLUE SKY
                 ↓
              AUDIT
```

## Required command identity

Every command shall have:

- unique command ID;
- mission/flight correlation ID where applicable;
- target vehicle/component;
- command class;
- parameters;
- requested authority/source;
- timestamp;
- sequence/correlation information.

## Command state machine

```text
REQUESTED
   ↓
VALIDATING
   ├── REJECTED
   ↓
DISPATCHED
   ↓
ACKNOWLEDGED
   ↓
EXECUTING
   ├── COMPLETED
   ├── FAILED
   ├── CANCELLED
   └── TIMEOUT / UNKNOWN
```

The exact states exposed to the pilot may be simplified, but the internal lifecycle must remain traceable.

## Required behavior

- precondition validation;
- authority validation;
- dispatch;
- acknowledgement;
- progress/result handling;
- timeout;
- retry policy;
- duplicate protection/idempotency;
- rejection handling;
- loss-of-link handling;
- stale-command prevention;
- audit record.

## Safety

No command may bypass mandatory safety or regulatory gates. BlueSky shall distinguish between:

- command accepted by BlueSky;
- command transmitted;
- command acknowledged by the vehicle;
- command actually executed.

These are separate states.

## Initial command classes

ARM, DISARM, TAKEOFF, LAND, RTL, HOLD, GUIDED/GOTO, mission start, pause, resume, abort and other vehicle-specific supported actions.

Vehicle-specific actions must be capability-gated.

## Link loss

If communication is lost:

- the command state becomes `UNKNOWN` where execution cannot be established;
- BlueSky shall not blindly repeat a non-idempotent command;
- onboard autopilot contingency behavior remains authoritative;
- after recovery, state reconciliation/read-back determines the actual vehicle state.

## Acceptance criterion

Every operational command has a defined lifecycle from request through validation, dispatch, acknowledgement/result and audit, including deterministic failure and communication-loss behavior.
