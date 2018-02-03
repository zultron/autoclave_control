import QtQuick 2.0

Text {
    // Main properties
    property double value: 121.0
    property int decimals: 1
    property double scale: 1.0
    property string suffix: "°C"

    // Compute text display
    text: (value * scale).toFixed(decimals) + suffix
}
