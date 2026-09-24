import QtQuick

Item {
    id: root

    width: 1440
    height: 96

    Rectangle {
        anchors.fill: parent
        color: "#050A12"
    }

    BottomToolbar {
        id: toolbar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 54
    }

    Text {
        x: 18
        y: 8
        text: "DS / BOTTOM TOOLBAR / 001 — DRAG REORDER + GAP-FREE HIDE"
        color: "#7F7F7F"
        font.family: "IBM Plex Sans Condensed"
        font.pixelSize: 9
    }

    Text {
        x: 18
        y: 22
        text: "Drag workspace buttons to reorder • ☰ enables/disables buttons"
        color: "#BFBFBF"
        font.family: "IBM Plex Sans Condensed"
        font.pixelSize: 9
    }
}
