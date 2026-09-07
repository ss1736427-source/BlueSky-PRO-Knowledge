# BlueSky PRO — HMI Design System

Status: WORKING BASELINE

## Purpose
This document is the visual source of truth for the BlueSky PRO HMI. The current interface work is performed from the supplied BlueSky PRO screen sketches and logo assets.

## Design principles
- Preserve the BlueSky PRO visual identity.
- Use the project's approved colors and typography rather than substituting generic UI styling.
- Treat panels as independent components so their position, size, visibility and grouping can be changed without redrawing the whole screen.
- Optimize for operator ergonomics and information hierarchy.
- Keep primary flight information visible; move secondary information into expandable or contextual panels.
- The Figma prototype is a component/layout reference for later Qt 6 + QML implementation.

## Current visual baseline
Background: #050A12
Panels: #08111D
Cards: #0C1725
Selected/Hover: #111F30
Primary Blue: #168BFF
Cyan: #35B9FF
Normal: #39D98A
Warning: #FFC857
Critical: #FF5C6C

## Typography baseline
UI: Inter
Headers: Inter Tight 600/700
Telemetry / technical data: B612 / B612 Mono

## Component rules
Panels, cards, headers, controls, telemetry blocks and navigation elements are separate components. Layout must support controlled repositioning and resizing.

## Logo rule
Use the supplied BlueSky PRO master asset. Do not redraw, simplify, recolor or replace the logo without an explicit project decision.

## Change control
Any new color, font, spacing, line width or component geometry becomes part of this baseline only after explicit approval.
