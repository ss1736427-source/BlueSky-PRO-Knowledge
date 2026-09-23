---
id: DS-BOTTOM-TOOLBAR-001
type: design_system_component
status: working_reference
system: BlueSky PRO
---

# BlueSky PRO — DS Bottom Toolbar 001

## Purpose

Canonical Design System component for persistent workspace navigation and panel control.

## Structure

`LEFT ◀ | UAV | MAP | ADMIN | FPV | VIRTUAL FLT | RIGHT ▶ | TIME | ☰ TOOLS`

### Fixed elements
- LEFT ◀
- RIGHT ▶
- TIME
- ☰ TOOLS

### Configurable workspace contexts
- UAV
- MAP
- ADMIN
- FPV
- VIRTUAL FLT

Fixed elements never participate in workspace reordering.

## Visual rules

- Black primary surface: `#000000`
- Panel surface: `#050505`
- Primary text: `#FFFFFF`
- Service text/borders: `#7F7F7F`
- Active workspace accent: `#32FFFF`
- 1 px service/component borders.
- Compact persistent height; exact application geometry remains responsive to the host window.
- Active context is visually distinct but does not become a command/flight-control state.

## Interaction rules

1. Workspace contexts may be enabled or disabled.
2. Their order is persistent.
3. Disabling the active context immediately selects the first enabled context in saved order.
4. At least one workspace context must remain enabled.
5. Re-enabled contexts return to their saved position.
6. TOOLS configures the workspace toolbar; it is not a workspace context.
7. LEFT/RIGHT control panel visibility and remain fixed.
8. TIME is a system element and remains fixed.
9. Toolbar configuration changes presentation/navigation only.
10. Toolbar configuration cannot delete data, alter mission logic, stop telemetry, change route calculations or bypass safety authority.

## Safety boundary

`MISSION → VALIDATION → READINESS → SAFETY GATE → OPERATOR APPROVAL → EXECUTION`

The Bottom Toolbar is navigation/presentation infrastructure and cannot bypass this chain.

## Visual reference

`BLUESKY_PRO_DS_BOTTOM_TOOLBAR_001.svg`

This is a DS reference component, not a final application screenshot and not a certification artifact.
