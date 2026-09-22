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

    property bool missionVisible: true
    signal hideMissionRequested()
    signal restoreMissionRequested()
    signal missionTemplateMenuRequested()

    Rectangle {
        anchors.fill: parent
        color: root.bg
    }

    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1
        color: root.divider
    }

    Row {
        x: 16
        y: 14
        spacing: 12

        Text {
            text: "MISSION CONTEXT"
            color: root.secondary
            font.family: "B612"
            font.pixelSize: 13
            font.bold: true
        }

        Text {
            text: "+"
            color: root.cyan
            font.family: "B612 Mono"
            font.pixelSize: 18
            font.bold: true
        }

        Text {
            text: "≡"
            color: root.secondary
            font.family: "B612 Mono"
            font.pixelSize: 16
        }
    }

    MouseArea {
        x: 104
        y: 8
        width: 26
        height: 28
        onClicked: root.missionTemplateMenuRequested()
    }

    Text {
        visible: root.missionVisible
        x: 16
        y: 48
        text: "BS-260920-A-001"
        color: root.text
        font.family: "B612 Mono"
        font.pixelSize: 16
        font.bold: true
    }

    Text {
        visible: root.missionVisible
        x: 16
        y: 70
        text: "Area Survey"
        color: root.text
        font.family: "B612"
        font.pixelSize: 13
    }

    Text {
        visible: root.missionVisible
        x: 16
        y: 90
        text: "4 UAV · BVLOS · wind-aware"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 11
    }

    Text {
        visible: root.missionVisible
        x: 16
        y: 126
        text: "MISSION TEMPLATES"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 12
        font.bold: true
    }

    // Default view contains only the template used by the active task.
    Rectangle {
        visible: root.missionVisible
        x: 16
        y: 151
        width: parent.width - 32
        height: 34
        color: "#151515"
        border.color: root.cyan
        border.width: 1

        Text {
            anchors.fill: parent
            anchors.leftMargin: 12
            verticalAlignment: Text.AlignVCenter
            text: "Area Survey"
            color: root.text
            font.family: "B612"
            font.pixelSize: 12
        }
    }

    Text {
        visible: root.missionVisible
        x: 16
        y: 196
        text: "+  MORE TEMPLATES"
        color: root.cyan
        font.family: "B612 Mono"
        font.pixelSize: 10
        font.bold: true
    }

    MouseArea {
        visible: root.missionVisible
        x: 16
        y: 190
        width: parent.width - 32
        height: 24
        onClicked: root.missionTemplateMenuRequested()
    }

    Text {
        visible: root.missionVisible
        x: 16
        y: 238
        text: "HIDE"
        color: root.cyan
        font.family: "B612 Mono"
        font.pixelSize: 11
        font.bold: true
    }

    MouseArea {
        visible: root.missionVisible
        x: 16
        y: 232
        width: 80
        height: 28
        onClicked: root.hideMissionRequested()
    }

    Text {
        visible: root.missionVisible
        x: 16
        y: 278
        text: "MISSION ID"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 11
        font.bold: true
    }

    Text {
        visible: root.missionVisible
        x: 16
        y: 300
        text: "immutable: BS-260920-A-001"
        color: root.text
        font.family: "B612 Mono"
        font.pixelSize: 11
    }

    Text {
        visible: root.missionVisible
        x: 16
        y: 342
        text: "PANEL TOOLS"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 11
        font.bold: true
    }

    Text {
        visible: root.missionVisible
        x: 16
        y: 366
        text: "Route · Altitude · Speed · Offset"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 10
    }

    Text {
        visible: root.missionVisible
        x: 16
        y: 386
        text: "Weather · Obstacles · Airspace"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 10
    }
    Column {
        visible: !root.missionVisible
        anchors.horizontalCenter: parent.horizontalCenter
        y: 72
        spacing: 14

        Text {
            width: parent.parent.width - 32
            horizontalAlignment: Text.AlignHCenter
            text: "MISSION HIDDEN"
            color: root.secondary
            font.family: "B612"
            font.pixelSize: 13
            font.bold: true
        }

        Text {
            width: parent.parent.width - 32
            horizontalAlignment: Text.AlignHCenter
            text: "Saved state retained"
            color: root.muted
            font.family: "IBM Plex Sans Condensed"
            font.pixelSize: 11
        }

        Rectangle {
            width: 150
            height: 32
            color: "transparent"
            border.color: root.cyan
            border.width: 1

            Text {
                anchors.fill: parent
                text: "+  RESTORE"
                color: root.cyan
                font.family: "B612 Mono"
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.restoreMissionRequested()
            }
        }
    }

}
