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
OBJECTIVE / TASK INTERPRETATION
   ↓
CAPABILITY + RESOURCE DISCOVERY
   ↓
TASK / COVERAGE MODEL
   ↓
ALGORITHM ORCHESTRATION
   ↓
CANDIDATE SOLUTIONS
   ↓
SAFETY + REGULATORY + ENERGY GATE
   ↓
OPERATIONAL ORCHESTRATOR
   ↓
READINESS / AUTHORIZATION / RELEASE
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
RUNTIME STATE + NEXT-ACTION DECISION
   ↓
REPLANNING / RECOVERY
   ↓
RESULT VERIFICATION
   ↓
VIRTUAL ↔ REAL ↔ REPLAY ANALYSIS
   ↓
INTERNAL EXPERIENCE / CORRECTIONS
   ↓
APPROVED MODEL / ALGORITHM / KNOWLEDGE
   ↓
NEXT PREDICTION / PLANNING CYCLE
```

## 3. Current GAP classification

| Capability | Architectural contract | Implementation | Integration / verification | Priority |
|---|---|---|---|---|
| Mission Model | BASELINED | IMPLEMENTED | pending | P0 |
| Mission Objective Profiles | BASELINED | pending | pending | P0 |
| Vehicle Capability Model | BASELINED | IMPLEMENTED | pending | P0 |
| Payload Capability Model | BASELINED | IMPLEMENTED | pending | P0 |
| Algorithm Orchestration | BASELINED | IMPLEMENTED | pending | P0 |
| **Operational Orchestrator** | **BASELINED** | pending | pending | **P0** |
| **Dynamic Readiness / Action Graph** | **existing requirements + additive orchestration boundary** | pending | pending | **P0** |
| **Resource/mission adaptation decision path** | **BASELINED by orchestration policy** | pending | pending | **P0** |
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
| Mission result verification | **additive contract required by operational orchestration** | pending | pending | P0 |
| Intelligence Core / Intelligence Contract | BASELINED | pending | pending | P1 |
| Internal operational experience | BASELINED | pending | pending | P1 |
| Virtual/Real/Actual-condition Replay comparison | BASELINED | pending | pending | P1 |
| Difference + cause analysis | BASELINED | pending | pending | P1 |
| External Technology Intelligence | BASELINED | pending | pending | P1 |
| Competitive Intelligence | BASELINED | pending | pending | P1 |
| Comparison / Benchmark Engine | BASELINED | pending | pending | P1 |
| Hypothesis / Experiment lifecycle | BASELINED | pending | pending | P1 |
| Controlled learning / model promotion | BASELINED | pending | pending | P1 |
| Knowledge provenance / governance | BASELINED | pending | pending | P1 |
| Log / replay | specified | pending | pending | P1 |
| Predicted-vs-actual analysis | specified | pending | pending | P1 |
| Corrections / model learning | specified | pending | pending | P1 |

## 4. Additive orchestration gaps

The following are architectural additions, not replacements for existing contracts:

### 4.1 Task objective → acceptable outcomes

The mission objective shall be represented independently from the selected route, vehicle allocation and algorithm. A mission may define multiple acceptable outcomes and operational priorities. The orchestrator evaluates candidate solutions against mandatory acceptance conditions and then optimizes applicable objectives.

### 4.2 Resource availability → mission adaptation

Resource selection shall be able to identify unavailable/available UAVs and equipment and feed that state into planning. If the preferred resource is unavailable, the system shall evaluate feasible alternatives including another UAV, multiple UAVs, changed route/profile, task splitting or multiple sorties where permitted.

### 4.3 Preparation → dynamic next action

Preparation shall be represented as a dependency-aware graph. Independent actions may proceed in parallel; blocked actions remain unavailable until prerequisites are satisfied. The orchestrator selects the next actionable step or coordinated parallel set rather than exposing a static checklist.

### 4.4 Role-aware execution

The common preparation graph shall support one person performing multiple roles or several people performing distributed roles. Each role receives only its applicable human actions while the system retains the global readiness state.

### 4.5 Automation → human authority

Actions shall be classified as automatable, human-guided or human-decision. Automation is permitted only within an explicit authority boundary. Mandatory configuration and safety/regulatory constraints cannot be silently changed.

### 4.6 Mission adaptation envelope

Active mission adaptation shall distinguish pre-authorized automatic changes from changes requiring human decision. The adaptation envelope shall be traceable to mission authorization, safety policy and verified vehicle/FCS capability.

### 4.7 Next-action selection objective

When several actions are executable, selection shall advance successful mission completion while respecting hard safety/regulatory constraints, protected energy reserve, task quality and operational timing/resource constraints.

### 4.8 Result-based completion

`LANDED` and `MISSION COMPLETE` shall remain distinct states. Mission completion requires the mission-specific result, data integrity and quality/output acceptance conditions to be satisfied.

### 4.9 Controlled learning

Operational observations feed analysis and candidate corrections. Production behaviour changes only through evidence-backed human review, versioning and controlled promotion.

## 5. Critical interface gaps

### 5.1 Planning → Vehicle

The planner must produce a vehicle-independent mission intent and a vehicle-compatible executable representation. Capability negotiation must occur before mission finalization.

### 5.2 Planning → Autopilot

A mission package must have explicit versioning, coordinate/frame conventions, command semantics, validation status and read-back verification.

### 5.3 Autopilot → BlueSky Runtime

The adapter must normalize telemetry, vehicle state, mission progress, command acknowledgement, faults and failsafe state into a common runtime model.

### 5.4 C2 → Runtime

C2 state must be observable by the runtime and must support deterministic channel selection, degradation and recovery behaviour.

### 5.5 ATM / Regulatory → Planning

External regulatory information must enter the same authoritative constraint model used by planning and replanning, with source, timestamp/version and validity.

### 5.6 Runtime → Planning

The replanning contract defines triggers, immutable constraints, validation of a new plan and controlled transfer to the UAV. Runtime changes are classified by impact so the system avoids unnecessary full recomputation.

### 5.7 Orchestrator → Runtime

The operational orchestrator shall provide a canonical decision/action context: current state, available resources, dependencies, authority, constraints, candidate actions, selected action and reason. Runtime remains authoritative for deterministic execution-state transitions.

### 5.8 Execution → Evidence

The executable mission version, vehicle configuration, payload configuration, algorithms, environmental inputs, regulatory status and operator actions must be correlated with flight logs.

### 5.9 Intelligence → Operational Core

Intelligence may predict, analyse and recommend, but it must consume canonical domain contracts and must not bypass the Safety/Regulatory/Energy Gate or controlled runtime authority.

### 5.10 Virtual Flight ↔ Real Flight

The same mission configuration must support a forecast-based virtual run, correlation with actual flight results, and an actual-condition replay where data permits. The comparison must preserve the forecast/environment/model versions used for each result.

### 5.11 Experience → Learning

Operational discrepancies must be converted into learning candidates only after cause analysis and sufficient evidence. A single observation shall not silently modify production behaviour.

### 5.12 External Intelligence → BlueSky improvement

External research, technology and competitor information is reference evidence, not operational truth. External findings must pass provenance, relevance, hypothesis, experiment and validation steps before affecting production models or algorithms.

### 5.13 Learning → Production

Candidate models, corrections or algorithms require controlled validation, versioning, approval and rollback capability before promotion.

## 6. Definition of done for a P0 integration

A P0 item is not complete at documentation stage. It becomes complete only when:

1. contract is baselined;
2. implementation exists;
3. adapter/integration works;
4. automated tests pass;
5. representative SIL/HIL tests pass where applicable;
6. failure behaviour is tested;
7. evidence is retained;
8. verification status is traceable to the exact version.

## 7. Anti-rework order

Implementation shall follow dependency order:

```text
1. Mission Model
2. Vehicle/Payload Capability Model
3. Autopilot API
4. C2 API
5. Mission Package
6. Safety + Energy Gate
7. Operational Orchestrator integration contract
8. Runtime State Machine
9. Dynamic Readiness / Action Graph
10. Unified Telemetry/Event Model
11. SIL
12. ArduPilot/PX4 adapters
13. HIL
14. ATM/Regulatory adapters
15. Mission result verification
16. Real-UAV validation
17. Replay / predicted-vs-actual / corrections
18. Intelligence Core integration
19. External / Competitive Intelligence
20. Comparison / Benchmark Engine
21. Controlled learning / model promotion
```

This order is additive to the existing dependency chain. No existing P0 contract is invalidated by the orchestration layer.

## 8. Audit rule

Whenever a new feature is proposed, the audit asks:

- Which lifecycle stage does it belong to?
- Which existing contract does it consume?
- Which external boundary does it cross?
- What is its failure behaviour?
- How is it tested?
- What evidence proves it works?
- If it learns or changes behaviour, what is the promotion and rollback path?
- Does it duplicate an existing contract, or compose it through an explicit interface?

If one of these is missing, the feature remains a GAP rather than being considered complete.

## 9. Current architecture status

The existing P0 contracts remain authoritative. The Operational Orchestrator is now an additive cross-cutting P0 architecture contract connecting those contracts into one operational decision path. The Dynamic Readiness / Action Graph and mission result verification are identified as implementation/integration additions; they do not replace the existing Runtime, Validation or Lifecycle contracts.

The following P0 contracts are baselined in the repository:

- Mission Model;
- Mission Objective Profiles;
- Vehicle/Payload Capability Model;
- Universal Autopilot API;
- C2 Runtime and Channel Management;
- Mission Package;
- Operational Validation;
- Unified Telemetry/Event Model;
- End-to-End Operational Lifecycle;
- Operational Orchestrator & Energy Policy.

The Intelligence & Evolution Architecture is additionally baselined as a cross-cutting P1 architecture contract. It formalizes internal experience, virtual/real/replay comparison, external technology and competitive intelligence, benchmarking, hypothesis/experiment flow and controlled learning without changing the existing P0 domain contracts.

These baselines close architectural definition gaps but do **not** imply implementation or verification completion.

The Mission Model now also has a typed planning-layer contract in `04_SOFTWARE/PLANNING/model/mission_model.hpp` with a dedicated contract test. Integration/verification remains pending.

The Vehicle/Equipment Capability Model now also has a typed planning-layer contract in `04_SOFTWARE/PLANNING/model/vehicle_equipment_capability.hpp` with a dedicated contract test. Integration/verification remains pending.

The Algorithm Orchestrator is additionally implemented in `04_SOFTWARE/PLANNING`, with dedicated integration, route-validation, determinism, objective-selection and rejection-reason tests. Its integration/verification status remains pending until execution is confirmed for the exact repository version.

## 10. Remaining P0 implementation gaps

1. concrete ArduPilot adapter;
2. concrete PX4 adapter;
3. OEM adapter framework and first OEM integration;
4. executable Mission Package schema/serialization and transfer implementation;
5. C2 drivers and failover implementation;
6. Operational Orchestrator integration implementation;
7. dynamic readiness/action-graph implementation;
8. runtime state machine/replanning implementation;
9. automated validation engine;
10. SIL integration harness;
11. HIL integration;
12. ATM/FPL/authorization adapters;
13. normalized telemetry/event implementation;
14. mission result verification;
15. real-UAV operational verification.

These additions do not change the existing contracts. They connect and operationalize them as one unified BlueSky lifecycle.
