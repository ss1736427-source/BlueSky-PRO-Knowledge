import QtQuick
import QtCore

Item {
    id: root
    property string missionId: ""
    property string missionSummary: ""
    property string missionReviewState: ""
    property var missionTemplateIndices: []
    signal closeRequested()
    signal applyRequested()

    readonly property color bg: "#07111E"
    readonly property color panel: "#0B1B2B"
    readonly property color line: "#174056"
    readonly property color cyan: "#00DDF2"
    readonly property color textColor: "#DCE8F2"
    readonly property color muted: "#91A8BA"
    readonly property color switchGreen: "#39D353"
    property bool parameterPanelOpen: true
    property real tableSplitRatio: 0.47
    // Live telemetry inputs; connect these to the flight-data source when available.
    property bool liveFlightActive: false
    // Design-time marker keeps the aircraft visible in Qt Design Studio.
    // A connected telemetry feed overrides this preview position.
    property bool showAircraftPreview: true
    property real previewDistanceKm: 46.7
    property real previewAltitudeM: 180
    property real liveDistanceKm: 0
    property real liveElapsedSeconds: 0
    property real liveAltitudeM: 0
    property bool mandatoryPointSet: false
    property real mandatoryProgress: 0.60
    property real mandatoryAltitudeM: 180
    property int mandatoryRouteIndex: -1
    readonly property real plannedDistanceKm: 78.4
    readonly property real plannedDurationSeconds: 78 * 60
    property var parameterVisibility: ({
        course: true, distance: true, altitude: true, airspeed: true,
        groundspeed: true, time: true, deltaHeight: true, energy: true, note: true
    })
    property var columns: [
        { label: "#", w: 0.035, key: "number" },
        { label: "ТИП", w: 0.075, key: "type" },
        { label: "ТОЧКА / ШИРОТА, ДОЛГОТА", w: 0.17, key: "point" },
        { label: "КУРС\n°", w: 0.065, key: "course" },
        { label: "ДИСТАНЦИЯ\nкм", w: 0.075, key: "distance" },
        { label: "ВЫСОТА\nм", w: 0.075, key: "altitude" },
        { label: "V_ВОЗД\nм/с", w: 0.075, key: "airspeed" },
        { label: "V_ПУТ\nм/с", w: 0.075, key: "groundspeed" },
        { label: "ВРЕМЯ\nмин", w: 0.075, key: "time" },
        { label: "Δh\nм", w: 0.06, key: "deltaHeight" },
        { label: "ЭНЕРГИЯ\n%", w: 0.07, key: "energy" },
        { label: "ПРИМЕЧАНИЕ", w: 0.15, key: "note" }
    ]
    property var columnOrder: ["number", "type", "point", "course", "distance", "altitude",
                               "airspeed", "groundspeed", "time", "deltaHeight", "energy", "note"]
    function orderedColumns() {
        var result = []
        for (var i = 0; i < root.columnOrder.length; ++i)
            for (var j = 0; j < root.columns.length; ++j)
                if (root.columns[j].key === root.columnOrder[i]) result.push(root.columns[j])
        return result
    }
    function columnAtX(x) {
        var all = root.orderedColumns()
        var cursor = 0
        var candidates = []
        for (var i = 0; i < all.length; ++i) {
            var left = cursor
            cursor += all[i].w * tableHeader.width
            if (root.parameterVisibility[all[i].key] !== false) {
                candidates.push({ key: all[i].key, center: (left + cursor) / 2 })
            }
        }
        if (candidates.length === 0) return ""
        for (var j = 0; j < candidates.length; ++j)
            if (x < candidates[j].center) return candidates[j].key
        return candidates[candidates.length - 1].key
    }
    function moveColumn(fromKey, toKey) {
        if (!fromKey || !toKey || fromKey === toKey) return
        var next = root.columnOrder.slice(0)
        var from = next.indexOf(fromKey), to = next.indexOf(toKey)
        if (from < 0 || to < 0) return
        next.splice(from, 1)
        next.splice(to, 0, fromKey)
        root.columnOrder = next
        profileSettings.columnOrderJson = JSON.stringify(next)
    }
    function columnValue(rowIndex, key) {
        var row = routeModel.get(rowIndex)
        if (!row) return ""
        var values = {
            number: String(rowIndex + 1), type: rowIndex === root.mandatoryRouteIndex ? "Обязательная" : row.pointType,
            point: row.pointName + "\n" + row.coordinates,
            course: row.course, distance: row.distance, altitude: row.altitude,
            airspeed: row.airspeed, groundspeed: row.groundspeed, time: row.time,
            deltaHeight: row.deltaHeight, energy: row.energy, note: row.note
        }
        return values[key] === undefined ? "" : values[key]
    }
    function parameterKey(i) {
        return ["number", "type", "point", "course", "distance", "altitude",
                "airspeed", "groundspeed", "time", "deltaHeight", "energy", "note"][i]
    }
    function toggleParameter(key) {
        var next = Object.assign({}, root.parameterVisibility)
        next[key] = !next[key]
        root.parameterVisibility = next
    }

    Settings {
        id: profileSettings
        category: "BlueSkyPRO/MissionProfile"
        property string columnOrderJson: ""
        property real tableSplitRatio: 0.47
        property bool mandatoryPointSet: false
        property real mandatoryProgress: 0.60
        property real mandatoryAltitudeM: 180
        property int mandatoryRouteIndex: -1
    }

    Component.onCompleted: {
        root.tableSplitRatio = Math.max(0.25, Math.min(0.75, profileSettings.tableSplitRatio))
        root.mandatoryPointSet = profileSettings.mandatoryPointSet
        root.mandatoryProgress = Math.max(0, Math.min(1, profileSettings.mandatoryProgress))
        root.mandatoryAltitudeM = Math.max(0, Math.min(400, profileSettings.mandatoryAltitudeM))
        root.mandatoryRouteIndex = profileSettings.mandatoryRouteIndex
        if (root.mandatoryRouteIndex >= routeModel.count) root.mandatoryRouteIndex = -1
        if (profileSettings.columnOrderJson.length > 0) {
            try {
                var saved = JSON.parse(profileSettings.columnOrderJson)
                if (Array.isArray(saved) && saved.length === root.columns.length)
                    root.columnOrder = saved
            } catch (e) { }
        }
    }

    onTableSplitRatioChanged: profileSettings.tableSplitRatio = tableSplitRatio
    onMandatoryPointSetChanged: profileSettings.mandatoryPointSet = mandatoryPointSet
    onMandatoryProgressChanged: profileSettings.mandatoryProgress = mandatoryProgress
    onMandatoryAltitudeMChanged: profileSettings.mandatoryAltitudeM = mandatoryAltitudeM
    onMandatoryRouteIndexChanged: profileSettings.mandatoryRouteIndex = mandatoryRouteIndex

    anchors.fill: parent
    z: 80
    visible: root.visible

    Rectangle {
        anchors.fill: parent
        color: "#B8000710"
    }

    Rectangle {
        id: dialog
        width: Math.min(1540, parent.width - 18)
        height: Math.min(900, parent.height - 16)
        anchors.centerIn: parent
        color: root.bg
        border.color: root.cyan
        border.width: 1
        radius: 5

        Column {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 7

            Rectangle {
                id: titleBar
                width: parent.width
                height: 34
                color: root.panel
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    y: (parent.height - height) / 2
                    text: "ПРОФИЛЬ МИССИИ"
                    color: root.cyan
                    font.family: "B612"
                    font.pixelSize: 15
                    font.bold: true
                }
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 205
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.missionId
                    color: root.cyan
                    font.family: "B612 Mono"
                    font.pixelSize: 12
                }
                // When the parameter panel is collapsed, keep its tools button
                // visible in the title bar, immediately left of the close button.
                Text {
                    id: collapsedToolsToggle
                    visible: !root.parameterPanelOpen
                    anchors.right: parent.right
                    anchors.rightMargin: 42
                    anchors.verticalCenter: parent.verticalCenter
                    text: "☰"
                    color: root.cyan
                    font.pixelSize: 22
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -8
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.parameterPanelOpen = true
                    }
                }
                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    text: "×"
                    color: root.cyan
                    font.pixelSize: 22
                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -7
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.closeRequested()
                    }
                }
            }

            Row {
                id: contentRow
                width: parent.width
                height: parent.height - titleBar.height - 7
                spacing: 8

                Column {
                    id: mainColumn
                    width: parent.width - parameterPanel.width - parent.spacing
                    height: parent.height
                    spacing: 0

                    Rectangle {
                        id: tablePanel
                        width: parent.width
                        height: Math.round((mainColumn.height - splitHandle.height) * root.tableSplitRatio)
                        color: root.bg
                        border.color: root.line
                        radius: 3

                        Column {
                            anchors.fill: parent
                            spacing: 0

                            Row {
                                id: tableHeader
                                width: parent.width
                                height: 40
                                spacing: 0
                                Repeater {
                                    model: root.orderedColumns()
                                    delegate: Rectangle {
                                        id: headerCell
                                        width: tableHeader.width * modelData.w
                                        height: tableHeader.height
                                        visible: root.parameterVisibility[modelData.key] !== false
                                        color: headerDragArea.pressed ? "#12394A" : "#0B1B2B"
                                        border.color: root.line
                                        Text {
                                            anchors.fill: parent
                                            anchors.margins: 3
                                            text: modelData.label
                                            color: root.textColor
                                            font.family: "B612"
                                            font.pixelSize: 10
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            wrapMode: Text.Wrap
                                        }
                                        MouseArea {
                                            id: headerDragArea
                                            anchors.fill: parent
                                            cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                                            drag.target: null
                                            property real pressX: 0
                                            property real pressY: 0
                                            property bool didDrag: false

                                            onPressed: {
                                                pressX = mouse.x
                                                pressY = mouse.y
                                                didDrag = false
                                            }

                                            onPositionChanged: {
                                                if (pressed &&
                                                    (Math.abs(mouse.x - pressX) > Qt.styleHints.startDragDistance ||
                                                     Math.abs(mouse.y - pressY) > Qt.styleHints.startDragDistance)) {
                                                    didDrag = true
                                                }
                                            }

                                            onReleased: {
                                                if (!didDrag) return
                                                var p = headerDragArea.mapToItem(tableHeader, mouse.x, mouse.y)
                                                root.moveColumn(modelData.key, root.columnAtX(p.x))
                                            }
                                        }
                                    }
                                }
                            }

                            ListView {
                                id: routeTable
                                width: parent.width
                                height: parent.height - tableHeader.height
                                clip: true
                                model: routeModel
                                delegate: Row {
                                    id: routeRowDelegate
                                    width: routeTable.width
                                    height: Math.max(37, Math.min(48, routeTable.height / 6))
                                    spacing: 0
                                    property int rowIndex: index
                                    Repeater {
                                        model: root.orderedColumns()
                                        delegate: Rectangle {
                                            width: routeTable.width * modelData.w
                                            height: parent.height
                                            visible: root.parameterVisibility[modelData.key] !== false
                                            color: routeTable.currentIndex === routeRowDelegate.rowIndex ? "#102B3A" : (rowIndex % 2 ? "#091725" : "#0C1D2C")
                                            border.color: root.line
                                            Text {
                                                anchors.fill: parent
                                                anchors.margins: 4
                                                text: root.columnValue(routeRowDelegate.rowIndex, modelData.key)
                                                color: modelData.key === "energy" ? (Number(root.columnValue(routeRowDelegate.rowIndex, modelData.key)) > 70 ? "#64FF00" : "#FFD339") : root.textColor
                                                font.family: "B612"
                                                font.pixelSize: 10
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                wrapMode: Text.Wrap
                                                elide: Text.ElideRight
                                            }
                                            // Altitude cells are editable in the design preview.
                                            Rectangle {
                                                visible: modelData.key === "altitude"
                                                anchors.fill: parent
                                                anchors.margins: 5
                                                color: "transparent"
                                                border.color: "#31566A"
                                                radius: 2
                                                TextInput {
                                                    anchors.fill: parent
                                                    anchors.margins: 2
                                                    text: root.columnValue(routeRowDelegate.rowIndex, "altitude")
                                                    color: root.textColor
                                                    font.family: "B612 Mono"
                                                    font.pixelSize: 11
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    selectByMouse: true
                                                    validator: IntValidator { bottom: 0; top: 5000 }
                                                    onEditingFinished: routeModel.setProperty(routeRowDelegate.rowIndex, "altitude", text)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Transparent vertical splitter: drag up/down to resize the
                    // table viewport and the flight-profile plot proportionally.
                    Item {
                        id: splitHandle
                        width: parent.width
                        height: 1
                        z: 2

                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.width
                            height: 1
                            color: splitMouse.containsMouse ? root.cyan : root.line
                            opacity: splitMouse.containsMouse ? 0.95 : 0.65
                        }

                        MouseArea {
                            id: splitMouse
                            anchors.fill: parent
                            // Keep a practical drag target while the visual gap is 1 px.
                            anchors.margins: -5
                            hoverEnabled: true
                            cursorShape: Qt.SplitVCursor
                            property real lastY: 0

                            onPressed: lastY = mouse.y
                            onPositionChanged: {
                                if (!pressed) return
                                var delta = mouse.y - lastY
                                lastY = mouse.y
                                var available = mainColumn.height - splitHandle.height
                                var minTable = 150
                                var minProfile = 190
                                var nextHeight = tablePanel.height + delta
                                nextHeight = Math.max(minTable, Math.min(available - minProfile, nextHeight))
                                root.tableSplitRatio = nextHeight / available
                            }
                        }
                    }

                    Rectangle {
                        id: profilePanel
                        width: parent.width
                        height: mainColumn.height - tablePanel.height - splitHandle.height
                        color: root.bg
                        border.color: root.line
                        radius: 3

                        Column {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 4
                            Row {
                                width: parent.width
                                height: 26
                                Text {
                                    text: "ПРОФИЛЬ ПОЛЁТА"
                                    color: root.cyan
                                    font.family: "B612"
                                    font.pixelSize: 15
                                    font.bold: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Item { width: 18; height: 1 }
                                Text {
                                    text: "━ Профиль маршрута     ▰ Рельеф местности     ┄ Ограничение высоты     ○ Точки маршрута     ➜ Ветер"
                                    color: root.muted
                                    font.family: "B612"
                                    font.pixelSize: 9
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            Canvas {
                                id: profileCanvas
                                width: parent.width
                                height: parent.height - 30
                                onWidthChanged: requestPaint()
                                onHeightChanged: requestPaint()
                                Connections {
                                    target: root
                                    function onLiveFlightActiveChanged() { profileCanvas.requestPaint() }
                                    function onLiveDistanceKmChanged() { profileCanvas.requestPaint() }
                                    function onLiveElapsedSecondsChanged() { profileCanvas.requestPaint() }
                                    function onLiveAltitudeMChanged() { profileCanvas.requestPaint() }
                                    function onMandatoryPointSetChanged() { profileCanvas.requestPaint() }
                                    function onMandatoryProgressChanged() { profileCanvas.requestPaint() }
                                    function onMandatoryAltitudeMChanged() { profileCanvas.requestPaint() }
                                    function onMandatoryRouteIndexChanged() { profileCanvas.requestPaint() }
                                }
                                onPaint: {
                                    var ctx = getContext("2d")
                                    ctx.clearRect(0, 0, width, height)
                                    var left = 42, right = width - 12, top = 18, bottom = height - 28
                                    var plotW = right - left, plotH = bottom - top
                                    ctx.strokeStyle = "#17384A"
                                    ctx.lineWidth = 1
                                    for (var gy = 0; gy <= 4; gy++) {
                                        var y = top + plotH * gy / 4
                                        ctx.beginPath(); ctx.moveTo(left, y); ctx.lineTo(right, y); ctx.stroke()
                                    }
                                    for (var gx = 0; gx <= 8; gx++) {
                                        var x = left + plotW * gx / 8
                                        ctx.beginPath(); ctx.moveTo(x, top); ctx.lineTo(x, bottom); ctx.stroke()
                                    }
                                    // Terrain area
                                    var terrain = [130,70,105,145,82,150,90,165,120,75,135,155,95,205,280,230,160,205,130,90,120,195]
                                    ctx.beginPath(); ctx.moveTo(left, bottom)
                                    for (var i = 0; i < terrain.length; i++) {
                                        var tx = left + plotW * i / (terrain.length - 1)
                                        var ty = bottom - (terrain[i] / 400) * plotH
                                        ctx.lineTo(tx, ty)
                                    }
                                    ctx.lineTo(right, bottom); ctx.closePath()
                                    ctx.fillStyle = "#294B2D"; ctx.fill()
                                    ctx.strokeStyle = "#64A83B"; ctx.lineWidth = 1; ctx.stroke()
                                    // Altitude restriction
                                    ctx.setLineDash([8, 5]); ctx.strokeStyle = "#FF3548"; ctx.lineWidth = 2
                                    ctx.beginPath(); ctx.moveTo(left, top + plotH * 0.12); ctx.lineTo(right, top + plotH * 0.12); ctx.stroke()
                                    ctx.setLineDash([])
                                    // Planned route profile
                                    var alts = []
                                    for (var ai = 0; ai < routeModel.count; ai++)
                                        alts.push(Number(routeModel.get(ai).altitude))
                                    ctx.beginPath()
                                    for (var p = 0; p < alts.length; p++) {
                                        var px = left + plotW * p / (alts.length - 1)
                                        var py = bottom - (alts[p] / 400) * plotH
                                        if (p === 0) ctx.moveTo(px, py); else ctx.lineTo(px, py)
                                    }
                                    ctx.strokeStyle = root.cyan; ctx.lineWidth = 3; ctx.stroke()
                                    for (var m = 0; m < alts.length; m++) {
                                        var mx = left + plotW * m / (alts.length - 1)
                                        var my = bottom - (alts[m] / 400) * plotH
                                        ctx.beginPath(); ctx.arc(mx, my, 4, 0, Math.PI * 2)
                                        var isMandatoryRoutePoint = root.mandatoryPointSet && root.mandatoryRouteIndex === m
                                        ctx.fillStyle = isMandatoryRoutePoint ? "#155BFF" : "#EAF7FF"; ctx.fill()
                                        ctx.strokeStyle = isMandatoryRoutePoint ? "#B8D4FF" : root.cyan; ctx.lineWidth = 2; ctx.stroke()
                                    }
                                    if (root.mandatoryPointSet) {
                                        var mandatoryX = left + plotW * root.mandatoryProgress
                                        var mandatoryY = bottom - (root.mandatoryAltitudeM / 400) * plotH
                                        ctx.strokeStyle = "#155BFF"; ctx.lineWidth = 2; ctx.setLineDash([4, 3])
                                        ctx.beginPath(); ctx.moveTo(mandatoryX, mandatoryY + 10); ctx.lineTo(mandatoryX, bottom); ctx.stroke()
                                        ctx.setLineDash([])
                                        ctx.beginPath(); ctx.arc(mandatoryX, mandatoryY, 9, 0, Math.PI * 2)
                                        ctx.fillStyle = "#155BFF"; ctx.fill()
                                        ctx.strokeStyle = "#B8D4FF"; ctx.lineWidth = 2; ctx.stroke()
                                        ctx.fillStyle = "#FFFFFF"; ctx.font = "bold 11px sans-serif"
                                        ctx.fillText("ОБЯЗАТЕЛЬНАЯ", Math.min(right - 100, mandatoryX + 13), Math.max(top + 13, mandatoryY - 13))
                                    }
                                    ctx.fillStyle = "#DCE8F2"; ctx.font = "11px sans-serif"
                                    ctx.fillText("Высота, м", 3, 12)
                                    // Time axis: elapsed mission time, from departure to planned ETA.
                                    ctx.fillText("Время полёта", Math.max(45, width / 2 - 35), height - 4)
                                    ctx.fillText("00:00", left - 18, bottom + 14)
                                    ctx.fillText("400", left - 32, top + 4)
                                    ctx.fillText("01:18", right - 24, bottom + 14)
                                    for (var ti = 1; ti < 8; ti++) {
                                        var totalMinutes = Math.floor(78 * ti / 8)
                                        var hours = Math.floor(totalMinutes / 60)
                                        var minutes = totalMinutes % 60
                                        var label = (hours < 10 ? "0" : "") + hours + ":" +
                                                    (minutes < 10 ? "0" : "") + minutes
                                        ctx.fillText(label, left + plotW * ti / 8 - 15, bottom + 14)
                                    }

                                    // Aircraft marker: live telemetry takes priority. In the
                                    // design preview, show a clearly marked sample position.
                                    if (root.liveFlightActive || root.showAircraftPreview) {
                                        var markerDistance = root.liveFlightActive ? root.liveDistanceKm : root.previewDistanceKm
                                        var progress = Math.max(0, Math.min(1, markerDistance / root.plannedDistanceKm))
                                        var seg = progress * (alts.length - 1)
                                        var segIndex = Math.min(alts.length - 2, Math.floor(seg))
                                        var frac = seg - segIndex
                                        var routeAlt = alts[segIndex] + (alts[segIndex + 1] - alts[segIndex]) * frac
                                        var markerAlt = root.liveFlightActive && root.liveAltitudeM > 0
                                                        ? root.liveAltitudeM
                                                        : (root.liveFlightActive ? routeAlt : root.previewAltitudeM)
                                        var aircraftX = left + plotW * progress
                                        var aircraftY = bottom - (markerAlt / 400) * plotH

                                        // Halo and vertical leader make the aircraft easy to locate.
                                        ctx.strokeStyle = "#FFFFFF"
                                        ctx.lineWidth = 1
                                        ctx.setLineDash([3, 3])
                                        ctx.beginPath()
                                        ctx.moveTo(aircraftX, aircraftY + 13)
                                        ctx.lineTo(aircraftX, bottom)
                                        ctx.stroke()
                                        ctx.setLineDash([])
                                        ctx.beginPath()
                                        ctx.arc(aircraftX, aircraftY, 13, 0, Math.PI * 2)
                                        ctx.fillStyle = "#00DDF2"
                                        ctx.fill()
                                        ctx.strokeStyle = "#FFFFFF"
                                        ctx.lineWidth = 2
                                        ctx.stroke()

                                        ctx.save()
                                        ctx.translate(aircraftX, aircraftY)
                                        ctx.rotate(-Math.PI / 2)
                                        ctx.fillStyle = "#07111E"
                                        ctx.strokeStyle = "#FFFFFF"
                                        ctx.lineWidth = 1.5
                                        ctx.beginPath()
                                        ctx.moveTo(0, -9)
                                        ctx.lineTo(6, 7)
                                        ctx.lineTo(0, 4)
                                        ctx.lineTo(-6, 7)
                                        ctx.closePath()
                                        ctx.fill()
                                        ctx.stroke()
                                        ctx.restore()

                                        ctx.fillStyle = "#FFFFFF"
                                        ctx.font = "bold 11px sans-serif"
                                        var aircraftLabel = root.liveFlightActive ? "БПЛА" : "БПЛА · ПРИМЕР"
                                        var labelWidth = ctx.measureText(aircraftLabel).width
                                        var labelX = Math.max(left, Math.min(right - labelWidth, aircraftX + 16))
                                        var labelY = Math.max(top + 14, aircraftY - 17)
                                        ctx.fillStyle = "#07111E"
                                        ctx.fillRect(labelX - 3, labelY - 11, labelWidth + 6, 16)
                                        ctx.fillStyle = "#FFFFFF"
                                        ctx.fillText(aircraftLabel, labelX, labelY)

                                        if (root.liveFlightActive) {
                                            var liveTime = Math.max(0, Math.floor(root.liveElapsedSeconds))
                                            var liveLabel = (Math.floor(liveTime / 3600) < 10 ? "0" : "") + Math.floor(liveTime / 3600) + ":" +
                                                            (Math.floor((liveTime % 3600) / 60) < 10 ? "0" : "") + Math.floor((liveTime % 3600) / 60)
                                            ctx.font = "10px sans-serif"
                                            ctx.fillText(liveLabel, Math.min(right - 35, aircraftX + 10), Math.max(top + 28, aircraftY + 25))
                                        }
                                    }
                                }

                                MouseArea {
                                    id: mandatoryPointMouse
                                    anchors.fill: parent
                                    z: 5
                                    hoverEnabled: true
                                    cursorShape: pressed ? Qt.ClosedHandCursor : Qt.CrossCursor
                                    property int dragRouteIndex: -1
                                    property real plotLeft: 42
                                    property real plotRight: width - 12
                                    property real plotTop: 18
                                    property real plotBottom: height - 28

                                    function updateMandatoryPoint(mouseX, mouseY) {
                                        var progress = Math.max(0, Math.min(1, (mouseX - plotLeft) / Math.max(1, plotRight - plotLeft)))
                                        var altitude = Math.max(0, Math.min(400, (plotBottom - mouseY) / Math.max(1, plotBottom - plotTop) * 400))
                                        root.mandatoryProgress = dragRouteIndex >= 0 ? dragRouteIndex / (routeModel.count - 1) : progress
                                        root.mandatoryAltitudeM = Math.round(altitude)
                                        root.mandatoryPointSet = true
                                        if (dragRouteIndex >= 0)
                                            routeModel.setProperty(dragRouteIndex, "altitude", String(root.mandatoryAltitudeM))
                                    }

                                    onPressed: {
                                        if (mouse.x < plotLeft || mouse.x > plotRight || mouse.y < plotTop || mouse.y > plotBottom) {
                                            mouse.accepted = false
                                            return
                                        }
                                        var progress = (mouse.x - plotLeft) / Math.max(1, plotRight - plotLeft)
                                        var routePosition = progress * (routeModel.count - 1)
                                        var nearest = Math.max(0, Math.min(routeModel.count - 1, Math.round(routePosition)))
                                        var nearestX = plotLeft + (plotRight - plotLeft) * nearest / (routeModel.count - 1)
                                        var nearestY = plotBottom - Number(routeModel.get(nearest).altitude) / 400 * (plotBottom - plotTop)
                                        var nearWaypoint = Math.abs(mouse.x - nearestX) <= 14 && Math.abs(mouse.y - nearestY) <= 16

                                        // Only start a new constraint when the operator clicks
                                        // on the route line or one of its waypoint markers.
                                        var lower = Math.max(0, Math.min(routeModel.count - 2, Math.floor(routePosition)))
                                        var fraction = routePosition - lower
                                        var lowerY = plotBottom - Number(routeModel.get(lower).altitude) / 400 * (plotBottom - plotTop)
                                        var upperY = plotBottom - Number(routeModel.get(lower + 1).altitude) / 400 * (plotBottom - plotTop)
                                        var routeY = lowerY + (upperY - lowerY) * fraction
                                        if (!nearWaypoint && Math.abs(mouse.y - routeY) > 16) {
                                            mouse.accepted = false
                                            return
                                        }

                                        dragRouteIndex = nearWaypoint ? nearest : -1
                                        root.mandatoryRouteIndex = dragRouteIndex
                                        if (nearWaypoint) {
                                            root.mandatoryProgress = nearest / (routeModel.count - 1)
                                            root.mandatoryAltitudeM = Number(routeModel.get(nearest).altitude)
                                            root.mandatoryPointSet = true
                                        } else {
                                            updateMandatoryPoint(mouse.x, mouse.y)
                                        }
                                    }
                                    onPositionChanged: {
                                        if (pressed) updateMandatoryPoint(mouse.x, mouse.y)
                                    }
                                    onReleased: dragRouteIndex = -1
                                }
                            }

                        }
                    }
                }

                Rectangle {
                    id: parameterPanel
                    width: root.parameterPanelOpen ? 270 : 0
                    height: parent.height
                    color: root.bg
                    border.color: root.line
                    radius: 3
                    Behavior on width { NumberAnimation { duration: 160 } }

                    Column {
                        anchors.fill: parent
                        anchors.margins: root.parameterPanelOpen ? 8 : 0
                        spacing: 8

                        Item {
                            width: parent.width
                            height: 38

                            Text {
                                visible: root.parameterPanelOpen
                                anchors.left: parent.left
                                anchors.right: panelToggle.left
                                anchors.rightMargin: 4
                                anchors.verticalCenter: parent.verticalCenter
                                text: "ОТОБРАЖЕНИЕ ПАРАМЕТРОВ"
                                color: root.textColor
                                font.family: "B612"
                                font.pixelSize: 14
                                font.bold: true
                                wrapMode: Text.Wrap
                                verticalAlignment: Text.AlignVCenter
                            }

                            Text {
                                id: panelToggle
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                width: 28
                                height: 32
                                text: "☰"
                                color: root.parameterPanelOpen ? "#FFFFFF" : root.cyan
                                font.pixelSize: 22
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                                MouseArea {
                                    anchors.fill: parent
                                    anchors.margins: -4
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.parameterPanelOpen = !root.parameterPanelOpen
                                }
                            }
                        }

                        Rectangle {
                            visible: root.parameterPanelOpen
                            width: parent.width
                            height: 1
                            color: root.line
                        }

                        Repeater {
                            model: ["Курс", "Дистанция", "Высота", "V_возд", "V_пут", "Время", "Δh (набор/снижение)", "Энергия", "Примечание"]
                            delegate: Row {
                                id: parameterRow
                                visible: root.parameterPanelOpen
                                width: parent.width
                                height: 30
                                spacing: 10
                                property string parameterKey: ["course", "distance", "altitude", "airspeed", "groundspeed", "time", "deltaHeight", "energy", "note"][index]
                                property bool parameterChecked: root.parameterVisibility[parameterKey] !== false

                                Rectangle {
                                    id: parameterSwitch
                                    width: 38
                                    height: 21
                                    radius: 11
                                    y: (parent.height - height) / 2
                                    color: parameterRow.parameterChecked ? root.switchGreen : "#263847"
                                    border.width: 1
                                    border.color: parameterRow.parameterChecked ? root.switchGreen : "#547084"

                                    Rectangle {
                                        width: 15
                                        height: 15
                                        radius: 8
                                        y: (parameterSwitch.height - height) / 2
                                        x: parameterRow.parameterChecked ? parameterSwitch.width - width - 3 : 3
                                        color: parameterRow.parameterChecked ? "#07111E" : "#B7C7D3"
                                        Behavior on x { NumberAnimation { duration: 120 } }
                                    }
                                }

                                Text {
                                    width: parent.width - parameterSwitch.width - parent.spacing
                                    text: modelData
                                    color: root.textColor
                                    font.family: "B612"
                                    font.pixelSize: 18
                                    anchors.verticalCenter: parent.verticalCenter
                                    wrapMode: Text.Wrap
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: root.toggleParameter(parameterRow.parameterKey)
                                    cursorShape: Qt.PointingHandCursor
                                }
                            }
                        }
                    }
                }            }

        }
    }

    ListModel {
        id: routeModel
        ListElement { pointType: "Старт"; pointName: "WP0 (База)"; coordinates: "55.7522, 37.6156"; course: "—"; distance: "0.0"; altitude: "120"; airspeed: "—"; groundspeed: "—"; time: "00:00"; deltaHeight: "—"; energy: "100"; note: "Взлёт (VTOL)" }
        ListElement { pointType: "Участок"; pointName: "WP1"; coordinates: "55.7801, 37.6923"; course: "087"; distance: "12.4"; altitude: "150"; airspeed: "28.0"; groundspeed: "25.4"; time: "04:52"; deltaHeight: "+30"; energy: "92"; note: "Набор высоты" }
        ListElement { pointType: "Участок"; pointName: "WP2"; coordinates: "55.8065, 37.8041"; course: "095"; distance: "18.7"; altitude: "150"; airspeed: "30.0"; groundspeed: "27.1"; time: "06:54"; deltaHeight: "0"; energy: "81"; note: "Патрулирование" }
        ListElement { pointType: "Участок"; pointName: "WP3"; coordinates: "55.8410, 37.9124"; course: "110"; distance: "15.6"; altitude: "180"; airspeed: "28.5"; groundspeed: "26.0"; time: "05:47"; deltaHeight: "+30"; energy: "68"; note: "Обход зоны" }
        ListElement { pointType: "Участок"; pointName: "WP4"; coordinates: "55.8702, 38.0231"; course: "132"; distance: "16.8"; altitude: "150"; airspeed: "29.0"; groundspeed: "24.8"; time: "06:46"; deltaHeight: "-30"; energy: "54"; note: "Съёмка" }
        ListElement { pointType: "Финиш"; pointName: "WP5 (Цель)"; coordinates: "55.9001, 38.1156"; course: "142"; distance: "14.9"; altitude: "120"; airspeed: "28.0"; groundspeed: "25.6"; time: "05:59"; deltaHeight: "-30"; energy: "42"; note: "Снижение, посадка" }
    }
}
