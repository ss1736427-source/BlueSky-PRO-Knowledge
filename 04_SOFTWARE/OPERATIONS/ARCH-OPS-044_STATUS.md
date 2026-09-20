# ARCH-OPS-044 — Device Capability Runtime

**Status:** IMPLEMENTATION_BASELINE

## Evidence

- `SIL_DEVICE_CAPABILITY_RUNTIME`
- deterministic registration and update semantics;
- duplicate capability normalization;
- lifecycle transition;
- immutable resolve-by-device copy;
- missing-device handling;
- CMake/CTest registration.

## Boundary

No live transport, authentication, vendor discovery, certificate handling, or mission execution is claimed.

## Next gap

Bind capability discovery to device identity/session admission and use the resulting capability set as a prerequisite for mission and command compatibility checks.
