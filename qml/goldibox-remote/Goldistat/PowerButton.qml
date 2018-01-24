import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import Machinekit.HalRemote 1.0

Button {
    /* Power button

       Simple, round O/1 power button, turns yellow when on
     */

    property string name: "enable"
    property alias synced: pin.synced

    enabled: (pin.direction !== HalPin.In)

    tooltip: "Enable/Disable Goldibox"
    checkable: true

    id: base

    HalPin {
        id: pin
        name: base.name
        type: HalPin.Bit
        direction: HalPin.Out
    }

    Binding {
	target: base;
	property: "checked";
	value: pin.value;
    }
    Binding {
	target: pin;
	property: "value";
	value: base.checked;
    }

    style: ButtonStyle {
	background: Item {
	    Rectangle {
		/* Base circle */

		// Center on parent, on bottom
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
		z: 0

		// Circle fills parent
		height: parent.height
		width: height
		radius: width/2

		// Color
		color: "#626262"
	    }
	    Canvas {
		/* I/O symbol */

		// Parameters
		// - I line geometry:  ratios to base height
		property double lineTop: 0.15        // line top Y
		property double lineBot: 0.40        // line bot Y
		// - O arc geometry
		property double arcStart: 310        // start in degrees
		property double arcEnd: 230          // end in degrees
		property double arcRadius: 0.3       // radius ratio
		// - Line and color
		property double lineWidth: 0.15      // line width ratio
		property string lineCap: "round"     // line end style
		property color lineColorOff: "black" // Color of lines, off
		property color lineColorOn: "yellow" // Color of lines, on
		// - Checked signal
		property bool checked: control.checked

		// Max size, on top
		anchors.fill: parent
		z: 1

		// Redraw when the button is checked/unchecked
		onCheckedChanged: requestPaint()

		// Draw the symbol
		contextType: "2d"
		onPaint: {
		    if (!context) return;
		    context.reset();
		    context.beginPath();
		    // Draw O arc
		    context.arc(width/2, height/2,      // center
				width*arcRadius,        // radius
				arcStart * Math.PI/180, // arc start/end
				arcEnd * Math.PI/180);  //   in radians
		    // Draw I line:  top to bottom
		    context.moveTo(width/2, height * lineTop);
		    context.lineTo(width/2, height * lineBot);
		    // Stroke line and arc with width, cap and color
		    context.strokeStyle = (
			checked ? lineColorOn : lineColorOff );
		    context.lineWidth = width * lineWidth;
		    context.lineCap = lineCap;
		    context.stroke();
		}
	    }
	}
    }
}
