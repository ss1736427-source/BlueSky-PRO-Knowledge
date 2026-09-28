# BlueSky PRO — Interim Display Checkpoint

**Date:** 2026-09-28  
**Status:** Intermediate visual baseline; not a release candidate  
**Branch:** `fix/hmi-map-right-panel-refresh-2026-09-28`  
**Related PR:** [#213 — HMI: replace map placeholder and refresh mission panel](https://github.com/ss1736427-source/BlueSky-PRO-Knowledge/pull/213)

## Captured state

The Qt Design Studio screenshot supplied on 2026-09-28 is accepted as the interim display baseline.

- Compact top header with ETD, TOT, TRIP, ETA, READY, WARNING, and operator area.
- Left mission list and green **СОЗДАТЬ МИССИЮ** action.
- Central Flight Chart schematic with grid, sample route, waypoint markers, restricted-area illustration, legend, and illustrative wind indicator.
- Right **MISSION STATUS** panel with readiness, flight conditions, warnings/corrections, mission actions, and safety-authority information.
- Bottom toolbar with LEFT / ADMIN / MAP / VIRTUAL FLT / FPV / UAV / RIGHT, clock, and tools menu.

## Known limitations / follow-up

1. Flight Chart is a schematic prototype, not a georeferenced map. It has no live map tiles, coordinates, NOTAM feed, weather feed, or operational route data.
2. The bottom-tool order shown in the captured screen is not yet confirmed as the intended persistent default.
3. The right-panel Mission Actions area has excess vertical whitespace and needs a layout pass.
4. QML build/runtime validation in Qt Design Studio is still required.

## Safety boundary

This checkpoint records a visual HMI state only. It does not establish flight readiness, validate a mission, or authorize UAV operation. Core / Safety remains authoritative.

## Reversion

This checkpoint is preserved in the dedicated feature branch and PR. To discard this interim update, close PR #213 without merging; do not reset or force-push `main`.
