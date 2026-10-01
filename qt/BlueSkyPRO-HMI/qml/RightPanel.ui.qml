import QtQuick

Item {
    id: root

    // Prevent child controls from painting outside the panel when its
    // width is collapsed to zero by MainContent.
    clip: true
    implicitWidth: 270

    property color bg: "#08111D"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color muted: "#7F7F7F"
    property color green: "#64FF00"
    property color amber: "#FFD339"
    property color red: "#FF1E14"
    property color cyan: "#32FFFF"
    property color divider: "#7F7F7F"

    // Match LeftPanel outline; shared top/bottom seams are owned by header/toolbar.
    property bool showTopBorder: true
    property bool showRightBorder: true
    property bool showBottomBorder: true
    property bool showLeftBorder: true

    // Contextual validation is not shown until automatic revalidation succeeds.
    property bool validationConfirmationRequired: false
    property bool manualCreationMode: false
    property bool manualCompositionComplete: false
    property bool manualValidationStarted: false
    property bool missionReady: false
    property bool warningActive: true
    property var systemMessages: [
        { id: "SYS-C2-001", kind: "FAILURE", title: "Потеря связи C2", detail: "Связь с БПЛА требует проверки. Проверьте состояние канала и доступность аппарата.", action: "Проверить связь с БПЛА", requiresIntervention: true, severity: "critical" },
        { id: "SYS-WIND-001", kind: "WARNING", title: "Коррекция ветра требует подтверждения", detail: "Изменение ветровых условий повлияло на расчёт маршрута. Проверьте обновлённую коррекцию.", action: "Проверить коррекцию маршрута", requiresIntervention: true, severity: "warning" },
        { id: "SYS-BAT-001", kind: "CHANGE", title: "Применена модель деградации батареи", detail: "Расчёт производительности учитывает деградацию аккумулятора.", action: "", requiresIntervention: false, severity: "info" }
    ]
    property var acknowledgedMessageIds: []
    property var selectedInformationMessage: null
    property bool interventionMode: false
    signal pilotInterventionRequested(string messageId)
    property bool validationVisible: manualCreationMode ? !manualValidationStarted : validationConfirmationRequired
    property real validationPulse: 1.0

    // ATC work area sizes itself to the currently enabled action buttons.
    property bool atcHeaderVisible: panelSettingsPopup.enabledTools.indexOf("Readiness") >= 0
    property bool atcValidationVisible: root.validationVisible && panelSettingsPopup.enabledTools.indexOf("Validation") >= 0
    property bool atcSendVisible: panelSettingsPopup.enabledTools.indexOf("Send Flight Plan") >= 0
    property bool atcStartVisible: panelSettingsPopup.enabledTools.indexOf("Start Mission") >= 0
    property int atcVisibleButtonCount: (atcValidationVisible ? 1 : 0)
                                        + (atcSendVisible ? 1 : 0)
                                        + (atcStartVisible ? 1 : 0)
    property int atcButtonHeight: 38
    property int atcButtonGap: 10
    property int atcButtonStackTop: atcHeaderVisible ? 43 : 12
    property int atcWorkAreaHeight: (atcHeaderVisible ? 33 : 12)
                                    + (atcHeaderVisible && atcVisibleButtonCount > 0 ? atcButtonGap : 0)
                                    + atcVisibleButtonCount * atcButtonHeight
                                    + Math.max(0, atcVisibleButtonCount - 1) * atcButtonGap
                                    + 12
    property int atcValidationY: atcWorkArea.y + atcButtonStackTop
    property int atcSendY: atcValidationY + (atcValidationVisible ? atcButtonHeight + atcButtonGap : 0)
    property int atcStartY: atcValidationY
                            + (atcValidationVisible ? atcButtonHeight + atcButtonGap : 0)
                            + (atcSendVisible ? atcButtonHeight + atcButtonGap : 0)

    signal startMissionRequested()
    signal validateManualMissionRequested()

    Rectangle {
        anchors.fill: parent
        color: root.bg
    }

    // Edge ownership mirrors LeftPanel. MainContent disables the top and bottom
    // edges so TopHeader and BottomToolbar each provide one continuous shared line.
    Rectangle {
        visible: root.showTopBorder
        x: 0
        y: 0
        width: parent.width
        height: 1
        color: root.cyan
        antialiasing: false
    }
    Rectangle {
        visible: root.showRightBorder
        x: parent.width - 1
        y: 0
        width: 1
        height: parent.height
        color: root.cyan
        antialiasing: false
    }
    Rectangle {
        visible: root.showBottomBorder
        x: 0
        y: parent.height - 1
        width: parent.width
        height: 1
        color: root.cyan
        antialiasing: false
    }
    Rectangle {
        visible: root.showLeftBorder
        x: 0
        y: 0
        width: 1
        height: parent.height
        color: root.cyan
        antialiasing: false
    }

    // Overall right-panel title: plain text, with the menu on the same row.
    Item {
        id: rightPanelTitleBar
        x: 10
        y: 8
        width: parent.width - 20
        height: 38
        z: 10

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.right: panelSettings.left
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: "INFORMATION"
            color: root.text
            font.family: "B612"
            font.pixelSize: 13
            font.bold: true
            elide: Text.ElideRight
        }
    }

    // Checklist card — same rounded, outlined visual language as ATC.
    Rectangle {
        id: checklistCard
        visible: panelSettingsPopup.enabledTools.indexOf("Checklist") >= 0
        x: 16
        y: 54
        width: parent.width - 32
        height: 136
        radius: 8
        color: "transparent"
        border.color: "#236078"
        border.width: 1
        antialiasing: true
    }

    Rectangle {
        visible: checklistCard.visible
        x: checklistCard.x + 1
        y: checklistCard.y + 1
        width: checklistCard.width - 2
        height: 32
        radius: 7
        color: "#0B1B2B"
        antialiasing: true

        Rectangle {
            x: 0
            y: height / 2
            width: parent.width
            height: parent.height / 2
            color: parent.color
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.right: checklistCounts.left
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: "CHECKLIST"
            color: root.text
            font.family: "B612"
            font.pixelSize: 13
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        Row {
            id: checklistCounts
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 3

            Text {
                text: "5"
                color: root.green
                font.family: "B612"
                font.pixelSize: 13
                font.bold: true
            }
            Text {
                text: "/"
                color: root.secondary
                font.family: "B612"
                font.pixelSize: 13
                font.bold: true
            }
            Text {
                text: "3"
                color: "#FF00D4"
                font.family: "B612"
                font.pixelSize: 13
                font.bold: true
            }
        }
    }

    Text { visible: checklistCard.visible; x: checklistCard.x + 12; y: checklistCard.y + 41; text: "✓  Mission definition"; color: root.green; font.family: "B612"; font.pixelSize: 12 }
    Text { visible: checklistCard.visible; x: checklistCard.x + 12; y: checklistCard.y + 62; text: "✓  UAV allocation"; color: root.green; font.family: "B612"; font.pixelSize: 12 }
    Text { visible: checklistCard.visible; x: checklistCard.x + 12; y: checklistCard.y + 83; text: "✓  C2 availability"; color: root.green; font.family: "B612"; font.pixelSize: 12 }
    Text { visible: checklistCard.visible; x: checklistCard.x + 12; y: checklistCard.y + 104; text: "⚠  Weather revalidation"; color: root.amber; font.family: "B612"; font.pixelSize: 12 }

    // INFORMATION: acknowledgement hides an item from this overview only.
    // Source events remain in the system journal/audit trail.
    function visibleSystemMessages() {
        return systemMessages.filter(function(message) {
            return acknowledgedMessageIds.indexOf(message.id) < 0
        })
    }

    function hasUnacknowledgedCriticalMessage() {
        return systemMessages.some(function(message) {
            return message.severity === "critical" &&
                   acknowledgedMessageIds.indexOf(message.id) < 0
        })
    }

    function acknowledgeInformationMessage() {
        if (!selectedInformationMessage)
            return
        var next = acknowledgedMessageIds.slice()
        if (next.indexOf(selectedInformationMessage.id) < 0)
            next.push(selectedInformationMessage.id)
        acknowledgedMessageIds = next
        selectedInformationMessage = null
        interventionMode = false
    }

    Rectangle {
        id: informationCard
        visible: panelSettingsPopup.enabledTools.indexOf("Information") >= 0
                 || root.hasUnacknowledgedCriticalMessage()
        x: 16
        y: checklistCard.y + checklistCard.height + 10
        width: parent.width - 32
        height: 220
        radius: 8
        color: "transparent"
        border.color: "#236078"
        border.width: 1
        antialiasing: true
    }

    Rectangle {
        visible: informationCard.visible
        x: informationCard.x + 1
        y: informationCard.y + 1
        width: informationCard.width - 2
        height: 32
        radius: 7
        color: "#0B1B2B"
        antialiasing: true

        Rectangle {
            x: 0
            y: height / 2
            width: parent.width
            height: parent.height / 2
            color: parent.color
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: "ALERTING"
            color: root.text
            font.family: "B612"
            font.pixelSize: 13
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }

    // Empty body is intentional: no unacknowledged messages means no alert text.
    Column {
        id: informationOverview
        visible: informationCard.visible && !root.selectedInformationMessage
        x: informationCard.x + 10
        y: informationCard.y + 39
        width: informationCard.width - 20
        spacing: 2

        Repeater {
            model: root.visibleSystemMessages()

            delegate: Item {
                width: parent.width
                height: 39

                Rectangle {
                    anchors.fill: parent
                    radius: 4
                    color: messageMouse.containsMouse ? "#102337" : "transparent"
                    border.width: modelData.severity === "critical" ? 1 : 0
                    border.color: root.red
                }

                Text {
                    x: 4
                    y: 2
                    width: parent.width - 8
                    height: 15
                    text: (modelData.kind === "FAILURE" ? "✕  " :
                           modelData.kind === "WARNING" ? "⚠  " : "•  ") + modelData.kind
                    color: modelData.severity === "critical" ? root.red :
                           modelData.severity === "warning" ? root.amber : root.cyan
                    font.family: "B612"
                    font.pixelSize: 9
                    font.bold: true
                }

                Text {
                    x: 4
                    y: 17
                    width: parent.width - 8
                    height: 20
                    text: modelData.title
                    color: root.secondary
                    font.family: "B612"
                    font.pixelSize: 10
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    id: messageMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.selectedInformationMessage = modelData
                        root.interventionMode = false
                    }
                }
            }
        }
    }

    Column {
        visible: informationCard.visible && !!root.selectedInformationMessage
        x: informationCard.x + 12
        y: informationCard.y + 40
        width: informationCard.width - 24
        spacing: 5

        Text {
            width: parent.width
            text: root.selectedInformationMessage ? root.selectedInformationMessage.title : ""
            color: root.selectedInformationMessage && root.selectedInformationMessage.severity === "critical" ? root.red :
                   root.selectedInformationMessage && root.selectedInformationMessage.severity === "warning" ? root.amber : root.text
            font.family: "B612"
            font.pixelSize: 10
            font.bold: true
            wrapMode: Text.Wrap
        }

        Text {
            width: parent.width
            text: root.interventionMode && root.selectedInformationMessage
                  ? "ТРЕБУЕТСЯ ДЕЙСТВИЕ ПИЛОТА"
                  : (root.selectedInformationMessage ? root.selectedInformationMessage.detail : "")
            color: root.secondary
            font.family: "B612"
            font.pixelSize: 9
            wrapMode: Text.Wrap
        }

        Text {
            visible: !!root.selectedInformationMessage && root.selectedInformationMessage.requiresIntervention
            width: parent.width
            text: root.interventionMode && root.selectedInformationMessage
                  ? root.selectedInformationMessage.action
                  : "Нажмите, чтобы открыть область действий пилота."
            color: root.cyan
            font.family: "B612"
            font.pixelSize: 9
            wrapMode: Text.Wrap
        }

        Row {
            width: parent.width
            spacing: 6

            Rectangle {
                visible: !!root.selectedInformationMessage &&
                         root.selectedInformationMessage.requiresIntervention &&
                         !root.interventionMode
                width: (parent.width - parent.spacing) * 0.58
                height: 26
                radius: 3
                color: "#0B1B2B"
                border.color: root.cyan

                Text {
                    anchors.fill: parent
                    text: "К ДЕЙСТВИЮ"
                    color: root.cyan
                    font.family: "B612"
                    font.pixelSize: 8
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.interventionMode = true
                        root.pilotInterventionRequested(root.selectedInformationMessage.id)
                    }
                }
            }

            Rectangle {
                width: root.selectedInformationMessage &&
                       root.selectedInformationMessage.requiresIntervention &&
                       !root.interventionMode
                       ? (parent.width - parent.spacing) * 0.42 : parent.width
                height: 26
                radius: 3
                color: "transparent"
                border.color: root.divider

                Text {
                    anchors.fill: parent
                    text: root.selectedInformationMessage &&
                          root.selectedInformationMessage.requiresIntervention &&
                          !root.interventionMode ? "НАЗАД" : "ПОДТВЕРДИТЬ"
                    color: root.secondary
                    font.family: "B612"
                    font.pixelSize: 8
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (root.selectedInformationMessage &&
                            root.selectedInformationMessage.requiresIntervention &&
                            !root.interventionMode) {
                            root.selectedInformationMessage = null
                        } else {
                            root.acknowledgeInformationMessage()
                        }
                    }
                }
            }
        }
    }

    // Unified ATC work area. The rounded frame encloses the heading and
    // all action controls, with a clear inset around every button.
    Rectangle {
        id: atcWorkArea
        visible: root.atcHeaderVisible || root.atcVisibleButtonCount > 0
        x: 16
        y: parent.height - root.atcWorkAreaHeight - 20
        width: parent.width - 32
        height: root.atcWorkAreaHeight
        radius: 8
        color: "transparent"
        border.color: "#236078"
        border.width: 1
        antialiasing: true
        z: 0
    }

    // Header is a filled band, not a separate bordered card.
    Rectangle {
        visible: root.atcHeaderVisible
        x: atcWorkArea.x + 1
        y: atcWorkArea.y + 1
        width: atcWorkArea.width - 2
        height: 32
        radius: 7
        color: "#0B1B2B"
        antialiasing: true

        // Square the lower corners of the header band so it joins the work area.
        Rectangle {
            x: 0
            y: height / 2
            width: parent.width
            height: parent.height / 2
            color: parent.color
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: "ATC"
            color: root.text
            font.family: "B612"
            font.pixelSize: 13
            font.bold: true
            verticalAlignment: Text.AlignVCenter
        }
    }

    Rectangle {
        visible: root.atcValidationVisible
        x: 26
        y: root.atcValidationY
        width: parent.width - 52
        height: root.atcButtonHeight
        color: "transparent"
        border.color: Qt.rgba(root.green.r, root.green.g, root.green.b, root.validationPulse)
        opacity: root.manualCreationMode && !root.manualCompositionComplete ? 0.55 : 1.0
        border.width: 1
    }

    Text {
        visible: root.atcValidationVisible
        x: 26
        y: root.atcValidationY
        width: parent.width - 52
        height: root.atcButtonHeight
        text: root.manualCreationMode ? "ВАЛИДАЦИЯ МИССИИ" : "VALIDATE MISSION"
        opacity: root.manualCreationMode && !root.manualCompositionComplete ? 0.65 : 1.0
        color: root.green
        font.family: "B612"
        font.pixelSize: 12
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        visible: root.manualCreationMode && !root.manualValidationStarted
                 && panelSettingsPopup.enabledTools.indexOf("Validation") >= 0
        x: 26
        y: root.atcValidationY
        width: parent.width - 52
        height: root.atcButtonHeight
        enabled: root.manualCompositionComplete
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.validateManualMissionRequested()
    }

    SequentialAnimation on validationPulse {
        running: root.manualCreationMode ? !root.manualValidationStarted : root.validationConfirmationRequired
        loops: Animation.Infinite
        NumberAnimation { from: 0.35; to: 1.0; duration: 650; easing.type: Easing.InOutSine }
        NumberAnimation { from: 1.0; to: 0.35; duration: 650; easing.type: Easing.InOutSine }
    }

    Rectangle {
        visible: root.atcSendVisible
        x: 26
        y: root.atcSendY
        width: parent.width - 52
        height: root.atcButtonHeight
        color: "transparent"
        border.color: root.divider
        border.width: 1
    }

    Text {
        visible: root.atcSendVisible
        x: 26
        y: root.atcSendY
        width: parent.width - 52
        height: root.atcButtonHeight
        text: "SEND FLIGHT PLAN"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 12
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Rectangle {
        visible: root.atcStartVisible
        x: 26
        y: root.atcStartY
        width: parent.width - 52
        height: root.atcButtonHeight
        color: root.missionReady ? "transparent" : "#050505"
        border.color: root.missionReady ? root.green : root.divider
        border.width: 1
    }

    Text {
        visible: root.atcStartVisible
        x: 26
        y: root.atcStartY
        width: parent.width - 52
        height: root.atcButtonHeight
        text: "START MISSION"
        color: root.missionReady ? root.green : root.muted
        font.family: "B612"
        font.pixelSize: 12
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        visible: root.atcStartVisible
        x: 26
        y: root.atcStartY
        width: parent.width - 52
        height: root.atcButtonHeight
        enabled: root.missionReady
        onClicked: root.startMissionRequested()
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
        width: Math.min(parent.width - 16, Math.max(260, panelSettingsPopup.contentWidth))
        height: Math.min(parent.height - 52, 86 + panelSettingsPopup.tools.length * 34)
        title: "INFORMATION SETTINGS"
        tools: ["Checklist", "Information", "Readiness", "Validation", "Send Flight Plan", "Start Mission"]
        onClosed: open = false
    }
}
