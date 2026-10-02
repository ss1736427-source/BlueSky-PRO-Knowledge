import QtQuick
import Qt.labs.settings 1.1

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
        var visible = root.orderedColumns().filter(function(col) {
            return root.parameterVisibility[col.key] !== false
        })
        var cursor = 0
        for (var i = 0; i < visible.length; ++i) {
            cursor += visible[i].w * tableHeader.width
            if (x < cursor) return visible[i].key
        }
        return visible.length ? visible[visible.length - 1].key : ""
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
            number: String(rowIndex + 1), type: row.pointType,
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
    }

    Component.onCompleted: {
        if (profileSettings.columnOrderJson.length > 0) {
            try {
                var saved = JSON.parse(profileSettings.columnOrderJson)
                if (Array.isArray(saved) && saved.length === root.columns.length)
                    root.columnOrder = saved
            } catch (e) { }
        }
    }

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
                    anchors.verticalCenter: parent.verticalCenter
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
                height: parent.height - titleBar.height - footer.height - 14
                spacing: 8

                Column {
                    id: mainColumn
                    width: parent.width - parameterPanel.width - parent.spacing
                    height: parent.height
                    spacing: 8

                    Rectangle {
                        id: tablePanel
                        width: parent.width
                        height: Math.round((parent.height - parent.spacing) * 0.47)
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

                    Rectangle {
                        id: profilePanel
                        width: parent.width
                        height: parent.height - tablePanel.height - parent.spacing
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
                                height: parent.height - 66
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
                                    var alts = [120,150,150,180,150,120]
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
                                        ctx.fillStyle = "#EAF7FF"; ctx.fill()
                                        ctx.strokeStyle = root.cyan; ctx.lineWidth = 2; ctx.stroke()
                                    }
                                    ctx.fillStyle = "#DCE8F2"; ctx.font = "11px sans-serif"
                                    ctx.fillText("Высота, м", 3, 12)
                                    ctx.fillText("Дистанция по маршруту, км", Math.max(45, width / 2 - 70), height - 4)
                                    ctx.fillText("0", left - 14, bottom + 14)
                                    ctx.fillText("400", left - 32, top + 4)
                                    ctx.fillText("78.4", right - 20, bottom + 14)
                                }
                            }
                            Row {
                                width: parent.width
                                height: 28
                                spacing: 5
                                Repeater {
                                    model: [
                                        ["ДИСТАНЦИЯ", "78.4 км"],
                                        ["ВРЕМЯ ПОЛЁТА", "01:18"],
                                        ["СРЕДНЯЯ V_ПУТ", "25.8 м/с"],
                                        ["МИН / МАКС ВЫСОТА", "120 / 180 м"],
                                        ["НАБОР / СНИЖЕНИЕ", "+90 / -90 м"],
                                        ["РАСХОД ЭНЕРГИИ", "58 %"],
                                        ["ОСТАТОК ЭНЕРГИИ", "42 %"]
                                    ]
                                    delegate: Rectangle {
                                        width: (parent.width - 6 * 5) / 7
                                        height: parent.height
                                        color: "#0B1B2B"
                                        border.color: root.line
                                        Column {
                                            anchors.centerIn: parent
                                            Text { text: modelData[0]; color: root.muted; font.pixelSize: 8; font.family: "B612" }
                                            Text { text: modelData[1]; color: root.textColor; font.pixelSize: 11; font.bold: true; font.family: "B612 Mono" }
                                        }
                                    }
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
                                    anchors.verticalCenter: parent.verticalCenter
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

            Row {
                id: footer
                width: parent.width
                height: 34
                spacing: 8
                Rectangle {
                    width: 125; height: parent.height
                    color: root.panel; border.color: root.line; radius: 2
                    Text { anchors.centerIn: parent; text: "ЭКСПОРТ  ▾"; color: root.textColor; font.family: "B612"; font.pixelSize: 11 }
                }
                Item { width: parent.width - 125 - 110 - 130 - 24; height: 1 }
                Rectangle {
                    width: 110; height: parent.height
                    color: root.panel; border.color: root.line; radius: 2
                    Text { anchors.centerIn: parent; text: "ОТМЕНА"; color: root.textColor; font.family: "B612"; font.pixelSize: 11 }
                    MouseArea { anchors.fill: parent; onClicked: root.closeRequested(); cursorShape: Qt.PointingHandCursor }
                }
                Rectangle {
                    width: 130; height: parent.height
                    color: root.cyan; border.color: root.cyan; radius: 2
                    Text { anchors.centerIn: parent; text: "ПРИМЕНИТЬ"; color: "#04111B"; font.family: "B612"; font.pixelSize: 11; font.bold: true }
                    MouseArea { anchors.fill: parent; onClicked: root.applyRequested(); cursorShape: Qt.PointingHandCursor }
                }
            }
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
