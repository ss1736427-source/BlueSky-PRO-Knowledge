# BlueSky PRO — Current Screen Reference

Status: WORKING REFERENCE

## Source

The current reference consists of the supplied BlueSky PRO interface sketches and the supplied logo asset set.

## Working objective

Create a complete operational HMI rather than a static copy of the sketch.

The interface work must cover:

1. ergonomic assessment of the current composition;
2. hiding or removing non-primary information from the main operational view;
3. adding required panels where information is currently missing;
4. editing existing panels;
5. allowing controlled panel relocation and resizing;
6. checking panel dimensions, spacing, borders and line weights;
7. checking background, surface and status colors against the controlled palette;
8. applying the controlled typography;
9. embedding the supplied BlueSky PRO logo asset;
10. producing layouts suitable for both tablet and PC;
11. maintaining a direct path from the Figma component model to Qt 6 + QML.

## Panel model

Treat the following as independent UI components during reconstruction:

- Header / top telemetry strip
- Mission Templates
- Flight Chart / map
- Mission Analysis
- ATC / communications
- Instruments / system state
- UAV Status cards
- Bottom navigation
- Operator status
- Mission progress

The exact grouping and placement are subject to ergonomic review. A panel may be moved, collapsed, replaced or split without changing unrelated components.

## Top Header — intermediate controlled structure

The current intermediate Header is defined as one adaptive component for both tablet and PC.

### Common structure

`LOGO → ETD → TOT → TRIP → ETA → READY → WARNING → OPERATOR`

- **LOGO** — fixed/static left anchor.
- **FLIGHT DATA zone** — adaptive central zone containing ETD, TOT, TRIP, ETA, READY and WARNING.
- **OPERATOR** — fixed/static right anchor.
- The flexible space belongs to the central layout; the fixed anchors do not move when the available width changes.

### Tablet variant

`LOGO → ETD → TOT → TRIP → ETA → READY → WARNING → OPERATOR → BAT`

- **BAT** is tablet-only and represents the tablet/device battery state.
- BAT is a separate device-level element; it is not part of the flight-data group.

### PC variant

`LOGO → ETD → TOT → TRIP → ETA → READY → WARNING → OPERATOR`

- BAT is not displayed in the PC Header.

### Responsive rule

Do not create two unrelated Header designs. Use one component with adaptive composition:

`TOP HEADER = FIXED LOGO + FLEXIBLE FLIGHT DATA + FIXED OPERATOR (+ TABLET-ONLY BAT)`

This structure is an intermediate working baseline and remains subject to visual/ergonomic validation before final approval.

## Visual control

The controlled color system is documented in `BLUESKY_PRO_COLORS.md`.

The controlled typography baseline is documented in `BLUESKY_PRO_TYPOGRAPHY.md`.

The logo rules and asset status are documented in `BLUESKY_PRO_LOGO.md` and `08_HMI/ASSETS/logo/README.md`.

## Important constraint

Do not introduce a new visual identity while optimizing ergonomics. The task is to improve the working view while preserving the approved BlueSky PRO identity and supplied assets.
