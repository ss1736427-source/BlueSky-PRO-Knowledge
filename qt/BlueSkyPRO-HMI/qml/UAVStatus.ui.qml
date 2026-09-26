import QtQuick

Item {
    id: root

    signal uavSelected(int index)

    implicitHeight: 82

    property color bg: "#000000"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color green: "#64FF00"
    property color amber: "#FFD339"
    property color divider: "#202020"

    // Visual working model. Final parameter set remains configurable per UAV panel.
    property var uavModel: [
        { id: "UAV-01", state: "READY", battery: "96%", detail: "C2 OK  |  HGT 80 m" },
        { id: "UAV-02", state: "READY", battery: "94%", detail: "C2 OK  |  HGT 80 m" },
        { id: "UAV-03", state: "CHECK", battery: "91%", detail: "correction pending" },
        { id: "UAV-04", state: "READY", battery: "95%", detail: "C2 OK  |  HGT 80 m" }
    ]

    Rectangle {
        anchors.fill: parent
        color: root.bg
    }

    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 46
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 10
        spacing: 8

        Repeater {
            model: root.uavModel

            delegate: Rectangle {
                width: (parent.width - Math.max(0, root.uavModel.length - 1) * 8) / Math.max(1, root.uavModel.length)
                height: 62
                color: "#0A0A0A"
                border.color: modelData.state === "CHECK" ? root.amber : root.divider
                border.width: 1

                Text {
                    anchors.fill: parent
                    anchors.margins: 10
                    text: modelData.id + "  " + modelData.state
                          + "\nBAT " + modelData.battery + "  |  " + modelData.detail
                    color: modelData.state === "CHECK" ? root.amber : root.text
                    font.family: "B612 Mono"
                    font.pixelSize: 10
                    lineHeight: 1.25
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.uavSelected(index)
                }
            }
        }
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
        height: 254
        title: "UAV PANEL SETTINGS"
        tools: ["UAV Selection", "Control / C2", "Navigation", "Energy", "Payload / Equipment", "Maintenance", "Diagnostics", "Displayed Parameters"]
        onClosed: open = false
    }
}
