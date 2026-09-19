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


## Bottom Toolbar — controlled structure

The Bottom Toolbar is a compact persistent control layer at the bottom of the Flight Chart. The map remains the primary workspace.

### Complete layout

`◀ LEFT → [ CENTRAL TOOL BUTTONS ] → RIGHT ▶ → HH:MM → ☰`

The central area contains the tools selected for display. The four elements `◀ LEFT`, `RIGHT ▶`, `HH:MM` and `☰` are static controls and are not part of the configurable tool list.

### Left panel control

- `◀ LEFT` is a static, compact control fixed at the left side of the Bottom Toolbar.
- Pressing it opens the left panel and highlights the button.
- Pressing it again closes the left panel and removes the highlight.
- The button state always corresponds to the actual panel state.

### Right-side fixed group

The fixed right-side sequence is:

`RIGHT ▶ → HH:MM → ☰`

- `RIGHT ▶` is a static, compact control for the right panel.
- `HH:MM` is a static digital clock in 24-hour display format.
- `☰` is a static menu icon replacing the previous `TOOLS` text label.
- Their order and positions are fixed.
- `RIGHT ▶`, `HH:MM` and `☰` are never redistributed with the central tools.
- Pressing `RIGHT ▶` opens the right panel and highlights the button; pressing it again closes the panel and removes the highlight.

### Map interaction and panel closure

- A **single click** in the map area activates/makes map controls available; it does not close an open side panel.
- A **double-click** in the map area closes an open side panel.
- After closure, the corresponding `LEFT` or `RIGHT ▶` button returns to its non-highlighted state.
- A click inside a side panel does not close that panel.
- Double-click closure is a permanent interaction rule and applies regardless of the Auto-hide setting.

### Auto-hide

- Panel Auto-hide is a configurable interface option.
- Auto-hide is separate from the permanent double-click closure gesture.
- The Auto-hide option must not alter the direct state indication of `LEFT` / `RIGHT ▶`.
- The exact additional automatic-hide trigger is not defined by the current Bottom Toolbar decision and must not be invented at this stage.

### Central tool area

- The middle section displays the Flight Chart tools selected through the `☰` menu.
- Displayed tools are distributed **evenly across the available central width**.
- The central area adapts to available width.
- The fixed controls do not move when the number of central tools changes.
- Tools are displayed as **buttons**, not as free-standing text labels.
- All displayed tool buttons use one common visual style.

### Default central tools

The default Bottom Toolbar configuration displays:

- `ADMIN`
- `UAV PANEL`
- `MAP`

These default tools are evenly distributed in the central area. The user may change the displayed tool set through `☰`.

Previously defined Flight Chart tools such as `SELECT`, `POINT`, `LINE`, `ZONE`, `RTH`, `MEASURE`, `PROFILE` and `WEATHER` remain available as tool candidates; they are not the default central selection unless explicitly configured.

### Unified tool-button style

- The visual style is configured **once for the entire group of displayed central tool buttons**.
- Individual tools cannot have separate visual styles.
- Shared settings apply simultaneously to every displayed tool button.
- The shared style covers common geometry/size, height, typography, text size, spacing/padding, border treatment and interaction states.
- A newly added tool automatically inherits the current shared style.
- The central tool buttons therefore remain visually consistent regardless of their number or function.

### Configuration boundaries

The `☰` menu configures the central tool set and its common group style. It does not configure:

- `◀ LEFT`
- `RIGHT ▶`
- `HH:MM`
- `☰`

Those four elements remain static.



## UAV Panel — controlled default composition

The supplied visual reference `минимальная панель БПЛА(2).png` defines the **default UAV Panel data composition and layout**.

### Default composition

The expanded UAV Panel uses a wide horizontal composition with:

- a left UAV identity block containing the UAV image/visual, UAV identifier and readiness/state indicator;
- a vertical divider separating UAV identity from operational data;
- a main operational-data block arranged vertically;
- a settings control at the upper-right of the panel;
- a mission status/progress row across the bottom of the panel.

### Default operational data

The default visual composition displays these data groups in this order:

1. Height
2. Speed
3. Battery
4. Engines

The values are displayed in a large primary-value treatment aligned consistently to the right of their corresponding labels/icons.

### Engines indication

The Engines row uses a horizontal 0–100% scale with threshold-colored operating zones, a current-position marker and the current percentage value at the right.

### Mission row

The lower row contains:

- `МИССИЯ` label;
- horizontal mission progress bar;
- current mission state at the right.

### Composition rule

This visual arrangement is the **default UAV Panel composition**. It is not a generic vertical side-card layout.

For multiple UAVs, the same complete vertical composition is used as the data group for each UAV. UAV groups are arranged horizontally from left to right and separated by vertical dividers.

The supplied image is the visual reference for the composition; it must not be silently replaced by a different panel arrangement during further HMI work.


### UAV Panel — latest composition corrections

The default UAV Panel composition is refined as follows:

- Remove the enclosing frame/border around the UAV visual/identity block. The UAV image, identifier and state remain grouped but are not enclosed in a separate rectangular card.
- Remove the text state `ВЫПОЛНЯЕТСЯ` from the `МИССИЯ` row. The mission row retains the `МИССИЯ` label and mission progress indication without that status text.
- Replace the `Двигатели` row with an `ОБОРОТЫ` row.
- `ОБОРОТЫ` is represented as a percentage value; the displayed value is expressed in `%`.
- Replace the battery presentation with a **horizontal segmented indicator**: a row of discrete rectangular sectors followed by the numeric percentage value.
- The supplied reference image `Индикатор батареи 2.JPG` is the visual reference for the segmented battery indicator: horizontal discrete sectors with the percentage value to the right.
- The battery indicator is part of the normal compact UAV data presentation and is not a separate framed card.


### UAV Panel — parameter indication and separators

The UAV operational parameters must use the controlled BlueSky PRO navigation terminology and indication rules:

- `GS` — Ground Speed.
- `AS` — Air Speed.
- `HGT` — true height above ground.
- `ALT` — barometric altitude.
- `CLIMB` — climb.
- `DESCENT` — descent.
- Do not use `ALTITUDE`, `CLIMB RATE` or `DESCENT RATE` as displayed parameter names.
- Do not add `+` or `−` signs to the primary `CLIMB`, `DESCENT`, `HGT` or `ALT` indications.

For the UAV Panel, the primary compact navigation values use the same controlled abbreviations. Horizontal speed may be displayed in the user-facing `m/s` or `km/h` form according to the established display rule; Core units remain `m/s`.

The UAV Panel must **not use horizontal divider lines between individual operational parameters**. Height, speed, battery and RPM are presented as one visually coherent data group, separated by spacing/alignment rather than horizontal rules. The vertical separation between the UAV identity block and operational-data block remains.


### UAV Panel — mission progress line

The **thin horizontal mission-progress line at the bottom of the UAV Panel remains**.

- It belongs to the `МИССИЯ` row at the bottom of the panel.
- It is the only horizontal progress separator/indicator intentionally retained in the current UAV Panel composition.
- Removing the horizontal divider lines between individual operational parameters does **not** remove the mission progress line.


### UAV Panel — intermediate mission progress line styling

The current UAV Panel mission progress line is accepted as an **intermediate visual variant**.

- The mission progress line remains at the bottom of the panel.
- Its current thickness is reduced to approximately **50% of the previous thickness**.
- The line thickness is a configurable visual property.
- The line color is a configurable visual property.
- The current thin green presentation is only the intermediate visual selection and is not the final locked color/thickness baseline.
