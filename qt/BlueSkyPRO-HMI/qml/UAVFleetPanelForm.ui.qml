import QtQuick

Item {
    id: root

    property var displayModel: []
    property int selectedIndex: -1
    property int settingsIndex: -1
    property var settingsParameters: ["ALT", "SPD", "BAT", "ENG"]
    property int expandedUavIndex: -1
    property string expandedParameterLabel: ""
    property string expandedParameterValue: ""
    property var availableParameterOptions: []
    property bool settingsOpen: false
    property int dragIndex: -1
    property real dragOffsetX: 0
    property real dragOffsetY: 0
    property int dragTargetIndex: -1

    readonly property int maxParameterRows: {
        var count = 4
        for (var i = 0; i < root.displayModel.length; ++i)
            count = Math.max(count, root.displayModel[i].primaryParameters.length)
        return count
    }
    readonly property real settingsPopupPreferredWidth: {
        var desired = 380
        for (var i = 0; i < root.availableParameterOptions.length; ++i)
            desired = Math.max(desired, String(root.availableParameterOptions[i].label).length * 7.2 + 112)
        return Math.min(root.width - 24, desired)
    }
    property int gridColumns: cardGrid.columnCount
    property real gridCardWidth: cardGrid.cardWidth
    property real gridCardHeight: cardGrid.cardHeight
    property int gridSpacing: cardGrid.spacing

    property color bg: "#D9050A12"
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
    signal smartToolRequested(int index, string parameter)
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
        property int minCardWidth: 280
        property int columnCount: Math.max(1, Math.floor((width + gap) / (minCardWidth + gap)))
        property real cardWidth: (width - (columnCount - 1) * gap) / columnCount
        property real cardHeight: Math.min(root.height - 12, 48 + root.maxParameterRows * 20)
        columns: columnCount
        spacing: gap
        width: root.width - 20
        x: 10
        anchors.verticalCenter: parent.verticalCenter
        height: Math.ceil(root.displayModel.length / columnCount) * cardHeight
                + Math.max(0, Math.ceil(root.displayModel.length / columnCount) - 1) * spacing

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
                color: index === root.selectedIndex ? "#F0111F30" : "#E60C1725"
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
                    x: 10
                    y: 5
                    width: parent.width - 20
                    height: 24
                    spacing: 7

                    Image {
                        width: 20
                        height: 20
                        source: "icons8-menu-24.svg"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }

                    Text {
                        width: parent.width - 34
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.modelName + "  ·  " + modelData.id
                        color: root.secondary
                        font.family: "IBM Plex Sans Condensed"
                        font.pixelSize: Math.max(10, Math.min(13, cardRoot.width / 34))
                        font.bold: true
                        elide: Text.ElideRight
                    }
                }

                MouseArea {
                    x: 6
                    y: 3
                    width: 30
                    height: 28
                    z: 5
                    onClicked: root.settingsRequested(index)
                }

                Rectangle {
                    x: 10
                    y: 32
                    width: parent.width - 20
                    height: 1
                    color: root.divider
                }

                Item {
                    id: aircraftArea
                    x: 8
                    y: 38
                    width: parent.width * 0.40
                    height: parent.height - 66

                    // Square image well. Production binds a local configured UAV image here.
                    Rectangle {
                        id: aircraftImageFrame
                        anchors.centerIn: parent
                        width: Math.min(parent.width - 8, parent.height - 8, 110)
                        height: width
                        radius: 0
                        color: "transparent"
                        border.width: 0

                        Item {
                            anchors.fill: parent
                            anchors.margins: 12

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
                }

                Rectangle {
                    x: parent.width * 0.43
                    y: 38
                    width: 1
                    height: parent.height - 64
                    color: root.divider
                }

                Column {
                    id: metricColumn
                    x: parent.width * 0.45
                    y: 38
                    width: parent.width * 0.53
                    height: root.maxParameterRows * 20
                    spacing: 0

                    Repeater {
                        model: modelData.primaryParameters
                        delegate: Item {
                            required property var modelData
                            width: metricColumn.width
                            height: 20

                            Text {
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.label
                                color: root.secondary
                                font.family: "IBM Plex Sans Condensed"
                                font.pixelSize: Math.max(10, Math.min(12, cardRoot.width / 38))
                            }

                            Text {
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.value
                                color: root.text
                                font.family: "B612"
                                font.pixelSize: Math.max(11, Math.min(13, cardRoot.width / 35))
                                horizontalAlignment: Text.AlignRight
                            }

                            Rectangle {
                                visible: modelData.key === "ENG"
                                x: 0
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width
                                height: 4
                                radius: 2
                                color: "#20384A"
                                Repeater {
                                    model: 5
                                    delegate: Rectangle {
                                        required property int index
                                        x: (parent.width - 1) * index / 4
                                        width: 1
                                        height: parent.height
                                        color: "#527087"
                                    }
                                }
                                Rectangle {
                                    x: Math.max(0, Math.min(parent.width - 2,
                                        (parent.width - 2) * cardRoot.modelData.engine / 100))
                                    width: 2
                                    height: parent.height + 5
                                    y: -2
                                    color: root.green
                                }
                            }
                        }
                    }
                }

                Flow {
                    id: smartToolsFlow
                    x: parent.width * 0.45
                    y: parent.height - 48
                    width: parent.width * 0.53
                    height: 28
                    spacing: 4
                    visible: cardRoot.modelData.smartTools.length > 0

                    Repeater {
                        model: cardRoot.modelData.smartTools
                        delegate: Rectangle {
                            required property var modelData
                            width: Math.max(54, smartToolLabel.implicitWidth + 14)
                            height: 23
                            radius: 3
                            color: root.expandedUavIndex === cardRoot.index
                                   && root.expandedParameterLabel === modelData.label
                                   ? root.selectedSurface : "#08111D"
                            border.color: root.expandedUavIndex === cardRoot.index
                                          && root.expandedParameterLabel === modelData.label
                                          ? root.cyan : root.divider
                            border.width: 1

                            Text {
                                id: smartToolLabel
                                anchors.centerIn: parent
                                text: modelData.label
                                color: root.secondary
                                font.family: "B612 Mono"
                                font.pixelSize: 9
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: root.smartToolRequested(cardRoot.index, modelData.key)
                            }
                        }
                    }
                }

                Text {
                    x: parent.width * 0.45
                    y: parent.height - 24
                    width: parent.width * 0.53
                    text: root.expandedUavIndex === cardRoot.index
                          ? root.expandedParameterLabel + "  " + root.expandedParameterValue : ""
                    color: root.text
                    font.family: "B612 Mono"
                    font.pixelSize: 12
                    elide: Text.ElideRight
                    visible: root.expandedUavIndex === cardRoot.index
                }

                Text {
                    x: 12
                    y: parent.height - 40
                    width: parent.width * 0.43
                    text: ""
                    color: root.text
                    font.family: "B612 Mono"
                    font.pixelSize: 17
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    x: 12
                    y: parent.height - 24
                    width: parent.width * 0.43
                    text: modelData.state + "  ·  " + modelData.progress
                    color: modelData.state === "READY" ? root.green
                           : modelData.state === "WARNING" ? root.red : root.amber
                    font.family: "B612 Mono"
                    font.pixelSize: 12
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }

                Rectangle {
                    x: 12
                    y: parent.height - 4
                    width: parent.width - 20
                    height: 0.7
                    radius: 0
                    color: modelData.state === "COMPLETED" ? root.muted
                           : modelData.state === "READY" ? root.green
                           : modelData.state === "WARNING" ? root.red : root.amber
                }

                MouseArea {
                    id: cardDragArea
                    anchors.fill: parent
                    z: 1
                    preventStealing: true
                    onPressed: root.dragStarted(index, cardDragArea.mapToItem(cardGrid, mouse.x, mouse.y).x, cardDragArea.mapToItem(cardGrid, mouse.x, mouse.y).y)
                    onPositionChanged: if (pressed) root.dragMoved(index, cardDragArea.mapToItem(cardGrid, mouse.x, mouse.y).x, cardDragArea.mapToItem(cardGrid, mouse.x, mouse.y).y)
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
        width: root.settingsPopupPreferredWidth
        height: Math.min(620, Math.max(360, parent.height * 2))
        x: Math.max(12, parent.width - width - 16)
        y: parent.height - height - 8
        radius: 4
        color: "#08111D"
        border.color: root.cyan
        border.width: 1

        Text {
            id: settingsTitle
            x: 14
            y: 12
            width: parent.width - 52
            text: "ПАРАМЕТРЫ КАРТОЧКИ · ДО 8"
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
                        height: 42
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
                            font.pixelSize: 13
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
