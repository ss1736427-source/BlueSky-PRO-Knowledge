# ARCH-OPS-049 — Operational Action Routing

Status: IMPLEMENTATION_BASELINE

Implemented:
- single operational action execution router;
- exact selected-action to execution-binding match;
- explicit mission-transfer and command-dispatch routing kinds;
- explicit device_id and required capabilities;
- mandatory handoff through ARCH-OPS-048 guarded entry points;
- rejection before execution when selection or capability admission fails;
- CTest coverage.

SIL evidence target: SIL_OPERATIONAL_ACTION_EXECUTION_ROUTER

Next: bind external operational request intake to the orchestrator pipeline.
