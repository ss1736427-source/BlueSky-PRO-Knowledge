import QtQuick

Item {
    id: root
    width: 1920
    height: 1080

    // BlueSky PRO — consolidated HMI visual baseline
    // UX: Intent → Task → Constraints → Resources → Mission → Validation → Execution
    // Presentation only. Core / Safety remain authoritative.

    property color bg: "#000000"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color muted: "#707070"
    property color green: "#64FF00"
    property color amber: "#FFD339"
    property color red: "#FF1E14"
    property color cyan: "#32FFFF"
    property color magenta: "#FF32FF"
    property color panel: "#0A0A0A"
    property color panel2: "#101010"
    property color map: "#07131A"
    property color grid: "#10232C"
    property color divider: "#202020"

    property int headerHeight: 62
    property int leftWidth: 300
    property int rightWidth: 340
    property int bottomHeight: 154

    Rectangle {
        anchors.fill: parent
        color: root.bg
    }

    // HEADER / SYSTEM STATUS
    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.headerHeight
        color: root.bg

        Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 1; color: root.divider }

        Text { x: 18; y: 17; text: "BlueSky PRO"; color: root.text; font.pixelSize: 22; font.bold: true }
        Text { x: 185; y: 20; text: "ETD 10:30"; color: root.secondary; font.pixelSize: 13 }
        Text { x: 275; y: 20; text: "TOT 00:42"; color: root.secondary; font.pixelSize: 13 }
        Text { x: 365; y: 20; text: "TRIP 01:18"; color: root.secondary; font.pixelSize: 13 }
        Text { x: 465; y: 20; text: "ETA 11:48"; color: root.secondary; font.pixelSize: 13 }

        Text { x: 570; y: 18; text: "READY  CHECK"; color: root.amber; font.pixelSize: 14; font.bold: true }
        Text { x: 690; y: 20; text: "Revalidation complete · confirm"; color: root.amber; font.pixelSize: 12 }
        Text { x: 925; y: 20; text: "C2  CONNECTED"; color: root.green; font.pixelSize: 12; font.bold: true }
        Text { x: 1060; y: 20; text: "GNSS  OK"; color: root.green; font.pixelSize: 12 }
        Text { x: 1150; y: 20; text: "BAT  96%"; color: root.green; font.pixelSize: 12 }
        Text { x: 1250; y: 20; text: "OPERATOR"; color: root.cyan; font.pixelSize: 12 }
        Text { x: 1340; y: 20; text: "MISSION  BS-260920-A-001"; color: root.secondary; font.pixelSize: 12 }
        Text { x: 1660; y: 20; text: "ADMIN"; color: root.muted; font.pixelSize: 12 }
    }

    // LEFT PANEL — TASK / MISSION
    Rectangle {
        id: leftPanel
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.bottom: bottomStrip.top
        width: root.leftWidth
        color: root.panel

        Rectangle { anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.right: parent.right; width: 1; color: root.divider }

        Text { x: 16; y: 18; text: "MISSION TEMPLATES"; color: root.secondary; font.pixelSize: 13; font.bold: true }

        Rectangle { x: 16; y: 46; width: 268; height: 38; color: "#151515"; border.color: root.cyan; border.width: 1 }
        Text { x: 0; y: 58; width: 300; text: "Area Survey"; color: root.text; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter }

        Rectangle { x: 16; y: 92; width: 268; height: 38; color: root.panel; border.color: root.divider; border.width: 1 }
        Text { x: 0; y: 104; width: 300; text: "Building 3D"; color: root.secondary; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter }

        Rectangle { x: 16; y: 138; width: 268; height: 38; color: root.panel; border.color: root.divider; border.width: 1 }
        Text { x: 0; y: 150; width: 300; text: "Landscape Photo"; color: root.secondary; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter }

        Rectangle { x: 16; y: 190; width: 268; height: 1; color: root.divider }

        Text { x: 16; y: 210; text: "MISSION ANALYSIS"; color: root.secondary; font.pixelSize: 12; font.bold: true }
        Text { x: 16; y: 235; text: "BS-260920-A-001"; color: root.text; font.pixelSize: 14; font.bold: true }
        Text { x: 16; y: 258; text: "Planning · 4 UAV · BVLOS"; color: root.secondary; font.pixelSize: 12 }

        Text { x: 16; y: 292; text: "MISSION PROFILE"; color: root.secondary; font.pixelSize: 12; font.bold: true }
        Text { x: 16; y: 317; text: "Total time     00:42"; color: root.text; font.pixelSize: 12 }
        Text { x: 16; y: 337; text: "ETD              10:30"; color: root.text; font.pixelSize: 12 }
        Text { x: 16; y: 357; text: "ETA              11:48"; color: root.text; font.pixelSize: 12 }
        Text { x: 16; y: 377; text: "TRIP TIME      01:18"; color: root.text; font.pixelSize: 12 }

        Text { x: 16; y: 411; text: "CONSTRAINTS"; color: root.secondary; font.pixelSize: 12; font.bold: true }
        Text { x: 16; y: 436; text: "Height 80 m · BVLOS"; color: root.secondary; font.pixelSize: 12 }
        Text { x: 16; y: 456; text: "Wind-aware routing"; color: root.secondary; font.pixelSize: 12 }
        Text { x: 16; y: 476; text: "4 UAV · 1 s separation"; color: root.secondary; font.pixelSize: 12 }
        Text { x: 16; y: 496; text: "Mandatory points: 3"; color: root.secondary; font.pixelSize: 12 }

        Text { x: 16; y: 530; text: "RESOURCES"; color: root.secondary; font.pixelSize: 12; font.bold: true }
        Text { x: 16; y: 554; text: "UAV fleet      4 / 4 allocated"; color: root.text; font.pixelSize: 12 }
        Text { x: 16; y: 574; text: "Payload        RGB + LiDAR"; color: root.secondary; font.pixelSize: 12 }
        Text { x: 16; y: 594; text: "C2              Primary + backup"; color: root.secondary; font.pixelSize: 12 }

        Text { x: 16; y: 632; text: "PANEL MODES"; color: root.secondary; font.pixelSize: 12; font.bold: true }
        Text { x: 16; y: 656; text: "PILOT   ·   TECH   ·   ADMIN"; color: root.cyan; font.pixelSize: 11 }
        Text { x: 16; y: 680; text: "FLIGHT   ·   HUB   ·   INTEGRATION"; color: root.secondary; font.pixelSize: 11 }

        Rectangle { x: 16; y: 710; width: 268; height: 1; color: root.divider }
        Text { x: 16; y: 730; text: "TOOLS"; color: root.secondary; font.pixelSize: 12; font.bold: true }
        Text { x: 16; y: 755; text: "Route  ·  Altitude  ·  Speed  ·  Offset"; color: root.secondary; font.pixelSize: 11 }
        Text { x: 16; y: 775; text: "Weather  ·  Obstacles  ·  Airspace"; color: root.secondary; font.pixelSize: 11 }
    }

    // CENTER — FLIGHT CHART
    Rectangle {
        id: map
        anchors.top: header.bottom
        anchors.left: leftPanel.right
        anchors.right: rightPanel.left
        anchors.bottom: bottomStrip.top
        color: root.map
        clip: true

        Text { x: 18; y: 16; text: "FLIGHT CHART"; color: root.secondary; font.pixelSize: 16; font.bold: true }
        Text { x: 18; y: 39; text: "AREA SURVEY · ACTIVE ROUTE 01 · NORTH UP"; color: root.muted; font.pixelSize: 10 }

        // Grid
        Rectangle { x: 0; y: 70; width: map.width; height: 1; color: root.grid }
        Rectangle { x: 0; y: 190; width: map.width; height: 1; color: root.grid }
        Rectangle { x: 0; y: 310; width: map.width; height: 1; color: root.grid }
        Rectangle { x: 0; y: 430; width: map.width; height: 1; color: root.grid }
        Rectangle { x: 0; y: 550; width: map.width; height: 1; color: root.grid }
        Rectangle { x: 0; y: 670; width: map.width; height: 1; color: root.grid }

        Rectangle { x: 120; y: 70; width: 1; height: 600; color: root.grid }
        Rectangle { x: 300; y: 70; width: 1; height: 600; color: root.grid }
        Rectangle { x: 480; y: 70; width: 1; height: 600; color: root.grid }
        Rectangle { x: 660; y: 70; width: 1; height: 600; color: root.grid }
        Rectangle { x: 840; y: 70; width: 1; height: 600; color: root.grid }
        Rectangle { x: 1020; y: 70; width: 1; height: 600; color: root.grid }

        // Restricted area
        Rectangle { x: 115; y: 115; width: 200; height: 125; color: "#24180A"; border.color: root.amber; border.width: 1 }
        Text { x: 140; y: 172; text: "RESTRICTED AREA"; color: root.amber; font.pixelSize: 11; font.bold: true }

        // Alternate route / obstacle bypass
        Rectangle { x: 365; y: 210; width: 150; height: 85; color: "#190B19"; border.color: root.magenta; border.width: 1 }
        Text { x: 385; y: 248; text: "BYPASS"; color: root.magenta; font.pixelSize: 10; font.bold: true }

        // Active route
        Rectangle { x: 440; y: 155; width: 470; height: 310; color: "transparent"; border.color: root.cyan; border.width: 2 }
        Text { x: 455; y: 166; text: "OPTIMAL ROUTE"; color: root.cyan; font.pixelSize: 11; font.bold: true }

        // Completed route portion
        Rectangle { x: 465; y: 215; width: 160; height: 2; color: root.green }
        Rectangle { x: 625; y: 215; width: 160; height: 2; color: root.cyan }
        Text { x: 465; y: 224; text: "COMPLETED"; color: root.green; font.pixelSize: 9 }

        // Route points
        Rectangle { x: 458; y: 208; width: 10; height: 10; radius: 5; color: root.cyan }
        Rectangle { x: 620; y: 208; width: 10; height: 10; radius: 5; color: root.cyan }
        Rectangle { x: 780; y: 208; width: 10; height: 10; radius: 5; color: root.cyan }
        Rectangle { x: 900; y: 208; width: 10; height: 10; radius: 5; color: root.amber }

        Rectangle { x: 458; y: 455; width: 10; height: 10; radius: 5; color: root.cyan }
        Rectangle { x: 620; y: 455; width: 10; height: 10; radius: 5; color: root.cyan }
        Rectangle { x: 780; y: 455; width: 10; height: 10; radius: 5; color: root.cyan }
        Rectangle { x: 900; y: 455; width: 10; height: 10; radius: 5; color: root.amber }

        Text { x: 455; y: 485; text: "MANDATORY WP-01   WP-02   WP-03"; color: root.secondary; font.pixelSize: 10 }

        // Weather / wind
        Rectangle { x: 18; y: 520; width: 300; height: 70; color: "#0A0A0A"; border.color: root.divider; border.width: 1 }
        Text { x: 30; y: 533; text: "WEATHER / WIND"; color: root.secondary; font.pixelSize: 11; font.bold: true }
        Text { x: 30; y: 558; text: "→ 7 m/s · 240°"; color: root.text; font.pixelSize: 13 }
        Text { x: 150; y: 558; text: "Forecast / Actual"; color: root.amber; font.pixelSize: 11 }
        Text { x: 30; y: 578; text: "Revalidation required"; color: root.amber; font.pixelSize: 10 }

        // ATC / Communication
        Rectangle { x: 18; y: 604; width: 300; height: 70; color: "#0A0A0A"; border.color: root.divider; border.width: 1 }
        Text { x: 30; y: 617; text: "ATC / COMMUNICATION"; color: root.secondary; font.pixelSize: 11; font.bold: true }
        Text { x: 30; y: 642; text: "C2 PRIMARY  OK"; color: root.green; font.pixelSize: 11 }
        Text { x: 155; y: 642; text: "BACKUP  STANDBY"; color: root.secondary; font.pixelSize: 10 }
        Text { x: 30; y: 660; text: "Flight plan channel ready"; color: root.secondary; font.pixelSize: 10 }

        // Flight profile / 3D
        Rectangle { x: map.width - 330; y: 520; width: 312; height: 154; color: "#0A0A0A"; border.color: root.divider; border.width: 1 }
        Text { x: map.width - 318; y: 533; text: "FLIGHT PROFILE / 3D"; color: root.secondary; font.pixelSize: 11; font.bold: true }
        Text { x: map.width - 318; y: 557; text: "80 m"; color: root.cyan; font.pixelSize: 18; font.bold: true }
        Text { x: map.width - 255; y: 561; text: "18 m/s"; color: root.text; font.pixelSize: 12 }
        Text { x: map.width - 185; y: 561; text: "Reserve 24%"; color: root.green; font.pixelSize: 11 }
        Rectangle { x: map.width - 315; y: 585; width: 280; height: 1; color: root.divider }
        Text { x: map.width - 318; y: 600; text: "ALT 80 → 80 → 70 → 80 m"; color: root.secondary; font.pixelSize: 10 }
        Text { x: map.width - 318; y: 620; text: "Speed 18 → 16 → 18 m/s"; color: root.secondary; font.pixelSize: 10 }
        Text { x: map.width - 318; y: 640; text: "Energy model · degradation 0.94"; color: root.secondary; font.pixelSize: 10 }
        Text { x: map.width - 318; y: 658; text: "Edit profile on map"; color: root.cyan; font.pixelSize: 10 }

        // Map tools
        Rectangle { x: map.width / 2 - 145; y: 690; width: 290; height: 28; color: "#0A0A0A"; border.color: root.divider; border.width: 1 }
        Text { x: map.width / 2 - 132; y: 698; text: "SELECT  ROUTE  ALT  SPEED  OFFSET  3D"; color: root.secondary; font.pixelSize: 9 }

        Text { x: map.width - 95; y: 90; text: "N"; color: root.text; font.pixelSize: 16; font.bold: true }
        Text { x: map.width - 112; y: 110; text: "WEST ← → EAST"; color: root.muted; font.pixelSize: 9 }
    }

    // RIGHT PANEL — VALIDATION / OPERATIONS
    Rectangle {
        id: rightPanel
        anchors.top: header.bottom
        anchors.right: parent.right
        anchors.bottom: bottomStrip.top
        width: root.rightWidth
        color: root.panel

        Rectangle { anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.left: parent.left; width: 1; color: root.divider }

        Text { x: 16; y: 18; text: "CHECKLIST"; color: root.text; font.pixelSize: 16; font.bold: true }
        Text { x: 16; y: 48; text: "✓ Mission definition"; color: root.green; font.pixelSize: 12 }
        Text { x: 16; y: 69; text: "✓ UAV allocation"; color: root.green; font.pixelSize: 12 }
        Text { x: 16; y: 90; text: "✓ C2 availability"; color: root.green; font.pixelSize: 12 }
        Text { x: 16; y: 111; text: "⚠ Weather revalidation"; color: root.amber; font.pixelSize: 12 }

        Rectangle { x: 16; y: 136; width: 308; height: 1; color: root.divider }
        Text { x: 16; y: 153; text: "CORRECTIONS"; color: root.secondary; font.pixelSize: 12; font.bold: true }
        Text { x: 16; y: 178; text: "Wind correction pending confirmation"; color: root.amber; font.pixelSize: 11 }
        Text { x: 16; y: 198; text: "Battery degradation model applied"; color: root.secondary; font.pixelSize: 10 }
        Text { x: 16; y: 216; text: "Route alternative available"; color: root.cyan; font.pixelSize: 10 }

        Rectangle { x: 16; y: 238; width: 308; height: 1; color: root.divider }
        Text { x: 16; y: 255; text: "MISSION READINESS"; color: root.secondary; font.pixelSize: 12; font.bold: true }
        Text { x: 16; y: 279; text: "Validation CONFIRM"; color: root.green; font.pixelSize: 14; font.bold: true }

        Rectangle { x: 16; y: 307; width: 308; height: 38; color: "transparent"; border.color: root.green; border.width: 1 }
        Text { x: 16; y: 319; width: 308; text: "VALIDATE MISSION"; color: root.green; font.pixelSize: 12; font.bold: true; horizontalAlignment: Text.AlignHCenter }

        Rectangle { x: 16; y: 354; width: 308; height: 38; color: "transparent"; border.color: root.divider; border.width: 1 }
        Text { x: 16; y: 366; width: 308; text: "SEND FLIGHT PLAN"; color: root.secondary; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter }

        Rectangle { x: 16; y: 401; width: 308; height: 38; color: "transparent"; border.color: root.divider; border.width: 1 }
        Text { x: 16; y: 413; width: 308; text: "START MISSION"; color: root.muted; font.pixelSize: 12; font.bold: true; horizontalAlignment: Text.AlignHCenter }

        Text { x: 16; y: 452; text: "LOCKED UNTIL VALIDATION + CURRENT CONDITIONS"; color: root.muted; font.pixelSize: 9 }

        Rectangle { x: 16; y: 470; width: 308; height: 1; color: root.divider }
        Text { x: 16; y: 488; text: "SAFETY GATE"; color: root.secondary; font.pixelSize: 12; font.bold: true }
        Text { x: 16; y: 512; text: "Core / Safety authority active"; color: root.text; font.pixelSize: 11 }
        Text { x: 16; y: 532; text: "AI recommendations: advisory only"; color: root.secondary; font.pixelSize: 10 }

        Rectangle { x: 16; y: 552; width: 308; height: 1; color: root.divider }
        Text { x: 16; y: 570; text: "ATC / FLIGHT PLAN"; color: root.secondary; font.pixelSize: 12; font.bold: true }
        Text { x: 16; y: 594; text: "Plan status      READY FOR SUBMISSION"; color: root.green; font.pixelSize: 10 }
        Text { x: 16; y: 613; text: "Each UAV      individual authorization"; color: root.secondary; font.pixelSize: 10 }

        Rectangle { x: 16; y: 637; width: 308; height: 1; color: root.divider }
        Text { x: 16; y: 655; text: "JOURNAL / LOG"; color: root.secondary; font.pixelSize: 12; font.bold: true }
        Text { x: 16; y: 679; text: "Audit trail · corrections · validation"; color: root.secondary; font.pixelSize: 10 }
        Text { x: 16; y: 698; text: "Traceability active"; color: root.cyan; font.pixelSize: 10 }
    }

    // BOTTOM — UAV STATUS + COLLAPSE CONTROLS + NAVIGATION
    Rectangle {
        id: bottomStrip
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: root.bottomHeight
        color: root.bg

        Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; height: 1; color: root.divider }

        // UAV cards
        Rectangle { x: 12; y: 12; width: 255; height: 66; color: root.panel; border.color: root.divider; border.width: 1 }
        Text { x: 25; y: 25; text: "UAV-01  READY"; color: root.green; font.pixelSize: 13; font.bold: true }
        Text { x: 25; y: 49; text: "BAT 96% · C2 OK · 80 m"; color: root.secondary; font.pixelSize: 10 }

        Rectangle { x: 277; y: 12; width: 255; height: 66; color: root.panel; border.color: root.divider; border.width: 1 }
        Text { x: 290; y: 25; text: "UAV-02  READY"; color: root.green; font.pixelSize: 13; font.bold: true }
        Text { x: 290; y: 49; text: "BAT 94% · C2 OK · 80 m"; color: root.secondary; font.pixelSize: 10 }

        Rectangle { x: 542; y: 12; width: 255; height: 66; color: root.panel; border.color: root.amber; border.width: 1 }
        Text { x: 555; y: 25; text: "UAV-03  CHECK"; color: root.amber; font.pixelSize: 13; font.bold: true }
        Text { x: 555; y: 49; text: "BAT 91% · correction pending"; color: root.secondary; font.pixelSize: 10 }

        Rectangle { x: 807; y: 12; width: 255; height: 66; color: root.panel; border.color: root.divider; border.width: 1 }
        Text { x: 820; y: 25; text: "UAV-04  READY"; color: root.green; font.pixelSize: 13; font.bold: true }
        Text { x: 820; y: 49; text: "BAT 95% · C2 OK · 80 m"; color: root.secondary; font.pixelSize: 10 }

        // Compact system instruments
        Rectangle { x: 1072; y: 12; width: 300; height: 66; color: root.panel; border.color: root.divider; border.width: 1 }
        Text { x: 1085; y: 24; text: "SYSTEM"; color: root.secondary; font.pixelSize: 10; font.bold: true }
        Text { x: 1085; y: 45; text: "C2 OK   GNSS OK   LINK OK"; color: root.green; font.pixelSize: 10 }
        Text { x: 1085; y: 62; text: "CPU 42%   TEMP 54°C"; color: root.secondary; font.pixelSize: 9 }

        // Panel collapse / expand controls
        Rectangle { x: 1384; y: 12; width: 74; height: 66; color: root.panel; border.color: root.divider; border.width: 1 }
        Text { x: 0; y: 30; width: 74; text: "◀ LEFT"; color: root.cyan; font.pixelSize: 10; horizontalAlignment: Text.AlignHCenter }

        Rectangle { x: 1464; y: 12; width: 74; height: 66; color: root.panel; border.color: root.divider; border.width: 1 }
        Text { x: 0; y: 30; width: 74; text: "RIGHT ▶"; color: root.cyan; font.pixelSize: 10; horizontalAlignment: Text.AlignHCenter }

        Rectangle { x: 1544; y: 12; width: 74; height: 66; color: root.panel; border.color: root.divider; border.width: 1 }
        Text { x: 0; y: 30; width: 74; text: "TOOLS"; color: root.secondary; font.pixelSize: 10; horizontalAlignment: Text.AlignHCenter }

        Rectangle { x: 1624; y: 12; width: 74; height: 66; color: root.panel; border.color: root.divider; border.width: 1 }
        Text { x: 0; y: 30; width: 74; text: "LAYOUT"; color: root.secondary; font.pixelSize: 10; horizontalAlignment: Text.AlignHCenter }

        Rectangle { x: 1704; y: 12; width: 74; height: 66; color: root.panel; border.color: root.divider; border.width: 1 }
        Text { x: 0; y: 30; width: 74; text: "LOG"; color: root.secondary; font.pixelSize: 10; horizontalAlignment: Text.AlignHCenter }

        // Bottom navigation
        Rectangle { x: 12; y: 91; width: 1760; height: 48; color: root.panel; border.color: root.divider; border.width: 1 }
        Text { x: 28; y: 108; text: "MISSION"; color: root.cyan; font.pixelSize: 11; font.bold: true }
        Text { x: 145; y: 108; text: "FLIGHT"; color: root.text; font.pixelSize: 11; font.bold: true }
        Text { x: 250; y: 108; text: "MAP"; color: root.secondary; font.pixelSize: 11 }
        Text { x: 340; y: 108; text: "TOOLS"; color: root.secondary; font.pixelSize: 11 }
        Text { x: 440; y: 108; text: "INTEGRATION"; color: root.secondary; font.pixelSize: 11 }
        Text { x: 570; y: 108; text: "HUB"; color: root.secondary; font.pixelSize: 11 }
        Text { x: 650; y: 108; text: "PILOT"; color: root.secondary; font.pixelSize: 11 }
        Text { x: 730; y: 108; text: "ADMINISTRATOR"; color: root.muted; font.pixelSize: 11 }
        Text { x: 900; y: 108; text: "TRACKING"; color: root.secondary; font.pixelSize: 11 }
        Text { x: 1010; y: 108; text: "JOURNAL / LOG"; color: root.secondary; font.pixelSize: 11 }
        Text { x: 1200; y: 108; text: "FPV"; color: root.secondary; font.pixelSize: 11 }
        Text { x: 1270; y: 108; text: "TECH"; color: root.secondary; font.pixelSize: 11 }
        Text { x: 1360; y: 108; text: "LEFT ◀"; color: root.cyan; font.pixelSize: 11 }
        Text { x: 1510; y: 108; text: "RIGHT ▶"; color: root.cyan; font.pixelSize: 11 }
        Text { x: 1650; y: 108; text: "READY"; color: root.green; font.pixelSize: 11; font.bold: true }
    }
}
