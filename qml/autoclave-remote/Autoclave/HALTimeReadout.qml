import QtQuick 2.0
import Machinekit.HalRemote 1.0

TimeReadout {
    id: time

    // Main properties
    property string name: "time-pin"
    property bool synced: true
    property bool dir_in: true

    // Connect HAL pin
    HalPin {
        id: timePin
        name: time.name
        type: HalPin.S32
        direction: HalPin.In
    }

    Binding {
        target: time;
        property: "value";
        value: timePin.value;
    }

    Binding {
        target: time;
        property: "synced";
        value: timePin.synced;
    }
}
