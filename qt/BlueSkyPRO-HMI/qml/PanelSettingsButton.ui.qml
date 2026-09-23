import QtQuick

Item {
    id: root
    implicitWidth: 28
    implicitHeight: 28

    signal clicked()

    Rectangle {
        anchors.fill: parent
        color: "#08111D"
        border.color: "#202020"
        border.width: 1
        radius: 3
    }

    Text {
        anchors.centerIn: parent
        text: "⚙"
        color: "#32FFFF"
        font.pixelSize: 14
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
