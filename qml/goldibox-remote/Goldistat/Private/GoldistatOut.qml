import QtQuick 2.0
import QtQuick.Controls 1.1
import Machinekit.HalRemote 1.0

Item {
    /* Outside temperature readout and pointer

       This readout displays the outside temperature as formatted
       float value with units, and has a triangular pointer pointing
       to bottom of the GoldistatSet dial, which is rotated to show
       temperature.
     */
    id: base

    // Parameters and settings
    // - Outgoing parameters
    property double value: 30.0    // Measured outside temperature, for readout
    property bool synched: false   // Bool:  HAL pin synched?
    // - Incoming parameters
    property alias pinName: pin.name // temp-ext HAL pin name
    // - Settings for readout
    property int decimals: 1       // Format `value` readout decimal places
    property string suffix: "°C"   // Readout units, appended to value
    property color readoutColor: "#000000"
    // - Pointer
    property color ptrcolor: "#000000"
    // - Text
    property string outTextStr: qsTr("OUT")
    // - Layout:  ratio to base width
    property double ptrHeight:     0.125      // ptr height
    property double ptrWidth: ptrHeight * 6/5 // ptr width
    property double readoutTextSize: 0.10     // readout text font height
    property double outTextSize: 0.070        // 'OUT' text font height

    // Fixed aspect ratio
    height: width // * (1.0 + ptrHeight + outTextSize + readoutTextSize)

    HalPin {
        id: pin
        name: "temp-ext"
        type: HalPin.Float
        direction: HalPin.In
    }

    Binding {
	target: base;
	property: "value";
	value: pin.value;
    }

    Binding {
	target: base;
	property: "synched";
	value: pin.synced;
    }

    Canvas {
        /* Black triangular pointer representing outside temp gauge */
        id: ptr

	// Center at bottom of GoldistatSet circle, raise to top layer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: base.width
	z: 1

        // Size relatively with fixed aspect ratio
        width: base.width * base.ptrWidth
        height: base.width * base.ptrHeight

	// Triangle points inword toward edge of GoldistatSet circle
        contextType: "2d"
        onPaint: {
            if (!context) return;
            context.reset();
            context.beginPath();
            // Start at tip of pointer
            context.moveTo(width/2, 0);
            // Trace left and down, then across
            context.lineTo(0, height);
            context.lineTo(width, height);
            // Fill with color
            context.fillStyle = base.ptrcolor;
            context.fill();
        }
    }

    Label {
        /* Temperature readout */
        id: temp

	// Text readout:  formatted float and units
        text: base.value.toFixed(base.decimals) + base.suffix

        // Size font proportionally and color text
        font.pixelSize: base.width * base.readoutTextSize
        color: base.readoutColor

        // Center text just below the pointer, raise to top layer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: base.width * (1.0 + base.ptrHeight)
	z: 1
    }

    Text {
        /* "OUT" text */
        id: outText
        text: base.outTextStr

	// Center text below readout with relative font size, raise to
	// top layer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: (
	    base.width * (1.0 + base.ptrHeight + base.readoutTextSize))
        font.pixelSize: parent.width * base.outTextSize
	z: 1
    }
}
