import QtQuick 2.0

Readout {
    // Main properties
    value: 121.0
    decimals: 1
    suffix: "°C"

    // Compute text display
    text: value.toFixed(decimals) + suffix
}
