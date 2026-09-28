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

    property string missionState: "AUTO"
    readonly property bool missionVisible: missionState === "AUTO"
    readonly property bool missionCreationMode: missionState === "MANUAL"
    property bool missionIdExpanded: false
    property string missionReviewState: "REWORK"
    readonly property color missionIdStatusColor: missionReviewState === "VERIFIED" ? "#64FF00" : "#FF00FF"
    property bool panelConfigOpen: false
    property int selectedTemplate: 2
    property bool analysisVisible: true
    property bool instrumentsVisible: false
    property bool atcVisible: false
    property bool diagnosticsVisible: false

    Rectangle {
        anchors.fill: parent
        color: root.bg
    }

    // The neighboring header owns this shared top seam; draw it once here
    // as the seam reference, not as a second panel outline.
    Rectangle {
        x: 0
        y: 0
        width: parent.width
        height: 1
        color: root.cyan
        antialiasing: false
    }
    Rectangle {
        x: 0
        y: 1
        width: 1
        height: parent.height - 1
        color: root.cyan
        antialiasing: false
    }
    Rectangle {
        x: parent.width - 1
        y: 1
        width: 1
        height: parent.height - 1
        color: root.cyan
        antialiasing: false
    }
    Rectangle {
        x: 0
        y: parent.height - 1
        width: parent.width
        height: 1
        color: root.cyan
        antialiasing: false
    }

    // Panel title bar: selected surface, cyan outline, controlled typography.
    Rectangle {
        x: 10
        y: 8
        width: parent.width - 20
        height: 38
        color: root.selectedSurface
        border.color: root.cyan
        border.width: 1

        Text {
            x: 12
            anchors.verticalCenter: parent.verticalCenter
            text: "Миссии"
            color: root.text
            font.family: "B612"
            font.pixelSize: 14
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

            MouseArea {
                anchors.fill: parent
                onClicked: root.missionState = "AUTO"
            }
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
        height: 40
        radius: 3
        color: root.card
        border.color: root.divider
        border.width: 1

        Text {
            id: missionIdLabel
            x: 10
            width: root.missionIdExpanded ? 142 : 48
            anchors.verticalCenter: parent.verticalCenter
            elide: Text.ElideRight
            text: root.missionIdExpanded ? "BS-260920-A-001" : "A-001"
            color: root.missionIdStatusColor
            font.family: "B612 Mono"
            font.pixelSize: 11
            font.bold: true

            MouseArea {
                anchors.fill: parent
                onClicked: root.missionIdExpanded = !root.missionIdExpanded
            }
        }

        Rectangle {
            x: missionIdLabel.x + missionIdLabel.width + 5
            y: 8
            width: 1
            height: parent.height - 16
            color: root.divider
        }

        Text {
            id: missionSummaryLabel
            x: missionIdLabel.x + missionIdLabel.width + 17
            width: Math.max(0, parent.width - x - 98)
            anchors.verticalCenter: parent.verticalCenter
            elide: Text.ElideRight
            text: "3D-картография территории"
            color: root.secondary
            font.family: "Noto Sans"
            font.pixelSize: 10
        }

        Rectangle {
            x: parent.width - 91
            y: 8
            width: 1
            height: parent.height - 16
            color: root.divider
        }

        Rectangle {
            id: hideMissionButton
            x: parent.width - 82
            width: 72
            height: 26
            anchors.verticalCenter: parent.verticalCenter
            radius: 2
            color: root.selectedSurface
            border.color: root.divider
            border.width: 1

            Text {
                anchors.fill: parent
                text: "⊘  СКРЫТЬ"
                color: root.secondary
                font.family: "B612 Mono"
                font.pixelSize: 9
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.missionState = "HIDDEN"
            }
        }
    }

    Rectangle {
        visible: root.panelConfigOpen && root.missionVisible
        x: 10
        y: 108
        width: parent.width - 20
        height: 154
        color: root.selectedSurface
        border.color: root.cyan
        border.width: 1
        z: 10

        Text {
            x: 12
            y: 10
            text: "ИНСТРУМЕНТЫ ПАНЕЛИ"
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
                text: (root.analysisVisible ? "✓ " : "○ ") + "Анализ миссии"
                color: root.analysisVisible ? root.cyan : root.secondary
                font.family: "Noto Sans"
                font.pixelSize: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.analysisVisible = !root.analysisVisible
                }
            }
            Text {
                text: (root.instrumentsVisible ? "✓ " : "○ ") + "Приборы"
                color: root.instrumentsVisible ? root.cyan : root.secondary
                font.family: "Noto Sans"
                font.pixelSize: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.instrumentsVisible = !root.instrumentsVisible
                }
            }
            Text {
                text: (root.atcVisible ? "✓ " : "○ ") + "УВД / Связь"
                color: root.atcVisible ? root.cyan : root.secondary
                font.family: "Noto Sans"
                font.pixelSize: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.atcVisible = !root.atcVisible
                }
            }
            Text {
                text: (root.diagnosticsVisible ? "✓ " : "○ ") + "Расширенная диагностика"
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

    Flickable {
        id: templateList
        visible: (root.missionVisible || root.missionCreationMode) && !root.panelConfigOpen
        x: 10
        y: 92
        width: parent.width - 20
        height: Math.max(0, parent.height - y - createMissionButton.height - 20)
        contentWidth: width
        contentHeight: templateColumn.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: templateColumn
            width: templateList.width
            spacing: 3
            Repeater {
                model: ["Картографирование территории","Инспекция объектов (здания, ЛЭП, трубопроводы)","3D-картография / реконструкция","Мониторинг территории","Поиск человека","Пожарный мониторинг","Доставка","Drone-in-a-Box","BVLOS-мониторинг","Экологический мониторинг","Ретрансляция связи","C-UAS — обнаружение БПЛА","Автоматическое обнаружение объектов","Групповая / роёвая миссия"]
                delegate: Rectangle {
                    required property int index
                    required property string modelData
                    width: templateColumn.width
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
                        width: parent.width - 52
                        anchors.verticalCenter: parent.verticalCenter
                        elide: Text.ElideRight
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
    }

    Rectangle {
        id: createMissionButton
        x: 10
        y: parent.height - height - 12
        width: parent.width - 20
        height: 44
        radius: 2
        color: root.card
        border.color: root.divider
        border.width: 1
        z: 30

        Text {
            anchors.fill: parent
            text: "СОЗДАТЬ МИССИЮ"
            color: "#64FF00"
            font.family: "B612"
            font.pixelSize: 12
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.missionState = "MANUAL"
        }
    }

}
