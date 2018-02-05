import QtQuick 2.0

Text {
    // Main properties
    property double value: 121.0
    property bool timeMode: false // Set to true to display a time value
    // - Scalar value with units
    property int decimals: 1
    property double scale: 1.0
    property string suffix: "°C"
    property string scalarText: (value * scale).toFixed(decimals) + suffix
    // - Time value
    property bool displayHours: true
    property int hours: Math.floor(value / 3600)
    property int minutes: Math.floor(
	(displayHours ? (value % 3600) : (value)) / 60)
    property int seconds: value % 60
    property string timeText: (
	(displayHours ? (hours + (minutes<10?":0":":")) : "") +
	    minutes + (seconds<10?":0":":") + seconds)

    // Compute text display
    text: (timeMode ? timeText : scalarText)
}
