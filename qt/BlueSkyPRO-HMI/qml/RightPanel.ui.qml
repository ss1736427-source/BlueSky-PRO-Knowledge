import QtQuick

Item {
    id: root
    implicitWidth: 340
    property color bg: "#0A0A0A"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color muted: "#7F7F7F"
    property color green: "#64FF00"
    property color amber: "#FFD339"
    property color red: "#FF1E14"
    property color cyan: "#32FFFF"
    property color divider: "#202020"

    Rectangle { anchors.fill: parent; color: root.bg }
    Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: root.divider }

    Text { x: 16; y: 14; text: "CHECKLIST 5/8"; color: root.text; font.family: "B612"; font.pixelSize: 16; font.bold: true }
    Text { x: 16; y: 43; text: "✓ Mission definition"; color: root.green; font.family: "B612"; font.pixelSize: 12 }
    Text { x: 16; y: 64; text: "✓ UAV allocation"; color: root.green; font.family: "B612"; font.pixelSize: 12 }
    Text { x: 16; y: 85; text: "✓ C2 availability"; color: root.green; font.family: "B612"; font.pixelSize: 12 }
    Text { x: 16; y: 106; text: "⚠ Weather revalidation"; color: root.amber; font.family: "B612"; font.pixelSize: 12 }

    Rectangle { x: 16; y: 130; width: parent.width - 32; height: 1; color: root.divider }
    Text { x: 16; y: 147; text: "WARNINGS / CORRECTIONS"; color: root.secondary; font.family: "B612"; font.pixelSize: 12; font.bold: true }
    Text { x: 16; y: 174; text: "Wind correction pending confirmation"; color: root.amber; font.family: "B612"; font.pixelSize: 11 }
    Text { x: 16; y: 195; text: "Battery degradation model applied"; color: root.secondary; font.family: "B612"; font.pixelSize: 10 }

    Rectangle { x: 16; y: 218; width: parent.width - 32; height: 1; color: root.divider }
    Text { x: 16; y: 235; text: "MISSION READINESS"; color: root.secondary; font.family: "B612"; font.pixelSize: 12; font.bold: true }
    Text { x: 16; y: 260; text: "READY CHECK"; color: root.amber; font.family: "B612 Mono"; font.pixelSize: 13; font.bold: true }
    Rectangle { x: 16; y: 286; width: parent.width - 32; height: 38; color: "transparent"; border.color: root.green; border.width: 1 }
    Text { x: 16; y: 286; width: parent.width - 32; height: 38; text: "VALIDATE MISSION"; color: root.green; font.family: "B612"; font.pixelSize: 12; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }

    Rectangle { x: 16; y: 334; width: parent.width - 32; height: 38; color: "transparent"; border.color: root.divider; border.width: 1 }
    Text { x: 16; y: 334; width: parent.width - 32; height: 38; text: "SEND FLIGHT PLAN"; color: root.secondary; font.family: "B612"; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }

    Rectangle { x: 16; y: 382; width: parent.width - 32; height: 38; color: "transparent"; border.color: root.divider; border.width: 1 }
    Text { x: 16; y: 382; width: parent.width - 32; height: 38; text: "START MISSION"; color: root.muted; font.family: "B612"; font.pixelSize: 12; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }

    Text { x: 16; y: 437; text: "START remains inactive until full readiness."; color: root.muted; font.family: "B612"; font.pixelSize: 9 }

    Rectangle { x: 16; y: 462; width: parent.width - 32; height: 1; color: root.divider }
    Text { x: 16; y: 480; text: "SAFETY GATE"; color: root.secondary; font.family: "B612"; font.pixelSize: 12; font.bold: true }
    Text { x: 16; y: 505; text: "Core / Safety authority active"; color: root.text; font.family: "B612"; font.pixelSize: 11 }
    Text { x: 16; y: 525; text: "AI recommendations: advisory only"; color: root.secondary; font.family: "B612"; font.pixelSize: 10 }
}