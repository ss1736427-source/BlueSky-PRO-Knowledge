import QtQuick

Item {
    id: root

    implicitHeight: 62

    property color bg: "#000000"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color muted: "#7F7F7F"
    property color green: "#64FF00"
    property color amber: "#FFD339"
    property color red: "#FF1E14"
    property color cyan: "#32FFFF"
    property color divider: "#202020"

    // One adaptive Header for PC and tablet.
    // PC: LOGO -> ETD -> TOT -> TRIP -> ETA -> READY -> WARNING -> OPERATOR
    // Tablet adds BAT as a separate device-level element.
    property bool tabletVariant: width < 1500
    property string etd: "10:30"
    property string tot: "—"
    property string trip: "01:18"
    property string eta: "11:48"
    property bool ready: true
    property bool warningActive: true
    property string operatorLabel: "PILOT"

    Rectangle {
        anchors.fill: parent
        color: root.bg
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: root.divider
    }

    // Fixed/static left anchor. The controlled logo asset remains an external slot.
    Item {
        id: logoBlock
        width: 150
        height: parent.height
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 18
            anchors.verticalCenter: parent.verticalCenter
            text: "BlueSky PRO"
            color: root.text
            font.family: "B612"
            font.pixelSize: 22
            font.bold: true
        }
    }

    Rectangle {
        anchors.left: logoBlock.right
        anchors.verticalCenter: parent.verticalCenter
        width: 1
        height: 38
        color: root.divider
    }

    // Fixed/static right anchor.
    Item {
        id: operatorBlock
        width: root.tabletVariant ? 150 : 112
        height: parent.height
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        Text {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: root.operatorLabel
            color: root.cyan
            font.family: "B612"
            font.pixelSize: 11
            font.bold: true
        }

        Text {
            visible: root.tabletVariant
            anchors.right: parent.right
            anchors.rightMargin: 18
            anchors.verticalCenter: parent.verticalCenter
            text: "BAT  --%"
            color: root.secondary
            font.family: "B612 Mono"
            font.pixelSize: 11
        }
    }

    Rectangle {
        anchors.right: operatorBlock.left
        anchors.verticalCenter: parent.verticalCenter
        width: 1
        height: 38
        color: root.divider
    }

    // Flexible central FLIGHT DATA zone.
    Row {
        id: flightData
        anchors.left: logoBlock.right
        anchors.leftMargin: 18
        anchors.right: operatorBlock.left
        anchors.rightMargin: 18
        anchors.verticalCenter: parent.verticalCenter
        spacing: root.tabletVariant ? 14 : 24
        clip: true

        Text {
            text: "ETD " + root.etd
            color: root.secondary
            font.family: "B612 Mono"
            font.pixelSize: 13
        }

        Text {
            text: "TOT " + root.tot
            color: root.secondary
            font.family: "B612 Mono"
            font.pixelSize: 13
        }

        Text {
            text: "TRIP " + root.trip
            color: root.secondary
            font.family: "B612 Mono"
            font.pixelSize: 13
        }

        Text {
            text: "ETA " + root.eta
            color: root.secondary
            font.family: "B612 Mono"
            font.pixelSize: 13
        }

        Text {
            text: root.ready ? "READY" : "NOT READY"
            color: root.ready ? root.green : root.amber
            font.family: "B612 Mono"
            font.pixelSize: 13
            font.bold: true
        }

        Text {
            visible: root.warningActive
            text: "WARNING"
            color: root.amber
            font.family: "B612 Mono"
            font.pixelSize: 11
            font.bold: true
        }
    }
}
