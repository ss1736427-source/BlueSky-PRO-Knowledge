# BlueSky PRO — Operational Decision Evidence Contract 001

**Status:** IMPLEMENTATION BASELINE — P0
**Parent:** `04_SOFTWARE/OPERATIONS/BLUESKY_OPERATIONAL_ORCHESTRATOR_INTEGRATION_CONTRACT_001.md`

## Purpose

Record consequential orchestration decisions so that the selected action, authority, constraints and source state remain auditable and replayable.

## Minimum evidence

Each recorded selection carries:

- stable decision ID;
- orchestrator policy version;
- input operational-state version;
- considered action IDs;
- selected action ID, when one exists;
- applicable constraints;
- resolved authority;
- resolved automation level;
- outcome (`Selected`, `HumanRequired`, or `None`);
- resulting state transition;
- completion evidence when available.

## Boundary

This recorder records decisions; it does not execute actions, alter authority, redefine subsystem state or bypass Safety, Regulatory or Energy gates. It is intentionally independent of UI and FCS execution.

A decision with no selected action remains a valid evidence record with `None` outcome. This preserves blocked/no-action states instead of silently losing them.

## Verification

CTest covers a successfully selected automatic action and a no-selection case. The test verifies identity, policy/state provenance, selected action, constraints, authority, automation, outcome and state/completion evidence.

## Anti-rework rule

This contract establishes evidence continuity before resource/mission adaptation and Runtime integration. Later components may extend the evidence record with richer provenance without changing the meaning of the existing fields.
