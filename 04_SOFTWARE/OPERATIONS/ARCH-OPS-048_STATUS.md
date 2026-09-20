# ARCH-OPS-048 — Capability Execution Integration

Status: IMPLEMENTATION_BASELINE

Implemented:
- capability admission integrated with mission transfer;
- capability admission integrated with command dispatch;
- explicit device_id preserved separately from vehicle_id;
- rejected actions stop before execution entry points;
- admitted actions delegate to existing runtimes;
- CTest coverage for admitted and rejected mission/command paths.

SIL evidence target: SIL_CAPABILITY_EXECUTION_INTEGRATION

Next: connect these guarded entry points to the higher-level operational action routing path.
