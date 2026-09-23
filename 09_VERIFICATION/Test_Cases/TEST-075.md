---
id: TEST-075
type: test_case
title: Insurance Preflight Eligibility and Policy Coverage Test
status: draft
verification_method: test
requirements:
  - SYS-REQ-052
  - SYS-REQ-053
  - SYS-REQ-054
---

# TEST-075 — Insurance Preflight Eligibility and Policy Coverage Test

## Objective

Verify that the preflight insurance gate evaluates the specific INSURED_UAV, applicable regulatory ruleset, policy validity, operation coverage, and required liability limit.

## Controlled scenarios

1. Valid policy + covered UAV + covered operation + sufficient limit -> PASS.
2. Expired policy -> BLOCK.
3. Policy belongs to another UAV -> BLOCK.
4. Operation outside policy coverage -> BLOCK or REVIEW according to configured policy rule.
5. Required insurance not applicable -> no insurance-only block.
6. Insufficient liability limit -> BLOCK.
7. Ambiguous coverage condition -> REVIEW.
8. All mandatory conditions valid -> immutable Insurance Preflight Snapshot created and linked to INSURED_UAV and Flight Record.

## Expected evidence

- input policy version;
- regulatory ruleset version;
- UAV identity;
- applicable legal requirement;
- calculated minimum limit;
- policy limit;
- decision;
- snapshot hash;
- evidence references.

## Execution

Not run. Verification result remains OPEN until controlled execution evidence is recorded.
