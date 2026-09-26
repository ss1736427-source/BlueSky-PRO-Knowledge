import QtQuick

Item {
    id: root

    // Prevent child controls from painting outside the panel when its
    // width is collapsed to zero by MainContent.
    clip: true
    implicitWidth: 340

    property color bg: "#0A0A0A"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color muted: "#7F7F7F"
    property color green: "#64FF00"
    property color amber: "#FFD339"
    property color red: "#FF1E14"
    property color cyan: "#32FFFF"
    property color divider: "#202020"

    // Contextual validation is not shown until automatic revalidation succeeds.
    property bool validationConfirmationRequired: false
    property bool manualCreationMode: false
    property bool manualCompositionComplete: false
    property bool manualValidationStarted: false
    property bool missionReady: false
    property bool warningActive: true
    property real validationPulse: 1.0
    signal startMissionRequested()\n    signal validateManualMissionRequested()

    Rectangle {
        anchors.fill: parent
        color: root.bg
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1
        color: root.divider
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

    Text {
        x: 16
        y: 235
        text: "MISSION READINESS"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 12
        font.bold: true
    }

    Text {
        x: 16
        y: 260
        text: root.missionReady ? "READY" : "NOT READY"
        color: root.missionReady ? root.green : root.amber
        font.family: "B612 Mono"
        font.pixelSize: 13
        font.bold: true
    }

    Rectangle {
        visible: root.manualCreationMode ? !root.manualValidationStarted : root.validationConfirmationRequired
        x: 16
        y: 286
        width: parent.width - 32
        height: 38
        color: "transparent"
        border.color: Qt.rgba(root.green.r, root.green.g, root.green.b, root.validationPulse)\n        opacity: root.manualCreationMode && !root.manualCompositionComplete ? 0.55 : 1.0
        border.width: 1
    }

    Text {
        visible: root.validationConfirmationRequired
        x: 16
        y: 286
        width: parent.width - 32
        height: 38
        text: root.manualCreationMode ? "ВАЛИДАЦИЯ МИССИИ" : "VALIDATE MISSION"\n        opacity: root.manualCreationMode && !root.manualCompositionComplete ? 0.65 : 1.0
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
        y: 286
        width: parent.width - 32
        height: 38
        enabled: root.manualCompositionComplete
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            root.validateManualMissionRequested()
        }
    }

    SequentialAnimation on validationPulse {
        running: root.manualCreationMode ? !root.manualValidationStarted : root.validationConfirmationRequired
        loops: Animation.Infinite
        NumberAnimation { from: 0.35; to: 1.0; duration: 650; easing.type: Easing.InOutSine }
        NumberAnimation { from: 1.0; to: 0.35; duration: 650; easing.type: Easing.InOutSine }
    }

    Rectangle {
        x: 16
        y: 334
        width: parent.width - 32
        height: 38
        color: "transparent"
        border.color: root.divider
        border.width: 1
    }

    Text {
        x: 16
        y: 334
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
        y: 382
        width: parent.width - 32
        height: 38
        color: root.missionReady ? "transparent" : "#050505"
        border.color: root.missionReady ? root.green : root.divider
        border.width: 1
    }

    Text {
        x: 16
        y: 382
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
        y: 382
        width: parent.width - 32
        height: 38
        enabled: root.missionReady
        onClicked: root.startMissionRequested()
    }

    Text {
        x: 16
        y: 437
        text: root.missionReady
              ? "Ready state active; safety gate remains authoritative."
              : "START remains inactive until full readiness."
        color: root.muted
        font.family: "B612"
        font.pixelSize: 9
    }

    Rectangle { x: 16; y: 462; width: parent.width - 32; height: 1; color: root.divider }

    Text {
        x: 16
        y: 480
        text: "SAFETY GATE"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 12
        font.bold: true
    }

    Text {
        x: 16
        y: 505
        text: "Core / Safety authority active"
        color: root.text
        font.family: "B612"
        font.pixelSize: 11
    }

    Text {
        x: 16
        y: 525
        text: "AI recommendations: advisory only"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 10
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
