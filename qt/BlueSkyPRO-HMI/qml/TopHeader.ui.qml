import QtQuick

Item {
    id: root

    // Top Header — composition workbench variant for Qt Design Studio.
    implicitHeight: root.headerHeight

    property int headerHeight: 86
    property color bg: "#000000"
    property color text: "#FFFFFF"
    property color secondary: "#BFBFBF"
    property color muted: "#7F7F7F"
    property color green: "#64FF00"
    property color amber: "#FFD339"
    property color red: "#FF1E14"
    property color divider: "#202020"

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
    property int separatorHeight: 54
    property int separatorWidth: 1

    property bool tabletVariant: width < 1500

    function scalePx(value, percent) {
        return Math.round(value * percent / 100)
    }

    Rectangle {
        anchors.fill: parent
        color: root.bg
    }

    // LEFT ANCHOR — width is a composition parameter and contains the scalable logo.
    Item {
        id: logoBlock
        width: root.anchorWidth
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Item {
            width: Math.min(root.scalePx(root.logoVisualWidth, root.logoScale),
                            logoBlock.width - 2 * root.anchorPadding)
            height: Math.min(root.scalePx(root.logoVisualHeight, root.logoScale),
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
                border.width: 1
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
                    color: "#101010"
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

    // CENTRAL COMPOSITION — centered on the Header axis between TRIP and ETA.
    Row {
        id: centralComposition
        anchors.centerIn: parent
        spacing: root.sectorGap

        HeaderSector {
            width: root.centralSectorWidth
            height: root.height
            title: "ETD"
            value: root.etd
            valueColor: root.secondary
            headingSize: root.headingSize
            valueSize: root.valueSize
            headingValueGap: root.headingValueGap
            separatorHeight: root.separatorHeight
            separatorWidth: root.separatorWidth
        }
        HeaderSector {
            width: root.centralSectorWidth
            height: root.height
            title: "TOT"
            value: root.tot
            valueColor: root.secondary
            headingSize: root.headingSize
            valueSize: root.valueSize
            headingValueGap: root.headingValueGap
            separatorHeight: root.separatorHeight
            separatorWidth: root.separatorWidth
        }
        HeaderSector {
            width: root.centralSectorWidth
            height: root.height
            title: "TRIP"
            value: root.trip
            valueColor: root.secondary
            headingSize: root.headingSize
            valueSize: root.valueSize
            headingValueGap: root.headingValueGap
            separatorHeight: root.separatorHeight
            separatorWidth: root.separatorWidth
        }
        HeaderSector {
            width: root.centralSectorWidth
            height: root.height
            title: "ETA"
            value: root.eta
            valueColor: root.secondary
            headingSize: root.headingSize
            valueSize: root.valueSize
            headingValueGap: root.headingValueGap
            separatorHeight: root.separatorHeight
            separatorWidth: root.separatorWidth
        }
        HeaderSector {
            width: root.centralSectorWidth
            height: root.height
            title: "READY"
            value: root.ready ? "READY" : "NOT READY"
            valueColor: root.ready ? root.green : root.amber
            headingSize: root.headingSize
            valueSize: root.valueSize
            headingValueGap: root.headingValueGap
            separatorHeight: root.separatorHeight
            separatorWidth: root.separatorWidth
        }
        HeaderSector {
            width: root.centralSectorWidth
            height: root.height
            title: "WARNING"
            value: root.warningActive ? "!" : "—"
            valueColor: root.warningActive ? root.amber : root.muted
            headingSize: root.headingSize
            valueSize: root.valueSize
            headingValueGap: root.headingValueGap
            separatorHeight: root.separatorHeight
            separatorWidth: root.separatorWidth
            showRightSeparator: false
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: root.divider
    }

    // Visual review guard: turns red if central composition reaches the symmetric anchors.
    Rectangle {
        visible: centralComposition.width > parent.width - 2 * root.anchorWidth
        anchors.centerIn: centralComposition
        width: centralComposition.width
        height: parent.height
        color: "transparent"
        border.color: root.red
        border.width: 1
        z: 10
    }
}