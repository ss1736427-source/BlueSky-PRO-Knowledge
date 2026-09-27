import QtQuick

Item {
    id: root

    property var displayModel: []
    property int selectedIndex: -1
    property int settingsIndex: -1
    property var settingsParameters: ["ALT", "SPD", "BAT", "ENG"]
    property var availableParameterOptions: []
    property bool settingsOpen: false
    property int dragIndex: -1
    property real dragOffsetX: 0
    property real dragOffsetY: 0
    property int dragTargetIndex: -1

    property int gridColumns: cardGrid.columns
    property real gridCardWidth: cardGrid.cardWidth
    property real gridCardHeight: cardGrid.cardHeight
    property int gridSpacing: cardGrid.spacing

    property color bg: "#050A12"
    property color card: "#0C1725"
    property color selectedSurface: "#111F30"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color muted: "#7F7F7F"
    property color cyan: "#32FFFF"
    property color green: "#64FF00"
    property color amber: "#FFD339"
    property color red: "#FF1E14"
    property color divider: "#29435B"

    signal uavSelected(int index)
    signal uavDoubleClicked(int index)
    signal settingsRequested(int index)
    signal dragStarted(int index, real x, real y)
    signal dragMoved(int index, real x, real y)
    signal dragFinished(int index)
    signal parameterToggleRequested(string parameter)
    signal parameterMoveRequested(string parameter, int direction)
    signal applyToAllRequested()
    signal settingsClosed()

    Rectangle {
        anchors.fill: parent
        color: root.bg
    }

    Grid {
        id: cardGrid
        property int gap: 12
        property int minCardWidth: 320
        property int columns: Math.max(1, Math.floor((width + gap) / (minCardWidth + gap)))
        property real cardWidth: (width - (columns - 1) * gap) / columns
        property real cardHeight: Math.min(360, Math.max(310, root.height * 0.40))
        columns: Math.max(1, Math.floor((width + gap) / (minCardWidth + gap)))
        spacing: gap
        width: root.width - 20
        x: 10
        anchors.verticalCenter: parent.verticalCenter
        height: Math.ceil(root.displayModel.length / columns) * cardHeight
                + Math.max(0, Math.ceil(root.displayModel.length / columns) - 1) * spacing

        Repeater {
            id: cardRepeater
            model: root.displayModel

            delegate: Rectangle {
                id: cardRoot
                required property int index
                required property var modelData

                width: cardGrid.cardWidth
                height: cardGrid.cardHeight
                radius: 5
                color: index === root.selectedIndex ? root.selectedSurface : root.card
                border.color: modelData.state === "WARNING" ? root.red
                              : index === root.selectedIndex ? root.cyan : root.divider
                border.width: index === root.selectedIndex || modelData.state === "WARNING" ? 2 : 1

                transform: Translate {
                    x: root.dragIndex === index ? root.dragOffsetX : 0
                    y: root.dragIndex === index ? root.dragOffsetY : 0
                }
                z: root.dragIndex === index ? 100 : 0

                Row {
                    id: cardHeader
                    x: 12
                    y: 10
                    width: parent.width - 24
                    height: 30
                    spacing: 10

                    Image {
                        width: 24
                        height: 24
                        source: "icons8-menu-24.svg"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }

                    Text {
                        width: parent.width - 40
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.modelName + "  ·  " + modelData.sequence
                        color: root.secondary
                        font.family: "B612"
                        font.pixelSize: 13
                        font.bold: true
                        elide: Text.ElideRight
                    }
                }

                MouseArea {
                    x: 8
                    y: 6
                    width: 34
                    height: 34
                    z: 5
                    onClicked: root.settingsRequested(index)
                }

                Rectangle {
                    x: 12
                    y: 48
                    width: parent.width - 24
                    height: 1
                    color: root.divider
                }

                Item {
                    id: aircraftArea
                    x: 12
                    y: 60
                    width: parent.width * 0.43
                    height: parent.height - 122

                    // Neutral placeholder; production uses the local image assigned in UAV configuration.
                    Item {
                        anchors.centerIn: parent
                        width: Math.min(parent.width * 0.88, parent.height * 0.72)
                        height: width * 0.62

                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.width * 0.38
                            height: parent.height * 0.24
                            radius: 5
                            color: "#DCE8F4"
                            rotation: -3
                        }
                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.width * 0.94
                            height: 4
                            radius: 2
                            color: "#B9CDE0"
                            rotation: -3
                        }
                        Repeater {
                            model: 4
                            delegate: Rectangle {
                                required property int index
                                width: parent.width * 0.16
                                height: width
                                radius: width / 2
                                color: "transparent"
                                border.color: "#B9CDE0"
                                border.width: 2
                                x: index % 2 === 0 ? parent.width * 0.08 : parent.width * 0.76
                                y: index < 2 ? parent.height * 0.08 : parent.height * 0.68
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: parent.width * 1.35
                                    height: 2
                                    color: "#7F9BB5"
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    x: parent.width * 0.47
                    y: 60
                    width: 1
                    height: parent.height - 120
                    color: root.divider
                }

                Column {
                    id: metricColumn
                    x: parent.width * 0.51
                    y: 60
                    width: parent.width * 0.46
                    height: parent.height - 120
                    spacing: 0

                    Repeater {
                        model: modelData.displayParameters
                        delegate: Item {
                            required property var modelData
                            width: metricColumn.width
                            height: metricColumn.height / Math.max(1, cardRoot.modelData.displayParameters.length)

                            Text {
                                anchors.left: parent.left
                                anchors.top: parent.top
                                text: modelData.label
                                color: root.secondary
                                font.family: "B612 Mono"
                                font.pixelSize: 12
                            }

                            Text {
                                anchors.right: parent.right
                                anchors.top: parent.top
                                text: modelData.value
                                color: root.text
                                font.family: "B612 Mono"
                                font.pixelSize: 13
                                horizontalAlignment: Text.AlignRight
                            }

                            Rectangle {
                                visible: modelData.key === "ENG"
                                x: 0
                                y: 22
                                width: parent.width
                                height: 5
                                radius: 2
                                color: "#20384A"
                                Rectangle {
                                    width: parent.width * Math.max(0, Math.min(1, cardRoot.modelData.engine / 100))
                                    height: parent.height
                                    radius: 2
                                    color: root.green
                                }
                            }
                        }
                    }
                }

                Text {
                    x: 12
                    y: parent.height - 54
                    width: parent.width * 0.43
                    text: modelData.id
                    color: root.text
                    font.family: "B612 Mono"
                    font.pixelSize: 17
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    x: 12
                    y: parent.height - 30
                    width: parent.width * 0.43
                    text: modelData.state
                    color: modelData.state === "READY" ? root.green
                           : modelData.state === "WARNING" ? root.red : root.amber
                    font.family: "B612 Mono"
                    font.pixelSize: 12
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }

                Rectangle {
                    x: 12
                    y: parent.height - 12
                    width: parent.width - 24
                    height: 5
                    radius: 2
                    color: modelData.state === "COMPLETED" ? root.muted
                           : modelData.state === "READY" ? root.green
                           : modelData.state === "WARNING" ? root.red : root.amber
                }

                MouseArea {
                    id: cardDragArea
                    anchors.fill: parent
                    z: 1
                    preventStealing: true
                    onPressed: {
                        var p = cardDragArea.mapToItem(cardGrid, mouse.x, mouse.y)
                        root.dragStarted(index, p.x, p.y)
                    }
                    onPositionChanged: if (pressed) {
                        var p = cardDragArea.mapToItem(cardGrid, mouse.x, mouse.y)
                        root.dragMoved(index, p.x, p.y)
                    }
                    onReleased: root.dragFinished(index)
                    onDoubleClicked: root.uavDoubleClicked(index)
                    onCanceled: root.dragFinished(index)
                }
            }
        }
    }

    Rectangle {
        id: settingsPopup
        visible: root.settingsOpen
        z: 500
        x: Math.max(10, parent.width - width - 16)
        y: 44
        width: 330
        height: Math.min(parent.height - 60, 430)
        radius: 4
        color: "#08111D"
        border.color: root.cyan
        border.width: 1

        Text {
            x: 14
            y: 12
            width: parent.width - 52
            text: "ПАРАМЕТРЫ КАРТОЧКИ"
            color: root.text
            font.family: "B612"
            font.pixelSize: 13
            font.bold: true
        }

        Text {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 12
            text: "×"
            color: root.cyan
            font.pixelSize: 18
            MouseArea {
                anchors.fill: parent
                anchors.margins: -8
                onClicked: root.settingsClosed()
            }
        }

        Rectangle {
            x: 12
            y: 38
            width: parent.width - 24
            height: 1
            color: root.divider
        }

        Flickable {
            id: settingsList
            x: 12
            y: 48
            width: parent.width - 24
            height: parent.height - 102
            contentWidth: width
            contentHeight: settingsColumn.implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: settingsColumn
                width: settingsList.width
                spacing: 2

                Repeater {
                    model: root.availableParameterOptions
                    delegate: Rectangle {
                        required property var modelData
                        width: settingsColumn.width
                        height: 30
                        color: root.settingsParameters.indexOf(modelData.key) >= 0 ? root.selectedSurface : "transparent"

                        MouseArea {
                            anchors.left: parent.left
                            anchors.right: upButton.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            onClicked: root.parameterToggleRequested(modelData.key)
                        }

                        Text {
                            x: 8
                            anchors.verticalCenter: parent.verticalCenter
                            text: (root.settingsParameters.indexOf(modelData.key) >= 0 ? "☑  " : "☐  ") + modelData.label
                            color: root.settingsParameters.indexOf(modelData.key) >= 0 ? root.text : root.secondary
                            font.family: "B612"
                            font.pixelSize: 11
                        }

                        Text {
                            id: upButton
                            anchors.right: downButton.left
                            anchors.rightMargin: 2
                            anchors.verticalCenter: parent.verticalCenter
                            text: "↑"
                            color: root.settingsParameters.indexOf(modelData.key) >= 0 ? root.cyan : root.muted
                            font.pixelSize: 14
                        }
                        MouseArea {
                            anchors.right: downButton.left
                            anchors.rightMargin: 2
                            width: 24
                            height: parent.height
                            enabled: root.settingsParameters.indexOf(modelData.key) >= 0
                            onClicked: root.parameterMoveRequested(modelData.key, -1)
                        }

                        Text {
                            id: downButton
                            anchors.right: parent.right
                            anchors.rightMargin: 6
                            anchors.verticalCenter: parent.verticalCenter
                            text: "↓"
                            color: root.settingsParameters.indexOf(modelData.key) >= 0 ? root.cyan : root.muted
                            font.pixelSize: 14
                        }
                        MouseArea {
                            anchors.right: parent.right
                            anchors.rightMargin: 2
                            width: 24
                            height: parent.height
                            enabled: root.settingsParameters.indexOf(modelData.key) >= 0
                            onClicked: root.parameterMoveRequested(modelData.key, 1)
                        }
                    }
                }
            }
        }

        Rectangle {
            x: 12
            y: parent.height - 44
            width: parent.width - 24
            height: 1
            color: root.divider
        }

        Text {
            x: 14
            y: parent.height - 34
            text: "ПРИМЕНИТЬ КО ВСЕМ"
            color: root.cyan
            font.family: "B612 Mono"
            font.pixelSize: 10
            font.bold: true
            MouseArea {
                anchors.fill: parent
                anchors.margins: -8
                onClicked: root.applyToAllRequested()
            }
        }
    }
}
