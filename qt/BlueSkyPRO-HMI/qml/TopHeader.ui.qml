import QtQuick

Item {
    id: root
    implicitHeight: 62
    property color bg: "#000000"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color muted: "#7F7F7F"
    property color green: "#64FF00"
    property color amber: "#FFD339"
    property color red: "#FF1E14"
    property color cyan: "#32FFFF"

    Rectangle { anchors.fill: parent; color: root.bg }
    Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 1; color: "#202020" }

    Text { x: 18; anchors.verticalCenter: parent.verticalCenter; text: "BlueSky PRO"; color: root.text; font.family: "B612"; font.pixelSize: 22; font.bold: true }
    Row {
        anchors.left: parent.left; anchors.leftMargin: 190
        anchors.verticalCenter: parent.verticalCenter
        spacing: 22
        Text { text: "MISSION  PREPARATION"; color: root.cyan; font.family: "B612"; font.pixelSize: 12; font.bold: true }
        Text { text: "ETD 10:30"; color: root.secondary; font.family: "B612 Mono"; font.pixelSize: 13 }
        Text { text: "TOT —"; color: root.secondary; font.family: "B612 Mono"; font.pixelSize: 13 }
        Text { text: "TRIP 01:18"; color: root.secondary; font.family: "B612 Mono"; font.pixelSize: 13 }
        Text { text: "ETA 11:48"; color: root.secondary; font.family: "B612 Mono"; font.pixelSize: 13 }
    }
    Row {
        anchors.right: parent.right; anchors.rightMargin: 18
        anchors.verticalCenter: parent.verticalCenter
        spacing: 18
        Text { text: "C2  CONNECTED"; color: root.green; font.family: "B612 Mono"; font.pixelSize: 11; font.bold: true }
        Text { text: "GNSS  OK"; color: root.green; font.family: "B612 Mono"; font.pixelSize: 11 }
        Text { text: "WARNING"; color: root.amber; font.family: "B612 Mono"; font.pixelSize: 11; font.bold: true }
        Text { text: "PILOT"; color: root.cyan; font.family: "B612"; font.pixelSize: 11 }
    }
}