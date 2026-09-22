import QtQuick

Item {
    id: root

    implicitHeight: 68

    property color bg: "#000000"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color muted: "#7F7F7F"
    property color green: "#64FF00"
    property color amber: "#FFD339"
    property color red: "#FF1E14"
    property color cyan: "#32FFFF"
    property color divider: "#202020"

    Rectangle {
        anchors.fill: parent
        color: root.bg
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: root.divider
    }

    Text {
        x: 18
        anchors.verticalCenter: parent.verticalCenter
        text: "BlueSky PRO"
        color: root.text
        font.family: "B612"
        font.pixelSize: 22
        font.bold: true
    }

    Rectangle {
        x: 160
        width: 1
        height: 38
        anchors.verticalCenter: parent.verticalCenter
        color: root.divider
    }

    Row {
        x: 182
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        Text {
            text: "MISSION"
            color: root.muted
            font.family: "B612"
            font.pixelSize: 11
            font.bold: true
        }

        Text {
            text: "READY"
            color: root.green
            font.family: "B612 Mono"
            font.pixelSize: 16
            font.bold: true
        }
    }

    Rectangle {
        x: 285
        width: 1
        height: 38
        anchors.verticalCenter: parent.verticalCenter
        color: root.divider
    }

    Row {
        x: 308
        anchors.verticalCenter: parent.verticalCenter
        spacing: 22

        Text {
            text: "ETD 10:30"
            color: root.secondary
            font.family: "B612 Mono"
            font.pixelSize: 13
        }

        Text {
            text: "TOT —"
            color: root.secondary
            font.family: "B612 Mono"
            font.pixelSize: 13
        }

        Text {
            text: "TRIP 01:18"
            color: root.secondary
            font.family: "B612 Mono"
            font.pixelSize: 13
        }

        Text {
            text: "ETA 11:48"
            color: root.secondary
            font.family: "B612 Mono"
            font.pixelSize: 13
        }
    }

    Rectangle {
        x: 720
        width: 1
        height: 38
        anchors.verticalCenter: parent.verticalCenter
        color: root.divider
    }

    Text {
        x: 742
        anchors.verticalCenter: parent.verticalCenter
        text: "WARNING"
        color: root.amber
        font.family: "B612 Mono"
        font.pixelSize: 11
        font.bold: true
    }

    Row {
        anchors.right: operatorBlock.left
        anchors.rightMargin: 24
        anchors.verticalCenter: parent.verticalCenter
        spacing: 18

        Text {
            text: "C2  CONNECTED"
            color: root.green
            font.family: "B612 Mono"
            font.pixelSize: 11
            font.bold: true
        }

        Text {
            text: "GNSS  OK"
            color: root.green
            font.family: "B612 Mono"
            font.pixelSize: 11
        }
    }

    Rectangle {
        id: operatorDivider
        anchors.right: operatorBlock.left
        anchors.rightMargin: 12
        width: 1
        height: 38
        anchors.verticalCenter: parent.verticalCenter
        color: root.divider
    }

    Item {
        id: operatorBlock
        width: 86
        height: parent.height
        anchors.right: parent.right
        anchors.rightMargin: 18

        Text {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: "PILOT"
            color: root.cyan
            font.family: "B612"
            font.pixelSize: 11
            font.bold: true
        }
    }
}
