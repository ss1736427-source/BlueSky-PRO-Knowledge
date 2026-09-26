import QtQuick

Item {
    id: root

    TextMetrics {
        id: widestTemplateText
        font.family: "Noto Sans"
        font.pixelSize: 12
        font.bold: true
        text: "Картографирование территории"
    }

    TextMetrics {
        id: headerTitleText
        font.family: "Noto Sans"
        font.pixelSize: 13
        font.bold: true
        text: "Миссии"
    }

    // Width is driven by the widest visible content and the fixed right-side header controls.
    implicitWidth: Math.max(270, Math.min(420,
        Math.max(widestTemplateText.width + 44, headerTitleText.width + 84)))
    implicitHeight: 520
    // When hosted by MainContent the panel height is supplied by top/bottom anchors,
    // so it follows the workspace height automatically.

    property color bg: "#08111D"
    property color card: "#0C1725"
    property color selectedSurface: "#111F30"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color muted: "#7F7F7F"
    property color cyan: "#32FFFF"
    property color divider: "#7F7F7F"

    property bool missionVisible: true
    property string missionId: "BS-260920-A-001"
    property bool templatesExpanded: true
    property bool panelConfigOpen: false
    property int selectedTemplate: 2
    property bool analysisVisible: true
    property bool instrumentsVisible: false
    property bool atcVisible: false
    property bool diagnosticsVisible: false

    signal hideMissionRequested()
    signal restoreMissionRequested()
    signal missionTemplateMenuRequested()
    signal templateSelected(int index)
    signal createMissionRequested()
    signal panelConfigurationChanged()
    signal missionHidden()

    ListModel {
        id: templateModel
        ListElement { title: "Картографирование территории"; subtitle: ""; accent: "#64FF00" }
        ListElement { title: "Обследование зданий"; subtitle: ""; accent: "#BFBFBF" }
        ListElement { title: "3D картография"; subtitle: ""; accent: "#32FFFF" }
        ListElement { title: "Линейное обследование"; subtitle: ""; accent: "#32FFFF" }
        ListElement { title: "Картографирование коридора"; subtitle: ""; accent: "#FFD339" }
        ListElement { title: "Точка интереса"; subtitle: ""; accent: "#FF32FF" }
        ListElement { title: "Создать миссию"; subtitle: ""; accent: "#BFBFBF" }
    }

    Rectangle {
        anchors.fill: parent
        color: root.bg
    }

    // Full panel frame follows the interface structural-stroke language.
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: root.cyan
        border.width: 1
        radius: 1
    }

    // Panel title bar: distinct hierarchy within the panel, using the
    // controlled selected surface and one cyan outline.
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
            rightPadding: 70
            text: "Миссии"
            color: root.text
            font.family: "B612"
            font.pixelSize: 14
            font.bold: true
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Text {
                width: 18
                horizontalAlignment: Text.AlignHCenter
                text: "+"
                color: root.missionVisible ? root.muted : root.cyan
                font.family: "B612 Mono"
                font.pixelSize: 18
                font.bold: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (!root.missionVisible)
                            root.restoreMissionRequested()
                    }
                }
            }

            Text {
                width: 18
                horizontalAlignment: Text.AlignHCenter
                text: "≡"
                color: root.panelConfigOpen ? root.cyan : root.secondary
                font.family: "B612 Mono"
                font.pixelSize: 16

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.panelConfigOpen = !root.panelConfigOpen
                        root.missionTemplateMenuRequested()
                    }
                }
            }
        }
    }

    // Mission context is persistent while the mission is visible.
    Rectangle {
        visible: root.missionVisible
        x: 10
        y: 50
        width: parent.width - 20
        height: 36
        color: root.card
        border.color: "transparent"
        border.width: 0

        Text {
            x: 10
            anchors.verticalCenter: parent.verticalCenter
            text: root.missionId
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
            onClicked: root.hideMissionRequested()
        }
    }

    // Panel configuration is presentation-only and independent of Bottom Toolbar configuration.
    Rectangle {
        visible: root.panelConfigOpen
        x: 10
        y: 90
        width: parent.width - 20
        height: 154
        color: root.selectedSurface
        border.color: root.cyan
        border.width: 1
        z: 20

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
            y: 32
            width: parent.width - 24
            spacing: 7

            Repeater {
                model: [
                    { "label": "Mission Analysis", "key": "analysis", "enabled": root.analysisVisible },
                    { "label": "Instruments", "key": "instruments", "enabled": root.instrumentsVisible },
                    { "label": "ATC / Communication", "key": "atc", "enabled": root.atcVisible },
                    { "label": "Extended Diagnostics", "key": "diagnostics", "enabled": root.diagnosticsVisible }
                ]

                delegate: Text {
                    required property var modelData
                    width: parent.width
                    text: (modelData.enabled ? "✓ " : "○ ") + modelData.label
                    color: modelData.enabled ? root.cyan : root.secondary
                    font.family: "Noto Sans"
                    font.pixelSize: 10

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (modelData.key === "analysis") root.analysisVisible = !root.analysisVisible
                            else if (modelData.key === "instruments") root.instrumentsVisible = !root.instrumentsVisible
                            else if (modelData.key === "atc") root.atcVisible = !root.atcVisible
                            else if (modelData.key === "diagnostics") root.diagnosticsVisible = !root.diagnosticsVisible
                            root.panelConfigurationChanged()
                        }
                    }
                }
            }
        }
    }

    // Reference-style template list. The selected item uses the controlled
    // selected surface and cyan structural highlight rather than arbitrary blue.
    Column {
        visible: root.missionVisible && root.templatesExpanded && !root.panelConfigOpen
        x: 10
        y: root.missionVisible ? 92 : 50
        width: parent.width - 20
        height: Math.max(0, parent.height - y - 10)
        spacing: 3
        clip: true

        Repeater {
            model: templateModel

            delegate: Rectangle {
                required property int index
                required property string title
                required property string subtitle
                required property string accent

                width: parent.width
                height: 56
                radius: 3
                color: index === root.selectedTemplate ? root.selectedSurface : root.card
                border.color: index === root.selectedTemplate ? root.cyan : root.divider
                border.width: index === root.selectedTemplate ? 1 : 1

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 3
                    radius: 2
                    color: index === root.selectedTemplate ? root.cyan : "transparent"
                }

                Text {
                    x: 16
                    y: 19
                    text: title
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
                    onClicked: {
                        root.selectedTemplate = index
                        root.templateSelected(index)
                        if (index === templateModel.count - 1)
                            root.createMissionRequested()
                    }
                }
            }
        }
    }

    // Expanded mission context remains available when templates are collapsed.
    Column {
        visible: root.missionVisible && !root.templatesExpanded && !root.panelConfigOpen
        x: 16
        y: 98
        width: parent.width - 32
        spacing: 10

        Text {
            text: root.missionId
            color: root.text
            font.family: "B612 Mono"
            font.pixelSize: 16
            font.bold: true
        }

        Text {
            text: "Area Survey"
            color: root.text
            font.family: "Noto Sans"
            font.pixelSize: 13
        }

        Text {
            text: "4 UAV  |  BVLOS  |  wind-aware"
            color: root.secondary
            font.family: "Noto Sans"
            font.pixelSize: 11
        }
    }

    Text {
        visible: root.missionVisible && !root.templatesExpanded && !root.panelConfigOpen
        x: 16
        y: 162
        text: "MISSION ID  |  immutable"
        color: root.secondary
        font.family: "Noto Sans"
        font.pixelSize: 11
        font.bold: true
    }

    Text {
        visible: root.missionVisible && !root.templatesExpanded && !root.panelConfigOpen
        x: 16
        y: 184
        text: root.missionId
        color: root.text
        font.family: "B612 Mono"
        font.pixelSize: 11
    }

    Text {
        visible: root.missionVisible && !root.templatesExpanded
        x: 16
        y: 226
        text: "PANEL TOOLS"
        color: root.secondary
        font.family: "Noto Sans"
        font.pixelSize: 11
        font.bold: true
    }

    Text {
        visible: root.missionVisible && !root.templatesExpanded
        x: 16
        y: 250
        text: "Analysis  |  Instruments  |  ATC  |  Diagnostics"
        color: root.secondary
        font.family: "Noto Sans"
        font.pixelSize: 10
    }

    Text {
        visible: root.missionVisible && !root.templatesExpanded
        x: 16
        y: 270
        text: "Weather  |  Obstacles  |  Airspace"
        color: root.secondary
        font.family: "Noto Sans"
        font.pixelSize: 10
    }

    Text {
        visible: !root.missionVisible
        anchors.horizontalCenter: parent.horizontalCenter
        y: 72
        text: "MISSION HIDDEN"
        color: root.secondary
        font.family: "Noto Sans"
        font.pixelSize: 13
        font.bold: true
    }

    Rectangle {
        visible: !root.missionVisible
        anchors.horizontalCenter: parent.horizontalCenter
        y: 110
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
