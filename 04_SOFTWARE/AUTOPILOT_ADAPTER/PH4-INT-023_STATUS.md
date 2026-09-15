# PH4-INT-023 — Contingency Command Behavior

**Status:** IMPLEMENTATION PREPARATION — VERIFICATION PENDING  
**Evidence boundary:** `SIL_FIXTURE_ONLY`  
**Baseline:** `MAVLINK2 / BASELINE-1`

## Purpose

Verify the normalized contingency-command contract at the BlueSky autopilot-adapter boundary without assuming that BlueSky replaces onboard flight-controller authority.

## Scope

The SIL verification shall cover the normalized contingency commands supported by the established contract:

- `HOLD`
- `RTL`
- `LAND`
- `ABORT`

The verification shall also cover rejection/negative paths for:

- unsupported command;
- invalid lifecycle/state;
- safety rejection;
- command rejection or timeout where represented by the adapter contract.

## Safety boundary

BlueSky remains supervisory. The onboard flight-control system remains authoritative for stabilization and onboard failsafe behavior. A contingency request from BlueSky is a command request through the adapter, not a transfer of low-level flight-control authority.

Loss of the BlueSky connection must not be interpreted as proof that a contingency command has been executed. Command acceptance, execution state, acknowledgement, reason, and timestamps must remain correlated and traceable.

## Required evidence

The implementation must preserve the established EvidenceSession correlation model and produce evidence classified as `SIL_FIXTURE_ONLY`. No HIL, physical-UAV, flight-test, certification, or real MAVLink-transport evidence is claimed by this stage.

## Acceptance sequence

1. Compile the contingency-command fixture.
2. Verify supported contingency-command acceptance and normalized results.
3. Verify negative-path handling.
4. Verify safety-state gating.
5. Verify command/result correlation and timestamps.
6. Run the Python verification test.
7. Run repository CI.
8. Merge only after CI is green.
9. Change this document to `CLOSED — CI VERIFIED` only after the merge and verified CI result.

## Exit condition

PH4-INT-023 remains open until implementation, automated verification, CI, and merge are all confirmed. PH4-INT-024 must not begin before this exit condition is satisfied.
