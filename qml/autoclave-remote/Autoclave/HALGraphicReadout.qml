import QtQuick 2.0
import Machinekit.HalRemote 1.0

GraphicReadout {
    id: readout

    // Main properties
    property alias name: pin.name
    property bool synced: true
    property bool int_type: false

    // Connect HAL pin
    HalPin {
        id: pin
        name: "temp-pin"
        type: (readout.int_type ? HalPin.S32 : HalPin.Float)
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
