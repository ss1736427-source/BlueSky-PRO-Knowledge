# BlueSky PRO — Architecture GAP Matrix

**Status:** BASELINE — controlled integration audit

## 1. Purpose

This matrix checks whether the BlueSky product lifecycle has a continuous path from mission intent to real UAV execution and back to verified operational evidence.

A document describing an interface is not treated as implementation. Each capability progresses through:

`SPECIFIED → CONTRACT BASELINED → IMPLEMENTED → INTEGRATED → TESTED → VERIFIED`

## 2. End-to-end control chain

```text
MISSION INTENT
   ↓
MISSION MODEL
   ↓
VEHICLE / PAYLOAD CAPABILITY
   ↓
TASK / COVERAGE MODEL
   ↓
ALGORITHM ORCHESTRATION
   ↓
ROUTE + WIND + ENERGY + RESOURCE
   ↓
REGULATORY / ATM
   ↓
C2
   ↓
AUTOPILOT ADAPTER
   ↓
MISSION PACKAGE
   ↓
OPERATIONAL VALIDATION
   ↓
READY FOR FLIGHT
   ↓
UAV EXECUTION
   ↓
TELEMETRY / EVENTS / LOGS
   ↓
REPLANNING / RECOVERY
   ↓
REPLAY / PREDICTED-vs-ACTUAL
   ↓
CORRECTIONS
```

## 3. Current GAP classification

| Capability | Architectural contract | Implementation | Integration / verification | Priority |
|---|---|---|---|---|
| Mission Model | BASELINED | pending | pending | P0 |
| Mission Objective Profiles | BASELINED | pending | pending | P0 |
| Vehicle Capability Model | required | pending | pending | P0 |
| Payload Capability Model | required | pending | pending | P0 |
| Universal Autopilot API | BASELINED | pending | pending | P0 |
| ArduPilot adapter | required | pending | pending | P0 |
| PX4 adapter | required | pending | pending | P0 |
| OEM adapter framework | required | pending | pending | P0 |
| C2 abstraction | required | pending | pending | P0 |
| Channel management / failover | required | pending | pending | P0 |
| Mission Package | required | pending | pending | P0 |
| Mission upload + read-back verification | required | pending | pending | P0 |
| Regulatory adapter layer | BASELINED concept | pending | pending | P0 |
| FPL / authorization workflows | required | pending | pending | P0 |
| SIL | specified | pending | pending | P0 |
| HIL | specified | pending | pending | P0 |
| Automated pre-flight validation | specified | pending | pending | P0 |
| Telemetry normalization | required | pending | pending | P0 |
| Runtime state machine | required | pending | pending | P0 |
| Recovery / failsafe coordination | specified | pending | pending | P0 |
| Replanning | specified | pending | pending | P0 |
| Log / replay | specified | pending | pending | P1 |
| Predicted-vs-actual analysis | specified | pending | pending | P1 |
| Corrections / model learning | specified | pending | pending | P1 |

## 4. Critical interface gaps

### 4.1 Planning → Vehicle

The planner must produce a vehicle-independent mission intent and a vehicle-compatible executable representation. Capability negotiation must occur before mission finalization.

### 4.2 Planning → Autopilot

A mission package must have explicit versioning, coordinate/frame conventions, command semantics, validation status and read-back verification.

### 4.3 Autopilot → BlueSky Runtime

The adapter must normalize telemetry, vehicle state, mission progress, command acknowledgement, faults and failsafe state into a common runtime model.

### 4.4 C2 → Runtime

C2 state must be observable by the runtime and must support deterministic channel selection, degradation and recovery behaviour.

### 4.5 ATM / Regulatory → Planning

External regulatory information must enter the same authoritative constraint model used by planning and replanning, with source, timestamp/version and validity.

### 4.6 Runtime → Planning

The system needs an explicit replanning contract: what events may trigger replanning, which constraints are immutable, how a new plan is validated, and how it is transferred to the UAV.

### 4.7 Execution → Evidence

The executable mission version, vehicle configuration, payload configuration, algorithms, environmental inputs, regulatory status and operator actions must be correlated with flight logs.

## 5. Definition of done for a P0 integration

A P0 item is not complete at documentation stage. It becomes complete only when:

1. contract is baselined;
2. implementation exists;
3. adapter/integration works;
4. automated tests pass;
5. representative SIL/HIL tests pass where applicable;
6. failure behaviour is tested;
7. evidence is retained;
8. verification status is traceable to the exact version.

## 6. Anti-rework order

Implementation shall follow dependency order:

```text
1. Mission Model
2. Vehicle/Payload Capability Model
3. Autopilot API
4. C2 API
5. Mission Package
6. Safety + Energy Gate
7. Runtime State Machine
8. SIL
9. ArduPilot/PX4 adapters
10. HIL
11. ATM/Regulatory adapters
12. Telemetry / Replay
13. Real-UAV validation
```

UI work must consume these contracts and must not redefine them.

## 7. Audit rule

Whenever a new feature is proposed, the audit asks:

- Which lifecycle stage does it belong to?
- Which existing contract does it consume?
- Which external boundary does it cross?
- What is its failure behaviour?
- How is it tested?
- What evidence proves it works?

If one of these is missing, the feature remains a GAP rather than being considered complete.

## 8. Immediate P0 work

The highest-risk missing practical contours are:

1. Vehicle/Payload Capability Model;
2. concrete universal Autopilot Adapter implementation;
3. Mission Package schema and transfer/read-back protocol;
4. C2 runtime/channel state machine;
5. runtime/replanning state machine;
6. SIL/HIL integration harness;
7. regulatory/FPL adapter implementation;
8. normalized telemetry and event model.

These are the interfaces that turn the current architectural model into an executable product.
