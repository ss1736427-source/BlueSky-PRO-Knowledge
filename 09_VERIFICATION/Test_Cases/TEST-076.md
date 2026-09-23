---
id: TEST-076
type: test_case
title: UAV Insurance History Accumulation and Data Lineage Test
status: draft
verification_method: test
requirements:
  - SYS-REQ-055
---

# TEST-076 — UAV Insurance History Accumulation and Data Lineage Test

## Objective

Verify that completed flights update the insurance history of the specific INSURED_UAV and that derived metrics remain traceable to source evidence and calculation/ruleset versions.

## Controlled scenarios

1. Complete a normal flight -> flight count and exposure increase.
2. Add a maintenance/configuration change -> history is attached to the UAV and effective period.
3. Add an anomaly/incident -> event appears in UAV safety history.
4. Add a new flight under a different configuration -> configuration-specific history remains distinguishable.
5. Recalculate a metric -> source records, method, version and timestamp are retained.
6. Corrupt/remove source evidence -> derived metric must not silently remain authoritative.

## Expected evidence

- UAV history record;
- exposure counters;
- event records;
- configuration history;
- source references;
- calculation method/version;
- integrity status.

## Execution

Not run. Verification result remains OPEN until controlled execution evidence is recorded.
