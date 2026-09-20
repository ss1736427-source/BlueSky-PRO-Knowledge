import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: root
    visible: true
    width: 1920
    height: 1080
    minimumWidth: 1280
    minimumHeight: 720
    title: "BlueSky PRO"
    color: theme.bg

    /*
      BlueSky PRO — HMI visual baseline
      UX flow:
      Intent → Task → Constraints → Resources → Mission →
      Validation → Execution

      Presentation only:
      critical mission logic and safety authority remain in Core/Safety.
    */
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
        readonly property color panel2: "#101010"
        readonly property color map: "#07131A"
        readonly property color divider: "#202020"
        readonly property color route: "#32FFFF"
    }

    property int headerHeight: 64
    property int leftWidth: 280
    property int rightWidth: 320
    property int bottomHeight: 194

    // =========================================================
    // HEADER / SYSTEM STATUS
    // =========================================================
    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.headerHeight
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
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 26

            Text {
                text: "BlueSky PRO"
                color: theme.text
                font.pixelSize: 22
                font.bold: true
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                text: "ETD 10:30"
                color: theme.secondary
                font.pixelSize: 13
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                text: "TOT 00:42"
                color: theme.secondary
                font.pixelSize: 13
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                text: "TRIP 01:18"
                color: theme.secondary
                font.pixelSize: 13
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                text: "ETA 11:48"
                color: theme.secondary
                font.pixelSize: 13
                verticalAlignment: Text.AlignVCenter
            }

            Item { width: 10; height: 1 }

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

            Item { width: 10; height: 1 }

            Text {
                text: "OPERATOR"
                color: theme.cyan
                font.pixelSize: 13
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    // =========================================================
    // LEFT PANEL — MISSION / TASK
    // =========================================================
    Rectangle {
        id: leftPanel
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.bottom: bottomStrip.top
        width: root.leftWidth
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
            spacing: 12

            Text {
                text: "MISSION TEMPLATES"
                color: theme.secondary
                font.pixelSize: 13
                font.bold: true
            }

            Repeater {
                model: ["Area Survey", "Building 3D", "Landscape Photo"]

                delegate: Rectangle {
                    width: leftPanel.width - 32
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

            Rectangle {
                width: parent.width
                height: 1
                color: theme.divider
            }

            Text {
                text: "MISSION ANALYSIS"
                color: theme.secondary
                font.pixelSize: 13
                font.bold: true
            }

            Text {
                text: "BS-260920-A-001"
                color: theme.text
                font.pixelSize: 14
                font.bold: true
            }

            Text {
                text: "Planning · 4 UAV"
                color: theme.secondary
                font.pixelSize: 13
            }

            Text {
                text: "MISSION PROFILE"
                color: theme.secondary
                font.pixelSize: 12
                font.bold: true
                topPadding: 8
            }

            Text {
                text: "Total time     00:42\nETD              10:30\nETA              11:48\nTRIP TIME      01:18"
                color: theme.text
                font.pixelSize: 12
                lineHeight: 1.35
            }

            Text {
                text: "CONSTRAINTS"
                color: theme.secondary
                font.pixelSize: 12
                font.bold: true
                topPadding: 6
            }

            Text {
                text: "Height 80 m · BVLOS\nWind-aware routing · 4 UAV"
                color: theme.secondary
                font.pixelSize: 12
                lineHeight: 1.35
            }
        }
    }

    // =========================================================
    // FLIGHT CHART — PRIMARY WORKSPACE
    // =========================================================
    Rectangle {
        id: map
        anchors.top: header.bottom
        anchors.left: leftPanel.right
        anchors.right: rightPanel.left
        anchors.bottom: bottomStrip.top
        color: theme.map
        clip: true

        Text {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 14
            text: "FLIGHT CHART"
            color: theme.secondary
            font.pixelSize: 16
            font.bold: true
        }

        // Map grid
        Repeater {
            model: 9

            Rectangle {
                x: index * map.width / 8
                y: 48
                width: 1
                height: map.height - 64
                color: "#10232C"
            }
        }

        Repeater {
            model: 6

            Rectangle {
                x: 0
                y: 70 + index * (map.height - 90) / 5
                width: map.width
                height: 1
                color: "#10232C"
            }
        }

        // Restricted area
        Rectangle {
            x: map.width * 0.11
            y: map.height * 0.18
            width: 190
            height: 120
            color: "#24180A"
            opacity: 0.75
            border.color: theme.amber
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "RESTRICTED AREA"
                color: theme.amber
                font.pixelSize: 11
                font.bold: true
            }
        }

        // Mission route
        Rectangle {
            id: routeBox
            x: map.width * 0.30
            y: map.height * 0.25
            width: map.width * 0.42
            height: map.height * 0.43
            color: "transparent"
            border.color: theme.route
            border.width: 2

            Text {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                text: "OPTIMAL ROUTE"
                color: theme.cyan
                font.pixelSize: 11
                font.bold: true
            }

            Repeater {
                model: 8

                Rectangle {
                    width: 7
                    height: 7
                    radius: 4
                    x: (index % 4) * (routeBox.width - 20) / 3 + 6
                    y: index < 4
                        ? 18
                        : routeBox.height - 25
                    color: theme.cyan
                }
            }
        }

        // Route direction indicator
        Text {
            anchors.left: routeBox.left
            anchors.bottom: routeBox.bottom
            anchors.margins: 12
            text: "→  WEST / EAST"
            color: theme.secondary
            font.pixelSize: 11
        }

        // Weather / wind overlay
        Rectangle {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 16
            anchors.bottomMargin: 16
            width: 270
            height: 64
            color: "#0A0A0A"
            border.color: theme.divider
            border.width: 1

            Text {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 10
                text: "WEATHER / WIND"
                color: theme.secondary
                font.pixelSize: 11
                font.bold: true
            }

            Text {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                anchors.bottomMargin: 9
                text: "→  7 m/s · 240°    Forecast / Actual"
                color: theme.text
                font.pixelSize: 12
            }
        }

        // Flight profile overlay
        Rectangle {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 16
            anchors.bottomMargin: 16
            width: 300
            height: 64
            color: "#0A0A0A"
            border.color: theme.divider
            border.width: 1

            Text {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 10
                text: "FLIGHT PROFILE"
                color: theme.secondary
                font.pixelSize: 11
                font.bold: true
            }

            Text {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                anchors.bottomMargin: 9
                text: "80 m · 18 m/s · energy reserve 24%"
                color: theme.text
                font.pixelSize: 12
            }
        }
    }

    // =========================================================
    // RIGHT PANEL — VALIDATION / READINESS
    // =========================================================
    Rectangle {
        id: rightPanel
        anchors.top: header.bottom
        anchors.right: parent.right
        anchors.bottom: bottomStrip.top
        width: root.rightWidth
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
            spacing: 10

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
                text: "CORRECTIONS"
                color: theme.secondary
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: "Wind correction pending confirmation"
                color: theme.amber
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                width: parent.width
            }

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

            Text {
                text: "Validation CONFIRM"
                color: theme.green
                font.pixelSize: 14
                font.bold: true
            }

            Rectangle {
                width: parent.width
                height: 42
                color: "transparent"
                border.color: theme.green
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "VALIDATE MISSION"
                    color: theme.green
                    font.pixelSize: 13
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                }
            }

            Rectangle {
                width: parent.width
                height: 42
                color: "transparent"
                border.color: theme.divider
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "START MISSION"
                    color: theme.muted
                    font.pixelSize: 13
                    font.bold: true
                }
            }

            Text {
                text: "LOCKED UNTIL VALIDATION CONFIRMATION"
                color: theme.muted
                font.pixelSize: 11
                wrapMode: Text.WordWrap
                width: parent.width
            }

            Rectangle {
                width: parent.width
                height: 1
                color: theme.divider
            }

            Text {
                text: "SAFETY GATE"
                color: theme.secondary
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: "Core / Safety authority active\nAI recommendations: advisory only"
                color: theme.secondary
                font.pixelSize: 11
                lineHeight: 1.35
            }
        }
    }

    // =========================================================
    // BOTTOM — UAV STATUS + NAVIGATION
    // =========================================================
    Rectangle {
        id: bottomStrip
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: root.bottomHeight
        color: theme.bg

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 1
            color: theme.divider
        }

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            anchors.topMargin: 12
            spacing: 10
            height: 72

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
                        color: index === 2 ? theme.amber : theme.green
                        font.pixelSize: 13
                        font.bold: true
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: 10
                        anchors.bottomMargin: 8
                        text: "C2  OK"
                        color: theme.muted
                        font.pixelSize: 10
                    }
                }
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: navRow.top
            anchors.bottomMargin: 1
            height: 1
            color: theme.divider
        }

        Row {
            id: navRow
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            anchors.bottomMargin: 10
            height: 40

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "◀ LEFT"
                color: theme.cyan
                font.pixelSize: 12
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 120
                anchors.verticalCenter: parent.verticalCenter
                text: "MISSION"
                color: theme.secondary
                font.pixelSize: 12
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: "FLIGHT  ·  MAP  ·  TOOLS  ·  LOG"
                color: theme.text
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: "RIGHT ▶"
                color: theme.cyan
                font.pixelSize: 12
            }
        }
    }
}
