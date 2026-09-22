import QtQuick

Item {
    id: root

    implicitHeight: 54

    property color bg: "#000000"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color cyan: "#32FFFF"
    property color divider: "#202020"
    property bool leftOpen: true
    property bool rightOpen: true

    signal leftPanelToggleRequested()
    signal rightPanelToggleRequested()

    Rectangle {
        anchors.fill: parent
        color: root.bg
    }

    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 6

        Repeater {
            model: ["LEFT ◀", "RIGHT ▶", "UAV", "MAP", "TOOLS", "LAYOUT", "FPV", "JOURNAL / LOG", "ADMIN"]

            delegate: Rectangle {
                width: Math.max(76, label.implicitWidth + 28)
                height: 38
                color: "#0A0A0A"
                border.color: root.divider
                border.width: 1

                Text {
                    id: label
                    anchors.centerIn: parent
                    text: modelData
                    color: index === 0
                           ? (root.leftOpen ? root.cyan : root.secondary)
                           : index === 1
                           ? (root.rightOpen ? root.cyan : root.secondary)
                           : root.secondary
                    font.family: "B612 Mono"
                    font.pixelSize: 10
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: index < 2
                    onClicked: {
                        if (index === 0)
                            root.leftPanelToggleRequested()
                        else
                            root.rightPanelToggleRequested()
                    }
                }
            }
        }
    }
}
