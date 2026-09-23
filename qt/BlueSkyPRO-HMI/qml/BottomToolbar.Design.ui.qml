import QtQuick

Item {
    id: root

    width: 1440
    height: 96

    property color backgroundColor: "#050A12"
    property color panelColor: "#08111D"
    property color buttonColor: "#0C1725"
    property color activeSurfaceColor: "#111F30"
    property color primaryColor: "#FFFFFF"
    property color serviceColor: "#7F7F7F"
    property color activeColor: "#32FFFF"

    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor
    }

    Rectangle {
        x: 12
        y: 12
        width: 1416
        height: 72
        color: root.panelColor
    }

    Rectangle {
        x: 258
        y: 24
        width: 110
        height: 48
        color: root.activeSurfaceColor
    }

    Rectangle {
        x: 900
        y: 24
        width: 1
        height: 48
        color: root.serviceColor
    }

    Text {
        x: 24
        y: 24
        width: 108
        height: 48
        text: "◀ LEFT"
        color: root.primaryColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: "B612 Mono"
        font.pixelSize: 16
        font.weight: Font.Bold
    }

    Text {
        x: 140
        y: 24
        width: 110
        height: 48
        text: "UAV"
        color: root.primaryColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: "B612 Mono"
        font.pixelSize: 16
        font.weight: Font.Bold
    }

    Text {
        x: 258
        y: 24
        width: 110
        height: 48
        text: "MAP"
        color: root.activeColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: "B612 Mono"
        font.pixelSize: 16
        font.weight: Font.Bold
    }

    Text {
        x: 376
        y: 24
        width: 110
        height: 48
        text: "ADMIN"
        color: root.primaryColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: "B612 Mono"
        font.pixelSize: 16
        font.weight: Font.Bold
    }

    Text {
        x: 494
        y: 24
        width: 110
        height: 48
        text: "FPV"
        color: root.primaryColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: "B612 Mono"
        font.pixelSize: 16
        font.weight: Font.Bold
    }

    Text {
        x: 612
        y: 24
        width: 150
        height: 48
        text: "VIRTUAL FLT"
        color: root.primaryColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: "B612 Mono"
        font.pixelSize: 16
        font.weight: Font.Bold
    }

    Text {
        x: 778
        y: 24
        width: 108
        height: 48
        text: "RIGHT ▶"
        color: root.primaryColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: "B612 Mono"
        font.pixelSize: 16
        font.weight: Font.Bold
    }

    Text {
        x: 916
        y: 24
        width: 150
        height: 48
        text: "HH:MM"
        color: root.primaryColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: "B612 Mono"
        font.pixelSize: 16
        font.weight: Font.Bold
    }

    Text {
        x: 1080
        y: 24
        width: 330
        height: 48
        text: "☰"
        color: root.primaryColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: "B612 Mono"
        font.pixelSize: 16
        font.weight: Font.Bold
    }

    Text {
        x: 24
        y: 80
        text: "DS / BOTTOM TOOLBAR / 001 — FIXED ANCHORS + CONFIGURABLE WORKSPACE CONTEXTS"
        color: root.serviceColor
        font.family: "IBM Plex Sans Condensed"
        font.pixelSize: 9
    }
}
