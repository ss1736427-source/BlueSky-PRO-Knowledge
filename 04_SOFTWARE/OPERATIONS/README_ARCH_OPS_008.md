# ARCH-OPS-008 — Operational Decision Evidence

Implementation stage closes the evidence/provenance step required after deterministic next-action selection.

Implementation: `core/operational_decision_evidence.hpp`
Test: `core/operational_decision_evidence_test.cpp`
CI: `operational-orchestrator-decision-evidence.yml`

The evidence record preserves decision identity, policy/state provenance, considered/selected actions, constraints, authority, automation, outcome, state transition and completion evidence.