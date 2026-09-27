import QtQuick

Item {
    id: root

    signal uavSelected(int index)
    signal uavDoubleClicked(int index)
    property int selectedIndex: -1

    property color bg: "#03182B"
    property color card: "#061D32"
    property color text: "#EAF3FF"
    property color secondary: "#8EA9C5"
    property color cyan: "#00BFFF"
    property color green: "#28E887"
    property color amber: "#FFD339"
    property color divider: "#294A68"

    property var uavModel: [
        { id: "BS-001", type: "MULTIROTOR", state: "READY", alt: "0 m", speed: "0 km/h", battery: "100 %", range: "120 km", eta: "—" },
        { id: "BS-002", type: "FIXED WING", state: "READY", alt: "0 m", speed: "0 km/h", battery: "100 %", range: "180 km", eta: "—" },
        { id: "BS-003", type: "MULTIROTOR", state: "READY", alt: "0 m", speed: "0 km/h", battery: "100 %", range: "150 km", eta: "—" },
        { id: "BS-004", type: "VTOL", state: "READY", alt: "0 m", speed: "0 km/h", battery: "100 %", range: "200 km", eta: "—" }
    ]

    Rectangle { anchors.fill: parent; color: root.bg }

    Row {
        id: cardRow
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 12
        height: Math.min(282, parent.height - 24)

        Repeater {
            model: root.uavModel

            delegate: Rectangle {
                id: cardRoot
                required property int index
                required property var modelData
                width: (cardRow.width - (root.uavModel.length - 1) * cardRow.spacing) / root.uavModel.length
                height: cardRow.height
                radius: 6
                color: root.card
                border.color: index === root.selectedIndex ? root.cyan : root.divider
                border.width: index === root.selectedIndex ? 2 : 1

                // Compact settings affordance, kept inside the card contour.
                Text {
                    id: settingsGlyph
                    x: 14
                    y: 10
                    text: "☷"
                    color: "#A9D8FF"
                    font.pixelSize: 25
                    font.bold: true
                }
                MouseArea {
                    x: 8; y: 6; width: 42; height: 38
                    z: 3
                    onClicked: root.uavSelected(index)
                }

                Item {
                    id: aircraftView
                    x: 14
                    y: 48
                    width: Math.max(100, cardRoot.width * 0.43)
                    height: cardRoot.height - 92

                    // Simple scalable vehicle schematic; can be replaced by per-model SVG assets.
                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width * 0.48
                        height: 18
                        radius: 7
                        color: "#DCE8F4"
                        rotation: -4
                    }
                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width * 0.88
                        height: 5
                        radius: 2
                        color: "#B9CDE0"
                        rotation: -4
                    }
                    Repeater {
                        model: 4
                        delegate: Rectangle {
                            required property int index
                            width: 26
                            height: 26
                            radius: 13
                            color: "transparent"
                            border.color: "#B9CDE0"
                            border.width: 2
                            x: index % 2 === 0 ? aircraftView.width * 0.12 : aircraftView.width * 0.70
                            y: index < 2 ? aircraftView.height * 0.25 : aircraftView.height * 0.63
                            Rectangle {
                                anchors.centerIn: parent
                                width: 34
                                height: 2
                                color: "#7F9BB5"
                            }
                        }
                    }
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        width: parent.width * 0.24
                        height: 8
                        radius: 2
                        color: "#829AB1"
                    }
                }

                Text {
                    x: 12
                    y: cardRoot.height - 68
                    width: Math.max(80, cardRoot.width * 0.43)
                    text: modelData.id
                    color: root.text
                    font.family: "Noto Sans"
                    font.pixelSize: 18
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }
                Text {
                    x: 12
                    y: cardRoot.height - 40
                    width: Math.max(80, cardRoot.width * 0.43)
                    text: modelData.state
                    color: modelData.state === "READY" ? root.green : root.amber
                    font.family: "B612 Mono"
                    font.pixelSize: 13
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }

                Rectangle {
                    x: cardRoot.width * 0.49
                    y: 38
                    width: 1
                    height: cardRoot.height - 76
                    color: root.divider
                }

                Column {
                    x: cardRoot.width * 0.53
                    y: 38
                    width: cardRoot.width * 0.43
                    height: cardRoot.height - 76
                    spacing: 0

                    Repeater {
                        model: [
                            { label: "ALT", value: modelData.alt },
                            { label: "SPD", value: modelData.speed },
                            { label: "BAT", value: modelData.battery },
                            { label: "RNG", value: modelData.range },
                            { label: "ETA", value: modelData.eta }
                        ]
                        delegate: Item {
                            required property var modelData
                            width: parent.width
                            height: parent.height / 5
                            Text {
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.label
                                color: root.secondary
                                font.family: "B612 Mono"
                                font.pixelSize: 14
                            }
                            Text {
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.value
                                color: root.text
                                font.family: "Noto Sans"
                                font.pixelSize: 15
                            }
                        }
                    }
                }

                Rectangle {
                    x: 12
                    y: cardRoot.height - 18
                    width: cardRoot.width - 24
                    height: 7
                    radius: 3
                    color: modelData.state === "READY" ? root.green : root.amber
                }

                MouseArea {
                    anchors.fill: parent
                    z: 2
                    onClicked: root.uavSelected(index)
                    onDoubleClicked: root.uavDoubleClicked(index)
                }
            }
        }
    }

    PanelSettingsButton {
        id: panelSettings
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 10
        z: 400
        onClicked: panelSettingsPopup.open = !panelSettingsPopup.open
    }

    PanelSettingsPopup {
        id: panelSettingsPopup
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 44
        width: 260
        height: 254
        title: "UAV PANEL SETTINGS"
        tools: ["UAV Selection", "Control / C2", "UAV Configuration", "Navigation", "Energy", "Payload / Equipment", "Maintenance", "Diagnostics", "Displayed Parameters"]
        onClosed: open = false
    }
}
