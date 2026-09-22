import QtQuick

Item {
    id: root
    width: 1920
    height: 1080

    // BlueSky PRO — Qt Design Studio working screen.
    // Visual composition only. Core / Safety remain authoritative.
    property int headerHeight: 62
    property int leftWidth: 300
    property int rightWidth: 340
    property int uavHeight: 82
    property int toolbarHeight: 54
    property bool leftPanelOpen: true
    property bool rightPanelOpen: true
    property int selectedUavIndex: -1
    property string uavDecision: ""
    property string lastJournalEvent: ""
    property string missionId: "BS-260920-A-001"
    property string journalStatus: "READY"
    signal journalEvent(string eventType, int uavIndex, string decision)
    signal journalAppendRequested(string eventType, string missionId, int uavIndex, string decision)
    signal uavDecisionRequested(string decision, int uavIndex)

    Rectangle {
        anchors.fill: parent
        color: "#000000"
    }

    TopHeader {
        id: topHeader
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.headerHeight
        tabletVariant: root.width < 1500
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
        }

        FlightChart {
            id: flightChart
            anchors.left: leftPanel.right
            anchors.right: rightPanel.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }

        RightPanel {
            id: rightPanel
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: root.rightPanelOpen ? root.rightWidth : 0
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
