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

    property color bg: "transparent"
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
    // Reference point for normal cruise engine load; adjust to the aircraft profile.
    property real engineCruisePercent: 60

    function formatMissionTime(value) {
        var total = Math.max(0, Math.floor(Number(value) || 0))
        var hours = Math.floor(total / 3600)
        var minutes = Math.floor((total % 3600) / 60)
        var seconds = total % 60
        function twoDigits(n) { return n < 10 ? "0" + n : "" + n }
        return hours > 0
                ? twoDigits(hours) + ":" + twoDigits(minutes) + ":" + twoDigits(seconds)
                : twoDigits(minutes) + ":" + twoDigits(seconds)
    }

    function missionProgress(data) {
        var total = Math.max(1, Number(data.missionTotalSeconds) || 1)
        var remaining = Math.max(0, Number(data.missionRemainingSeconds) || 0)
        return Math.max(0, Math.min(1, 1 - remaining / total))
    }

    function blendColor(fromColor, toColor, amount) {
        var t = Math.max(0, Math.min(1, amount))
        return Qt.rgba(fromColor.r + (toColor.r - fromColor.r) * t,
                       fromColor.g + (toColor.g - fromColor.g) * t,
                       fromColor.b + (toColor.b - fromColor.b) * t, 1)
    }

    function engineLoadColor(value) {
        var p = Math.max(0, Math.min(100, Number(value)))
        var gray = Qt.color("#7F8994")
        var blue = Qt.color("#39A9FF")
        var green = Qt.color("#64D98A")
        var red = Qt.color("#FF3B35")
        var cruise = Math.max(1, Math.min(99, root.engineCruisePercent))
        if (p <= 0)
            return gray
        if (p < cruise * 0.5)
            return blendColor(gray, blue, p / (cruise * 0.5))
        if (p < cruise)
            return blendColor(blue, green, (p - cruise * 0.5) / (cruise * 0.5))
        return blendColor(green, red, (p - cruise) / (100 - cruise))
    }

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
        property real cardHeight: Math.min(root.height - 12, 66 + root.maxParameterRows * 20)
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

                    Item {
                        width: 12
                        height: 24

                        Image {
                            anchors.centerIn: parent
                            width: 12
                            height: 12
                            source: "icons8-menu-24.svg"
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }
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
                    height: parent.height - 84

                    // Local illustrative asset selected by aircraft class.
                    Image {
                        id: aircraftImage
                        anchors.centerIn: parent
                        width: Math.min(parent.width - 8, 124)
                        height: Math.min(parent.height - 8, 92)
                        source: modelData.imageSource
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                        asynchronous: true
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
                                anchors.top: parent.top
                                anchors.topMargin: 1
                                text: modelData.label
                                color: root.secondary
                                font.family: "IBM Plex Sans Condensed"
                                font.pixelSize: Math.max(10, Math.min(12, cardRoot.width / 38))
                            }

                            Text {
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.topMargin: 1
                                text: modelData.value
                                color: root.text
                                font.family: "B612"
                                font.pixelSize: Math.max(11, Math.min(13, cardRoot.width / 35))
                                horizontalAlignment: Text.AlignRight
                            }

                            Rectangle {
                                visible: modelData.key === "ENG"
                                x: 0
                                y: parent.height - 3
                                width: parent.width
                                height: 2
                                radius: 1
                                color: "#20384A"

                                Rectangle {
                                    x: 0
                                    y: 0
                                    width: Math.max(2, parent.width * Math.max(0, Math.min(100, Number(cardRoot.modelData.engine))) / 100)
                                    height: parent.height
                                    radius: 1
                                    color: root.engineLoadColor(cardRoot.modelData.engine)
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
                    id: missionRemainingLabel
                    x: 12
                    y: parent.height - 23
                    width: parent.width - 24
                    text: root.formatMissionTime(modelData.missionRemainingSeconds)
                    color: root.secondary
                    font.family: "B612 Mono"
                    font.pixelSize: 10
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id: aircraftStateLabel
                    x: aircraftArea.x
                    y: parent.height - 42
                    width: aircraftArea.width
                    text: modelData.state === "STBY" ? "STBY"
                          : modelData.state === "READY" ? "READY"
                          : modelData.state
                    color: modelData.state === "READY" ? root.green
                           : modelData.state === "STBY" ? root.cyan
                           : modelData.state === "WARNING" ? root.red : root.amber
                    font.family: "B612 Mono"
                    font.pixelSize: Math.max(11, Math.min(13, cardRoot.width / 30))
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                }

                // Mission completion indicator: a 0.5 px full-width track and progress fill.
                Rectangle {
                    id: missionProgressTrack
                    x: 0
                    y: parent.height - 0.5
                    width: parent.width
                    height: 0.5
                    radius: 0
                    color: root.divider

                    Rectangle {
                        x: 0
                        y: 0
                        width: parent.width * root.missionProgress(cardRoot.modelData)
                        height: parent.height
                        radius: 0
                        color: cardRoot.modelData.state === "WARNING" ? root.red : root.green
                    }
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
