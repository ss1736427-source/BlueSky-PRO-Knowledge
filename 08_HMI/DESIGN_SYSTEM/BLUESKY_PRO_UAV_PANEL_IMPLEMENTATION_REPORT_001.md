---
id: HMI-UAV-PANEL-IMPLEMENTATION-001
type: hmi_implementation_report
status: implementation_for_qt_design_studio_review
system: BlueSky PRO
date: 2026-09-27
---

# BlueSky PRO — UAV Panel Implementation Report 001

## 1. Source documents reviewed

- `02_SYSTEM_DESIGN/INTERFACE/UAV_DISPLAY_SELECTION_001.md` — AGREED; default UAV card composition, per-UAV display configuration, optional smart tools, adaptive panel sizing.
- `08_HMI/DESIGN_SYSTEM/BLUESKY_PRO_PANEL_BEHAVIOR_SPECIFICATION_001.md` — panel state must match toolbar state; UAV-specific context; hiding is presentation-only.
- `08_HMI/DESIGN_SYSTEM/BLUESKY_PRO_PANEL_LAYOUT.md` — configurable UAV parameters; layout adapts to displayed information; configuration must not alter mission data.
- `08_HMI/DESIGN_SYSTEM/BLUESKY_PRO_QT_DESIGN_STUDIO_WORKBOOK_001.md` — UAV panel owns detailed telemetry, multiple UAVs, mission progress, battery/resource, communication state and operational state.
- `08_HMI/DESIGN_SYSTEM/BLUESKY_PRO_PANEL_TOOL_ALLOCATION_001.md` — UAV context ownership and tool/configuration boundaries.
- `08_HMI/DESIGN_SYSTEM/BLUESKY_PRO_DESIGN_SYSTEM.md` — approved colors, typography, HGT/ALT terminology and single-stroke panel boundary rule.

## 2. Default card content — corrected

The prior implementation showed `RNG` and `ETA` by default and omitted the engine operating-mode indicator. This did not match the AGREED `UAV-DISPLAY-SELECTION-001` baseline.

The default card now contains:

1. Configured aircraft/model name and sequence.
2. Local aircraft image placeholder (until the configured local UAV/model asset is connected).
3. Board ID.
4. Operational/readiness state and mission state indicator.
5. Height: `HGT` below 100 m true height; `ALT` at/above 100 m, following the HMI terminology baseline.
6. Speed.
7. Battery percentage.
8. Engine operating mode: numeric percentage plus a horizontal bar.
9. Mission-state footer indicator.

`RNG` and `ETA` are optional parameters, not default permanent fields.

## 3. Optional display parameters

The per-card submenu provides these selectable fields:

- WIND — wind
- HDG — heading
- ETA — estimated arrival
- C2 — command/control link state
- CAM — camera state
- RNG — remaining range
- EET — estimated elapsed/remaining flight time as provided by the data source
- TRIP — trip time
- TOT — takeoff time
- GNSS — navigation fix/state
- LINK — communication link state
- WP — waypoint
- PROGRESS — mission progress/state
- BAT HEALTH — battery health
- PAYLOAD — payload/equipment
- TELEM — telemetry quality/state

The four primary fields (height, speed, battery, engines) are also configurable. Parameter order can be changed with the up/down controls. The menu offers **ПРИМЕНИТЬ КО ВСЕМ** for copying the selected card's display configuration to the fleet.

To preserve readability, the current HMI prototype limits a card to eight displayed parameters at once. This is a presentation limit only; it does not limit telemetry acquisition or stored data.

## 4. Card layout and fleet behavior

- Fleet cards are arranged in a responsive grid with a minimum target width of 320 px and a comfortable card height.
- Cards are reordered by drag-and-drop. The order is saved using Qt Settings.
- Each UAV has its own parameter selection/order, saved by board ID.
- The selected UAV is highlighted with the approved cyan navigation color.
- A warning-state UAV receives a red outline; normal state uses the approved green semantic color.
- The fleet layout uses the available workspace between the persistent header and bottom toolbar.
- The uploaded compact three-line menu icon is represented by `icons8-menu-24.svg` and used on each card.
- Selecting a card selects the UAV. Double-click opens the existing local UAV context flow.
- The UAV toolbar button toggles the panel: first press opens it and highlights UAV; second press returns to MAP and removes the active highlight. The runtime toolbar and Design Studio toolbar presentation must stay synchronized with the actual active context.

## 5. Files

- `qt/BlueSkyPRO-HMI/qml/UAVFleetPanelForm.ui.qml` — Qt Design Studio visual form.
- `qt/BlueSkyPRO-HMI/qml/UAVFleetPanel.qml` — runtime state, per-UAV settings, persistence and drag/reorder behavior.
- `qt/BlueSkyPRO-HMI/qml/icons8-menu-24.svg` — compact submenu icon matching the supplied icon.
- `qt/BlueSkyPRO-HMI/qml/MainContent.ui.qml` — routes the UAV workspace to the new fleet panel.
- `qt/BlueSkyPRO-HMI/qml/BottomToolbar.qml` — runtime UAV toggle behavior.

The project QML and image folders are included by directory in `BlueSkyPRO-HMI.qmlproject`; no individual file registration is required.

## 6. Verification status

Implemented in the controlled branch. The repository source has been updated, but Qt Design Studio runtime/preview verification has not yet been performed in the user's local environment.

Required DS checks:

- [ ] QML project loads without errors.
- [ ] UAV opens and closes on repeated toolbar clicks.
- [ ] UAV button highlight exactly follows panel visibility.
- [ ] Four cards are legible at the target desktop width.
- [ ] Dragging changes card order and persists after restart.
- [ ] Per-card settings toggle and reorder fields.
- [ ] Apply-to-all copies the field configuration.
- [ ] User submenu icon renders.
- [ ] Single-click selects a UAV; double-click opens its local context.
- [ ] No panel content is clipped at the tested resolution.

## 7. Known integration boundary

Card values are design-preview values, not live telemetry. Production integration must bind these fields to the normalized telemetry/fleet state and the configured local UAV image. The visual layer must not invent or calculate authoritative flight state. Missing values should be represented as unavailable, and safety-critical warnings must remain visible regardless of optional-field filtering.
