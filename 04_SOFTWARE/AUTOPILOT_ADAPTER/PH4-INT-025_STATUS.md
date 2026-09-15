# PH4-INT-025 — Clean Close and Archive

**Status:** IMPLEMENTATION PREPARATION — VERIFICATION PENDING  
**Evidence boundary:** `SIL_FIXTURE_ONLY`  
**Baseline:** `MAVLINK2 / BASELINE-1`

## Purpose

Establish and verify the normalized autopilot-adapter close lifecycle after operational activity, including deterministic cleanup, correlation preservation, and archive closure without changing flight-controller authority.

## Scope

The stage shall cover:

- explicit clean-close operation at the adapter boundary;
- close allowed after completed or terminated operational lifecycle;
- rejection/handling of invalid close state;
- idempotent close behavior where applicable;
- preservation of vehicle, mission, flight-record, source/protocol/version correlation;
- EvidenceSession lifecycle closure and archive state;
- separation of close/archive from mission execution and contingency authority.

## Safety and boundary

Close and archive are lifecycle/evidence operations. They must not be interpreted as a command to the flight controller and must not alter onboard flight-control authority.

BlueSky remains supervisory. Protocol-specific cleanup remains inside the adapter boundary.

## Required evidence

Evidence shall remain classified as `SIL_FIXTURE_ONLY`. No HIL, physical-UAV, flight-test, certification, or real MAVLink-transport evidence is claimed.

## Acceptance sequence

1. Baseline the clean-close lifecycle contract.
2. Implement the SIL fixture.
3. Register the fixture in CMake without disturbing existing targets.
4. Verify successful close after operational completion/termination.
5. Verify invalid-state and repeat-close behavior.
6. Verify correlation, provenance and EvidenceSession archive closure.
7. Run repository CI.
8. Merge only after CI is green.
9. Change this document to `CLOSED — CI VERIFIED` only after merge and verified CI result.

## Exit condition

PH4-INT-025 remains open until contract implementation, automated verification, CI, and merge are all confirmed.

PH4-INT-026 must not begin before this exit condition is satisfied.
