# PH4-INT-022 — Link-loss behavior & reconnect/resynchronization

**Status:** IMPLEMENTED — CI VERIFICATION PENDING  
**Evidence boundary:** `SIL_FIXTURE_ONLY`  
**Scope:** normalized autopilot adapter link lifecycle

## Objective

Verify that a communication-link loss is represented as a degraded state, telemetry freshness is invalidated, recovery enters an explicit recovering state, mismatched state is rejected, and a valid mission/configuration snapshot restores the synchronized connected state.

## Acceptance criteria

- initial connection reaches `CONNECTED`;
- link loss transitions to `DEGRADED`;
- stale telemetry is not treated as fresh;
- recovery enters `RECOVERING`;
- mismatched mission state is rejected during recovery;
- valid mission/configuration state resynchronizes successfully;
- connection returns to `CONNECTED` only after successful reconciliation;
- telemetry freshness is restored only after resynchronization;
- EvidenceSession preserves vehicle, mission, flight-record, protocol and source correlation.

## Evidence identifiers

- Run: `TEST-RUN-PH4-INT-022`
- Evidence domain: `EC-03`
- Requirement: `REQ-INT-LINK-LOSS-RESYNCHRONIZATION`
- Test method: `TM-PH4-INT-022`
- Test case: `TC-PH4-INT-022`
- Configuration: `CFG-SIL-LINK-022`
- Flight record: `FLIGHT-RECORD-PH4-INT-022`
- Mission: `MISSION-022`
- Vehicle: `UAV-LINK-022`
- Source: `SRC-07`
- Protocol: `MAVLINK2`
- Protocol version: `BASELINE-1`

## Boundary

This stage is a SIL fixture only. It does not constitute evidence from a real communications link, UAV, HIL environment, flight test, or certification test.

## Closure rule

PH4-INT-022 may be marked `CLOSED — CI VERIFIED` only after the fixture and EvidenceSession verification are executed successfully in CI and the PR is merged into `main`.
