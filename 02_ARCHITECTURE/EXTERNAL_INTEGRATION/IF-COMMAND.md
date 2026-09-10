# IF-COMMAND — Command Execution

**Priority:** P0
**Status:** STRUCTURE — TO BE BASELINED

## Flow

```text
Operator / Automation / Mission Engine
              ↓
        Command Request
              ↓
       Safety Validation
              ↓
       Vehicle Adapter
              ↓
         MAV_CMD / API
              ↓
          Autopilot
              ↓
        ACK / Progress
              ↓
       Command State
              ↓
            HUB
```

## Required behavior

- command identity
- target vehicle/component
- precondition validation
- authorization
- dispatch
- acknowledgement
- progress/result
- timeout
- retry policy
- duplicate protection
- rejection handling
- loss-of-link handling
- audit record

## Initial command classes

ARM, DISARM, TAKEOFF, LAND, RTL, HOLD, GUIDED/GOTO, mission start, pause, resume, abort and other vehicle-specific supported actions.

## Acceptance criterion

Every operational command has a defined lifecycle from request through validation, dispatch, acknowledgement/result and audit, including failure behavior.
