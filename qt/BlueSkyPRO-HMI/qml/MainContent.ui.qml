import QtQuick

Item {
    id: root
    width: 1920
    height: 1080

    // BlueSky PRO — Qt Design Studio working screen.
    // Visual composition only. Core / Safety remain authoritative.
    property int headerHeight: 86
    property int leftWidth: 300
    property int rightWidth: 340
    property int uavHeight: 82
    property int toolbarHeight: 54
    property bool leftPanelOpen: true
    property bool rightPanelOpen: true
    property bool missionVisible: true
    property bool missionReady: false
    property bool warningActive: true
    property int selectedUavIndex: -1
    property string uavDecision: ""
    property string lastJournalEvent: ""
    property string missionId: "BS-260920-A-001"
    property string journalStatus: "READY"
    property string activeTool: "MAP"
    property bool toolMenuOpen: false
    signal journalEvent(string eventType, int uavIndex, string decision)
    signal journalAppendRequested(string eventType, string missionId, int uavIndex, string decision)
    signal uavDecisionRequested(string decision, int uavIndex)

    Rectangle {
        anchors.fill: parent
        color: "#050A12"
    }

    TopHeader {
        id: topHeader
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.headerHeight
        tabletVariant: false
        ready: root.missionReady
        warningActive: root.warningActive
    }

    Item {
        id: workspace
        anchors.top: topHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: uavStatus.top

        LeftPanel {
            id: leftPanel
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: root.leftPanelOpen ? root.leftWidth : 0
            missionVisible: root.missionVisible
            onHideMissionRequested: root.missionVisible = false
            onRestoreMissionRequested: root.missionVisible = true
        }

        FlightChart {
            id: flightChart
            anchors.left: leftPanel.right
            anchors.right: rightPanel.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            missionVisible: root.missionVisible
            visible: root.activeTool === "MAP"
        }

        ToolContext {
            id: toolContext
            anchors.left: leftPanel.right
            anchors.right: rightPanel.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            visible: root.activeTool !== "MAP"
            contextName: root.activeTool
            contextSubtitle: root.activeTool === "UAV" ? "SELECT UAV → CONTROL / C2 → CONFIGURATION" : root.activeTool === "ADMIN" ? "SYSTEM ADMINISTRATION / ENGINEER / TECHNICIAN" : root.activeTool === "FPV" ? "VIDEO + FLIGHT DATA + CONTROL TRANSFER" : "SIMULATION / VIRTUAL UAV"
            sections: root.activeTool === "UAV"
                      ? ["UAV SELECTION", "CONTROL / C2", "UAV CONFIGURATION", "NAVIGATION", "ENERGY", "PAYLOAD / EQUIPMENT", "MAINTENANCE", "DIAGNOSTICS"]
                      : root.activeTool === "ADMIN"
                      ? ["USERS", "ROLES & ACCESS", "SYSTEM SETTINGS", "INTEGRATIONS", "DATA & SYNC", "DOCUMENTS", "AUDIT LOG"]
                      : root.activeTool === "FPV"
                      ? ["UAV SELECTION", "CONTROL STATION", "CONTROL MAPPING", "C2 / VIDEO STATE", "MANUAL CONTROL", "RETURN TO AUTO"]
                      : ["VIRTUAL UAV", "SIMULATION", "ENVIRONMENT", "SCENARIOS", "PLANNED / SIMULATED / ACTUAL", "RESULTS"]
        }

        RightPanel {
            id: rightPanel
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: root.rightPanelOpen ? root.rightWidth : 0
            missionReady: root.missionReady
            warningActive: root.warningActive
        }
    }

    UAVStatus {
        id: uavStatus
        onUavSelected: root.selectedUavIndex = index
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bottomToolbar.top
        height: root.uavHeight
    }

    BottomToolbar {
        id: bottomToolbar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: root.toolbarHeight
        leftOpen: root.leftPanelOpen
        rightOpen: root.rightPanelOpen
        onLeftPanelToggleRequested: root.leftPanelOpen = !root.leftPanelOpen
        onRightPanelToggleRequested: root.rightPanelOpen = !root.rightPanelOpen
        activeTool: root.activeTool
        onToolRequested: root.activeTool = tool
        onToolConfigurationRequested: root.toolMenuOpen = !root.toolMenuOpen
    }

    PanelSettingsPopup {
        id: toolMenu
        anchors.right: parent.right
        anchors.bottom: bottomToolbar.top
        width: 300
        height: 250
        title: "TOOLS"
        tools: ["MAP", "UAV", "FPV", "ADMIN", "VIRTUAL FLT"]
        open: root.toolMenuOpen
        onToolToggled: bottomToolbar.setToolEnabled(tool, enabled)
        onClosed: root.toolMenuOpen = false
    }

    ContextOverlay {
        id: contextOverlay
        visible: root.selectedUavIndex >= 0
        uavIndex: root.selectedUavIndex
        anchors.right: rightPanel.left
        anchors.bottom: uavStatus.top
        width: 360
        height: 122
        onDecisionRequested: {
            root.uavDecision = decision
            root.lastJournalEvent = root.missionId + " · UAV-" + (uavIndex + 1) + " · " + decision
            root.journalEvent("UAV_DECISION", uavIndex, decision)
            root.journalAppendRequested("UAV_DECISION", root.missionId, uavIndex, decision)
            root.journalStatus = "EVENT EMITTED"
            root.uavDecisionRequested(decision, uavIndex)
            root.selectedUavIndex = -1
        }
        onContextClosed: root.selectedUavIndex = -1
    }
}
