import QtQuick 2.0
import Machinekit.HalRemote 1.0

TempReadout {
    id: temp

    // Main properties
    property string name: "temp-pin"
    property bool synced: true
    property bool dir_in: true

    // Connect HAL pin
    HalPin {
        id: tempPin
        name: temp.name
        type: HalPin.Float
        direction: (dir_in ? HalPin.In : HalPin.Out)
    }

    Binding {
        target: temp;
        property: "value";
        value: tempPin.value;
    }

    Binding {
        target: temp;
        property: "synced";
        value: tempPin.synced;
    }
}
