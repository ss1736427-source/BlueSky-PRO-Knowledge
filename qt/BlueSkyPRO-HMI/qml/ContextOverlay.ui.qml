import QtQuick

Item {
    id: root
    property color bg: "#0A0A0A"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color amber: "#FFD339"
    property color cyan: "#32FFFF"
    property int uavIndex: -1
    signal decisionRequested(string decision, int uavIndex)
    signal contextClosed()

    visible: uavIndex >= 0
    Rectangle { anchors.fill: parent; color: root.bg; border.color: root.amber; border.width: 1 }
    Text { x: 14; y: 12; text: "UAV CONTEXT"; color: root.secondary; font.family: "B612"; font.pixelSize: 12; font.bold: true }
    Text { x: 14; y: 38; text: uavIndex >= 0 ? "UAV-" + ("0" + (uavIndex + 1)).slice(-2) + " · Preliminary assessment" : "Preliminary assessment"; color: root.text; font.family: "B612"; font.pixelSize: 13 }
    Text { x: 14; y: 62; text: "Telemetry · deviation · resource · weather"; color: root.secondary; font.family: "B612"; font.pixelSize: 10 }
    Rectangle { x: 14; y: 84; width: 78; height: 26; color: "transparent"; border.color: root.amber; border.width: 1
        Text { anchors.fill: parent; text: "RETURN"; color: root.amber; font.family: "B612"; font.pixelSize: 11; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
        MouseArea { anchors.fill: parent; onClicked: root.decisionRequested("RETURN", root.uavIndex) }
    }
    Rectangle { x: 102; y: 84; width: 190; height: 26; color: "transparent"; border.color: root.cyan; border.width: 1
        Text { anchors.fill: parent; text: "ПРОДОЛЖИТЬ ПОЛЁТ"; color: root.cyan; font.family: "B612"; font.pixelSize: 11; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
        MouseArea { anchors.fill: parent; onClicked: root.decisionRequested("CONTINUE", root.uavIndex) }
    }
    Text { x: 312; y: 91; text: "×"; color: root.secondary; font.family: "B612"; font.pixelSize: 16 }
    MouseArea { x: 304; y: 80; width: 42; height: 34; onClicked: root.contextClosed() }
}