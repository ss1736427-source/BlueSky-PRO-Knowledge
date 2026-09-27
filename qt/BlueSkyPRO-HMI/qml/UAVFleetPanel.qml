import QtQuick
import Qt.labs.settings

Item {
    id: root

    signal uavSelected(int index)
    signal uavDoubleClicked(int index)

    property int selectedIndex: -1
    property int settingsIndex: -1
    property var uavModel: [
        { id: "BS-001", modelName: "MULTIROTOR", sequence: "01", state: "READY", height: 0, speed: 0, battery: 100, engine: 0, wind: "—", heading: "—", eta: "—", c2: "C2 OK", camera: "—", range: "120 km", eet: "—", trip: "—", tot: "—", gnss: "3D FIX", link: "OK", wp: "—", progress: "STBY", batteryHealth: "100 %", payload: "—", telemetry: "NOMINAL" },
        { id: "BS-002", modelName: "FIXED WING", sequence: "02", state: "READY", height: 0, speed: 0, battery: 100, engine: 0, wind: "—", heading: "—", eta: "—", c2: "C2 OK", camera: "—", range: "180 km", eet: "—", trip: "—", tot: "—", gnss: "3D FIX", link: "OK", wp: "—", progress: "STBY", batteryHealth: "100 %", payload: "—", telemetry: "NOMINAL" },
        { id: "BS-003", modelName: "MULTIROTOR", sequence: "03", state: "READY", height: 0, speed: 0, battery: 100, engine: 0, wind: "—", heading: "—", eta: "—", c2: "C2 OK", camera: "—", range: "150 km", eet: "—", trip: "—", tot: "—", gnss: "3D FIX", link: "OK", wp: "—", progress: "STBY", batteryHealth: "100 %", payload: "—", telemetry: "NOMINAL" },
        { id: "BS-004", modelName: "VTOL", sequence: "04", state: "READY", height: 0, speed: 0, battery: 100, engine: 0, wind: "—", heading: "—", eta: "—", c2: "C2 OK", camera: "—", range: "200 km", eet: "—", trip: "—", tot: "—", gnss: "3D FIX", link: "OK", wp: "—", progress: "STBY", batteryHealth: "100 %", payload: "—", telemetry: "NOMINAL" }
    ]

    property var defaultParameters: ["ALT", "SPD", "BAT", "ENG"]
    property var parameterConfigs: ({})

    Settings {
        id: settings
        category: "BlueSkyPRO/UAVPanel"
        property string uavOrderJson: ""
        property string parameterConfigsJson: ""
    }

    function parseJson(value, fallback) {
        try { return value ? JSON.parse(value) : fallback } catch (e) { return fallback }
    }

    function persist() {
        settings.uavOrderJson = JSON.stringify(root.uavModel.map(function(item) { return item.id }))
        settings.parameterConfigsJson = JSON.stringify(root.parameterConfigs)
    }

    function parametersFor(index) {
        if (index < 0 || index >= root.uavModel.length)
            return root.defaultParameters.slice()
        var id = root.uavModel[index].id
        var saved = root.parameterConfigs[id]
        return Array.isArray(saved) ? saved.slice() : root.defaultParameters.slice()
    }

    function moveUav(fromIndex, toIndex) {
        if (fromIndex < 0 || toIndex < 0 || fromIndex >= root.uavModel.length || toIndex >= root.uavModel.length || fromIndex === toIndex)
            return
        var next = root.uavModel.slice()
        var item = next.splice(fromIndex, 1)[0]
        next.splice(toIndex, 0, item)
        root.uavModel = next
        if (root.selectedIndex === fromIndex)
            root.selectedIndex = toIndex
        else if (fromIndex < root.selectedIndex && toIndex >= root.selectedIndex)
            root.selectedIndex -= 1
        else if (fromIndex > root.selectedIndex && toIndex <= root.selectedIndex)
            root.selectedIndex += 1
        root.persist()
    }

    function toggleParameter(index, parameter) {
        if (index < 0 || index >= root.uavModel.length)
            return
        var next = root.parametersFor(index)
        var at = next.indexOf(parameter)
        if (at >= 0)
            next.splice(at, 1)
        else
            next.push(parameter)
        var configs = Object.assign({}, root.parameterConfigs)
        configs[root.uavModel[index].id] = next
        root.parameterConfigs = configs
        root.persist()
    }

    function moveParameter(index, parameter, direction) {
        if (index < 0 || index >= root.uavModel.length)
            return
        var next = root.parametersFor(index)
        var at = next.indexOf(parameter)
        var target = at + direction
        if (at < 0 || target < 0 || target >= next.length)
            return
        var item = next.splice(at, 1)[0]
        next.splice(target, 0, item)
        var configs = Object.assign({}, root.parameterConfigs)
        configs[root.uavModel[index].id] = next
        root.parameterConfigs = configs
        root.persist()
    }

    function applyParametersToAll() {
        var params = root.parametersFor(root.settingsIndex)
        var configs = Object.assign({}, root.parameterConfigs)
        for (var i = 0; i < root.uavModel.length; ++i)
            configs[root.uavModel[i].id] = params.slice()
        root.parameterConfigs = configs
        root.persist()
    }

    Component.onCompleted: {
        root.parameterConfigs = root.parseJson(settings.parameterConfigsJson, ({}))
        var savedOrder = root.parseJson(settings.uavOrderJson, [])
        if (Array.isArray(savedOrder) && savedOrder.length) {
            var ordered = []
            for (var i = 0; i < savedOrder.length; ++i) {
                for (var j = 0; j < root.uavModel.length; ++j) {
                    if (root.uavModel[j].id === savedOrder[i])
                        ordered.push(root.uavModel[j])
                }
            }
            for (var k = 0; k < root.uavModel.length; ++k) {
                var found = false
                for (var n = 0; n < ordered.length; ++n)
                    if (ordered[n].id === root.uavModel[k].id) found = true
                if (!found) ordered.push(root.uavModel[k])
            }
            root.uavModel = ordered
        }
    }

    UAVFleetPanelForm {
        id: form
        anchors.fill: parent
        uavModel: root.uavModel
        selectedIndex: root.selectedIndex
        settingsIndex: root.settingsIndex
        settingsParameters: root.parametersFor(root.settingsIndex)
        onUavSelected: {
            root.selectedIndex = index
            root.uavSelected(index)
        }
        onUavDoubleClicked: {
            root.selectedIndex = index
            root.uavDoubleClicked(index)
        }
        onSettingsRequested: {
            if (root.settingsIndex === index && form.settingsOpen)
                form.settingsOpen = false
            else {
                root.settingsIndex = index
                form.settingsOpen = true
            }
        }
        onReorderRequested: root.moveUav(fromIndex, toIndex)
        onParameterToggleRequested: root.toggleParameter(root.settingsIndex, parameter)
        onParameterMoveRequested: root.moveParameter(root.settingsIndex, parameter, direction)
        onApplyToAllRequested: root.applyParametersToAll()
        onSettingsClosed: form.settingsOpen = false
    }
}
