import QtQuick

Item {
    id: root

    property string contextName: "UAV"
    property string contextSubtitle: ""
    property var sections: []

    Rectangle {
        anchors.fill: parent
        color: "#050A12"
    }

    Text {
        x: 24
        y: 22
        text: root.contextName
        color: "#FFFFFF"
        font.family: "B612"
        font.pixelSize: 20
        font.bold: true
    }

    Text {
        x: 24
        y: 52
        text: root.contextSubtitle
        color: "#7F7F7F"
        font.family: "B612 Mono"
        font.pixelSize: 10
    }

    Rectangle {
        x: 24
        y: 82
        width: parent.width - 48
        height: 1
        color: "#202020"
    }

    Flow {
        x: 24
        y: 104
        width: parent.width - 48
        spacing: 10

        Repeater {
            model: root.sections

            delegate: Rectangle {
                width: 220
                height: 74
                color: "#08111D"
                border.color: "#202020"
                border.width: 1

                Text {
                    x: 12
                    y: 12
                    text: modelData
                    color: "#BFBFBF"
                    font.family: "B612"
                    font.pixelSize: 12
                    font.bold: true
                }

                Text {
                    x: 12
                    y: 38
                    text: "CONFIGURABLE"
                    color: "#7F7F7F"
                    font.family: "B612 Mono"
                    font.pixelSize: 9
                }
            }
        }
    }

    PanelSettingsButton {
        id: settings
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 14
        onClicked: popup.open = !popup.open
    }

    PanelSettingsPopup {
        id: popup
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 48
        width: 280
        height: Math.min(420, 80 + root.sections.length * 28)
        title: root.contextName + " SETTINGS"
        tools: root.sections
        onClosed: open = false
    }
}
