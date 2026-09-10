# BlueSky PRO — Vehicle / Payload Integration Framework

**Status:** WORKING BASELINE

## Objective

BlueSky shall present heterogeneous aircraft and mission equipment through normalized profiles so the user can operate a supported fleet without building integrations manually.

## Vehicle profile

Each aircraft profile shall contain:

- manufacturer/model;
- aircraft type and configuration;
- FCS/autopilot and firmware compatibility;
- navigation sensors;
- propulsion/energy characteristics relevant to planning;
- C2 interfaces;
- payload interfaces;
- supported commands;
- supported mission primitives;
- geofence/failsafe capabilities;
- performance limits;
- environmental limits;
- configuration baseline;
- verification status and version.

## Payload profile

Payload profiles shall describe:

- device identity/model;
- interface/protocol;
- power/state;
- capabilities;
- command set;
- telemetry/status;
- calibration/configuration requirements;
- recording/metadata behavior;
- mission actions;
- compatibility with aircraft/FCS;
- verification status.

Supported classes shall include, as applicable:

`EO camera | IR/thermal | LiDAR | gimbal | multisensor | mapping camera | other mission equipment`

## Equipment integration model

```text
Aircraft Profile
      │
      ├── FCS Profile
      ├── C2 Profile
      ├── Navigation/Sensor Profile
      ├── Energy/Propulsion Profile
      └── Payload Profile(s)
                 │
                 ▼
          BlueSky Capability Model
                 │
          Mission compatibility
                 │
                 ▼
              READY
```

## Capability-driven planning

Mission planning shall evaluate whether the selected aircraft/payload combination can perform the requested mission before authorization and flight.

Examples:

- required sensor absent → NOT CAPABLE;
- required camera action unsupported → mission correction required;
- required altitude/speed outside aircraft limits → mission correction required;
- payload weight incompatible → NOT READY;
- required navigation performance unavailable → degraded/blocked according to safety policy.

## Payload abstraction

BlueSky mission actions shall use semantic operations such as:

`START_RECORDING`, `STOP_RECORDING`, `CAPTURE`, `SET_GIMBAL`, `SET_CAMERA_MODE`, `SET_SENSOR_MODE`.

The payload adapter translates them into the device-specific protocol/API.

## Data association

Payload data shall retain association with:

- mission;
- vehicle;
- payload;
- timestamp;
- position/attitude where available;
- mission action/event;
- Flight Record.

## OEM principle

A vendor-specific payload or aircraft shall not require changes to the BlueSky mission domain model. Integration-specific behavior belongs in adapters, profiles and compatibility metadata.
