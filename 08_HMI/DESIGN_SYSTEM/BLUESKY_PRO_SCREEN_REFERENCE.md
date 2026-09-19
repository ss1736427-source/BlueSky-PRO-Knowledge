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


## Left Panel — Mission Templates — controlled intermediate structure

The supplied sketch `Панель шаблонов левая(1).JPG` is the visual reference for the Mission Templates panel.

### Visual composition

- Preserve the visual style of the supplied Mission Templates sketch.
- Remove the individual icons displayed beside each mission/template item.
- Keep the mission/template name as the primary label and its secondary description text.
- Keep the compact vertical list structure.
- The `+` and list/menu controls in the panel header remain part of the current sketch reference.

### Panel control

- The Left Panel is opened by pressing the `ADMIN`/left-panel tool button assigned on the Bottom Toolbar according to the current toolbar configuration.
- Pressing the same button again closes/collapses the Left Panel.
- The Bottom Toolbar button is a direct state indicator:
  - **panel open/expanded** → button highlighted;
  - **panel closed/collapsed** → button not highlighted.
- If the panel is closed through its external close/working-area interaction, the Bottom Toolbar button must immediately return to the non-highlighted state.
- The panel does not acquire a separate independent visual state from the Bottom Toolbar control.

This is an intermediate controlled structure and remains subject to subsequent ergonomic and visual refinement.


### Mission Template interaction and adaptive panel growth

- Clicking a mission/template button places the corresponding mission template/tooling onto the Flight Chart for further work.
- By default, the system may place a **system-defined set of complementary mission templates** onto the Flight Chart based on the mission being created. This default set is determined by the system for the requested mission; the operator then continues working with the displayed templates.
- Template buttons whose templates are currently used/active on the Flight Chart are **highlighted** in the Mission Templates panel.
- The panel's tool-management control adds a selected tool to the panel using the **same unified visual style as the other panel tools**.
- The Mission Templates panel is **minimal and compact**. It sizes itself to the actual content and dimensions of the items inside it rather than occupying unused space.
- The panel grows **vertically from top to bottom** as additional content is added.
- A newly added tool/template is appended **at the bottom** of the panel; existing items do not shift into a different ordering unless the user explicitly reorders them.
- The adaptive sizing applies to the panel container; it does not change the established compact visual style of the individual tools.


### Mission Templates — default filtered list

- The Mission Templates list is **filtered by default** to show only the templates currently used in the active task.
- All other available templates are **hidden from the default panel view**.
- Hidden templates remain available through the panel's existing list/menu control and are not deleted or disabled.
- When a hidden template is selected and becomes part of the task, it is added to the visible list and its button receives the active/highlighted state.
- The default view therefore shows the operator only the templates relevant to the current task, keeping the panel minimal and compact.

### Left Panel — mission context, hide/restore and Mission ID

The Left Panel also acts as a compact working-context control for missions.

#### Quick Hide

- The panel provides a quick HIDE action.
- HIDE first saves the current mission state automatically and only then hides the mission.
- The current mission is removed from the Flight Chart/map and the active panel list is cleared.
- No mission data is deleted by HIDE.
- This allows the operator to leave a prepared mission intact, work on another task in a clean map/panel workspace, and later restore the prepared mission.
- The hidden mission is restored through the + control.
- Restoring a hidden mission returns the same mission to the map and panel with its saved state and the same Mission ID.

#### Hidden missions and +

- The + control provides access to saved hidden missions.
- Selecting a hidden mission restores it as the active working mission.
- + is therefore a mission-context restore mechanism, not a mechanism for creating duplicate Mission IDs.

#### Draft deletion

- Delete is a separate operation for deleting an unwanted draft mission after work with it.
- HIDE must never imply deletion.
- A saved/hidden mission remains available until explicitly deleted.

#### Mission ID

Each mission receives a unique, human-readable Mission ID immediately after creation.

Controlled format:

BS-YYMMDD-T-NNN

where:
- BS — BlueSky;
- YYMMDD — mission creation date;
- T — creation marker:
  - M = Manual;
  - A = Automatic;
- NNN — sequential mission number for that date.

Examples:
- BS-260919-M-001
- BS-260919-A-002

Mission ID is immutable during save, hide, restore and editing. Hiding and restoring the mission never creates a new Mission ID.

The creation marker records the original creation method. Manual corrections to an automatically generated mission do not change A to M; subsequent changes are tracked separately in mission history/audit data.

The visible Mission ID is the human-readable identifier. The implementation may maintain a separate internal immutable UID for system-level uniqueness and synchronization; this internal UID is not part of the operator-facing ID.

#### Left Panel closure

The Left Panel closes by:
- the Left-panel Bottom Toolbar button;
- double-click in the map area;
- automatic closure at mission start.

A single click in the map area does not close the panel. The Bottom Toolbar Left button must always reflect the actual panel state.



## Right Panel — operational control, checklist, warnings and validation — preliminary controlled state

The Right Panel is an **operational panel**, not a duplicate telemetry dashboard. Detailed current telemetry belongs to the UAV Panel; spatial operational information belongs to the Map; non-immediate technical information, history, archives and journals belong to Administration / Technical State / Logs.

### Default Right Panel state — Checklist

The default content of the Right Panel during flight preparation is the **CHECKLIST**.

The header displays the completion counter:

`CHECKLIST 5/8 ✓`

Rules:
- completed checklist stages are shown **green**;
- incomplete/pending stages are shown **amber/yellow**;
- red is reserved for a critical/error condition, not for an ordinary incomplete checklist item;
- completed items remain completed in system state even when visually hidden.

### Completed checklist item dismissal

To save screen space:
- on **tablet**, a completed checklist item may be **swiped to the right** to hide it from the current visible list;
- on **PC**, a completed checklist item may be hidden by **double-clicking** it with the mouse;
- hiding a completed item is a presentation action only; it does not change its completed state or remove its audit/history record;
- the completion counter remains based on actual checklist state, not on the number of currently visible rows.

The remaining incomplete items stay visible.

### WARNING — Header and Right Panel parallel behavior

The Header `WARNING` indicator and the Right Panel `WARNINGS / CORRECTIONS` block operate in parallel.

When an operational warning appears:
- `WARNING` in the Header changes to the warning visual state;
- the `WARNINGS / CORRECTIONS` area in the Right Panel is highlighted;
- the warning is automatically expanded;
- the operator sees the current warning and the required/recommended action.

Closing a warning display does not erase the underlying event.

### Warning severity and display channel

Secondary operational warnings are presented through the Right Panel.

Example: a change in wind direction may produce a Right Panel warning without covering the main map.

A serious/critical warning is additionally presented as a large alert over the Map/Flight Chart so that the operator can assess the spatial situation and make the required decision.

For a critical map alert:
- Header `WARNING` is active;
- Right Panel warning state is active;
- the large alert is displayed on the map;
- after reading/studying the alert, **double-clicking the warning area closes the visual alert**;
- closing the visual alert does not delete the event from the journal;
- if another active warning remains, the global `WARNING` state remains active.

### Weather forecast change warning

When a material forecast/weather update affects the mission, the Right Panel warning presents the **new TAF/METAR** and a concise comparison with the previous data.

The concise comparison should identify, where available:
- temperature: previous → new;
- wind direction: previous → new;
- wind speed: previous → new;
- gusts: previous → new;
- visibility: previous → new;
- cloud-base / cloud-height limits: previous → new.

The operator should immediately see **what changed and by how much**. Full TAF/METAR text and detailed comparison remain available through the warning details view.

### Automatic validation after a relevant change

Mission validation is not a permanently visible primary button.

When a relevant mission input changes, the system automatically performs a new validation. Relevant changes include, as applicable:
- route / waypoint changes;
- selected UAV or UAV configuration changes;
- battery/resource changes;
- equipment changes;
- weather/forecast changes;
- restrictions/NOTAM changes;
- other inputs that can affect mission readiness.

After the automatic validation completes successfully, the Right Panel shows a **VALIDATE MISSION** confirmation control only when operator confirmation is required.

The button uses a **dynamic breathing green outline** to attract attention.

The meaning is:

> Automatic validation has completed successfully. The result is OK. Operator confirmation is required.

After the operator confirms the result:
- the breathing outline stops;
- the validation confirmation control disappears;
- the current readiness state remains available.

If automatic validation detects a problem, the interface presents the corresponding warning/error state instead of implying successful validation.

If there is **no relevant change**, there is **no validation button on the Right Panel**.

Validation is therefore an explicit confirmation of a newly checked state, not a substitute for automatic checking.

### Mission Readiness and Start Mission

`START MISSION` is not green by default.

It becomes **green and active only when the mission has full current readiness** and all required checklist/validation conditions are satisfied.

If a relevant change invalidates current readiness, `START MISSION` returns to the non-ready/disabled state until the new state is successfully checked and confirmed where required.

### Selected UAV set

The operator may select one or more UAVs for an operational command.

#### Tablet
- long press on a specific UAV card/area selects that UAV;
- another long press on another UAV adds it to the selected set;
- long press on an already selected UAV removes it from the selected set.

#### PC
- mouse click on a UAV card/area selects or adds the UAV to the selected set;
- clicking an already selected UAV removes it from the selected set.

The selected set may therefore contain one or several UAVs.

### RETURN

The normal Right Panel action is **RETURN**, not RTH.

`RETURN` is addressed to the **currently selected UAV set**:
- one selected UAV → command applies to that UAV;
- two or more selected UAVs → command applies to all selected UAVs.

The user-facing command is therefore explicitly associated with the selected UAV set rather than with the entire fleet.

The underlying return procedure remains a Core/Safety-controlled flight procedure; the UI command does not hard-code the maneuver implementation.

### ABORT

`ABORT` is **removed from the normal Right Panel**.

It is not presented as a routine operational button beside RETURN.

ABORT is exposed only in the appropriate emergency/critical alert context, according to the applicable emergency procedure.

### Operational action hierarchy

The normal Right Panel therefore prioritizes:

1. CHECKLIST;
2. active WARNINGS / CORRECTIONS;
3. Mission Readiness;
4. contextual validation confirmation after relevant automatic re-check;
5. `SEND FLIGHT PLAN`;
6. `START MISSION` — green only at full readiness;
7. `RETURN` — for the selected UAV set.

`ABORT` is not part of this normal list and appears only in the relevant emergency context.

This is a **preliminary controlled state** for further HMI/ergonomic validation; it does not yet constitute the final visual baseline.
