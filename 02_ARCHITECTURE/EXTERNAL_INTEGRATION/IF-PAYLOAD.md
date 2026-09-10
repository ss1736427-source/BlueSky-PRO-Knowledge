# IF-PAYLOAD — Payload Interface

## Purpose
Define the integration boundary between BlueSky/HUB and mission payload systems.

## Payload classes
Camera, EO/IR, thermal, LiDAR, gimbal, other mission equipment.

## Command path
BlueSky → Payload Adapter → Payload Controller → Payload.

## Data path
Payload → Payload Adapter/HUB → Mission Data Store → Flight Record / processing.

## Required capabilities
- device discovery
- capability identification
- status/health
- command execution and acknowledgement
- trigger/scheduling
- recording state
- timestamp and mission correlation
- metadata association
- failure/degraded-state reporting

## Key requirement
Payload integration must be adapter-based so UAV/autopilot integration is independent of a particular payload manufacturer.
