import QtQuick 2.0
import Machinekit.HalRemote 1.0

GraphicTimeReadout {
    id: readout

    // Main properties
    property alias name: pin.name
    property bool synced: true
    property alias type: pin.type

    // Connect HAL pin
    HalPin {
        id: pin
        name: "time-pin"
        type: HalPin.S32
        direction: HalPin.In
    }

    Binding {
        target: readout;
        property: "value";
        value: pin.value;
    }

    Binding {
        target: readout;
        property: "synced";
        value: pin.synced;
    }
}
