import QtQuick

Item {
    id: root

    property string title: "PANEL SETTINGS"
    property var tools: []
    property bool open: false
    property var enabledTools: root.tools.slice()
    signal toolToggled(string tool, bool enabled)

    function syncEnabledTools(toolsList) {
        enabledTools = toolsList.slice()
    }

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

    function longestToolLabel() {
        var longest = ""
        for (var i = 0; i < tools.length; ++i) {
            if (String(tools[i]).length > longest.length)
                longest = String(tools[i])
        }
        return longest
    }

    TextMetrics {
        id: toolLabelMetrics
        font.family: "B612"
        font.pixelSize: 13
        text: root.longestToolLabel()
    }

    readonly property real contentWidth: toolLabelMetrics.width + 64

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
        spacing: 4

        Repeater {
            model: root.tools

            delegate: Item {
                width: parent.width
                height: 26

                Text {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: (root.enabledTools.indexOf(modelData) >= 0 ? "☑  " : "☐  ") + modelData
                    color: "#BFBFBF"
                    font.family: "B612"
                    font.pixelSize: 13
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.toggleTool(modelData)
                    cursorShape: Qt.PointingHandCursor
                }
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
