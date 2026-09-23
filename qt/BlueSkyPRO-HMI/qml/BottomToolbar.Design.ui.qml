import QtQuick

Item {
    id: root

    width: 1440
    height: 96

    property color background: "#000000"
    property color surface: "#050505"
    property color primary: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color divider: "#202020"
    property color active: "#32FFFF"

    Rectangle {
        anchors.fill: parent
        color: root.background
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 64
        color: root.surface
        border.color: root.divider
        border.width: 1

        Row {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 6

            Rectangle {
                width: 104
                height: 48
                anchors.verticalCenter: parent.verticalCenter
                color: root.surface
                border.color: root.divider
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "◀ LEFT"
                    color: root.primary
                    font.family: "B612 Mono"
                    font.pixelSize: 16
                    font.bold: true
                }
            }

            Rectangle {
                width: 112
                height: 48
                anchors.verticalCenter: parent.verticalCenter
                color: root.surface
                border.color: root.divider
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "UAV"
                    color: root.secondary
                    font.family: "B612 Mono"
                    font.pixelSize: 16
                    font.bold: true
                }
            }

            Rectangle {
                width: 112
                height: 48
                anchors.verticalCenter: parent.verticalCenter
                color: "#071419"
                border.color: root.active
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "MAP"
                    color: root.active
                    font.family: "B612 Mono"
                    font.pixelSize: 16
                    font.bold: true
                }
            }

            Rectangle {
                width: 124
                height: 48
                anchors.verticalCenter: parent.verticalCenter
                color: root.surface
                border.color: root.divider
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "ADMIN"
                    color: root.secondary
                    font.family: "B612 Mono"
                    font.pixelSize: 16
                    font.bold: true
                }
            }

            Rectangle {
                width: 112
                height: 48
                anchors.verticalCenter: parent.verticalCenter
                color: root.surface
                border.color: root.divider
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "FPV"
                    color: root.secondary
                    font.family: "B612 Mono"
                    font.pixelSize: 16
                    font.bold: true
                }
            }

            Rectangle {
                width: 176
                height: 48
                anchors.verticalCenter: parent.verticalCenter
                color: root.surface
                border.color: root.divider
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "VIRTUAL FLT"
                    color: root.secondary
                    font.family: "B612 Mono"
                    font.pixelSize: 16
                    font.bold: true
                }
            }

            Rectangle {
                width: 112
                height: 48
                anchors.verticalCenter: parent.verticalCenter
                color: root.surface
                border.color: root.divider
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "RIGHT ▶"
                    color: root.primary
                    font.family: "B612 Mono"
                    font.pixelSize: 16
                    font.bold: true
                }
            }

            Rectangle {
                width: 116
                height: 48
                anchors.verticalCenter: parent.verticalCenter
                color: root.surface
                border.color: root.divider
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "TIME 12:48"
                    color: root.secondary
                    font.family: "B612 Mono"
                    font.pixelSize: 16
                    font.bold: true
                }
            }

            Rectangle {
                width: 136
                height: 48
                anchors.verticalCenter: parent.verticalCenter
                color: root.surface
                border.color: root.divider
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "☰ TOOLS"
                    color: root.secondary
                    font.family: "B612 Mono"
                    font.pixelSize: 16
                    font.bold: true
                }
            }
        }
    }
}
