import QtQuick

Item {
    id: root

    // Flight Chart visual prototype. This is a schematic HMI layer only:
    // it does not load geographic tiles or provide operational navigation data.
    property color bg: "#050A12"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color muted: "#718096"
    property color cyan: "#32FFFF"
    property color green: "#64FF00"
    property color amber: "#FFD339"
    property color divider: "#263747"
    property bool missionVisible: true
    property bool manualCreationMode: false
    property bool manualCompositionComplete: false
    signal manualCompositionCompleted()
    signal mapDoubleClicked()

    Rectangle {
        anchors.fill: parent
        color: root.bg
    }

    // Subtle engineering grid to establish the map workspace.
    Repeater {
        model: Math.max(0, Math.floor(root.width / 64))
        delegate: Rectangle {
            x: index * 64
            y: 0
            width: 1
            height: root.height
            color: "#101D2A"
            opacity: 0.8
        }
    }
    Repeater {
        model: Math.max(0, Math.floor(root.height / 64))
        delegate: Rectangle {
            x: 0
            y: index * 64
            width: root.width
            height: 1
            color: "#101D2A"
            opacity: 0.8
        }
    }

    // Schematic no-fly / restricted area. Not a real georeferenced zone.
    Rectangle {
        visible: root.missionVisible
        x: root.width * 0.60
        y: root.height * 0.22
        width: Math.min(190, root.width * 0.20)
        height: Math.min(150, root.height * 0.24)
        radius: 3
        color: "#3D151B"
        opacity: 0.55
        border.color: "#FF514A"
        border.width: 1

        Repeater {
            model: 5
            delegate: Rectangle {
                x: 8
                y: 14 + index * 24
                width: parent.width - 16
                height: 1
                color: "#FF514A"
                opacity: 0.5
            }
        }

        Text {
            anchors.centerIn: parent
            text: "RESTRICTED AREA"
            color: "#FF8B85"
            font.family: "B612 Mono"
            font.pixelSize: 9
        }
    }

    // Route is intentionally schematic until a geographic map/data source is connected.
    Canvas {
        id: routeCanvas
        anchors.fill: parent
        visible: root.missionVisible
        renderTarget: Canvas.Image
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var p0 = { x: width * 0.16, y: height * 0.72 }
            var p1 = { x: width * 0.30, y: height * 0.54 }
            var p2 = { x: width * 0.43, y: height * 0.62 }
            var p3 = { x: width * 0.53, y: height * 0.43 }
            var p4 = { x: width * 0.76, y: height * 0.68 }

            ctx.beginPath()
            ctx.moveTo(p0.x, p0.y)
            ctx.lineTo(p1.x, p1.y)
            ctx.lineTo(p2.x, p2.y)
            ctx.lineTo(p3.x, p3.y)
            ctx.lineTo(p4.x, p4.y)
            ctx.lineWidth = 2
            ctx.strokeStyle = "#32FFFF"
            ctx.stroke()

            // Planned route dashes and small cross-track tick marks.
            ctx.setLineDash([5, 6])
            ctx.lineWidth = 1
            ctx.strokeStyle = "#B6FFFF"
            ctx.beginPath()
            ctx.moveTo(p3.x, p3.y)
            ctx.lineTo(p4.x, p4.y)
            ctx.stroke()
            ctx.setLineDash([])

            var points = [p0, p1, p2, p3, p4]
            for (var i = 0; i < points.length; ++i) {
                ctx.beginPath()
                ctx.arc(points[i].x, points[i].y, i === 0 || i === points.length - 1 ? 5 : 4, 0, Math.PI * 2)
                ctx.fillStyle = i === 0 ? "#64FF00" : (i === points.length - 1 ? "#FFD339" : "#32FFFF")
                ctx.fill()
                ctx.lineWidth = 1
                ctx.strokeStyle = "#050A12"
                ctx.stroke()
            }
        }
    }

    onWidthChanged: routeCanvas.requestPaint()
    onHeightChanged: routeCanvas.requestPaint()
    onMissionVisibleChanged: routeCanvas.requestPaint()

    Text {
        visible: root.missionVisible
        x: 18
        y: 16
        text: "FLIGHT CHART"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 14
        font.bold: true
    }

    Rectangle {
        visible: root.missionVisible
        x: 18
        y: 42
        width: 106
        height: 22
        color: "#0C1725"
        border.color: root.divider
        border.width: 1
        Text {
            anchors.centerIn: parent
            text: "SCHEMATIC VIEW"
            color: root.amber
            font.family: "B612 Mono"
            font.pixelSize: 8
        }
    }

    Row {
        visible: root.missionVisible
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 18
        spacing: 14

        Repeater {
            model: [
                { label: "START", color: "#64FF00" },
                { label: "WAYPOINT", color: "#32FFFF" },
                { label: "FINISH", color: "#FFD339" },
                { label: "RESTRICTED", color: "#FF514A" }
            ]
            delegate: Row {
                spacing: 5
                Rectangle {
                    width: 7
                    height: 7
                    radius: 4
                    anchors.verticalCenter: parent.verticalCenter
                    color: modelData.color
                }
                Text {
                    text: modelData.label
                    color: root.secondary
                    font.family: "B612 Mono"
                    font.pixelSize: 8
                }
            }
        }
    }

    // Wind indicator: illustrative only, not live weather data.
    Rectangle {
        visible: root.missionVisible
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 18
        width: 126
        height: 58
        color: "#08111D"
        border.color: root.divider
        border.width: 1

        Column {
            anchors.centerIn: parent
            spacing: 4
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "WIND"
                color: root.secondary
                font.family: "B612 Mono"
                font.pixelSize: 9
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "↗  — m/s"
                color: root.cyan
                font.family: "B612 Mono"
                font.pixelSize: 12
            }
        }
    }

    Text {
        visible: root.missionVisible
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 18
        text: "SCHEMATIC ROUTE • NOT FOR FLIGHT EXECUTION"
        color: root.muted
        font.family: "B612 Mono"
        font.pixelSize: 9
    }

    Text {
        visible: !root.missionVisible && !root.manualCreationMode
        anchors.centerIn: parent
        text: "НЕТ АКТИВНОЙ МИССИИ"
        color: root.muted
        font.family: "B612 Mono"
        font.pixelSize: 12
    }

    Text {
        visible: root.manualCreationMode
        anchors.horizontalCenter: parent.horizontalCenter
        y: 16
        text: "РУЧНОЕ СОЗДАНИЕ МИССИИ · M"
        color: root.green
        font.family: "B612 Mono"
        font.pixelSize: 12
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onDoubleClicked: root.mapDoubleClicked()
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
        title: "MAP SETTINGS"
        tools: ["Base Map", "Airspace / Restrictions", "NOTAM", "Weather Layers", "Route / Waypoints", "UAV Display", "Planned / Actual Track", "Map Interaction"]
        onClosed: open = false
    }
}
