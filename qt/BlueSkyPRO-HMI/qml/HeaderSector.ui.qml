import QtQuick

Item {
    id: root
    property string title: ""
    property string value: ""
    property color valueColor: "#BFBFBF"
    property color headingColor: "#BFBFBF"
    property int headingSize: 11
    property int valueSize: 18
    property int headingValueGap: 3

    Text {
        id: heading
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -(root.headingValueGap + root.valueSize) / 2
        text: root.title
        color: root.headingColor
        font.family: "B612"
        font.pixelSize: root.headingSize
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: heading.bottom
        anchors.topMargin: root.headingValueGap
        text: root.value
        color: root.valueColor
        font.family: "B612 Mono"
        font.pixelSize: root.valueSize
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
    }

}