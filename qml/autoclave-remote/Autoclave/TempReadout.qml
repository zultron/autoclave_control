import QtQuick 2.0
import Machinekit.HalRemote 1.0

Text {
    id: temp

    // Main properties
    property double value: 121.0
    property int decimals: 1
    property string suffix: "°C"
    property bool displayHours: true

    // Compute text display
    text: value.toFixed(decimals) + suffix
}
