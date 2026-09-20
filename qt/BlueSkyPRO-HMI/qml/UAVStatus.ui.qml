import QtQuick

Item {
    id: root
    signal uavSelected(int index)
    implicitHeight: 78
    property color bg: "#000000"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color green: "#64FF00"
    property color amber: "#FFD339"
    property color divider: "#202020"

    Rectangle { anchors.fill: parent; color: root.bg }
    Row {
        anchors.fill: parent; anchors.margins: 10; spacing: 8
        Repeater {
            model: [
                "UAV-01  READY\nBAT 96% · C2 OK · HGT 80 m",
                "UAV-02  READY\nBAT 94% · C2 OK · HGT 80 m",
                "UAV-03  CHECK\nBAT 91% · correction pending",
                "UAV-04  READY\nBAT 95% · C2 OK · HGT 80 m"
            ]
            delegate: Rectangle {
                width: (parent.width - 24) / 4
                height: 58
                color: "#0A0A0A"
                border.color: index === 2 ? root.amber : root.divider
                border.width: 1
                Text { anchors.fill: parent; anchors.margins: 10; text: modelData; color: index === 2 ? root.amber : root.text; font.family: "B612 Mono"; font.pixelSize: 10; lineHeight: 1.25; verticalAlignment: Text.AlignVCenter }
                MouseArea { anchors.fill: parent; onClicked: root.uavSelected(index) }
            }
        }
    }
}