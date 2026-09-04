---
id: NAVIGATION-TRACEABILITY-MATRIX-001
type: navigation_traceability_matrix
status: working_baseline
authority: derived_from_navigation_state_model_rules_algorithm_verification_model
---

# BlueSky PRO — Navigation Traceability Matrix

## 1. Purpose

This matrix is the next controlled traceability layer for Navigation.
It links the existing Navigation Rules and Algorithm to the existing verification model without creating new system requirements solely from the Navigation workstream.

## 2. Decision rule

A Navigation rule or algorithm statement is not a new SYS-REQ unless comparison with the authoritative requirements baseline demonstrates an actual requirement gap.

```text
Navigation Knowledge
→ Rule
→ Algorithm
→ Existing Requirement
→ Architecture / Interface
→ Verification
→ Evidence
```

## 3. Traceability

| Rule | Algorithm block | Verification | Current disposition |
|---|---|---|---|
| N-001 Planned ≠ Actual | State construction | NAV-V20 | COVERED BY NAVIGATION MODEL |
| N-002 Course / Heading / Track distinct | Reference frame / wind relationship | NAV-V01, V02, V06 | COVERED; numerical convention open |
| N-003 Bearing distinct | Navigation semantics | V3 | COVERED |
| N-004 Airspeed ≠ Groundspeed | Wind relationship | NAV-V01…V04 | COVERED; formula verification pending |
| N-005 Drift derived | Derived navigation values | V3, V4 | COVERED; exact convention open |
| N-006 Reference Frame explicit | Reference frame | NAV-V02, V3 | COVERED; approved project CRS pending |
| N-007 Provenance | Source validation | V1, V5 | COVERED |
| N-008 Navigation ≠ Execution Authority | Safety boundary | NAV-V18 | COVERED BY AUTHORITY CHAIN |
| N-009 Actual ↔ Planned | Deviation calculation | NAV-V06, V07 | COVERED |
| N-010 Route/WP version context | Route/WP state | NAV-V07 | COVERED |
| N-011 Measured / Estimated / Derived / Predicted | State construction | NAV-V20 | COVERED |
| N-012 Quality states | Source validation / quality | NAV-V08…V12 | COVERED; thresholds open |
| N-013 Common Navigation State | Integration | V6 | COVERED BY INTEGRATION MODEL |
| N-014 Dynamic Return uses Actual State | Feasibility / Dynamic Return | NAV-V15 | COVERED; formula details open |
| N-015 Individual UAV state | Multi-UAV | NAV-V19 | COVERED |
| N-016 Material change → revalidation | Runtime adaptation | NAV-V16, V17 | COVERED |
| N-017 Map/WP Table common state | Route/WP integration | NAV-V07 | COVERED |
| N-018 Safety priority | Safety boundary | NAV-V18 | COVERED |
| N-019 AI has no execution authority | Safety / authorization | NAV-V18 | COVERED BY AUTHORITY PRINCIPLE |
| N-020 Knowledge provenance | Traceability | Evidence chain | COVERED |

## 4. Verification coverage

The existing Navigation Verification Model defines V1–V7 and NAV-V01…NAV-V20. It explicitly requires traceability from test input through navigation state, calculation, expected/actual result, validation, safety decision and evidence.

No test result is inferred from test definition. Until execution evidence exists, status remains `NOT VERIFIED`.

## 5. Open items

The following remain specification prerequisites rather than invented values:

- coordinate reference system;
- altitude datum;
- units and precision;
- WCA formula;
- Drift Angle convention/sign;
- Cross Track Error formula/sign;
- source-fusion method and source priority;
- stale thresholds;
- confidence calculation;
- turn anticipation;
- route-segment course definition.

## 6. Baseline decision

Current Navigation workstream produces **0 confirmed new SYS-REQ** from this matrix.

Existing requirements remain authoritative. Navigation material is allocated as derived rule, algorithm, architecture/interface input, or verification content until a controlled gap is demonstrated.

## 7. Next controlled action

Proceed to formal mathematical specification only for the open items above, with each parameter linked to its source, applicability, design decision and verification case before implementation.
