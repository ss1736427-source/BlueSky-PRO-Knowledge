import QtQuick

Item {
    id: root
    property color bg: "#07131A"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color muted: "#7F7F7F"
    property color green: "#64FF00"
    property color amber: "#FFD339"
    property color cyan: "#32FFFF"
    property color magenta: "#FF32FF"
    property color divider: "#202020"

    Rectangle { anchors.fill: parent; color: root.bg }

    Text { x: 18; y: 14; text: "FLIGHT CHART"; color: root.secondary; font.family: "B612"; font.pixelSize: 16; font.bold: true }
    Text { x: 18; y: 37; text: "AREA SURVEY · ACTIVE ROUTE · NORTH UP"; color: root.muted; font.family: "B612 Mono"; font.pixelSize: 10 }

    // Spatial reference grid — visual placeholder for the map provider adapter.
    Repeater {
        model: 6
        delegate: Rectangle { x: 0; y: 76 + index * 105; width: parent.width; height: 1; color: "#10232C" }
    }
    Repeater {
        model: 7
        delegate: Rectangle { x: 90 + index * 170; y: 76; width: 1; height: parent.height - 150; color: "#10232C" }
    }

    Rectangle { x: 90; y: 120; width: 190; height: 110; color: "#24180A"; border.color: root.amber; border.width: 1 }
    Text { x: 108; y: 168; text: "RESTRICTED AREA"; color: root.amber; font.family: "B612"; font.pixelSize: 11; font.bold: true }

    Rectangle { x: 340; y: 230; width: 145; height: 78; color: "#190B19"; border.color: root.magenta; border.width: 1 }
    Text { x: 360; y: 264; text: "BYPASS"; color: root.magenta; font.family: "B612"; font.pixelSize: 10; font.bold: true }

    Rectangle { x: 430; y: 150; width: 520; height: 310; color: "transparent"; border.color: root.cyan; border.width: 2 }
    Text { x: 448; y: 162; text: "OPTIMAL ROUTE"; color: root.cyan; font.family: "B612"; font.pixelSize: 11; font.bold: true }

    Rectangle { x: 455; y: 215; width: 165; height: 2; color: root.green }
    Rectangle { x: 620; y: 215; width: 175; height: 2; color: root.cyan }
    Text { x: 455; y: 226; text: "COMPLETED"; color: root.green; font.family: "B612 Mono"; font.pixelSize: 9 }

    Repeater {
        model: 8
        delegate: Rectangle {
            x: index < 4 ? 450 + index * 115 : 450 + (index - 4) * 115
            y: index < 4 ? 208 : 452
            width: 10; height: 10; radius: 5
            color: index === 3 || index === 7 ? root.amber : root.cyan
        }
    }
    Text { x: 450; y: 485; text: "MANDATORY WP-01   WP-02   WP-03"; color: root.secondary; font.family: "B612 Mono"; font.pixelSize: 10 }

    Rectangle { x: 18; y: parent.height - 154; width: 300; height: 64; color: "#0A0A0A"; border.color: root.divider; border.width: 1 }
    Text { x: 30; y: parent.height - 142; text: "WEATHER / WIND"; color: root.secondary; font.family: "B612"; font.pixelSize: 11; font.bold: true }
    Text { x: 30; y: parent.height - 117; text: "→ 7 m/s · 240°"; color: root.text; font.family: "B612 Mono"; font.pixelSize: 13 }
    Text { x: 150; y: parent.height - 117; text: "Forecast / Actual"; color: root.amber; font.family: "B612"; font.pixelSize: 10 }

    Rectangle { x: parent.width - 330; y: parent.height - 154; width: 312; height: 64; color: "#0A0A0A"; border.color: root.divider; border.width: 1 }
    Text { x: parent.width - 318; y: parent.height - 142; text: "FLIGHT PROFILE / 3D"; color: root.secondary; font.family: "B612"; font.pixelSize: 11; font.bold: true }
    Text { x: parent.width - 318; y: parent.height - 117; text: "HGT 80 m"; color: root.cyan; font.family: "B612 Mono"; font.pixelSize: 16; font.bold: true }
    Text { x: parent.width - 220; y: parent.height - 116; text: "GS 18 m/s"; color: root.text; font.family: "B612 Mono"; font.pixelSize: 11 }

    Text { x: parent.width - 270; y: 86; text: "N"; color: root.text; font.family: "B612"; font.pixelSize: 16; font.bold: true }
    Text { x: parent.width / 2 - 130; y: parent.height - 76; text: "SELECT   ROUTE   ALT   SPEED   OFFSET   3D"; color: root.secondary; font.family: "B612 Mono"; font.pixelSize: 9 }
}