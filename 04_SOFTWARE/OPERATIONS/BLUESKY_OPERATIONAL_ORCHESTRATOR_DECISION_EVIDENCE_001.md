# BlueSky PRO — Operational Decision Evidence Contract 001

**Status:** IMPLEMENTATION BASELINE — P0

This contract records consequential orchestration decisions for audit and replay.

Each record carries a stable decision ID, orchestrator policy version, input state version, considered and selected action IDs, applicable constraints, resolved authority and automation level, outcome, resulting state transition, and completion evidence when available.

A no-selection record is retained with an explicit `None` outcome so blocked/no-action states are not silently lost.

The recorder only records evidence. It does not execute actions, alter authority, redefine subsystem state, or bypass safety, regulatory, authorization or energy gates.

CTest verifies successful automatic selection evidence and a blocked/no-selection evidence record.
