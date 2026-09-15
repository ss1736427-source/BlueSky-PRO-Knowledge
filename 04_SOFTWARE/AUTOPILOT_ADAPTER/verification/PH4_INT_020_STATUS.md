# PH4-INT-020 — C2 lifecycle correlation

Status: IN PROGRESS — awaiting CI verification

## Objective
Verify deterministic C2 link lifecycle and preserve flight/vehicle correlation across the controlled SIL fixture path.

## Scope
- reject send before connection
- reject empty authentication
- connect
- authenticate
- heartbeat health state
- transmit/receive sequence and payload correlation
- disconnect
- reject heartbeat after disconnect
- EvidenceSession correlation

## Evidence boundary
`SIL_FIXTURE_ONLY`.

No real C2 transport, HIL, real-aircraft execution, flight-test evidence, or certification evidence is claimed.

## Exit criterion
CI must pass the PH4-INT-020 fixture and EvidenceSession test without error masking.
