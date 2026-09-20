import QtQuick

Item {
    id: root
    property color bg: "#0A0A0A"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color amber: "#FFD339"
    property color cyan: "#32FFFF"

    visible: false
    Rectangle { anchors.fill: parent; color: root.bg; border.color: root.amber; border.width: 1 }
    Text { x: 14; y: 12; text: "UAV CONTEXT"; color: root.secondary; font.family: "B612"; font.pixelSize: 12; font.bold: true }
    Text { x: 14; y: 38; text: "Preliminary assessment"; color: root.text; font.family: "B612"; font.pixelSize: 13 }
    Text { x: 14; y: 62; text: "Telemetry · deviation · resource · weather"; color: root.secondary; font.family: "B612"; font.pixelSize: 10 }
    Text { x: 14; y: 88; text: "RETURN"; color: root.amber; font.family: "B612"; font.pixelSize: 12; font.bold: true }
    Text { x: 105; y: 88; text: "ПРОДОЛЖИТЬ ПОЛЁТ"; color: root.cyan; font.family: "B612"; font.pixelSize: 12; font.bold: true }
}