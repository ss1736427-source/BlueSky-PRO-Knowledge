# ARCH-OPS-018 — P0 MAVLink Session Boundary

## Decision
G0-01 audit is complete at the current controlled implementation level. The repository contains executable ArduPilot/PX4 reference adapter boundaries and an end-to-end SIL adapter lifecycle, but the MAVLink implementation remains a deterministic fixture/boundary rather than physical transport.

Therefore the next executable P0 slice is G0-02: MAVLink session boundary.

## Rules
- MAVLink2 is the initial protocol baseline.
- Dialect/version policy is explicit and capability/version based.
- Session identity is distinct from vehicle identity.
- System/component identity must be preserved.
- HEARTBEAT is the liveness primitive at the session boundary.
- Malformed and unsupported messages are rejected, never normalized as valid.
- Loss/recovery changes the transport session identity while preserving operational correlation.
- Physical serial/UDP/TCP/radio transport is outside this slice.
- ArduPilot/PX4 mission semantics remain inside their adapters.

## Result
ARCH-OPS-018 establishes the minimum deterministic session boundary required before physical transport implementation and before G0-03 command-runtime integration.
