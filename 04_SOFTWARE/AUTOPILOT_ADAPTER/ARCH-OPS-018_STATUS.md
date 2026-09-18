# ARCH-OPS-018 — MAVLink Session Boundary

**Status:** IMPLEMENTATION — PR pending CI

## Scope
Implement the smallest P0 G0-02 session boundary without introducing socket/serial/radio code or autopilot-specific mission semantics.

## Implemented
- explicit MAVLink2 session identity;
- dialect requirement;
- system/component identity preservation;
- connection/disconnection state;
- HEARTBEAT acceptance and freshness;
- malformed/unsupported message rejection;
- source identity routing gate;
- loss → recovery → new transport session restoration;
- deterministic counters for accepted/rejected messages.

## Boundary
This is a protocol-session contract boundary. It is not real MAVLink wire transport, serial/UDP/TCP/radio integration, autopilot discovery against a real vehicle, or HIL/real-flight evidence.

## G0-02 coverage
| Requirement | Coverage |
|---|---|
| version/dialect policy | IMPLEMENTED — deterministic MAVLink2 + dialect gate |
| connection/session identity | IMPLEMENTED — session/system/component identity |
| heartbeat/liveness | IMPLEMENTED — HEARTBEAT + freshness |
| routing | IMPLEMENTED — source identity and support/malformed gates |
| physical transport | OPEN — next integration boundary |

## Verification
CTest coverage exercises positive, malformed, unsupported, loss/recovery and session replacement paths.

## Exit criterion
CI must pass the full repository adapter workflow. Do not merge until full GREEN CI is verified.
