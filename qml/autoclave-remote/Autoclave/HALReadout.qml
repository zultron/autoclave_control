import QtQuick 2.0
import Machinekit.HalRemote 1.0

Readout {
    id: base

    // Main properties
    property string name: "read-pin"
    property bool synced: true
    property bool dir_in: true

    // Connect HAL pin
    HalPin {
        id: pin
        name: base.name
        type: (base.timeMode ? HalPin.S32 : HalPin.Float)
        direction: HalPin.In
    }

    Binding {
        target: base;
        property: "value";
        value: pin.value;
    }

    Binding {
        target: base;
        property: "synced";
        value: pin.synced;
    }
}
