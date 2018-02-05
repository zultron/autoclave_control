import QtQuick 2.0
import Machinekit.HalRemote 1.0

Image {
    id: img
    fillMode: Image.PreserveAspectFit

    property bool synced: true
    property alias name: pin.name
    property bool invert: false

    visible: true

    // Connect HAL pin
    HalPin {
        id: pin
        name: "set-pin"
        type: HalPin.Bit
        direction: HalPin.In
    }

    Binding {
        target: img;
        property: "visible";
        value: (img.invert ? (!pin.value) : pin.value);
    }

    Binding {
        target: img;
        property: "synced";
        value: pin.synced;
    }
}
