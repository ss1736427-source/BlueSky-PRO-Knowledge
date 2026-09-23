import QtQuick

Item {
    id: root

    property string title: "PANEL SETTINGS"
    property var tools: []
    property bool open: false
    property var enabledTools: root.tools.slice()
    signal toolToggled(string tool, bool enabled)

    function firstEnabled() {
        return enabledTools.length > 0 ? enabledTools[0] : ""
    }

    function toggleTool(tool) {
        var next = enabledTools.slice()
        var i = next.indexOf(tool)
        var enabled = i < 0
        if (enabled)
            next.push(tool)
        else
            next.splice(i, 1)
        enabledTools = next
        toolToggled(tool, enabled)
    }

    signal closed()

    visible: root.open
    z: 500

    Rectangle {
        anchors.fill: parent
        color: "#08111D"
        border.color: "#32FFFF"
        border.width: 1
    }

    Text {
        x: 14
        y: 12
        text: root.title
        color: "#FFFFFF"
        font.family: "B612"
        font.pixelSize: 13
        font.bold: true
    }

    Rectangle {
        x: 14
        y: 36
        width: parent.width - 28
        height: 1
        color: "#202020"
    }

    Column {
        x: 14
        y: 48
        width: parent.width - 28
        spacing: 7

        Repeater {
            model: root.tools

            delegate: Text {
                width: parent.width
                text: (root.enabledTools.indexOf(modelData) >= 0 ? "☑  " : "☐  ") + modelData
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var enabled = root.enabledTools.indexOf(modelData) >= 0
                        root.toggleTool(modelData)
                    }
                }
                color: "#BFBFBF"
                font.family: "B612"
                font.pixelSize: 10
            }
        }
    }

    Text {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 12
        text: "CLOSE"
        color: "#32FFFF"
        font.family: "B612 Mono"
        font.pixelSize: 10
        font.bold: true

        MouseArea {
            anchors.fill: parent
            anchors.margins: -8
            onClicked: root.closed()
        }
    }
}
