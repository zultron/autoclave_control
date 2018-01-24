import QtQuick 2.0
import QtQuick.Controls 1.1
import Machinekit.HalRemote 1.0

Item {
    /* Goldibox thermostat zone setting

       This donut-shaped knob has independent settings for "too hot"
       and "too cold" zones, displaying them as red and blue arcs that
       may be adjusted to set an intermediate green "just right"
       zone's width and position.  The two controls include numeric
       readout for precise setting.
     */

    id: base

    // Parameters and settings
    // - Outgoing settings
    property double redZone: 35.0          // Too Hot
    property double blueZone: 15.0         // Too Cold
    //property bool synced: pinMin.synced && pinMax.synced
    property bool redSynched
    property bool blueSynched
    property bool synched: redSynched && blueSynched
    // - Incoming settings
    property double tempOut: 30.0          // Angle: outside temperature
    property double range: 90.0            // Angle: +/- temp setting range
    property double minGreenZone: 2.0      // Min Goldilocks zone
    property alias pinMinName: pinMin.name // temp-min HAL pin name
    property alias pinMaxName: pinMax.name // temp-max HAL pin name
    // - Value display parameters
    property int decimals: 1             // Fmt float w/one decimal
    property string suffix: "°C"         // Units
    property double handleTextSize: 0.08 // Format:  text height
    property double handleTextOffset: 9  // Format:  tweak horiz. offset
    // - Value setting parameters
    property double stepSize: 0.2        // Increment for mouse wheel
    // - Formatting
    property color redColor: "#ff0000"   // Color of Too Hot zone
    property color blueColor: "#0000ff"  // Color of Too Cold zone
    property color greenColor: "#00c000" // Color of Just Right zone
    property double borderWidth: 0.02    // Width of border strokes
    property color borderColor: "darkGray" // Color of border strokes
    property double handleDiameter: 0.08 // Diameter of border handle circle
    property color readoutColor: "black" // Color of readout text
    // - Size settings, relative to width
    property double arcWidth: 0.25       // Width of arc

    // Debugging
    // - Angles
    property alias redAngle: red.angle
    property alias blueAngle: blue.angle
    // - Mouse
    property double mouseX: 0.0
    property double mouseY: 0.0
    property int inring: 0
    property double totemp: 0.0
    property double dragged: 0.0
    // - Mouse press register
    property alias rzone: events.registerZone
    property alias rtemporig: events.registerTempOrig
    property alias rtempstart: events.registerTempStart

    // Square
    height: width

    HalPin {
        id: pinMin
        name: "temp-min"
        type: HalPin.Float
        direction: HalPin.Out
    }

    Binding {
	target: base;
	property: "blueZone";
	value: pinMin.value;
    }

    Binding {
	target: base;
	property: "blueSynched";
	value: pinMin.synced;
    }

    HalPin {
        id: pinMax
        name: "temp-max"
        type: HalPin.Float
        direction: HalPin.Out
    }

    Binding {
	target: base;
	property: "redZone";
	value: pinMax.value;
    }

    Binding {
	target: base;
	property: "redSynched";
	value: pinMax.synced;
    }

    Canvas {
        /* Green background circle; exposed area represents "Just
         * Right" Goldilocks temperature zone */
        id: green

        // Max size, on bottom
        anchors.fill: parent
        z: 0

        contextType: "2d"
        onPaint: {
            if (!context) return;
            context.reset();
            context.beginPath();
            // Slice is from 45 deg. NE to 45 deg. NW
            context.arc(width/2, height/2,              // center
			width*(0.5 - base.arcWidth/2),  // radius
			0, Math.PI * 2);                // endpoints in radians
            // Stroke arc with width and color
            context.strokeStyle = base.greenColor;
            context.lineWidth = width * base.arcWidth;
            context.stroke();
        }
    }

    Canvas {
        /* "Too Hot" red zone arc */
        id: red

	// The setting
        property alias value: pinMax.value

        // Compute angle:
        // - (tempOut - range/2) .. (tempOut + range/2) => -.25PI .. 1.25PI
        property double angle: (
	    (value - base.tempOut) / base.range * -1.5 + 0.5) * Math.PI

        // Max size, above green ring
        anchors.fill: parent
        z: 1

	// Repaint canvas whenever angle, value, tempOut change
        onAngleChanged: requestPaint()
        onValueChanged: requestPaint()
        property alias tempOut: base.tempOut
        onTempOutChanged: requestPaint()

        contextType: "2d"
        onPaint:
        {
            if (!context) return;
            context.reset();
            context.beginPath();
            // Slice is from up/N to angle
            context.arc(width/2, height/2,              // center
			width*(0.5 - base.arcWidth/2),  // radius
			Math.PI * -0.5, angle);         // endpoints in radians
            // Stroke arc with width and color
            context.strokeStyle = base.redColor;
            context.lineWidth = width * base.arcWidth;
            context.stroke();
        }
    }

    Item {
        /* Readouts and gray border + circle at border of green and red

           This is a rectangular area centered on and wide as the dial
           so that it may be rotated around its center as the zone
           changes
	*/
        id: redBorder

	// Fill parent, rotate with red arc, on top
        anchors.fill: parent
        rotation: red.angle * 180 / Math.PI
        z: 2

        Rectangle {
            // Radial gray line at zone border
            id: redLine
            width: parent.width * base.arcWidth
            height: parent.width * base.borderWidth
            color: base.borderColor
            x: parent.width * (1 - base.arcWidth)
            y: parent.height * (1/2 - base.borderWidth/2)
        }

        Rectangle {
            // Round gray "handle" at zone border
            id: redHandle
            width: parent.width * base.handleDiameter
            height: width
            radius: width/2
            color: base.borderColor
            x: parent.width * (1 - (base.arcWidth + base.handleDiameter)/2)
            y: parent.height * (1/2 - base.handleDiameter/2)
        }

        Label {
            // "Too Hot" temperature setting readout
            id: redReadout

            // Format float value with decimals in black text
            text: red.value.toFixed(base.decimals)
            color: base.readoutColor

            // Proportional size, centered above handle, with l/r tweak
            font.pixelSize: base.width * base.handleTextSize
            anchors.bottom: redHandle.top
            anchors.horizontalCenter: redHandle.horizontalCenter
            anchors.horizontalCenterOffset: -base.handleTextOffset
        }
    }

    Canvas {
        /* "Too Cold" blue zone arc */
        id: blue

	// The setting
        property alias value: pinMin.value

        // Compute angle:
        // - (tempOut - range/2) .. (tempOut + range/2) => -.25PI .. 1.25PI
        property double angle: (
	    (value - base.tempOut) / base.range * -1.5 + 0.5) * Math.PI

        // Max size, above green ring
        anchors.fill: parent
        z: 1

	// Repaint canvas whenever angle, value, tempOut change
        onAngleChanged: requestPaint()
        onValueChanged: requestPaint()
        property alias tempOut: base.tempOut
        onTempOutChanged: requestPaint()

        contextType: "2d"
        onPaint:
        {
            if (!context) return;
            context.reset();
            context.beginPath();
            // Slice is from angle to up/N.
            context.arc(width/2, height/2,              // center
			width*(0.5 - base.arcWidth/2),  // radius
			angle, Math.PI * 1.5);          // endpoints in radians
            // Stroke arc with width and color
            context.strokeStyle = base.blueColor;
            context.lineWidth = width * base.arcWidth;
            context.stroke();
        }
    }

    Item {
        /* Readouts and gray border + circle at border of green and blue

           This is a rectangular area centered on and wide as the dial
           so that it may be rotated around its center as the zone
           changes
	*/
        /* Readouts and gray border + circle at border of green and blue */
        id: blueBorder

	// Fill parent, rotate with blue arc, on top
        anchors.fill: parent
        rotation: blue.angle * 180 / Math.PI + 180
        z: 2

        Rectangle {
            // Radial gray line at zone border
            id: blueLine
            width: parent.width * base.arcWidth
            height: parent.width * base.borderWidth
            color: base.borderColor
            x: 0
            y: parent.height * (1/2 - base.borderWidth/2)
        }

        Rectangle {
            // Round gray "handle" at zone border
            id: blueHandle
            width: parent.width * base.handleDiameter
            height: width
            radius: width/2
            color: base.borderColor
            x: parent.width * (base.arcWidth - base.handleDiameter) / 2
            y: parent.height * (1/2 - base.handleDiameter/2)
        }

        Label {
            // "Too Cold" temperature setting readout
            id: blueReadout

            // Formatted float value in black text
            text: blue.value.toFixed(base.decimals)
            color: base.readoutColor

            // Proportional size, centered above handle, with l/r tweak
            font.pixelSize: base.width * base.handleTextSize
            anchors.bottom: blueHandle.top
            anchors.horizontalCenter: blueHandle.horizontalCenter
            anchors.horizontalCenterOffset: base.handleTextOffset
        }
    }

    Rectangle {
        /* Put a clear circle on top with gray borders to look purty */
        id: purty

	// Ring fills parent, on top
        anchors.fill: parent
        radius: width/2
        z: 8

	// Border color and width; inner circle area invisible
        border.color: base.borderColor
        border.width: parent.width * base.borderWidth
        color: "transparent"
    }

    MouseArea {
	/* Invisible layer for dealing with mouse button and scroll input

	   When arc is clicked, the angle is computed to determine
	   which arc, and the clicked arc and arc starting and clicked
	   position are saved in a register.

	   Then, when arc is dragged, the angle is compared with the
	   saved angle, and applied to the arc.

	   There are some simple safeguards to make sure the setting
	   doesn't go out of range off the 270 degree arc, and to make
	   sure a minimum green zone is maintained.
	  */
        id: events

	// Process clicks from full area, and be on top
        anchors.fill: parent
        z: 9 // On top

        // Saved state of initial mouse press
        property int registerZone: 0 // 0 for none, 1 for red, 2 for blue
        property double registerTempOrig: 0.0 // temp before mouse press
        property double registerTempStart: 0.0 // temp where mouse pressed

	// Calculate min/max value
	property double minimumValue: base.tempOut - base.range/2
	property double maximumValue: base.tempOut + base.range/2
	
        function mouseInRing(m) {
            // Calculate if mouse position is in settings ring
	    // - Get distance with Pythagoras
            var dx = m.x - height/2;
            var dy = m.y - width/2;
            var d = Math.sqrt(dx*dx + dy*dy);
	    // - Check click is in ring
	    var res = (d <= width/2) && (d >= (width * (0.5 - base.arcWidth)));
	    /* // Mouse outside ring; clear zone */
	    /* if (!res) registerZone = 0; */
	    // Debugging
	    base.inring = res;
	    base.mouseX = m.x;
	    base.mouseY = m.y;
            return res;
        }

        function mouseToTemp(m) {
            // Get angle in radians from straight up North
            var angle = Math.atan2(m.x - width/2, m.y - width/2);
            // Convert value to temperature
            var val = angle/Math.PI * base.range * 2/3 + base.tempOut;
	    // Debugging
	    base.totemp = val;
            return val;
        }

        // When pressed,
        // - If not pressed in ring, disable dragging, return.  Else,
        // - Check which zone the press was closest to
        // - Register the zone, original temp and clicked temp
        onPressed: {
            registerZone = 0;  // Clear zone
            if (!mouseInRing(mouse))
		// Mouse pos'n not in ring; return
		return;

            // Get temp from mouse position
            var temp = mouseToTemp(mouse);
            if ((red.value - temp) < (temp - blue.value)) {
                // Closer to red
                registerZone = 1;
                registerTempOrig = red.value;
            } else {
                // Closer to blue
                registerZone = 2;
                registerTempOrig = blue.value;
            }
            registerTempStart = temp;
        }
        // When moved, adjust the temperature by the amount dragged
        onPositionChanged: {
	    if ((registerZone == 0) || (!mouseInRing(mouse)))
		// Initial or current mouse pos'n not in ring
		return;

            // Get temp diff between current and saved mouse position
            var tempdiff = mouseToTemp(mouse) - registerTempStart;
            // New temp will be orig temp adjusted by the amount dragged
            var newTemp = registerTempOrig + tempdiff;

	    // Clip and set value
            if (registerZone == 1) { // red
                if (newTemp > maximumValue) newTemp = maximumValue;
                if (newTemp < blue.value + base.minGreenZone)
                    newTemp = blue.value + base.minGreenZone;
                red.value = newTemp;
            } else {                 // blue
                if (newTemp < minimumValue) newTemp = minimumValue;
                if (newTemp > red.value - base.minGreenZone)
                    newTemp = red.value - base.minGreenZone;
                blue.value = newTemp;
            }
            // Debugging
            base.dragged = tempdiff;
        }

        // Mouse wheel:
        // - If not in ring, do nothing, stop.  Else,
        // - Check which zone mouse is closest to
        // - Increment/decrement the zone, respecting max/min values
        onWheel: {
            registerZone = 0;  // Disable mouse dragging
            if (!mouseInRing(wheel)) return; // Ignore out of bounds

            var temp = mouseToTemp(wheel);
            if ((red.value - temp) < (temp - blue.value)) {
                // Closest to red
                var newv = red.value + wheel.angleDelta.y/15 * base.stepSize;
                if (newv > maximumValue) newv = maximumValue;
                if (newv < blue.value + base.minGreenZone)
                    newv = blue.value + base.minGreenZone;
                red.value = newv;
            } else {
                // Closest to blue
                var newv = blue.value - wheel.angleDelta.y/15 * base.stepSize;
                if (newv < minimumValue) newv = minimumValue;
                if (newv > red.value - base.minGreenZone)
                    newv = red.value - base.minGreenZone;
                base.blueZone = newv;
            }
        }
    }
}
