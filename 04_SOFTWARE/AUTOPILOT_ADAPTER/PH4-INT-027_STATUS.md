# PH4-INT-027 — End-to-End Adapter Lifecycle Gate

**Status:** IMPLEMENTATION PREPARATION — VERIFICATION PENDING  
**Evidence boundary:** `SIL_FIXTURE_ONLY`  
**Baseline:** `MAVLINK2 / BASELINE-1`

## Purpose

Close the Phase 4 Universal Integration Layer gate that requires one representative heterogeneous-UAV adapter path to demonstrate the complete operational adapter lifecycle as one correlated SIL scenario.

This stage does not introduce real transport, HIL, physical-UAV, flight-test or certification evidence. It composes the already verified normalized adapter capabilities into one deterministic end-to-end lifecycle proof.

## Scope

The fixture shall cover, in one correlated run:

1. connect and operational session establishment;
2. vehicle/autopilot/protocol identity availability;
3. capability availability and compatibility readiness;
4. canonical mission compilation;
5. mission upload;
6. mission read-back;
7. semantic mission comparison;
8. mission execution command boundary;
9. execution/flight-state evidence boundary;
10. flight-log acquisition;
11. clean close/archive;
12. preservation of mission, vehicle, flight-record, protocol and evidence provenance across the complete sequence.

## Safety and authority boundary

The scenario is SIL-only. No real MAVLink transport or flight-controller authority is exercised.

The fixture must not imply that SIL execution is representative-UAV or flight-test evidence. It proves only the normalized integration lifecycle and evidence continuity at the adapter boundary.

## Acceptance sequence

`CONNECT → IDENTIFY → CAPABILITIES → COMPATIBILITY → COMPILE → UPLOAD → READ-BACK → VERIFY → EXECUTE → LOG → CLOSE`

## Required evidence

- one executable C++ SIL fixture;
- one automated Python verification test;
- CMake/CTest registration;
- EvidenceSession record with one continuous correlation set;
- deterministic PASS/FAIL output;
- explicit `SIL_FIXTURE_ONLY` classification.

## Exit condition

PH4-INT-027 closes only after the fixture, automated verification, CI Configure, Build, Evidence Recorder and Test stages all pass and the change is merged to `main`.

## Deferred

Real transport, HIL, physical-UAV execution, operational flight validation, certification evidence and quantitative performance claims remain outside this stage.
