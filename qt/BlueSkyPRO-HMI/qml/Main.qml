import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: root

    // Design Studio preview theme. Production uses theme.qml via the CMake QML module.
    QtObject {
        id: theme
        readonly property color bg: "#000000"
        readonly property color text: "#FFFFFF"
        readonly property color secondary: "#BFBFBF"
        readonly property color muted: "#7F7F7F"
        readonly property color green: "#64FF00"
        readonly property color amber: "#FFD339"
        readonly property color red: "#FF1E14"
        readonly property color cyan: "#32FFFF"
        readonly property color magenta: "#FF32FF"
        readonly property color panel: "#0A0A0A"
        readonly property color divider: "#202020"
    }
    visible: true
    width: 1920
    height: 1080
    minimumWidth: 1280
    minimumHeight: 720
    title: "BlueSky PRO"

    color: theme.bg

    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 64
        color: theme.bg

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: theme.divider
        }

        Row {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 28

            Text {
                text: "BlueSky PRO"
                color: theme.text
                font.pixelSize: 22
                font.bold: true
                verticalAlignment: Text.AlignVCenter
            }

            Text { text: "ETD 10:30"; color: theme.secondary; font.pixelSize: 13; verticalAlignment: Text.AlignVCenter }
            Text { text: "TOT 00:42"; color: theme.secondary; font.pixelSize: 13; verticalAlignment: Text.AlignVCenter }
            Text { text: "TRIP 01:18"; color: theme.secondary; font.pixelSize: 13; verticalAlignment: Text.AlignVCenter }
            Text { text: "ETA 11:48"; color: theme.secondary; font.pixelSize: 13; verticalAlignment: Text.AlignVCenter }

            Item { width: 1; height: 1 }

            Text {
                text: "READY  CHECK"
                color: theme.amber
                font.pixelSize: 14
                font.bold: true
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                text: "Revalidation complete · confirm"
                color: theme.amber
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter
            }

            Item { width: 1; height: 1 }

            Text {
                text: "OPERATOR"
                color: theme.cyan
                font.pixelSize: 13
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    Rectangle {
        id: leftPanel
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.bottom: bottomStrip.top
        width: 280
        color: theme.panel

        Rectangle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: 1
            color: theme.divider
        }

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 14

            Text {
                text: "MISSION TEMPLATES"
                color: theme.secondary
                font.pixelSize: 13
                font.bold: true
            }

            Repeater {
                model: ["Area Survey", "Building 3D", "Landscape Photo"]
                delegate: Rectangle {
                    width: parent.width
                    height: 42
                    color: index === 0 ? "#151515" : theme.panel
                    border.color: index === 0 ? theme.cyan : theme.divider
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: theme.text
                        font.pixelSize: 13
                    }
                }
            }

            Text {
                text: "MISSION ANALYSIS"
                color: theme.secondary
                font.pixelSize: 13
                font.bold: true
                topPadding: 18
            }

            Text {
                text: "BS-260920-A-001\nPlanning · 4 UAV"
                color: theme.text
                font.pixelSize: 13
                lineHeight: 1.35
            }
        }
    }

    Rectangle {
        id: map
        anchors.top: header.bottom
        anchors.left: leftPanel.right
        anchors.right: rightPanel.left
        anchors.bottom: bottomStrip.top
        color: "#07131A"

        Text {
            anchors.centerIn: parent
            text: "FLIGHT CHART"
            color: theme.muted
            font.pixelSize: 20
            font.bold: true
        }

        Rectangle {
            anchors.centerIn: parent
            width: 560
            height: 300
            color: "transparent"
            border.color: theme.cyan
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "MAP PROVIDER / LOCAL DATA\nROUTE · ZONES · WEATHER · UAV"
                horizontalAlignment: Text.AlignHCenter
                color: theme.secondary
                font.pixelSize: 13
            }
        }
    }

    Rectangle {
        id: rightPanel
        anchors.top: header.bottom
        anchors.right: parent.right
        anchors.bottom: bottomStrip.top
        width: 320
        color: theme.panel

        Rectangle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: 1
            color: theme.divider
        }

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Text {
                text: "CHECKLIST"
                color: theme.text
                font.pixelSize: 16
                font.bold: true
            }

            Text { text: "✓ Mission definition"; color: theme.green; font.pixelSize: 13 }
            Text { text: "✓ UAV allocation"; color: theme.green; font.pixelSize: 13 }
            Text { text: "✓ C2 availability"; color: theme.green; font.pixelSize: 13 }
            Text { text: "⚠ Weather revalidation"; color: theme.amber; font.pixelSize: 13 }

            Rectangle {
                width: parent.width
                height: 1
                color: theme.divider
            }

            Text {
                text: "MISSION READINESS"
                color: theme.secondary
                font.pixelSize: 13
                font.bold: true
            }

            Text { text: "Validation CONFIRM"; color: theme.green; font.pixelSize: 14 }

            Button {
                text: "VALIDATE MISSION"
                width: parent.width
                height: 42
            }

            Button {
                text: "START MISSION"
                width: parent.width
                height: 42
                enabled: false
            }

            Text {
                text: "LOCKED UNTIL VALIDATION CONFIRMATION"
                color: theme.muted
                font.pixelSize: 11
                wrapMode: Text.WordWrap
                width: parent.width
            }
        }
    }

    Rectangle {
        id: bottomStrip
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 194
        color: theme.bg

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 1
            color: theme.divider
        }

        Row {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10

            Repeater {
                model: ["UAV-01  READY", "UAV-02  READY", "UAV-03  CHECK", "UAV-04  READY"]
                delegate: Rectangle {
                    width: (parent.width - 30) / 4
                    height: 72
                    color: theme.panel
                    border.color: theme.divider
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: modelData.indexOf("CHECK") >= 0 ? theme.amber : theme.green
                        font.pixelSize: 13
                        font.bold: true
                    }
                }
            }
        }

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 10
            height: 34

            Text { text: "◀ LEFT"; color: theme.cyan; font.pixelSize: 12; anchors.verticalCenter: parent.verticalCenter }
            Text { text: "CENTRAL TOOLS"; color: theme.secondary; font.pixelSize: 12; anchors.centerIn: parent }
            Text { text: "RIGHT ▶"; color: theme.cyan; font.pixelSize: 12; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter }
        }
    }
}
