# PH4-INT-026 — Capability Manifest and Compatibility Gate

**Status:** IMPLEMENTATION PREPARATION — VERIFICATION PENDING  
**Evidence boundary:** `SIL_FIXTURE_ONLY`  
**Baseline:** `MAVLINK2 / BASELINE-1`

## Purpose

Establish a normalized machine-readable capability manifest and deterministic compatibility gate at the Universal Autopilot Adapter boundary. The gate shall prevent unsupported protocol/version combinations from entering the operational adapter lifecycle while preserving the existing protocol-independent API.

## Scope

The stage shall cover:

- normalized adapter capability manifest;
- adapter, vendor, FCS, vehicle, protocol and protocol-version identity;
- declared command/mission/equipment/log/failsafe capability sets;
- explicit verification status and known limitations;
- compatibility evaluation against required protocol/version and required mission capability;
- deterministic rejection with `INCOMPATIBLE_VERSION` or `CAPABILITY_MISSING` where applicable;
- successful compatibility acceptance for the baseline MAVLink2 fixture;
- EvidenceSession correlation and provenance preservation.

## Safety and boundary

Compatibility evaluation is a readiness gate. It does not execute flight commands and does not change onboard flight-controller authority.

Protocol-specific details remain inside the adapter boundary. The BlueSky core consumes normalized manifest and compatibility results only.

## Required evidence

Evidence shall remain classified as `SIL_FIXTURE_ONLY`. No HIL, physical-UAV, flight-test, certification, or real transport evidence is claimed.

## Acceptance sequence

1. Baseline the normalized manifest and compatibility contract.
2. Implement the manifest/compatibility behavior on the universal adapter baseline.
3. Add the SIL fixture and register it in CMake without disturbing existing targets.
4. Verify complete manifest identity/capability fields.
5. Verify compatible baseline acceptance.
6. Verify protocol/version mismatch rejection.
7. Verify missing required capability rejection.
8. Verify EvidenceSession correlation and provenance.
9. Run repository CI.
10. Merge only after CI is green.
11. Change this document to `CLOSED — CI VERIFIED` only after merge and verified CI result.

## Exit condition

PH4-INT-026 remains open until implementation, automated verification, CI, and merge are all confirmed.

PH4-INT-027 must not begin before this exit condition is satisfied.
