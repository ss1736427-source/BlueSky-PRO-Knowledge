import QtQuick

Item {
    id: root

    // PLACEHOLDER ONLY.
    // Flight Chart has not yet been designed or approved. Do not treat this component
    // as the final map visual, map provider selection, or spatial interaction design.
    property color bg: "#000000"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color muted: "#7F7F7F"
    property color divider: "#202020"
    property bool missionVisible: true
    signal mapDoubleClicked()

    Rectangle {
        anchors.fill: parent
        color: root.bg

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onDoubleClicked: root.mapDoubleClicked()
        }
    }

    Text {
        visible: root.missionVisible
        anchors.horizontalCenter: parent.horizontalCenter
        y: 28
        text: "FLIGHT CHART"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 16
        font.bold: true
    }

    Text {
        visible: root.missionVisible
        anchors.horizontalCenter: parent.horizontalCenter
        y: 58
        text: "MAP DESIGN PENDING"
        color: root.muted
        font.family: "B612 Mono"
        font.pixelSize: 10
    }

    Rectangle {
        visible: root.missionVisible
        anchors.centerIn: parent
        width: Math.min(720, parent.width - 80)
        height: 220
        color: "#0A0A0A"
        border.color: root.divider
        border.width: 1

        Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                width: 620
                horizontalAlignment: Text.AlignHCenter
                text: "Flight Chart is the primary workspace."
                color: root.text
                font.family: "B612"
                font.pixelSize: 16
            }

            Text {
                width: 620
                horizontalAlignment: Text.AlignHCenter
                text: "Route, UAV, restriction, weather and spatial layers will be defined in the dedicated map design pass."
                color: root.secondary
                font.family: "B612"
                font.pixelSize: 11
                wrapMode: Text.WordWrap
            }

            Text {
                width: 620
                horizontalAlignment: Text.AlignHCenter
                text: "Current screen is a structural placeholder only."
                color: root.muted
                font.family: "B612 Mono"
                font.pixelSize: 10
            }
        }
    }
    Text {
        visible: !root.missionVisible
        anchors.centerIn: parent
        text: "NO ACTIVE MISSION"
        color: root.muted
        font.family: "B612 Mono"
        font.pixelSize: 12
    }

}
