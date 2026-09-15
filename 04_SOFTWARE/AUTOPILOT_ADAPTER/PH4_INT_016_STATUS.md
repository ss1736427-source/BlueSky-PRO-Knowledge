# PH4-INT-016 — MAVLink2 SIL Provenance

## Status
IMPLEMENTATION_BASELINE

## Objective
Bind the protocol-specific MAVLink2 adapter to the controlled SIL execution and evidence chain and preserve protocol-specific execution provenance end-to-end.

## Delivered
- MAVLink2 command acknowledgement is decoded at the protocol-specific adapter boundary.
- Controlled SIL execution source preserves Flight Record identity.
- Protocol, protocol version, protocol frame, vehicle, command, execution state and SIL execution source are passed into the EvidenceSession.
- Evidence package lifecycle reaches ARCHIVE and is validated/exported by the existing evidence framework.
- Automated Python/CMake test covers the end-to-end fixture chain.

## Evidence class
SIL_FIXTURE_ONLY.

## Boundary
This is a controlled software fixture. It is not real MAVLink transport, HIL, real-aircraft execution, flight-test evidence, or certification evidence.

## Next deterministic gap
Extend the controlled SIL chain to a broader mission execution/readback sequence with explicit protocol and Flight Record correlation before progressing toward HIL/physical execution.
