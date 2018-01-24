import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Button {
    /* Exit button

       Simple, round X button, quits the app when clicked
     */
    tooltip: "Exit Goldibox Control Application"
    onClicked: Qt.quit()
    width: 50
    height: 50

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
		/* X symbol */

		// Parameters
		// - X line geometry:  ratios to base height
		property double lineTL: 0.25     // line top Y/left X
		property double lineBR: 0.75     // line bot Y/right X
		// - Line and color
		property double lineWidth: 0.15   // line width ratio
		property string lineCap: "round"  // line end style
		property color lineColor: "black" // Color of lines

		// Max size, on top
		anchors.fill: parent
		z: 1

		// Draw the symbol
		contextType: "2d"
		onPaint: {
		    if (!context) return;
		    context.reset();
		    context.beginPath();
		    // Draw line:  Top left to bottom right
		    context.moveTo(width * lineTL, height * lineTL);
		    context.lineTo(width * lineBR, height * lineBR);
		    // Draw line:  Top right to bottom left
		    context.moveTo(width * lineTL, height * lineBR);
		    context.lineTo(width * lineBR, height * lineTL);
		    // Stroke line and arc with width, cap and color
		    context.strokeStyle = lineColor;
		    context.lineWidth = width * lineWidth;
		    context.lineCap = lineCap;
		    context.stroke();
		}
	    }
	}
    }
}
