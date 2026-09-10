# IF-C2 — Command & Control Interface

## Purpose
Define the boundary between BlueSky and the communications/C2 layer used to exchange commands, acknowledgements, telemetry and link state with UAVs.

## Scope
- command transport
- link establishment and loss detection
- addressing of multiple UAVs
- command priority and sequencing
- acknowledgement and timeout handling
- link quality/state
- degraded/offline operation
- security hooks

## Required flow
BlueSky → C2 Adapter → Transport/Radio/IP → Vehicle Adapter → Autopilot
Autopilot → Vehicle Adapter → Transport → C2 Adapter → BlueSky

## Mandatory states
CONNECTED, DEGRADED, LOST, RECOVERING, AUTHENTICATION_FAILED.

## Key requirement
C2 transport must remain replaceable; BlueSky operational logic must not depend directly on a particular radio, modem or network technology.
