import QtQuick

Item {
    id: root

    width: 1280
    height: 760

    property bool compositionComplete: false
    property bool validationStarted: false
    property bool missionReady: false

    Rectangle {
        anchors.fill: parent
        color: "#050A12"
    }

    Text {
        x: 28
        y: 20
        text: "DS / RIGHT PANEL / MANUAL MISSION VALIDATION / 001"
        color: "#7F7F7F"
        font.family: "IBM Plex Sans Condensed"
        font.pixelSize: 11
    }

    Text {
        x: 28
        y: 42
        text: "Preview controls simulate map composition state; they do not run the planning core."
        color: "#BFBFBF"
        font.family: "IBM Plex Sans Condensed"
        font.pixelSize: 11
    }

    RightPanel {
        id: rightPanel
        x: 920
        y: 90
        width: 340
        height: 650
        manualCreationMode: true
        manualCompositionComplete: root.compositionComplete
        manualValidationStarted: root.validationStarted
        missionReady: root.missionReady
        warningActive: true
        onValidateManualMissionRequested: root.validationStarted = true
    }

    Rectangle {
        x: 28
        y: 112
        width: 520
        height: 184
        color: "#08111D"
        border.color: "#263444"
        border.width: 1

        Column {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            Text {
                text: "MANUAL MISSION STATE"
                color: "#FFFFFF"
                font.family: "B612"
                font.pixelSize: 14
                font.bold: true
            }

            Text {
                text: root.compositionComplete ? "Сборка на карте завершена" : "Оператор собирает миссию на карте"
                color: root.compositionComplete ? "#64FF00" : "#BFBFBF"
                font.family: "B612"
                font.pixelSize: 12
            }

            Text {
                text: root.validationStarted ? "Запрос валидации отправлен · кнопка скрыта" : "Ожидание явного нажатия кнопки валидации"
                color: root.validationStarted ? "#64FF00" : "#FFD339"
                font.family: "B612"
                font.pixelSize: 12
                wrapMode: Text.WordWrap
            }
        }
    }

    Rectangle {
        x: 28
        y: 316
        width: 250
        height: 44
        radius: 2
        color: root.compositionComplete ? "#0C1725" : "#64FF00"
        border.color: "#64FF00"
        border.width: 1

        Text {
            anchors.fill: parent
            text: root.compositionComplete ? "СБОРКА ЗАВЕРШЕНА ✓" : "ЗАВЕРШИТЬ СБОРКУ (ТЕСТ)"
            color: root.compositionComplete ? "#64FF00" : "#050A12"
            font.family: "B612"
            font.pixelSize: 11
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent
            enabled: !root.compositionComplete && !root.validationStarted
            onClicked: root.compositionComplete = true
        }
    }

    Rectangle {
        x: 292
        y: 316
        width: 180
        height: 44
        color: "#0C1725"
        border.color: "#7F7F7F"
        border.width: 1

        Text {
            anchors.fill: parent
            text: "СБРОСИТЬ ТЕСТ"
            color: "#BFBFBF"
            font.family: "B612"
            font.pixelSize: 11
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.compositionComplete = false, root.validationStarted = false, root.missionReady = false
        }
    }

    Text {
        x: 28
        y: 390
        width: 520
        text: "Порядок проверки: 1) кнопка пульсирует и заблокирована; 2) нажмите «ЗАВЕРШИТЬ СБОРКУ»; 3) кнопка становится доступна; 4) нажмите «ВАЛИДАЦИЯ МИССИИ» в правой панели — она исчезнет."
        color: "#BFBFBF"
        font.family: "B612"
        font.pixelSize: 12
        wrapMode: Text.WordWrap
    }
}
