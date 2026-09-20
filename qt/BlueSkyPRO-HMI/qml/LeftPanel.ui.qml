import QtQuick

Item {
    id: root
    implicitWidth: 300
    property color bg: "#0A0A0A"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color muted: "#7F7F7F"
    property color cyan: "#32FFFF"
    property color divider: "#202020"

    Rectangle { anchors.fill: parent; color: root.bg }
    Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 1; color: root.divider }

    Row {
        x: 16; y: 14; spacing: 12
        Text { text: "MISSION CONTEXT"; color: root.secondary; font.family: "B612"; font.pixelSize: 13; font.bold: true }
        Text { text: "+"; color: root.cyan; font.family: "B612 Mono"; font.pixelSize: 18; font.bold: true }
        Text { text: "≡"; color: root.secondary; font.family: "B612 Mono"; font.pixelSize: 16 }
    }

    Text { x: 16; y: 48; text: "BS-260920-A-001"; color: root.text; font.family: "B612 Mono"; font.pixelSize: 16; font.bold: true }
    Text { x: 16; y: 70; text: "Area Survey"; color: root.text; font.family: "B612"; font.pixelSize: 13 }
    Text { x: 16; y: 90; text: "4 UAV · BVLOS · wind-aware"; color: root.secondary; font.family: "B612"; font.pixelSize: 11 }

    Text { x: 16; y: 126; text: "MISSION TEMPLATES"; color: root.secondary; font.family: "B612"; font.pixelSize: 12; font.bold: true }
    Column {
        x: 16; y: 151; width: parent.width - 32; spacing: 6
        Repeater {
            model: ["Area Survey", "Building 3D", "Landscape Photo"]
            delegate: Rectangle {
                width: parent.width; height: 34
                color: index === 0 ? "#151515" : "transparent"
                border.color: index === 0 ? root.cyan : root.divider
                border.width: 1
                Text { anchors.fill: parent; anchors.leftMargin: 12; verticalAlignment: Text.AlignVCenter; text: modelData; color: index === 0 ? root.text : root.secondary; font.family: "B612"; font.pixelSize: 12 }
            }
        }
    }

    Text { x: 16; y: 282; text: "HIDE"; color: root.cyan; font.family: "B612 Mono"; font.pixelSize: 11; font.bold: true }
    Text { x: 16; y: 312; text: "MISSION ID"; color: root.secondary; font.family: "B612"; font.pixelSize: 11; font.bold: true }
    Text { x: 16; y: 334; text: "immutable: BS-260920-A-001"; color: root.text; font.family: "B612 Mono"; font.pixelSize: 11 }

    Text { x: 16; y: 374; text: "PANEL TOOLS"; color: root.secondary; font.family: "B612"; font.pixelSize: 11; font.bold: true }
    Text { x: 16; y: 398; text: "Route · Altitude · Speed · Offset"; color: root.secondary; font.family: "B612"; font.pixelSize: 10 }
    Text { x: 16; y: 418; text: "Weather · Obstacles · Airspace"; color: root.secondary; font.family: "B612"; font.pixelSize: 10 }
}