---
id: C2-VER-CFG-001
type: c2_verification_configuration
status: controlled_working_stub
system: BlueSky PRO
basis: C2-VERIFICATION-CASES-001; VERIFICATION-REGISTER-001
---

# BLUE SKY PRO — C2 VERIFICATION CONFIGURATION 001

## 1. Purpose

Temporary controlled configuration stub for C2 verification cases `C2-V01..C2-V08`.
This record establishes the fields that must be completed before real execution. It is not test evidence and does not authorize or represent execution.

## 2. Configuration record

| Field | Stub value | Real-test replacement |
|---|---|---|
| Configuration ID | `C2-VER-CFG-001` | Retain ID; revise controlled record |
| Verification baseline | `BL-VER` | Confirm approved baseline |
| System version | `EXECUTION_STUB` | Actual system version |
| Software build ID | `EXECUTION_STUB` | Actual build identifier |
| Source revision | `EXECUTION_STUB` | Actual tested commit SHA |
| Interface version | `EXECUTION_STUB` | Actual interface version |
| C2 mode/profile | `TBD` | Approved applicable C2 configuration |
| Test environment | `EXECUTION_STUB` | Actual test environment |
| Hardware | `TBD` | Actual hardware configuration |
| Communication link | `TBD` | Actual C2 link/configuration |
| Simulator / aircraft | `TBD` | Actual approved test means |
| Dataset / inputs | `EXECUTION_STUB` | Actual dataset/input identity |
| Procedure | `EXECUTION_STUB` | Approved procedure and revision |
| Acceptance criteria | `TBD` | Controlled acceptance criteria |
| Reviewer | `TBD` | Named reviewer |
| Execution date | `TBD` | Actual execution date |
| Configuration status | `STUB — NOT APPROVED FOR EXECUTION` | `APPROVED` only after review |

## 3. Real-test replacement rule

Before real C2 execution, replace every `EXECUTION_STUB` and `TBD` field with the actual approved value and complete the required review.

After execution, the tested source revision, environment, inputs, procedure and measured results shall be retained in the execution record. The temporary stub shall not be presented as evidence.

## 4. Case coverage

The configuration applies to:

`C2-V01, C2-V02, C2-V03, C2-V04, C2-V05, C2-V06, C2-V07, C2-V08`

## 5. Status gate

```text
CONFIGURATION: CONTROLLED STUB
APPROVAL: NOT APPROVED
EXECUTION: NOT AUTHORIZED / NOT PERFORMED
EVIDENCE: NONE
VERIFICATION: NOT VERIFIED
```

No `PASS`, `PASSED` or `VERIFIED` status may be inferred from this stub.
