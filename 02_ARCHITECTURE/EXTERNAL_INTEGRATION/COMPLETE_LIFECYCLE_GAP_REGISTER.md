# BlueSky PRO — Complete Operational Lifecycle Gap Register

**Status:** WORKING BASELINE — COMPLETENESS REVIEW

## Purpose

This register closes the practical lifecycle gap between the existing BlueSky PRO architecture and a complete operational Ground Control / UAS mission system. Mission Planner and QGroundControl are used as capability references, not as UI or architecture templates.

## Full lifecycle

```text
ORGANIZATION / AIRCRAFT CONFIGURATION
        ↓
AIRCRAFT / PAYLOAD REGISTRATION
        ↓
TECHNICAL READINESS
        ↓
TASK
        ↓
MISSION DESIGN
        ↓
AIRSPACE + WEATHER + TERRAIN + TRAFFIC
        ↓
OPTIMIZATION
        ↓
VALIDATION
        ↓
SIMULATION / REPLAY
        ↓
AUTHORIZATION / FPL / OPERATIONAL APPROVAL
        ↓
PRE-FLIGHT READINESS GATE
        ↓
VEHICLE CONNECTION
        ↓
DISCOVERY / IDENTITY / CAPABILITIES
        ↓
CONFIGURATION SYNCHRONIZATION
        ↓
MISSION TRANSLATION
        ↓
MISSION UPLOAD + READ-BACK
        ↓
C2 LINK ESTABLISHMENT
        ↓
ARM / TAKEOFF
        ↓
FLIGHT EXECUTION
        ↓
TELEMETRY + C2 + PAYLOAD + VIDEO + TRAFFIC
        ↓
EXCEPTION / CONTINGENCY / REPLANNING
        ↓
LAND / RTL / MISSION COMPLETE
        ↓
LOG + DATA ACQUISITION
        ↓
POST-FLIGHT ANALYSIS
        ↓
FLIGHT RECORD / EVIDENCE
        ↓
MAINTENANCE / RESOURCE UPDATE
        ↓
LESSONS / CORRECTIONS / CONTROLLED UPDATE
        ↓
NEXT MISSION
```

## Gap classification

### G0 — critical operational integration

| ID | Contour | Current BlueSky position | Gap to close | Priority |
|---|---|---|---|---|
| G0-01 | Autopilot adapter | Adapter principle exists | Concrete vehicle adapter boundary and lifecycle | P0 |
| G0-02 | MAVLink session | MAVLink identified | Version/dialect/message policy, connection, heartbeat, routing | P0 |
| G0-03 | Command protocol | C2 conceptual | Command state machine, ACK, retry, timeout, rejection, execution result | P0 |
| G0-04 | Mission protocol | Mission Graph exists | Translator to vehicle mission representation + upload/read-back verification | P0 |
| G0-05 | Parameter protocol | Configuration model exists | Read/write/sync/compare/backup/restore and baseline | P0 |
| G0-06 | Vehicle state | State model exists | Normalized telemetry/health/quality contract and source mapping | P0 |
| G0-07 | C2 transport | C2 conceptual | Link/session abstraction, primary/backup links, loss/recovery state | P0 |
| G0-08 | Safety reconciliation | Safety architecture exists | BlueSky limits ↔ autopilot failsafe/geofence/rally/flight-mode consistency | P0 |
| G0-09 | Manual/override control | Not yet explicit as integration contract | RC/joystick/manual override and authority arbitration | P0 |
| G0-10 | Pre-arm/health | Readiness concept exists | Mapping of autopilot pre-arm/health failures into BlueSky gate | P0 |

### G1 — required operational subsystems

| ID | Contour | Current BlueSky position | Gap to close | Priority |
|---|---|---|---|---|
| G1-01 | Payload | Payload State exists | Command/state/data adapter | P1 |
| G1-02 | Video | Video identified | Stream transport, recording, loss/recovery, mission association | P1 |
| G1-03 | Companion computer | Identified conceptually | Onboard data/command interface | P1 |
| G1-04 | GNSS/RTK | Navigation concepts exist | RTCM/NTRIP/correction source and quality lifecycle | P1 |
| G1-05 | Traffic/ADS-B | Traffic exists in world model | Concrete source adapter and freshness/quality handling | P1 |
| G1-06 | GIS/Terrain/Obstacles | External data model exists | Provider adapter, cache, coordinate reference and freshness | P1 |
| G1-07 | Weather | Weather model exists | Provider adapters + forecast/actual provenance and validity | P1 |
| G1-08 | Airspace/NOTAM | Airspace model exists | Provider ingestion, normalization, freshness and conflict handling | P1 |
| G1-09 | ATM/FPL/authorization | FPL/ATM identified | Submission/status/rejection/correction/approval state machine | P1 |
| G1-10 | Logs | Flight Record exists | TLOG/DataFlash/ULog acquisition and source mapping | P1 |
| G1-11 | Peripheral bus | Vehicle peripherals conceptually present | DroneCAN/UAVCAN and other vehicle bus adapter strategy | P1 |
| G1-12 | Firmware/bootloader | Admin/configuration exists | Firmware compatibility, update, verification and rollback strategy | P1 |
| G1-13 | Calibration | Engineering setup exists conceptually | Sensor/RC/actuator calibration interface or defined external-tool boundary | P1 |

### G2 — completeness / maintainability

| ID | Contour | Required capability |
|---|---|---|
| G2-01 | Time synchronization | Common UTC/timebase, timestamp quality and synchronization status |
| G2-02 | Device identity | UAV/autopilot/component identity, certificates/keys and lifecycle |
| G2-03 | Configuration versioning | Immutable baseline, diff, approval and rollback |
| G2-04 | Link management | Link quality, latency, loss, bandwidth and source selection |
| G2-05 | Data provenance | Source, timestamp, quality, version and validity for external data |
| G2-06 | Diagnostics | Engineering diagnostics without exposing complexity to normal pilot UI |
| G2-07 | Offline operation | Cached mission/environment data and deterministic degraded-mode behavior |
| G2-08 | Replay | Reproduce vehicle telemetry, commands, mission state and external data state |
| G2-09 | Geotag/data association | Associate payload files with UAV position/time/mission/waypoint |
| G2-10 | Fleet addressing | Multi-UAV system/component addressing, routing and collision prevention |
| G2-11 | Data export/API | Controlled exchange with processing, GIS and enterprise systems |
| G2-12 | Maintenance feedback | Flight/resource data updates aircraft, battery, engine and component records |

## Competitor-derived practical baseline

Mission Planner explicitly separates CONNECT, DATA, PLAN, SETUP, CONFIG and SIMULATION and provides firmware loading, configuration, mission upload, telemetry, logs, simulation and live video. citeturn1search0turn1search6

Mission Planner's practical setup includes mandatory accelerometer/radio/servo configuration, DroneCAN/UAVCAN access, MAVLink inspection, signing and MAVLink forwarding. citeturn1search8

Mission Planner handles both onboard DataFlash logs and ground-station telemetry logs, including download, analysis and replay. citeturn1search1turn1search2

Mission Planner SITL can use the same operational controls, mission setup and parameter changes against a simulated vehicle. citeturn1search3

## Architectural rule

BlueSky must not become a copy of Mission Planner. The missing capability should be implemented as adapters and controlled interfaces beneath the BlueSky operational layer:

```text
                BLUE SKY OPERATIONAL CORE
                         │
        ┌────────────────┴────────────────┐
        │         INTEGRATION LAYER       │
        │                                 │
        │ Autopilot  C2  Payload  Video   │
        │ Mission    Params  RTK  Traffic │
        │ Airspace   Weather GIS  Logs    │
        └────────────────┬────────────────┘
                         │
              EXTERNAL SYSTEMS / UAV
```

## Completion criterion

BlueSky is operationally complete only when one real supported UAV can be:

1. identified and connected;
2. checked for compatibility and health;
3. synchronized with its approved configuration;
4. supplied with a validated mission;
5. commanded and monitored through the complete flight;
6. safely handled through link loss, contingency and termination states;
7. operated with required payload/video/data interfaces;
8. reconciled with airspace, weather and authorization data;
9. recorded with synchronized ground and onboard evidence;
10. closed into a Flight Record and maintenance state;
11. replayed in simulation/analysis using the same interface contracts.

Only after this P0/P1 closure should additional UI refinement be treated as product-completion work.
