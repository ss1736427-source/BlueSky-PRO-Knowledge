# BlueSky PRO — P0 External Integration Gap Matrix

**Status:** WORKING BASELINE — GAP CLOSURE

## Purpose

This matrix compares the current BlueSky PRO architecture baseline with practical ground-control capabilities represented by Mission Planner and QGroundControl, and identifies the interfaces that must exist for a real operational BlueSky deployment.

## Baseline rule

BlueSky is not required to reproduce Mission Planner feature-for-feature. The comparison is used to identify operational interfaces and lifecycle functions that a complete system cannot omit.

## P0 matrix

| Domain | Practical competitor capability | BlueSky current architectural position | Gap | Required action |
|---|---|---|---|---|
| Vehicle connection | Connect via USB/serial/telemetry/network | C2 and vehicle state are defined conceptually | OPEN | Define IF-AUTOPILOT connection/session contract |
| Vehicle discovery | Heartbeat, vehicle/firmware identification, capabilities | Vehicle state/capability concepts exist | OPEN | Define discovery, identity and capability handshake |
| Autopilot integration | Direct ArduPilot/PX4 communication | Adapter principle is now defined | OPEN | Define adapter boundary and first MAVLink adapter |
| MAVLink session | Telemetry, commands, mission and parameters | MAVLink named as required interface | OPEN | Define supported MAVLink dialect/messages/version policy |
| Command control | Arm, disarm, takeoff, land, RTL, mode changes, mission control | Supervisory C2 exists conceptually | OPEN | Define command lifecycle, ACK, retry, timeout and safe failure |
| Mission upload/download | Upload mission to vehicle and read back | Mission Graph exists; translation is defined conceptually | OPEN | Define BlueSky mission → vehicle mission translator and verification |
| Parameter management | Read/write/save/restore/compare parameters | Configuration model exists | OPEN | Define parameter synchronization and configuration baseline |
| Vehicle configuration | Firmware, frame, sensors, radio, safety, modes, power, tuning | ADMIN/configuration exists | PARTIAL | Define which engineering functions BlueSky owns vs external tools |
| Safety configuration | Failsafe, geofence, rally, operational limits | Safety architecture exists | PARTIAL | Define reconciliation between BlueSky safety policy and autopilot parameters |
| Telemetry | Live position, attitude, speed, battery, GPS, mode, health | Telemetry/UAV state concepts exist | PARTIAL | Define normalized telemetry schema and update/quality semantics |
| C2 | Link monitoring and loss behavior | C2 is defined conceptually | OPEN | Define primary/backup links, heartbeat, link quality and loss/recovery state machine |
| Log acquisition | TLOG and onboard DataFlash/ULog download and analysis | Flight Record exists conceptually | PARTIAL | Define IF-LOG and source-specific acquisition adapters |
| Simulation | SITL/HITL integration and mission testing | Digital Twin/simulation architecture exists | PARTIAL | Make the same external interface executable against simulator/autopilot SITL |
| Payload | Camera/gimbal/payload actions and state | Payload State is defined | OPEN | Define payload command/data adapter contract |
| Video | Live video during flight | Video is identified as a P1 interface | OPEN | Define stream transport, state, recording and mission association |
| Companion computer | MAVLink/data exchange with onboard companion | Companion is identified as P1 | OPEN | Define onboard data/command interface |
| Airspace/ATM | External airspace data and operational submission | Airspace/ATM/FPL identified | OPEN | Define source/API, submission, response, rejection and correction lifecycle |

## Minimum P0 operational path

```text
Aircraft registered
    ↓
Connection established
    ↓
Vehicle discovery / heartbeat
    ↓
Autopilot + firmware + capabilities identified
    ↓
Configuration synchronized
    ↓
Vehicle health / readiness verified
    ↓
BlueSky mission validated
    ↓
Mission translated for vehicle
    ↓
Mission uploaded
    ↓
Mission read-back / integrity verified
    ↓
ARM / START command
    ↓
Flight execution
    ↓
Telemetry + C2 + command ACK + health
    ↓
Contingency / RTL / LAND as required
    ↓
Mission complete
    ↓
Onboard logs acquired
    ↓
Flight Record closed
```

## Mandatory interface contracts to create next

1. `IF-AUTOPILOT` — vehicle connection, identification and adapter boundary.
2. `IF-MAVLINK` — MAVLink session, message set, dialect/version policy.
3. `IF-COMMAND` — command lifecycle and acknowledgement semantics.
4. `IF-MISSION` — mission translation, upload/download and verification.
5. `IF-PARAMETER` — parameter synchronization and configuration baseline.
6. `IF-C2` — command/control transport and loss/recovery behavior.
7. `IF-VEHICLE-STATE` — normalized state/health model.
8. `IF-SAFETY-CONFIG` — reconciliation with autopilot failsafe/geofence/rally/limits.
9. `IF-AIRSPACE-ATM` — operational airspace/FPL/authorization exchange.

## Non-goal

Do not clone Mission Planner's UI or expose raw autopilot complexity to the normal pilot workflow. BlueSky should absorb complexity through adapters, configuration baselines, validation and automation while retaining an engineering/maintenance path for deep diagnostics.

## External evidence

Mission Planner documentation identifies CONNECT, DATA, PLAN, SETUP, CONFIG, SIMULATION, logs and live video as major operational areas. It also supports firmware loading, vehicle configuration, autonomous mission planning, log download/analysis and simulator integration.

QGroundControl documents full vehicle setup for PX4/ArduPilot, autonomous mission planning and upload, Fly monitoring, video, multiple vehicles, vehicle configuration and post-flight analysis/log download.

MAVLink defines separate command, mission and parameter protocols; these protocols require explicit handling of acknowledgements, retries, synchronization and message semantics rather than treating MAVLink as a generic transport.
