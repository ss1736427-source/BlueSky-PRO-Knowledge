# IF-AUTOPILOT — Vehicle / Autopilot Interface

**Priority:** P0
**Status:** STRUCTURE — TO BE BASELINED

## Purpose

Provide a stable BlueSky interface to heterogeneous onboard flight-control systems without coupling the core mission model to one autopilot implementation.

## External endpoints

- ArduPilot
- PX4
- Future vendor-specific flight-control systems

## Flow

```text
BlueSky Mission / Command / Safety
            ↓
     Vehicle Adapter API
            ↓
   Autopilot Adapter
            ↓
 MAVLink / vendor protocol
            ↓
        Autopilot
            ↓
      Flight Controller
```

## Required capabilities

- vehicle discovery
- autopilot identification
- firmware/version identification
- capability discovery
- connection/session state
- command execution
- mission upload/download
- parameter read/write/synchronization
- normalized telemetry and health
- flight-mode/state mapping
- safety-state synchronization
- log acquisition
- time synchronization
- protocol/version compatibility

## Acceptance criterion

A representative supported aircraft can be connected, identified, synchronized, commanded, loaded with a mission, monitored during execution, and recovered/closed without BlueSky core depending on autopilot-specific data structures.
