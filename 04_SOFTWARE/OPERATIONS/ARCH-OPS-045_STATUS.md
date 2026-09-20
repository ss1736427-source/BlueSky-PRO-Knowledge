# ARCH-OPS-045 — Capability Discovery Boundary

**Status:** IMPLEMENTATION_BASELINE

## Evidence

- `SIL_CAPABILITY_DISCOVERY_BOUNDARY`
- identity admission;
- revoked-device rejection;
- normalized capability registration;
- explicit capability update;
- CTest coverage.

## Boundary

No live MAVLink parsing, authentication, certificate validation, transport management, or mission execution is claimed.

## Next gap

Make capability state an explicit prerequisite for mission and command compatibility resolution.
