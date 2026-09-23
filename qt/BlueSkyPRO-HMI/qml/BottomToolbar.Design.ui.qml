import QtQuick

Item {
    id: root

    width: 1440
    height: 96

    property color backgroundColor: "#000000"
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
        radius: 2
        color: root.backgroundColor
        border.color: root.serviceColor
        border.width: 1
    }

    Rectangle {
        x: 24
        y: 24
        width: 108
        height: 48
        color: root.backgroundColor
        border.color: root.serviceColor
        border.width: 1
        Text {
            anchors.centerIn: parent
            text: "◀ LEFT"
            color: root.primaryColor
            font.family: "B612 Mono"
            font.pixelSize: 16
            font.weight: Font.Bold
        }
    }

    Rectangle {
        x: 140
        y: 24
        width: 110
        height: 48
        color: root.backgroundColor
        border.color: root.serviceColor
        border.width: 1
        Text {
            anchors.centerIn: parent
            text: "UAV"
            color: root.primaryColor
            font.family: "B612 Mono"
            font.pixelSize: 16
            font.weight: Font.Bold
        }
    }

    Rectangle {
        x: 258
        y: 24
        width: 110
        height: 48
        color: root.backgroundColor
        border.color: root.activeColor
        border.width: 1
        Text {
            anchors.centerIn: parent
            text: "MAP"
            color: root.activeColor
            font.family: "B612 Mono"
            font.pixelSize: 16
            font.weight: Font.Bold
        }
    }

    Rectangle {
        x: 376
        y: 24
        width: 110
        height: 48
        color: root.backgroundColor
        border.color: root.serviceColor
        border.width: 1
        Text {
            anchors.centerIn: parent
            text: "ADMIN"
            color: root.primaryColor
            font.family: "B612 Mono"
            font.pixelSize: 16
            font.weight: Font.Bold
        }
    }

    Rectangle {
        x: 494
        y: 24
        width: 110
        height: 48
        color: root.backgroundColor
        border.color: root.serviceColor
        border.width: 1
        Text {
            anchors.centerIn: parent
            text: "FPV"
            color: root.primaryColor
            font.family: "B612 Mono"
            font.pixelSize: 16
            font.weight: Font.Bold
        }
    }

    Rectangle {
        x: 612
        y: 24
        width: 150
        height: 48
        color: root.backgroundColor
        border.color: root.serviceColor
        border.width: 1
        Text {
            anchors.centerIn: parent
            text: "VIRTUAL FLT"
            color: root.primaryColor
            font.family: "B612 Mono"
            font.pixelSize: 16
            font.weight: Font.Bold
        }
    }

    Rectangle {
        x: 778
        y: 24
        width: 108
        height: 48
        color: root.backgroundColor
        border.color: root.serviceColor
        border.width: 1
        Text {
            anchors.centerIn: parent
            text: "RIGHT ▶"
            color: root.primaryColor
            font.family: "B612 Mono"
            font.pixelSize: 16
            font.weight: Font.Bold
        }
    }

    Rectangle {
        x: 900
        y: 24
        width: 1
        height: 48
        color: root.serviceColor
    }

    Rectangle {
        x: 916
        y: 24
        width: 150
        height: 48
        color: root.backgroundColor
        border.color: root.serviceColor
        border.width: 1
        Text {
            anchors.centerIn: parent
            text: "TIME"
            color: root.primaryColor
            font.family: "B612 Mono"
            font.pixelSize: 16
            font.weight: Font.Bold
        }
    }

    Rectangle {
        x: 1080
        y: 24
        width: 330
        height: 48
        color: root.backgroundColor
        border.color: root.primaryColor
        border.width: 1
        Text {
            anchors.centerIn: parent
            text: "☰ TOOLS"
            color: root.primaryColor
            font.family: "B612 Mono"
            font.pixelSize: 16
            font.weight: Font.Bold
        }
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
