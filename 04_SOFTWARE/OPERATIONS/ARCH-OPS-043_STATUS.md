# ARCH-OPS-043 — Device identity runtime

**Status:** IMPLEMENTED — awaiting exact-HEAD CI verification

## Scope

Provides a deterministic identity registry for UAV, autopilot and component identity with credential fingerprint uniqueness and explicit lifecycle state.

## Evidence target

SIL_DEVICE_IDENTITY_RUNTIME

## Authority boundaries

- DeviceIdentityRuntime owns device identity registration, credential fingerprint uniqueness and identity lifecycle state.
- MavlinkSessionRuntime remains authoritative for live MAVLink session identity.
- FleetAddressingRuntime remains authoritative for system/component address ownership.
- AutopilotAdapter identity remains the vehicle/autopilot capability identity source.
- This slice does not generate, store, rotate or expose private keys.
- It does not authenticate a live link or establish certificate trust.

## Verification target

Deterministic contract tests cover registration, idempotency, identity collision, credential collision, resolution, lifecycle transitions and removal.
