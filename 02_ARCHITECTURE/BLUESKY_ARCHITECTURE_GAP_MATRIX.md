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
| Vehicle Capability Model | BASELINED | pending | pending | P0 |
| Payload Capability Model | BASELINED | pending | pending | P0 |
| Universal Autopilot API | BASELINED | pending | pending | P0 |
| ArduPilot adapter | required | pending | pending | P0 |
| PX4 adapter | required | pending | pending | P0 |
| OEM adapter framework | required | pending | pending | P0 |
| C2 abstraction | BASELINED | pending | pending | P0 |
| Channel management / failover | BASELINED | pending | pending | P0 |
| Mission Package | BASELINED | pending | pending | P0 |
| Mission upload + read-back verification | BASELINED | pending | pending | P0 |
| Regulatory adapter layer | BASELINED concept | pending | pending | P0 |
| FPL / authorization workflows | required | pending | pending | P0 |
| SIL | specified | pending | pending | P0 |
| HIL | specified | pending | pending | P0 |
| Automated pre-flight validation | specified | pending | pending | P0 |
| Telemetry normalization | BASELINED | pending | pending | P0 |
| Runtime state machine | specified | pending | pending | P0 |
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

The replanning contract defines triggers, immutable constraints, validation of a new plan and controlled transfer to the UAV. Runtime changes are classified by impact so the system avoids unnecessary full recomputation.

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
8. Unified Telemetry/Event Model
9. SIL
10. ArduPilot/PX4 adapters
11. HIL
12. ATM/Regulatory adapters
13. Real-UAV validation
14. Replay / predicted-vs-actual / corrections
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

## 8. Current architecture status

The following P0 contracts are now baselined in the repository:

- Mission Model;
- Mission Objective Profiles;
- Vehicle/Payload Capability Model;
- Universal Autopilot API;
- C2 Runtime and Channel Management;
- Mission Package;
- Operational Validation;
- Unified Telemetry/Event Model;
- End-to-End Operational Lifecycle.

These baselines close architectural definition gaps but do **not** imply implementation or verification completion.

## 9. Remaining P0 implementation gaps

1. concrete ArduPilot adapter;
2. concrete PX4 adapter;
3. OEM adapter framework and first OEM integration;
4. executable Mission Package schema/serialization and transfer implementation;
5. C2 drivers and failover implementation;
6. runtime state machine/replanning implementation;
7. automated validation engine;
8. SIL integration harness;
9. HIL integration;
10. ATM/FPL/authorization adapters;
11. normalized telemetry/event implementation;
12. real-UAV operational verification.

These items are the next implementation work, in dependency order.
