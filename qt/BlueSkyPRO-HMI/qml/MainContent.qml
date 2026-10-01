import QtQuick

Item {
    id: root
    width: 1920
    height: 1080

    // BlueSky PRO — Qt Design Studio working screen.
    // Visual composition only. Core / Safety remain authoritative.
    property int toolbarHeight: 54
    property int headerHeight: toolbarHeight
    property int leftWidth: leftPanel.implicitWidth
    property int rightWidth: leftWidth
    property bool leftPanelOpen: true
    property bool rightPanelOpen: true
    // Mission workflow states: AUTO, HIDDEN, MANUAL, VALIDATING
    property string missionState: "AUTO"
    readonly property bool missionVisible: missionState === "AUTO"
    // Validation is part of the manual-mission workflow; keep its UI active.
    readonly property bool missionCreationMode:
        missionState === "MANUAL" || missionState === "VALIDATING"
    property bool missionReady: false
    property bool manualCompositionComplete: false
    // Shared map view state: retained while switching mission templates and tools.
    property real mapPanX: 0
    property real mapPanY: 0
    property real mapZoom: 1.0
    readonly property bool manualValidationStarted: missionState === "VALIDATING"
    property bool warningActive: true
    property int selectedUavIndex: -1
    property bool contextOverlayOpen: false
    readonly property var selectedUav: selectedUavIndex >= 0 && selectedUavIndex < uavStatus.uavModel.length ? uavStatus.uavModel[selectedUavIndex] : null
    readonly property string selectedUavId: selectedUav ? selectedUav.id : "NO UAV SELECTED"
    property string uavDecision: ""
    property string lastJournalEvent: ""
    property string missionId: "BS-260920-A-001"
    // Mission review status is independent of flight readiness.
    property string missionReviewState: "REWORK"
    // Populated by the mission/task aggregation layer; current value is a design-preview example.
    property string missionSummary: "3D картография территории"
    // Example current automatic mission composition; supplied by mission/task aggregation in production.
    property var missionTemplateIndices: [1]
    property string journalStatus: "READY"
    property string activeTool: bottomToolbar.activeTool
    // Role selection is the application entry point; the workspace remains underneath.
    property bool roleSelectionVisible: true
    property string currentRole: ""
    readonly property bool uavPanelOpen: activeTool === "UAV"
    signal journalEvent(string eventType, int uavIndex, string decision)
    signal journalAppendRequested(string eventType, string missionId, int uavIndex, string decision)
    signal uavDecisionRequested(string decision, int uavIndex)
    signal workspaceContextRequested(string context)
    property string workspaceContext: bottomToolbar.activeTool

    Rectangle {
        anchors.fill: parent
        color: "#050A12"
    }

    TopHeader {
        id: topHeader
        z: 100
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.headerHeight
        leftAnchorWidth: root.leftWidth
        rightAnchorWidth: root.rightWidth
        tabletVariant: false
        ready: root.missionReady
        warningActive: root.warningActive
    }

    Item {
        id: workspace
        anchors.top: topHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bottomToolbar.top

        LeftPanel {
            id: leftPanel
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            // TopHeader owns the shared horizontal separator.
            showTopBorder: false
            // BottomToolbar owns the shared seam; avoid drawing a second line here.
            showBottomBorder: false
            visible: root.leftPanelOpen
            width: visible ? root.leftWidth : 0
            missionVisible: root.missionVisible
            missionCreationMode: root.missionCreationMode
            missionId: root.missionId
            missionReviewState: root.missionReviewState
            missionSummary: root.missionSummary
            missionTemplateIndices: root.missionTemplateIndices
            onHideMissionRequested: root.missionState = "HIDDEN"
            onRestoreMissionRequested: root.missionState = "AUTO"
            onCreateMissionRequested: root.missionState = "MANUAL"
        }

        FlightChart {
            id: flightChart
            anchors.left: leftPanel.right
            anchors.right: rightPanel.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            missionVisible: root.missionVisible
            manualCreationMode: root.missionCreationMode
            manualCompositionComplete: root.manualCompositionComplete
            useExternalMapState: true
            mapPanX: root.mapPanX
            mapPanY: root.mapPanY
            mapZoom: root.mapZoom
            // Keep the map as the persistent workspace in every mode.
            visible: true
            onMapViewChangeRequested: function(panX, panY, zoom) {
                root.mapPanX = panX
                root.mapPanY = panY
                root.mapZoom = zoom
            }
            onManualCompositionCompleted: root.manualCompositionComplete = true
            onMapDoubleClicked: root.leftPanelOpen = false
        }

        ToolContext {
            id: toolContext
            anchors.left: leftPanel.right
            anchors.right: rightPanel.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            // Do not replace the map workspace while creating a mission.
            visible: !root.missionCreationMode && root.activeTool !== "MAP" && root.activeTool !== "UAV"
            contextName: root.activeTool
            selectedUavIndex: root.selectedUavIndex
            selectedUavId: root.selectedUavId
            contextSubtitle: root.activeTool === "UAV" ? "SELECT UAV / CONTROL / C2 / CONFIGURATION" : root.activeTool === "ADMIN" ? "SYSTEM ADMINISTRATION / ENGINEER / TECHNICIAN" : root.activeTool === "FPV" ? "VIDEO + FLIGHT DATA + CONTROL TRANSFER" : "SIMULATION / VIRTUAL UAV"
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
            // A zero-width panel does not clip its children: hide the whole
            // component when collapsed so buttons/text/popups cannot leak
            // into the Flight Chart.
            visible: root.rightPanelOpen
            width: visible ? root.rightWidth : 0
            // Match the left panel's shared-edge ownership: header and toolbar draw the horizontal seams.
            showTopBorder: false
            showBottomBorder: false
            showLeftBorder: true
            showRightBorder: true
            missionReady: root.missionReady
            warningActive: root.warningActive
            manualCreationMode: root.missionCreationMode
            manualCompositionComplete: root.manualCompositionComplete
            manualValidationStarted: root.manualValidationStarted
            onValidateManualMissionRequested: root.missionState = "VALIDATING"
            onStartMissionRequested: root.leftPanelOpen = false
        }

        // Keep fleet and side panels in the same coordinate space so anchors
        // resolve correctly. Cards are centered within the available workspace.
        UAVFleetPanel {
            id: uavStatus
            visible: root.uavPanelOpen
            z: 20
            selectedIndex: root.selectedUavIndex
            onUavSelected: {
                root.selectedUavIndex = index
                root.contextOverlayOpen = false
            }
            onUavDoubleClicked: {
                root.selectedUavIndex = index
                root.contextOverlayOpen = true
            }
            anchors.left: leftPanel.right
            anchors.right: rightPanel.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }

        // Keep the overlay in the same coordinate space as the UAV fleet.
        ContextOverlay {
            id: contextOverlay
            visible: root.contextOverlayOpen && root.selectedUavIndex >= 0
            uavIndex: root.selectedUavIndex
            uavId: root.selectedUavId
            // Match the selected card's width, then clamp to the workspace.
            width: Math.max(minWidth, Math.min(maxWidth,
                uavStatus.cardRect(root.selectedUavIndex).width, parent.width - 16))
            height: implicitHeight
            x: {
                var card = uavStatus.cardRect(root.selectedUavIndex)
                var cardCenterX = uavStatus.x + card.x + card.width / 2
                return Math.max(8, Math.min(parent.width - width - 8, cardCenterX - width / 2))
            }
            y: {
                var card = uavStatus.cardRect(root.selectedUavIndex)
                var cardTop = uavStatus.y + card.y
                var above = cardTop - height - 8
                // Prefer directly above the affected card; if space is limited,
                // place it over the card while keeping the whole panel in view.
                return above >= 8 ? above
                                  : Math.max(8, Math.min(parent.height - height - 8,
                                        cardTop + (card.height - height) / 2))
            }
            z: 30
            onDecisionRequested: root.uavDecisionRequested(decision, uavIndex)
            onContextClosed: root.contextOverlayOpen = false
        }
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
        onToolActivated: root.contextOverlayOpen = false
    }

    // Entry screen connected to the real workspace. Continue closes the
    // role screen and activates the corresponding application context.
    RoleSelection {
        id: roleSelection
        anchors.fill: parent
        z: 1000
        visible: root.roleSelectionVisible
        onContinueRequested: function(role) {
            root.currentRole = role
            root.roleSelectionVisible = false
            if (role === "ADMIN")
                bottomToolbar.activateTool("ADMIN")
            else if (role === "ENGINEER")
                bottomToolbar.activateTool("UAV")
            else
                bottomToolbar.activateTool("UAV")
        }
    }

}
