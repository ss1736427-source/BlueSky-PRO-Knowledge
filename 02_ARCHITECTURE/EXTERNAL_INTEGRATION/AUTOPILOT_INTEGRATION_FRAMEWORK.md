# BlueSky PRO — Autopilot Integration Framework

**Status:** WORKING BASELINE — UNIVERSAL AUTOPILOT INTEROPERABILITY

## 1. Objective

BlueSky PRO shall be delivered as a ready-to-operate product for a customer's existing UAV fleet. The customer shall not be required to develop an integration for each aircraft.

The architecture therefore separates the BlueSky operational model from any specific Flight Control System (FCS), autopilot, manufacturer or transport protocol.

## 2. Supported integration classes

The framework shall support, subject to technical and legal interface availability:

- standardized autopilots/protocols (e.g. ArduPilot and PX4 through MAVLink);
- proprietary OEM autopilots through documented SDK/API/protocol;
- vehicle-specific integrations where a manufacturer provides an accessible interface;
- future protocols without changes to the BlueSky operational domain model.

## 3. Layered architecture

```text
                         BLUE SKY PRO
                              │
                   Operational Domain Model
                              │
                 Universal Vehicle Interface
                              │
                ┌─────────────┴─────────────┐
                │     Integration Layer     │
                ├────────────┬──────────────┤
                │            │              │
         Autopilot Adapter  C2 Adapter  Payload Adapter
                │            │              │
          Protocol Adapter  Transport    Device/API
                │
       ┌────────┼────────┬─────────┐
       ▼        ▼        ▼         ▼
   ArduPilot    PX4     OEM-FCS   Future-FCS
       │        │        │         │
     MAVLink  MAVLink  Native/API  ...
```

## 4. BlueSky Universal Vehicle Interface

The internal contract shall expose normalized objects and operations independent of the external implementation:

### State

- position and navigation state;
- attitude and motion state;
- altitude and speed;
- battery/energy state;
- GNSS/navigation quality;
- health and readiness;
- flight mode;
- failsafe state;
- mission state;
- communication state;
- payload state.

### Operations

- connect/disconnect;
- discover/identify;
- synchronize configuration;
- arm/disarm;
- takeoff/land;
- hold/pause/resume;
- RTL/return;
- guided/goto where supported;
- mission upload/download;
- mission start/stop/modify where supported;
- parameter read/write;
- geofence/rally/safety configuration;
- log acquisition;
- time synchronization.

Every operation has a capability requirement. Unsupported operations shall be explicitly reported rather than silently emulated.

## 5. Adapter responsibilities

Each adapter shall implement:

1. protocol/session establishment;
2. vehicle/system/component discovery;
3. capability discovery;
4. message and command translation;
5. acknowledgement and result mapping;
6. timeout/retry semantics;
7. state normalization;
8. configuration synchronization;
9. mission translation;
10. safety/failsafe mapping;
11. log acquisition;
12. protocol-specific diagnostics;
13. version/compatibility handling;
14. security requirements;
15. automated verification tests.

## 6. Capability-driven operation

BlueSky shall never assume that all aircraft implement the same functions.

```text
Connect
  ↓
Identify FCS / firmware / vehicle
  ↓
Discover capabilities
  ↓
Load verified vehicle profile
  ↓
Check mission + payload + safety requirements
  ↓
READY / NOT READY with explicit reasons
```

## 7. ArduPilot/PX4 reference implementation

MAVLink shall be the first common reference integration because it is used by both ArduPilot and PX4 ecosystems. The implementation shall use the relevant MAVLink microservices rather than treating MAVLink as a single undifferentiated interface.

Minimum services for the reference adapter:

- Heartbeat / system identification;
- Command Protocol;
- Mission Protocol;
- Parameter Protocol;
- telemetry/state messages;
- timesync where required;
- log transfer where supported;
- component/capability discovery.

MAVLink Command Protocol uses acknowledgements (`COMMAND_ACK`) and retransmission when an acknowledgement is not received; the Parameter Protocol provides key/value configuration exchange and allows GCS software to work with previously unknown parameters. citeturn0search12turn0search13

## 8. Mission translation

The BlueSky Mission Model shall remain richer and independent of MAVLink mission items.

```text
BlueSky Mission
      ↓
Capability check
      ↓
Vehicle-specific mission compiler/translator
      ↓
External mission representation
      ↓
Upload
      ↓
Read-back
      ↓
Canonical comparison
      ↓
MISSION VERIFIED
```

A mission shall not be considered uploaded merely because a transport operation completed. The vehicle-side mission shall be read back and verified against the approved mission identity/version and supported semantics.

## 9. Parameter management

Parameters shall be handled through a controlled configuration service:

- discover;
- snapshot;
- compare;
- validate;
- write;
- confirm/read-back;
- baseline;
- rollback where technically supported;
- associate the configuration with aircraft, firmware and Flight Record.

Mission Planner provides full parameter read/write, save, restore and compare functionality; BlueSky shall cover the operationally required subset through its normalized configuration service. citeturn0search9

## 10. Configuration baseline

A verified aircraft profile shall bind:

```text
Aircraft identity
+ FCS type
+ FCS version
+ vehicle type
+ parameter baseline
+ sensors
+ payload
+ C2 configuration
+ safety configuration
+ approved capabilities
+ verification status
```

Changing a safety-critical configuration shall invalidate the affected readiness/verification status until the applicable checks are repeated.

## 11. Universal compatibility rule

Compatibility shall be represented explicitly:

`SUPPORTED → VERIFIED → OPERATIONAL`

and separately:

`UNSUPPORTED → INCOMPATIBLE → NOT VERIFIED → DEGRADED`

BlueSky shall never advertise generic compatibility solely because a protocol connection can be established.

## 12. Exit criterion

An adapter is product-ready only when a representative aircraft can complete the defined connect → identify → configure → health/pre-arm → mission upload/read-back/verify → command/control → telemetry → contingency → landing/RTL → log acquisition lifecycle in its supported operational configuration, with automated regression coverage and documented limitations.
