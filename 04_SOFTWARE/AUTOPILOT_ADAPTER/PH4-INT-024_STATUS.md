# PH4-INT-024 — Flight Log Acquisition

**Status:** IMPLEMENTATION PREPARATION — VERIFICATION PENDING  
**Evidence boundary:** `SIL_FIXTURE_ONLY`  
**Baseline:** `MAVLINK2 / BASELINE-1`

## Purpose

Establish and verify the normalized autopilot-adapter contract for acquiring a flight log without coupling BlueSky core to a protocol-specific log-transfer implementation.

## Scope

The stage shall cover:

- capability declaration for flight-log acquisition;
- normalized log-acquisition request/result;
- vehicle, mission and flight-record correlation;
- source/protocol/version provenance;
- successful acquisition in the connected state;
- rejection when the adapter is not connected;
- rejection/handling of invalid or unavailable log identifiers;
- preservation of acquired-log identity and source reference;
- EvidenceSession correlation and lifecycle closure.

## Safety and boundary

Log acquisition is observational/evidence handling. It must not alter mission execution or flight-controller authority.

BlueSky remains supervisory. Protocol-specific log transfer remains inside the adapter boundary. No real MAVLink transport is introduced by this stage.

## Required evidence

Evidence shall remain classified as `SIL_FIXTURE_ONLY`. No HIL, physical-UAV, flight-test, certification, or real MAVLink-transport evidence is claimed.

## Acceptance sequence

1. Baseline the normalized log-acquisition contract.
2. Implement the SIL fixture.
3. Register the fixture in CMake without disturbing existing targets.
4. Verify capability and successful acquisition behavior.
5. Verify negative paths and connection gating.
6. Verify provenance and correlation through EvidenceSession.
7. Run repository CI.
8. Merge only after CI is green.
9. Change this document to `CLOSED — CI VERIFIED` only after the merge and verified CI result.

## Exit condition

PH4-INT-024 remains open until contract implementation, automated verification, CI, and merge are all confirmed.

PH4-INT-025 must not begin before this exit condition is satisfied.
