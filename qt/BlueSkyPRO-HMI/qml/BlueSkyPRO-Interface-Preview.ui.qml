import QtQuick

Item {
    id: root

    width: 1920
    height: 1080

    // BlueSky PRO — complete HMI preview composition.
    // Visual preview entry point: Header + Left + Flight Chart + Right +
    // UAV Status + Context Overlay + Bottom Toolbar.
    MainContent {
        id: interface
        anchors.fill: parent
    }
}
