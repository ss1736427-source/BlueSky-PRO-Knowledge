# PH4-INT-021 — Navigation lifecycle correlation

Status: IN PROGRESS — awaiting CI verification

## Objective
Verify deterministic navigation-source lifecycle handling and preserve source/vehicle/flight correlation through the controlled SIL fixture path.

## Scope
- reject navigation sample from an unexpected source;
- accept a valid navigation sample;
- preserve source and adapter timestamps;
- read back the accepted sample without correlation loss;
- preserve navigation quality and correction state;
- reject stale data;
- reject invalid data;
- preserve flight/mission/vehicle/source/protocol correlation in EvidenceSession.

## Evidence boundary
`SIL_FIXTURE_ONLY`.

No real GNSS receiver, RTK/NTRIP service, HIL, real-aircraft execution, flight-test evidence, or certification evidence is claimed.

## Exit criterion
CI must pass the PH4-INT-021 navigation fixture and EvidenceSession verification without error masking, while preserving the existing PH4-INT-015…020 test chain.
