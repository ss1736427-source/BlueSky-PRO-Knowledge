import QtQuick

Item {
    id: root

    property string title: "PANEL SETTINGS"
    property var tools: []
    property bool open: false

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
                text: "☐  " + modelData
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
