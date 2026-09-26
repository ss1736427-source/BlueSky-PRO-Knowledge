import QtQuick

Item {
    id: root
    width: 430
    height: 720

    property color bg: "#08111D"
    property color card: "#0C1725"
    property color selectedSurface: "#111F30"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color muted: "#7F7F7F"
    property color cyan: "#32FFFF"
    property color divider: "#7F7F7F"

    property bool missionVisible: true
    property bool panelConfigOpen: false
    property int selectedTemplate: 2
    property bool analysisVisible: true
    property bool instrumentsVisible: false
    property bool atcVisible: false
    property bool diagnosticsVisible: false

    Rectangle {
        anchors.fill: parent
        color: root.bg
        border.color: root.cyan
        border.width: 1
    }

    Rectangle {
        x: 10
        y: 8
        width: parent.width - 20
        height: 38
        color: root.card

        Text {
            x: 12
            anchors.verticalCenter: parent.verticalCenter
            text: "Mission Templates"
            color: root.text
            font.family: "Noto Sans"
            font.pixelSize: 13
            font.bold: true
        }

        Text {
            x: parent.width - 58
            anchors.verticalCenter: parent.verticalCenter
            text: "+"
            color: root.missionVisible ? root.muted : root.cyan
            font.family: "B612 Mono"
            font.pixelSize: 18
            font.bold: true
        }

        Text {
            x: parent.width - 28
            anchors.verticalCenter: parent.verticalCenter
            text: "≡"
            color: root.panelConfigOpen ? root.cyan : root.secondary
            font.family: "B612 Mono"
            font.pixelSize: 16
        }

        MouseArea {
            x: parent.width - 44
            width: 34
            height: parent.height
            onClicked: root.panelConfigOpen = !root.panelConfigOpen
        }
    }

    Rectangle {
        visible: root.missionVisible
        x: 10
        y: 50
        width: parent.width - 20
        height: 36
        color: root.card

        Text {
            x: 10
            anchors.verticalCenter: parent.verticalCenter
            text: "BS-260924-A-001"
            color: root.text
            font.family: "B612 Mono"
            font.pixelSize: 11
            font.bold: true
        }

        Text {
            x: parent.width - 66
            anchors.verticalCenter: parent.verticalCenter
            text: "HIDE"
            color: root.secondary
            font.family: "B612 Mono"
            font.pixelSize: 10
            font.bold: true
        }

        MouseArea {
            x: parent.width - 82
            width: 72
            height: parent.height
            onClicked: root.missionVisible = false
        }
    }

    Rectangle {
        visible: root.panelConfigOpen && root.missionVisible
        x: 10
        y: 90
        width: parent.width - 20
        height: 154
        color: root.selectedSurface
        border.color: root.cyan
        border.width: 1
        z: 10

        Text {
            x: 12
            y: 10
            text: "PANEL TOOLS"
            color: root.secondary
            font.family: "Noto Sans"
            font.pixelSize: 10
            font.bold: true
        }

        Column {
            x: 12
            y: 34
            spacing: 8

            Text {
                text: (root.analysisVisible ? "✓ " : "○ ") + "Mission Analysis"
                color: root.analysisVisible ? root.cyan : root.secondary
                font.family: "Noto Sans"
                font.pixelSize: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.analysisVisible = !root.analysisVisible
                }
            }
            Text {
                text: (root.instrumentsVisible ? "✓ " : "○ ") + "Instruments"
                color: root.instrumentsVisible ? root.cyan : root.secondary
                font.family: "Noto Sans"
                font.pixelSize: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.instrumentsVisible = !root.instrumentsVisible
                }
            }
            Text {
                text: (root.atcVisible ? "✓ " : "○ ") + "ATC / Communication"
                color: root.atcVisible ? root.cyan : root.secondary
                font.family: "Noto Sans"
                font.pixelSize: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.atcVisible = !root.atcVisible
                }
            }
            Text {
                text: (root.diagnosticsVisible ? "✓ " : "○ ") + "Extended Diagnostics"
                color: root.diagnosticsVisible ? root.cyan : root.secondary
                font.family: "Noto Sans"
                font.pixelSize: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.diagnosticsVisible = !root.diagnosticsVisible
                }
            }
        }
    }

    Column {
        visible: root.missionVisible && !root.panelConfigOpen
        x: 10
        y: 92
        width: parent.width - 20
        spacing: 3

        Repeater {
            model: [
                "Картографирование территории",
                "Обследование зданий",
                "3D картография",
                "Линейное обследование",
                "Картографирование коридора",
                "Точка интереса",
                "Создать миссию"
            ]

            delegate: Rectangle {
                required property int index
                required property string modelData
                width: parent.width
                height: 56
                radius: 3
                color: index === root.selectedTemplate ? root.selectedSurface : root.card
                border.color: index === root.selectedTemplate ? root.cyan : root.divider
                border.width: 1

                Rectangle {
                    visible: index === root.selectedTemplate
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 3
                    color: root.cyan
                }

                Text {
                    x: 16
                    anchors.verticalCenter: parent.verticalCenter
                    text: modelData
                    color: root.text
                    font.family: "Noto Sans"
                    font.pixelSize: 12
                    font.bold: true
                }

                Text {
                    visible: index === root.selectedTemplate
                    x: parent.width - 30
                    anchors.verticalCenter: parent.verticalCenter
                    text: "✓"
                    color: root.cyan
                    font.family: "B612 Mono"
                    font.pixelSize: 15
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.selectedTemplate = index
                }
            }
        }
    }

    Column {
        visible: !root.missionVisible
        anchors.horizontalCenter: parent.horizontalCenter
        y: 72
        spacing: 22

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "MISSION HIDDEN"
            color: root.secondary
            font.family: "Noto Sans"
            font.pixelSize: 13
            font.bold: true
        }

        Rectangle {
            width: 150
            height: 32
            color: "transparent"
            border.color: root.cyan
            border.width: 1

            Text {
                anchors.fill: parent
                text: "+ RESTORE"
                color: root.cyan
                font.family: "B612 Mono"
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.missionVisible = true
            }
        }
    }
}
