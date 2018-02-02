import QtQuick 2.0
import Machinekit.HalRemote 1.0

Text {
    id: time

    // Main properties
    property int value: 12*60 + 37 // 0:12:37
    property bool synced: true
    property bool displayHours: true

    // Compute text display
    property int hours: Math.floor(value / 3600)
    property int minutes: Math.floor(
	(displayHours ? (value % 3600) : (value)) / 60)
    property int seconds: value % 60
    text: ((displayHours ? (hours + (minutes<10?":0":":")) : "") +
	   minutes + (seconds<10?":0":":") + seconds)
}
