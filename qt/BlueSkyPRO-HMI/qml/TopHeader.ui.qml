import QtQuick

Item {
    id: root

    // Top Header — composition workbench variant for Qt Design Studio.
    // Design Studio workbench size only; runtime width remains adaptive through parent anchors.
    implicitWidth: 1920
    implicitHeight: root.headerHeight

    property int headerHeight: 86
    property color bg: "#050A12"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color muted: "#7F7F7F"
    property color green: "#64FF00"
    property color amber: "#FFD339"
    property color red: "#FF1E14"
    property color divider: "#111F30"
    property color panel: "#08111D"
    property color accent: "#32FFFF"
    property int borderWidth: 1
    property int borderRadius: 4

    property string etd: "10:30"
    property string tot: "—"
    property string trip: "—"
    property string eta: "11:48"
    property bool ready: true
    property bool warningActive: true
    property string operatorLabel: "OPERATOR"

    // Adjustable composition parameters — working values, not frozen tokens.
    property int anchorWidth: 164
    property int centralSectorWidth: 112
    property int sectorGap: 0
    property int anchorPadding: 14
    property int logoScale: 100
    property int logoVisualWidth: 132
    property int logoVisualHeight: 34
    property int operatorIconSize: 34
    property int operatorLabelSize: 11
    property int headingSize: 11
    property int valueSize: 18
    property int headingValueGap: 3
    // One canonical stroke token for every Header line.
    property int headerStrokeWidth: 1

    property bool tabletVariant: width < 1500

    Rectangle {
        id: headerSurface
        anchors.fill: parent
        color: root.panel
        border.width: 0
    }

    // LEFT ANCHOR — width is a composition parameter and contains the scalable logo.
    Item {
        id: logoBlock
        width: root.anchorWidth
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Item {
            width: Math.min(Math.round(root.logoVisualWidth * root.logoScale / 100),
                            logoBlock.width - 2 * root.anchorPadding)
            height: Math.min(Math.round(root.logoVisualHeight * root.logoScale / 100),
                             logoBlock.height - 2 * root.anchorPadding)
            anchors.centerIn: parent

            // Temporary visual slot until the controlled master SVG is supplied.
            Text {
                anchors.centerIn: parent
                text: "BlueSky PRO"
                color: root.text
                font.family: "B612"
                font.pixelSize: Math.max(12, Math.round(22 * root.logoScale / 100))
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    // RIGHT ANCHOR — outer geometry is intentionally identical to LOGO anchor.
    Item {
        id: operatorBlock
        width: root.anchorWidth
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Item {
            anchors.centerIn: parent
            width: parent.width - 2 * root.anchorPadding
            height: parent.height - 2 * root.anchorPadding

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: root.divider
                border.width: root.headerStrokeWidth
                radius: 3
            }

            Column {
                anchors.centerIn: parent
                spacing: 2

                Rectangle {
                    width: root.operatorIconSize
                    height: root.operatorIconSize
                    radius: width / 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#0C1725"
                    border.color: root.secondary
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "●"
                        color: root.secondary
                        font.pixelSize: Math.round(root.operatorIconSize * 0.42)
                    }
                }

                Text {
                    text: root.operatorLabel
                    color: root.secondary
                    font.family: "B612"
                    font.pixelSize: root.operatorLabelSize
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    // CENTRAL COMPOSITION — fills the adaptive space between equal-width anchors.
    // Six equal sectors preserve the geometric center between TRIP and ETA.
    Item {
        id: centralComposition
        anchors.left: logoBlock.right
        anchors.right: operatorBlock.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        HeaderSector {
            id: etdSector
            width: parent.width / 6
            height: parent.height
            title: "ETD"
            value: root.etd
            valueColor: root.secondary
            headingSize: root.headingSize
            valueSize: root.valueSize
            headingValueGap: root.headingValueGap
            anchors.left: parent.left
        }

        HeaderSector {
            id: totSector
            width: parent.width / 6
            height: parent.height
            title: "TOT"
            value: root.tot
            valueColor: root.secondary
            headingSize: root.headingSize
            valueSize: root.valueSize
            headingValueGap: root.headingValueGap
            anchors.left: etdSector.right
        }

        HeaderSector {
            id: tripSector
            width: parent.width / 6
            height: parent.height
            title: "TRIP"
            value: root.trip
            valueColor: root.secondary
            headingSize: root.headingSize
            valueSize: root.valueSize
            headingValueGap: root.headingValueGap
            anchors.left: totSector.right
        }

        HeaderSector {
            id: etaSector
            width: parent.width / 6
            height: parent.height
            title: "ETA"
            value: root.eta
            valueColor: root.secondary
            headingSize: root.headingSize
            valueSize: root.valueSize
            headingValueGap: root.headingValueGap
            anchors.left: tripSector.right
        }

        HeaderSector {
            id: readySector
            width: parent.width / 6
            height: parent.height
            title: "READY"
            value: root.ready ? "READY" : "NOT READY"
            valueColor: root.ready ? root.green : root.amber
            headingSize: root.headingSize
            valueSize: root.valueSize
            headingValueGap: root.headingValueGap
            anchors.left: etaSector.right
        }

        HeaderSector {
            id: warningSector
            width: parent.width / 6
            height: parent.height
            title: "WARNING"
            value: root.warningActive ? "!" : "—"
            valueColor: root.warningActive ? root.amber : root.muted
            headingSize: root.headingSize
            valueSize: root.valueSize
            headingValueGap: root.headingValueGap
            anchors.left: readySector.right
        }
    }

    // Structural dividers — all coordinates are in the root coordinate space.
    Rectangle {
        x: Math.round(centralComposition.x)
        y: Math.round((parent.height - root.separatorHeight) / 2)
        width: root.headerStrokeWidth
        height: Math.min(root.separatorHeight, parent.height - 16)
        color: root.accent
        z: 90
    }

    Rectangle {
        x: Math.round(centralComposition.x + centralComposition.width / 6)
        y: Math.round((parent.height - root.separatorHeight) / 2)
        width: root.headerStrokeWidth
        height: Math.min(root.separatorHeight, parent.height - 16)
        color: root.accent
        z: 90
    }

    Rectangle {
        x: Math.round(centralComposition.x + centralComposition.width * 2 / 6)
        y: Math.round((parent.height - root.separatorHeight) / 2)
        width: root.headerStrokeWidth
        height: Math.min(root.separatorHeight, parent.height - 16)
        color: root.accent
        z: 90
    }

    Rectangle {
        x: Math.round(centralComposition.x + centralComposition.width * 3 / 6)
        y: Math.round((parent.height - root.separatorHeight) / 2)
        width: root.headerStrokeWidth
        height: Math.min(root.separatorHeight, parent.height - 16)
        color: root.accent
        z: 91
    }

    Rectangle {
        x: Math.round(centralComposition.x + centralComposition.width * 4 / 6)
        y: Math.round((parent.height - root.separatorHeight) / 2)
        width: root.headerStrokeWidth
        height: Math.min(root.separatorHeight, parent.height - 16)
        color: root.accent
        z: 90
    }

    Rectangle {
        x: Math.round(centralComposition.x + centralComposition.width * 5 / 6)
        y: Math.round((parent.height - root.separatorHeight) / 2)
        width: root.headerStrokeWidth
        height: Math.min(root.separatorHeight, parent.height - 16)
        color: root.accent
        z: 90
    }

    Rectangle {
        x: Math.round(centralComposition.x + centralComposition.width)
        y: Math.round((parent.height - root.separatorHeight) / 2)
        width: root.headerStrokeWidth
        height: Math.min(root.separatorHeight, parent.height - 16)
        color: root.accent
        z: 90
    }

    // Outer frame: explicit 1px primitives, same as every structural divider.
    // Do not use Rectangle.border here: its rasterization differs from the divider
    // rectangles, especially at Design Studio zoom levels.
    Rectangle {
        x: 0
        y: 0
        width: parent.width
        height: root.headerStrokeWidth
        color: root.accent
        z: 100
    }

    Rectangle {
        x: 0
        y: parent.height - root.headerStrokeWidth
        width: parent.width
        height: root.headerStrokeWidth
        color: root.accent
        z: 100
    }

    Rectangle {
        x: 0
        y: 0
        width: root.headerStrokeWidth
        height: parent.height
        color: root.accent
        z: 100
    }

    Rectangle {
        x: parent.width - root.headerStrokeWidth
        y: 0
        width: root.headerStrokeWidth
        height: parent.height
        color: root.accent
        z: 100
    }

    // Central composition always occupies the exact adaptive space between the two equal anchors.

}