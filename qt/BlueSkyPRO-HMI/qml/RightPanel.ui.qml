import QtQuick

Item {
    id: root

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
    property color divider: "#263747"

    property bool showTopBorder: true
    property bool showRightBorder: true
    property bool showBottomBorder: true
    property bool showLeftBorder: true

    property bool validationConfirmationRequired: false
    property bool manualCreationMode: false
    property bool manualCompositionComplete: false
    property bool manualValidationStarted: false
    property bool missionReady: false
    property bool warningActive: true
    property real validationPulse: 1.0
    signal startMissionRequested()
    signal validateManualMissionRequested()

    Rectangle {
        anchors.fill: parent
        color: root.bg
    }

    // Single-pixel panel edges; shared horizontal seams belong to header/toolbar.
    Rectangle {
        visible: root.showTopBorder
        x: 0; y: 0; width: parent.width; height: 1
        color: root.cyan
        antialiasing: false
    }
    Rectangle {
        visible: root.showRightBorder
        x: parent.width - 1; y: 0; width: 1; height: parent.height
        color: root.cyan
        antialiasing: false
    }
    Rectangle {
        visible: root.showBottomBorder
        x: 0; y: parent.height - 1; width: parent.width; height: 1
        color: root.cyan
        antialiasing: false
    }
    Rectangle {
        visible: root.showLeftBorder
        x: 0; y: 0; width: 1; height: parent.height
        color: root.cyan
        antialiasing: false
    }

    Text {
        x: 16; y: 14
        text: "MISSION STATUS"
        color: root.text
        font.family: "B612"
        font.pixelSize: 16
        font.bold: true
    }

    Text {
        x: 16; y: 43
        text: "READINESS"
        color: root.secondary
        font.family: "B612 Mono"
        font.pixelSize: 10
    }

    Rectangle {
        x: 16; y: 64
        width: parent.width - 32; height: 34
        color: root.missionReady ? "#102719" : "#2A2410"
        border.color: root.missionReady ? root.green : root.amber
        border.width: 1
        Text {
            anchors.centerIn: parent
            text: root.missionReady ? "READY" : "NOT READY"
            color: root.missionReady ? root.green : root.amber
            font.family: "B612 Mono"
            font.pixelSize: 14
            font.bold: true
        }
    }

    Rectangle { x: 16; y: 112; width: parent.width - 32; height: 1; color: root.divider }

    Text {
        x: 16; y: 128
        text: "FLIGHT CONDITIONS"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 12
        font.bold: true
    }

    Text {
        x: 16; y: 154
        text: "✓ Mission definition"
        color: root.green
        font.family: "B612"
        font.pixelSize: 11
    }
    Text {
        x: 16; y: 175
        text: "✓ UAV allocation"
        color: root.green
        font.family: "B612"
        font.pixelSize: 11
    }
    Text {
        x: 16; y: 196
        text: "✓ C2 availability"
        color: root.green
        font.family: "B612"
        font.pixelSize: 11
    }
    Text {
        x: 16; y: 217
        text: root.warningActive ? "⚠ Weather revalidation" : "✓ Weather reviewed"
        color: root.warningActive ? root.amber : root.green
        font.family: "B612"
        font.pixelSize: 11
    }

    Rectangle { x: 16; y: 242; width: parent.width - 32; height: 1; color: root.divider }

    Text {
        x: 16; y: 258
        text: "WARNINGS / CORRECTIONS"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 12
        font.bold: true
    }
    Text {
        x: 16; y: 284
        width: parent.width - 32
        visible: root.warningActive
        text: "Wind correction pending confirmation"
        color: root.amber
        font.family: "B612"
        font.pixelSize: 10
        wrapMode: Text.WordWrap
    }
    Text {
        x: 16; y: 307
        width: parent.width - 32
        visible: root.warningActive
        text: "Battery degradation model applied"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 10
        wrapMode: Text.WordWrap
    }
    Text {
        x: 16; y: 284
        visible: !root.warningActive
        text: "No active warnings"
        color: root.green
        font.family: "B612"
        font.pixelSize: 10
    }

    Rectangle { x: 16; y: 336; width: parent.width - 32; height: 1; color: root.divider }

    Text {
        x: 16; y: 352
        text: "MISSION ACTIONS"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 12
        font.bold: true
    }

    Rectangle {
        visible: root.manualCreationMode ? !root.manualValidationStarted : root.validationConfirmationRequired
        x: 16; y: 378
        width: parent.width - 32; height: 38
        color: "transparent"
        border.color: Qt.rgba(root.green.r, root.green.g, root.green.b, root.validationPulse)
        border.width: 1
        opacity: root.manualCreationMode && !root.manualCompositionComplete ? 0.55 : 1.0
    }
    Text {
        visible: root.manualCreationMode ? !root.manualValidationStarted : root.validationConfirmationRequired
        x: 16; y: 378
        width: parent.width - 32; height: 38
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
        x: 16; y: 378
        width: parent.width - 32; height: 38
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
        x: 16; y: 428
        width: parent.width - 32; height: 38
        color: "transparent"
        border.color: root.divider
        border.width: 1
    }
    Text {
        x: 16; y: 428
        width: parent.width - 32; height: 38
        text: "SEND FLIGHT PLAN"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 12
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Rectangle {
        x: 16; y: 476
        width: parent.width - 32; height: 38
        color: root.missionReady ? "#102719" : "#050A12"
        border.color: root.missionReady ? root.green : root.divider
        border.width: 1
    }
    Text {
        x: 16; y: 476
        width: parent.width - 32; height: 38
        text: "START MISSION"
        color: root.missionReady ? root.green : root.muted
        font.family: "B612"
        font.pixelSize: 12
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    MouseArea {
        x: 16; y: 476
        width: parent.width - 32; height: 38
        enabled: root.missionReady
        onClicked: root.startMissionRequested()
    }

    Text {
        x: 16; y: 530
        width: parent.width - 32
        text: root.missionReady
              ? "Readiness confirmed; Core / Safety remains authoritative."
              : "START remains inactive until all readiness checks pass."
        color: root.muted
        font.family: "B612"
        font.pixelSize: 9
        wrapMode: Text.WordWrap
    }

    Rectangle { x: 16; y: 562; width: parent.width - 32; height: 1; color: root.divider }

    Text {
        x: 16; y: 578
        text: "SAFETY AUTHORITY"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 12
        font.bold: true
    }
    Text {
        x: 16; y: 604
        text: "Core / Safety authority active"
        color: root.text
        font.family: "B612"
        font.pixelSize: 10
    }
    Text {
        x: 16; y: 624
        width: parent.width - 32
        text: "AI recommendations: advisory only"
        color: root.secondary
        font.family: "B612"
        font.pixelSize: 10
        wrapMode: Text.WordWrap
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
        tools: ["Readiness", "Flight Conditions", "Warnings / Corrections", "Mission Actions", "Safety Authority"]
        onClosed: open = false
    }
}
