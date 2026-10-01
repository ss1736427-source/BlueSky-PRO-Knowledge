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
    property bool validationVisible: manualCreationMode ? !manualValidationStarted : validationConfirmationRequired
    property real validationPulse: 1.0
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

    // Checklist card — same rounded, outlined visual language as ATC.
    Rectangle {
        id: checklistCard
        visible: panelSettingsPopup.enabledTools.indexOf("Checklist") >= 0
        x: 16
        y: 8
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
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: "CHECKLIST 5/8 ✓"
            color: root.text
            font.family: "B612"
            font.pixelSize: 15
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }

    Text { visible: checklistCard.visible; x: checklistCard.x + 12; y: checklistCard.y + 41; text: "✓  Mission definition"; color: root.green; font.family: "B612"; font.pixelSize: 12 }
    Text { visible: checklistCard.visible; x: checklistCard.x + 12; y: checklistCard.y + 62; text: "✓  UAV allocation"; color: root.green; font.family: "B612"; font.pixelSize: 12 }
    Text { visible: checklistCard.visible; x: checklistCard.x + 12; y: checklistCard.y + 83; text: "✓  C2 availability"; color: root.green; font.family: "B612"; font.pixelSize: 12 }
    Text { visible: checklistCard.visible; x: checklistCard.x + 12; y: checklistCard.y + 104; text: "⚠  Weather revalidation"; color: root.amber; font.family: "B612"; font.pixelSize: 12 }

    // Warnings card — matching ATC/checklist frame and filled header.
    Rectangle {
        id: warningsCard
        visible: panelSettingsPopup.enabledTools.indexOf("Warnings / Corrections") >= 0 || root.warningActive
        x: 16
        y: 154
        width: parent.width - 32
        height: 168
        radius: 8
        color: "transparent"
        border.color: "#236078"
        border.width: 1
        antialiasing: true
    }

    Rectangle {
        visible: warningsCard.visible
        x: warningsCard.x + 1
        y: warningsCard.y + 1
        width: warningsCard.width - 2
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
            text: "WARNINGS / CORRECTIONS"
            color: root.text
            font.family: "B612"
            font.pixelSize: 12
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }

    Text {
        visible: warningsCard.visible && root.warningActive
        x: warningsCard.x + 12
        y: warningsCard.y + 49
        width: warningsCard.width - 24
        text: "Wind correction pending confirmation"
        color: root.amber
        font.family: "B612"
        font.pixelSize: 11
        wrapMode: Text.Wrap
    }

    Text {
        visible: warningsCard.visible && root.warningActive
        x: warningsCard.x + 12
        y: warningsCard.y + 77
        width: warningsCard.width - 24
        text: "Battery degradation model applied"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 10
        wrapMode: Text.Wrap
    }

    Rectangle {
        visible: warningsCard.visible && root.warningActive
        x: warningsCard.x + 12
        y: warningsCard.y + 110
        width: warningsCard.width - 24
        height: 1
        color: root.divider
    }

    // Unified ATC work area. The rounded frame encloses the heading and
    // all action controls, with a clear inset around every button.
    Rectangle {
        id: atcWorkArea
        visible: panelSettingsPopup.enabledTools.indexOf("Readiness") >= 0
                 || panelSettingsPopup.enabledTools.indexOf("Validation") >= 0
                 || panelSettingsPopup.enabledTools.indexOf("Send Flight Plan") >= 0
                 || panelSettingsPopup.enabledTools.indexOf("Start Mission") >= 0
        x: 16
        y: parent.height - (root.validationVisible ? 238 : 190)
        width: parent.width - 32
        height: root.validationVisible ? 218 : 170
        radius: 8
        color: "transparent"
        border.color: "#236078"
        border.width: 1
        antialiasing: true
        z: 0
    }

    // Header is a filled band, not a separate bordered card.
    Rectangle {
        visible: panelSettingsPopup.enabledTools.indexOf("Readiness") >= 0
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
        visible: root.validationVisible && panelSettingsPopup.enabledTools.indexOf("Validation") >= 0
        x: 26
        y: parent.height - 164
        width: parent.width - 52
        height: 38
        color: "transparent"
        border.color: Qt.rgba(root.green.r, root.green.g, root.green.b, root.validationPulse)
        opacity: root.manualCreationMode && !root.manualCompositionComplete ? 0.55 : 1.0
        border.width: 1
    }

    Text {
        visible: root.validationVisible && panelSettingsPopup.enabledTools.indexOf("Validation") >= 0
        x: 26
        y: parent.height - 164
        width: parent.width - 52
        height: 38
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
        y: parent.height - 164
        width: parent.width - 52
        height: 38
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
        visible: panelSettingsPopup.enabledTools.indexOf("Send Flight Plan") >= 0
        x: 26
        y: parent.height - 116
        width: parent.width - 52
        height: 38
        color: "transparent"
        border.color: root.divider
        border.width: 1
    }

    Text {
        visible: panelSettingsPopup.enabledTools.indexOf("Send Flight Plan") >= 0
        x: 26
        y: parent.height - 116
        width: parent.width - 52
        height: 38
        text: "SEND FLIGHT PLAN"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 12
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Rectangle {
        visible: panelSettingsPopup.enabledTools.indexOf("Start Mission") >= 0
        x: 26
        y: parent.height - 68
        width: parent.width - 52
        height: 38
        color: root.missionReady ? "transparent" : "#050505"
        border.color: root.missionReady ? root.green : root.divider
        border.width: 1
    }

    Text {
        visible: panelSettingsPopup.enabledTools.indexOf("Start Mission") >= 0
        x: 26
        y: parent.height - 68
        width: parent.width - 52
        height: 38
        text: "START MISSION"
        color: root.missionReady ? root.green : root.muted
        font.family: "B612"
        font.pixelSize: 12
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        visible: panelSettingsPopup.enabledTools.indexOf("Start Mission") >= 0
        x: 26
        y: parent.height - 68
        width: parent.width - 52
        height: 38
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
        title: "RIGHT PANEL SETTINGS"
        tools: ["Checklist", "Warnings / Corrections", "Readiness", "Validation", "Send Flight Plan", "Start Mission"]
        onClosed: open = false
    }
}
