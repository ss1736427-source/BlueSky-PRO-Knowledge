# IF-EQUIPMENT — Equipment Interface

## Purpose
Define the integration boundary between BlueSky/HUB and mission equipment systems.

## Equipment classes
Camera, EO/IR, thermal, LiDAR, gimbal, other mission equipment.

## Command path
BlueSky → Equipment Adapter → Equipment Controller → Equipment.

## Data path
Equipment → Equipment Adapter/HUB → Mission Data Store → Flight Record / processing.

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
Equipment integration must be adapter-based so UAV/autopilot integration is independent of a particular equipment manufacturer.
