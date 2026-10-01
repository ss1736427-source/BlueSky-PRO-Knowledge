import QtQuick

Item {
    id: root

    // Prevent child controls from painting outside the panel when its
    // width is collapsed to zero by MainContent.
    clip: true
    implicitWidth: 340

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

    Text {
        x: 16
        y: 14
        text: "CHECKLIST 5/8 ✓"
        color: root.text
        font.family: "B612"
        font.pixelSize: 16
        font.bold: true
    }

    Text { x: 16; y: 43; text: "✓ Mission definition"; color: root.green; font.family: "B612"; font.pixelSize: 12 }
    Text { x: 16; y: 64; text: "✓ UAV allocation"; color: root.green; font.family: "B612"; font.pixelSize: 12 }
    Text { x: 16; y: 85; text: "✓ C2 availability"; color: root.green; font.family: "B612"; font.pixelSize: 12 }
    Text { x: 16; y: 106; text: "⚠ Weather revalidation"; color: root.amber; font.family: "B612"; font.pixelSize: 12 }

    Rectangle {
        x: 16
        y: 130
        width: parent.width - 32
        height: 1
        color: root.divider
    }

    Text {
        x: 16
        y: 147
        text: "WARNINGS / CORRECTIONS"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 12
        font.bold: true
    }

    Text {
        x: 16
        y: 174
        visible: root.warningActive
        text: "Wind correction pending confirmation"
        color: root.amber
        font.family: "B612"
        font.pixelSize: 11
    }

    Text {
        x: 16
        y: 195
        visible: root.warningActive
        text: "Battery degradation model applied"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 10
    }

    Rectangle { x: 16; y: 218; width: parent.width - 32; height: 1; color: root.divider }

    // Keep mission readiness at the bottom edge of the right panel.
    Text {
        x: 16
        y: parent.height - (root.validationVisible ? 226 : 178)
        text: "MISSION READINESS"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 12
        font.bold: true
    }

    Text {
        x: 16
        y: parent.height - (root.validationVisible ? 202 : 154)
        text: root.missionReady ? "READY" : "NOT READY"
        color: root.missionReady ? root.green : root.amber
        font.family: "B612 Mono"
        font.pixelSize: 13
        font.bold: true
    }

    Rectangle {
        visible: root.validationVisible
        x: 16
        y: parent.height - 164
        width: parent.width - 32
        height: 38
        color: "transparent"
        border.color: Qt.rgba(root.green.r, root.green.g, root.green.b, root.validationPulse)
        opacity: root.manualCreationMode && !root.manualCompositionComplete ? 0.55 : 1.0
        border.width: 1
    }

    Text {
        visible: root.validationVisible
        x: 16
        y: parent.height - 164
        width: parent.width - 32
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
        x: 16
        y: parent.height - 164
        width: parent.width - 32
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
        x: 16
        y: parent.height - 116
        width: parent.width - 32
        height: 38
        color: "transparent"
        border.color: root.divider
        border.width: 1
    }

    Text {
        x: 16
        y: parent.height - 116
        width: parent.width - 32
        height: 38
        text: "SEND FLIGHT PLAN"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 12
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Rectangle {
        x: 16
        y: parent.height - 68
        width: parent.width - 32
        height: 38
        color: root.missionReady ? "transparent" : "#050505"
        border.color: root.missionReady ? root.green : root.divider
        border.width: 1
    }

    Text {
        x: 16
        y: parent.height - 68
        width: parent.width - 32
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
        x: 16
        y: parent.height - 68
        width: parent.width - 32
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
        width: 260
        height: 230
        title: "RIGHT PANEL SETTINGS"
        tools: ["Checklist", "Warnings / Corrections", "Readiness", "Validation", "Send Flight Plan", "Mission Actions", "Safety Gate"]
        onClosed: open = false
    }
}
