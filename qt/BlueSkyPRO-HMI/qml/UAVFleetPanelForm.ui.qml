import QtQuick

Item {
    id: root

    property var uavModel: []
    property int selectedIndex: -1
    property int settingsIndex: -1
    property var settingsParameters: ["ALT", "SPD", "BAT", "ENG"]
    property bool settingsOpen: false

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

    readonly property var availableParameters: [
        "ALT", "SPD", "BAT", "ENG",
        "WIND", "HDG", "ETA", "C2", "CAM",
        "RNG", "EET", "TRIP", "TOT", "GNSS",
        "LINK", "WP", "PROGRESS", "BAT HEALTH",
        "PAYLOAD", "TELEM"
    ]

    signal uavSelected(int index)
    signal uavDoubleClicked(int index)
    signal settingsRequested(int index)
    signal reorderRequested(int fromIndex, int toIndex)
    signal parameterToggleRequested(string parameter)
    signal parameterMoveRequested(string parameter, int direction)
    signal applyToAllRequested()
    signal settingsClosed()

    function parameterLabel(key, data) {
        if (key === "ALT")
            return data.height < 100 ? "HGT" : "ALT"
        if (key === "SPD") return "SPD"
        if (key === "BAT") return "BAT"
        if (key === "ENG") return "ENG"
        if (key === "WIND") return "WIND"
        if (key === "HDG") return "HDG"
        if (key === "ETA") return "ETA"
        if (key === "C2") return "C2"
        if (key === "CAM") return "CAM"
        if (key === "RNG") return "RNG"
        if (key === "EET") return "EET"
        if (key === "TRIP") return "TRIP"
        if (key === "TOT") return "TOT"
        if (key === "GNSS") return "GNSS"
        if (key === "LINK") return "LINK"
        if (key === "WP") return "WP"
        if (key === "PROGRESS") return "MISSION"
        if (key === "BAT HEALTH") return "BAT HLTH"
        if (key === "PAYLOAD") return "LOAD"
        if (key === "TELEM") return "TELEM"
        return key
    }

    function parameterValue(key, data) {
        if (key === "ALT") return Math.round(data.height) + " m"
        if (key === "SPD") return data.speed + " km/h"
        if (key === "BAT") return data.battery + " %"
        if (key === "ENG") return data.engine + " %"
        if (key === "WIND") return data.wind
        if (key === "HDG") return data.heading + "°"
        if (key === "ETA") return data.eta
        if (key === "C2") return data.c2
        if (key === "CAM") return data.camera
        if (key === "RNG") return data.range
        if (key === "EET") return data.eet
        if (key === "TRIP") return data.trip
        if (key === "TOT") return data.tot
        if (key === "GNSS") return data.gnss
        if (key === "LINK") return data.link
        if (key === "WP") return data.wp
        if (key === "PROGRESS") return data.progress
        if (key === "BAT HEALTH") return data.batteryHealth
        if (key === "PAYLOAD") return data.payload
        if (key === "TELEM") return data.telemetry
        return "—"
    }

    Rectangle {
        anchors.fill: parent
        color: root.bg
    }

    Grid {
        id: cardGrid
        property int gap: 12
        property int minCardWidth: 320
        property int columns: Math.max(1, Math.floor((root.width + gap) / (minCardWidth + gap)))
        property real cardWidth: (root.width - (columns - 1) * gap) / columns
        property real cardHeight: Math.min(340, Math.max(300, root.height * 0.40))
        columns: Math.max(1, Math.ceil(root.uavModel.length / Math.max(1, columns))) // layout is reset below by binding
        columns: Math.max(1, Math.floor((root.width + gap) / (minCardWidth + gap)))
        spacing: gap
        width: root.width - 20
        x: 10
        anchors.verticalCenter: parent.verticalCenter
        height: Math.ceil(root.uavModel.length / columns) * cardHeight
                + Math.max(0, Math.ceil(root.uavModel.length / columns) - 1) * spacing

        Repeater {
            id: cardRepeater
            model: root.uavModel

            delegate: Rectangle {
                id: cardRoot
                required property int index
                required property var modelData

                width: cardGrid.cardWidth
                height: cardGrid.cardHeight
                radius: 5
                color: index === root.selectedIndex ? root.selectedSurface : root.card
                border.color: index === root.selectedIndex ? root.cyan : root.divider
                border.width: index === root.selectedIndex ? 2 : 1

                property bool dragging: false
                property real dragOffsetX: 0
                property real dragOffsetY: 0
                property real pressX: 0
                property real pressY: 0
                property int dragTargetIndex: index

                transform: Translate { x: cardRoot.dragOffsetX; y: cardRoot.dragOffsetY }
                z: dragging ? 100 : 0

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

                    // Neutral local placeholder until the configured UAV image is available.
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
                        model: root.settingsOpen && root.settingsIndex === index
                               ? root.settingsParameters
                               : root.parameterListFor(index)

                        delegate: Item {
                            required property string modelData
                            width: metricColumn.width
                            height: metricColumn.height / Math.max(1, root.parameterListFor(cardRoot.index).length)

                            Text {
                                id: metricLabel
                                anchors.left: parent.left
                                anchors.top: parent.top
                                text: root.parameterLabel(modelData, cardRoot.modelData)
                                color: root.secondary
                                font.family: "B612 Mono"
                                font.pixelSize: 12
                            }

                            Text {
                                anchors.right: parent.right
                                anchors.top: parent.top
                                text: root.parameterValue(modelData, cardRoot.modelData)
                                color: root.text
                                font.family: "B612 Mono"
                                font.pixelSize: 13
                                horizontalAlignment: Text.AlignRight
                            }

                            Rectangle {
                                visible: modelData === "ENG"
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
                    color: modelData.state === "READY" ? root.green : modelData.state === "WARNING" ? root.red : root.amber
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
                    property bool moved: false

                    onPressed: {
                        cardRoot.pressX = mouse.x
                        cardRoot.pressY = mouse.y
                        cardRoot.dragOffsetX = 0
                        cardRoot.dragOffsetY = 0
                        cardRoot.dragTargetIndex = index
                        cardRoot.dragging = false
                        moved = false
                    }

                    onPositionChanged: {
                        if (!pressed)
                            return
                        var dx = mouse.x - cardRoot.pressX
                        var dy = mouse.y - cardRoot.pressY
                        if (!cardRoot.dragging && (Math.abs(dx) > 10 || Math.abs(dy) > 10))
                            cardRoot.dragging = true
                        if (!cardRoot.dragging)
                            return

                        cardRoot.dragOffsetX = dx
                        cardRoot.dragOffsetY = dy
                        moved = true

                        var p = cardDragArea.mapToItem(cardGrid, mouse.x, mouse.y)
                        var col = Math.max(0, Math.min(cardGrid.columns - 1,
                            Math.floor(p.x / (cardGrid.cardWidth + cardGrid.spacing))))
                        var row = Math.max(0, Math.floor(p.y / (cardGrid.cardHeight + cardGrid.spacing)))
                        var target = Math.max(0, Math.min(root.uavModel.length - 1,
                            row * cardGrid.columns + col))
                        cardRoot.dragTargetIndex = target
                    }

                    onReleased: {
                        var wasDragged = cardRoot.dragging
                        cardRoot.dragging = false
                        cardRoot.dragOffsetX = 0
                        cardRoot.dragOffsetY = 0
                        if (wasDragged) {
                            root.reorderRequested(index, cardRoot.dragTargetIndex)
                        } else {
                            root.uavSelected(index)
                        }
                    }

                    onDoubleClicked: root.uavDoubleClicked(index)
                    onCanceled: {
                        cardRoot.dragging = false
                        cardRoot.dragOffsetX = 0
                        cardRoot.dragOffsetY = 0
                    }
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
                    model: root.availableParameters

                    delegate: Rectangle {
                        required property string modelData
                        width: settingsColumn.width
                        height: 30
                        color: root.settingsParameters.indexOf(modelData) >= 0 ? root.selectedSurface : "transparent"

                        Text {
                            x: 8
                            anchors.verticalCenter: parent.verticalCenter
                            text: (root.settingsParameters.indexOf(modelData) >= 0 ? "☑" : "☐")
                                  + "  " + root.parameterLabel(modelData, root.uavModel[Math.max(0, root.settingsIndex)])
                            color: root.settingsParameters.indexOf(modelData) >= 0 ? root.text : root.secondary
                            font.family: "B612"
                            font.pixelSize: 11
                        }

                        Text {
                            anchors.right: upButton.left
                            anchors.rightMargin: 6
                            anchors.verticalCenter: parent.verticalCenter
                            text: "↑"
                            color: root.settingsParameters.indexOf(modelData) >= 0 ? root.cyan : root.muted
                            font.pixelSize: 14
                        }
                        MouseArea {
                            anchors.right: upButton.left
                            anchors.rightMargin: 2
                            width: 24
                            height: parent.height
                            enabled: root.settingsParameters.indexOf(modelData) >= 0
                            onClicked: root.parameterMoveRequested(modelData, -1)
                        }

                        Text {
                            id: upButton
                            anchors.right: downButton.left
                            anchors.rightMargin: 2
                            anchors.verticalCenter: parent.verticalCenter
                            text: "↑"
                            color: root.settingsParameters.indexOf(modelData) >= 0 ? root.cyan : root.muted
                            font.pixelSize: 14
                        }
                        MouseArea {
                            anchors.right: downButton.left
                            anchors.rightMargin: 2
                            width: 24
                            height: parent.height
                            enabled: root.settingsParameters.indexOf(modelData) >= 0
                            onClicked: root.parameterMoveRequested(modelData, -1)
                        }

                        Text {
                            id: downButton
                            anchors.right: parent.right
                            anchors.rightMargin: 6
                            anchors.verticalCenter: parent.verticalCenter
                            text: "↓"
                            color: root.settingsParameters.indexOf(modelData) >= 0 ? root.cyan : root.muted
                            font.pixelSize: 14
                        }
                        MouseArea {
                            anchors.right: parent.right
                            anchors.rightMargin: 2
                            width: 24
                            height: parent.height
                            enabled: root.settingsParameters.indexOf(modelData) >= 0
                            onClicked: root.parameterMoveRequested(modelData, 1)
                        }

                        MouseArea {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            z: -1
                            onClicked: root.parameterToggleRequested(modelData)
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
