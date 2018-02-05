import QtQuick 2.0
import QtQuick.Controls 1.1

Item {

    /* Ring-shaped Combination dial control and gauge readout

       The dial's arc-shaped value is set with a circular swipe.  The
       readout's arc-shaped value is superimposed over the dial value
       in progress-meter style.  Dial face, setting and readout colors
       are separately configurable.

       Configurable arc max/min angular positions may be less than,
       equal to or greater than 360 degrees.  This allows arcs to be
       greater than 360 degrees, with 360 degree spans displayed as
       concentric rings (good for e.g. timer time-picker widgets).  It
       also allows arcs to read clockwise or counterclockwise.

       Major and minor graduations may be configured.

       Other graphical items may be placed over the ring's center for
       other purposes.
     */
    id: base

    // Input/output values
    // - Setting
    //property double setValue: 200.0
    property double setValue: 121.0
    // - Readout
    //property double readValue: 150.0
    property double readValue: 1.0
    //property alias readValue: base.setValue

    // Display settings
    // - Visibility
    property bool readVisible: true // read value visible/invisible
    property double readFade: 1.0 // At 0.0, only set elements can be seen
    // - Size
    property double overallR: base.width/2 // Radius to outside edge
    property double centerR: overallR/2 // Radius to inner edge
    property double outerBezelWidth: width * 0.025 // width of outer ring
    property double bezelGapWidth: width * 0.012 // width of ring outside arcs
    property double outerR: overallR - outerBezelWidth - bezelGapWidth
    property double innerR: centerR + bezelGapWidth
    property double minorGradWidth: 0.10 // width of minor graduations; %
    property double majorGradWidth: 0.30 // width of major graduations; %
    property double gradLineWidth: outerR * 0.015
    property double handleDiameter: outerR * 0.125
    property double handleStrokeWidth: outerR * 0.025
    property double handleOverlap: 0.50 // pct
    property double setLineWidth: outerR * 0.02
    // - Min/max and direction
    property double minValue: 0.0
    //property double maxValue: 60.0*4 // 4 hours
    property double maxValue: 130.0
    property double maxLimit: maxValue // Max setting may be less than gauge range
    //property double minPos: 3/2 * Math.PI  // 12 o'clock
    property double minPos: 3/4 * Math.PI  // SW
    //property double maxPos: 4 * 2*Math.PI + minPos  // 4 spins around the dial
    property double maxPos: minPos + 3/2 * Math.PI // Clockwise 270 deg. to SE
    property double precision: 1.0 // Precision of setting
    property double mouseScale: 1.0 // Effect of mouse on value
    // - Graduations
    property double minorGrad: 1.0 // minutes
    //property double majorGrad: 5.0 // like 1..12 on clock
    property double majorGrad: 10.0
    // - Colors
    property color baseColor: "#ff00ff"
    property color gradColor: "#000000"
    property color setColor: "#000080"
    property color setBGColor: "#ff00ff" // Set background color
    property color readColor: "#008000"
    property color readBGColor: "#00c300" // Read background color

    // Computed parameters
    // - Major sizes
    property double medianR: (outerR+innerR)/2 // Halfway between
    property double handleFillR: handleDiameter/2
    property double handleStrokeR: handleStrokeWidth/2
    property double handleR: handleFillR+handleStrokeR
    // - Ranges, scales and angles
    property double toRads: Math.PI/180.0
    property double valueRange: maxValue-minValue
    property double posRange: maxPos-minPos
    property double posValueScale: posRange/valueRange
    property double radsPerMajorGrad: posValueScale * majorGrad
    property double radsPerMinorGrad: posValueScale * minorGrad
    property int numMinorGrads: Math.floor( // clip to <360deg. & int amount
	valueRange/minorGrad * Math.min(Math.abs(posRange),2*Math.PI)/posRange)
    property int numMajorGrads: Math.floor( // clip to <360deg. & int amount
	valueRange/majorGrad * Math.min(Math.abs(posRange),2*Math.PI)/posRange)

    // Size
    width: 400
    height: 400

    // ------------------- Convenience functions -------------------

    // Draw an arc centered on middle of gauge
    function drawArc(c, radius, start, end) {
	c.beginPath();
	c.arc(base.overallR, base.overallR,   // center
	      radius, start, end);
	c.stroke();
    }

    // Draw a graduation line
    function drawGrad(c,ang,w) {
	var gradOuterR = medianR + (outerR-medianR)*w;
	var gradInnerR = medianR + (innerR-medianR)*w;
	c.moveTo(Math.cos(ang)*gradOuterR + base.overallR,
		 Math.sin(ang)*gradOuterR + base.overallR);
	c.lineTo(Math.cos(ang)*gradInnerR + base.overallR,
		 Math.sin(ang)*gradInnerR + base.overallR);
    }

    // Draw a 'handle', a small circle on the set/read arc
    function drawHandle(c, dialAngle, dialRadius, radius) {
	c.beginPath();
	c.arc(base.overallR + Math.cos(dialAngle) * dialRadius,  // center X
	      base.overallR + Math.sin(dialAngle) * dialRadius,  // center Y
	      radius, 0, 2*Math.PI);
	c.stroke();
        c.fill();
    }

    // ------------------- Graphical elements -------------------

    // Background ring, incl. outer bezel
    Canvas {
	id: face

	// Positioning
	anchors.fill: parent
	z: 0

	contextType: "2d"
	onPaint: {
	    if (!context) return;
	    context.reset();

	    // Draw background in background color
	    context.strokeStyle = base.setBGColor;
	    context.lineWidth = overallR - centerR;
	    drawArc(context, (overallR + centerR)/2, 0, 2*Math.PI);

	    // Draw bezel in foreground color
	    context.strokeStyle = base.setColor;
	    context.lineWidth = outerBezelWidth;
	    drawArc(context, overallR - outerBezelWidth/2, 0, 2*Math.PI);
	}
    }

    // A second background ring in the stage complete color
    Canvas {
	id: readValFace
	property alias readVal: base.readValue
	property alias setVal: base.setValue

	// Positioning & visibility
	anchors.fill: parent
	z: 0.1
	opacity: base.readFade

	// This changes transparency as the read value increases
	onReadValChanged: requestPaint()
	onSetValChanged: requestPaint()

	contextType: "2d"
	onPaint: {
	    if (!context) return;
	    context.reset();

	    // Draw background in background color
	    context.strokeStyle = base.readBGColor;
	    context.lineWidth = overallR - centerR;
	    drawArc(context, (overallR + centerR)/2, 0, 2*Math.PI);

	    // Draw bezel in foreground color
	    context.strokeStyle = base.readColor;
	    context.lineWidth = outerBezelWidth;
	    drawArc(context, overallR - outerBezelWidth/2, 0, 2*Math.PI);
	}
    }

    // Graduations on face dial
    Canvas {
	id: faceGrads
	anchors.fill: parent
	z: 3

	contextType: "2d"
	onPaint: {
	    var i;
	    if (!context) return;
	    context.reset();
            context.beginPath();

	    // Draw graduations
	    // - First major graduation
	    drawGrad(context, minPos, majorGradWidth);
	    // - Minor graduations
	    for (i=1; i <= numMinorGrads; i++)
		drawGrad(context, minPos + i*radsPerMinorGrad, minorGradWidth);
	    // - Major graduations
	    for (i=1; i <= numMajorGrads; i++)
		drawGrad(context, minPos + i*radsPerMajorGrad, majorGradWidth);
	    // - Final major graduation
	    drawGrad(context, maxPos, majorGradWidth);
	    // - Stroke lines with color and width
	    context.strokeStyle = base.gradColor;
	    context.lineWidth = base.gradLineWidth;
	    context.stroke();
	}
    }

    // Set value arc
    Canvas {
	id: setValArc
	property alias value: base.setValue
	property int numCircs: Math.floor(value*posValueScale / (2*Math.PI))
	/* property double angle: ( */
	/*     value * posValueScale - numCircs*2*Math.PI + minPos) */
	property double angle: (value * posValueScale + minPos)
	property color color: base.setColor

	// Positioning
	anchors.fill: parent
	z: 2.1

	// Repaint canvas whenever value changes
        onValueChanged: requestPaint()
	onColorChanged: requestPaint()

	contextType: "2d"
	onPaint: {
	    if (!context) return;
	    context.reset();
	    context.strokeStyle = color;
	    context.lineWidth = outerR - innerR;

	    // Draw value arc
	    drawArc(context, medianR, minPos, angle);
	}
    }

    // Read value arc
    Canvas {
	id: readValArc
	property alias value: base.readValue
	property int numCircs: Math.floor(value*posValueScale / (2*Math.PI))
	property alias setNumCircs: setValArc.numCircs
	property double angle: value * posValueScale - numCircs*2*Math.PI + minPos
	property color color: base.readColor

	// Positioning & visibility
	anchors.fill: parent
	z: 2.2
	visible: base.readVisible

	// Repaint canvas whenever value changes
        onValueChanged: requestPaint()

	contextType: "2d"
	onPaint: {
	    if (!context) return;
	    context.reset();
	    context.strokeStyle = color;

	    // Draw previous round's arc, if applicable
	    if (numCircs > 0) {
		var lineWidth = numCircs * (outerR - innerR)/(setNumCircs+1);
		context.lineWidth = Math.min(lineWidth, outerR - innerR);
		drawArc(context, medianR, 0, 2*Math.PI);
	    }

	    // Draw read value outer arc
	    var lineWidth = (numCircs+1) * (outerR - innerR)/(setNumCircs+1);
	    context.lineWidth = Math.min(lineWidth, outerR - innerR);
	    drawArc(context, medianR, minPos, angle);
	}
    }

    // Set value line and handles:  Draw overlapping circles representing laps
    Canvas {
	id: setValHandle
	property alias angleIn: setValArc.angle
	property double angleOverlap: Math.asin(handleR*handleOverlap / medianR)
	property alias numCircs: setValArc.numCircs

	// Positioning
	anchors.fill: parent
	z: 9.1

	// Repaint canvas whenever value changes
        onAngleInChanged: requestPaint()

	contextType: "2d"
	onPaint: {
	    if (!context) return;
	    context.reset();
            context.fillStyle = setColor;
	    context.strokeStyle = setBGColor;
	    context.lineWidth = handleStrokeWidth;

	    // Draw extra, overlapping handles to represent laps, on bottom
	    for (var i=numCircs-1; i >= 0; i--) {
		if (i == numCircs-1) {
		    // Animate new handle appearance
		    // - Figure out how far from zero
		    var angleFromZero = (angleIn-minPos) % (2*Math.PI);
		    if (angleFromZero < 0) angleFromZero += 2*Math.PI;
		    // - Decide what to do
		    if (angleFromZero < (numCircs-2)*angleOverlap
			|| angleFromZero >= 2*Math.PI-0.0001)
			// Too early to draw
			;
		    else if (angleFromZero < (numCircs-1)*angleOverlap)
			// Just passed zero; draw at zero
			drawHandle(context, minPos, medianR, handleFillR);
		    else
			// Draw normally
			drawHandle(context, angleIn-angleOverlap*(numCircs-1),
				   medianR, handleFillR);
		} else
		    // Animate other handles
		    drawHandle(context, angleIn-angleOverlap*i,
			       medianR, handleFillR);
	    }

	    // Draw set line
	    context.beginPath();
	    drawGrad(context, angleIn, 1.0);
	    context.strokeStyle = base.gradColor;
	    context.lineWidth = base.setLineWidth;
	    context.stroke();
	}
    }

    // Read value handles:  Draw overlapping circles representing laps
    Canvas {
	id: readValHandle
	property alias angleIn: readValArc.angle
	property double angleOverlap: Math.asin(handleR*handleOverlap / medianR)
	property alias numCircs: readValArc.numCircs

	// Positioning & visibility
	anchors.fill: parent
	z: 9.2
	//visible: base.readVisible

	// Repaint canvas whenever value changes
        onAngleInChanged: requestPaint()

	contextType: "2d"
	onPaint: {
	    if (!context) return;
	    context.reset();
            context.fillStyle = readColor;
	    context.strokeStyle = readBGColor;
	    context.lineWidth = handleStrokeWidth;

	    // Draw extra, overlapping handles to represent laps, on bottom
	    for (var i=numCircs-1; i >= 0; i--) {
		if (i == numCircs-1) {
		    // Animate new handle appearance
		    // - Figure out how far from zero
		    var angleFromZero = (angleIn-minPos) % (2*Math.PI);
		    if (angleFromZero < 0) angleFromZero += 2*Math.PI;
		    // - Decide what to do
		    if (angleFromZero < (numCircs-2)*angleOverlap
			|| angleFromZero >= 2*Math.PI-0.0001)
			// Too early to draw
			;
		    else if (angleFromZero < (numCircs-1)*angleOverlap)
			// Just passed zero; draw at zero
			drawHandle(context, minPos, medianR, handleFillR);
		    else
			// Draw normally
			drawHandle(context, angleIn-angleOverlap*(numCircs-1),
				   medianR, handleFillR);
		} else
		    // Animate other handles
		    drawHandle(context, angleIn-angleOverlap*i,
			       medianR, handleFillR);
	    }
	}
    }

    /*
    // Zero handle, incomplete color
    Canvas {
	// Set zero handle
	id: setZeroHandle

	// Positioning & visibility
	anchors.fill: parent
	z: 9.3

	contextType: "2d"
	onPaint: {
	    if (!context) return;
	    context.reset();
            context.fillStyle = setColor;
	    context.strokeStyle = setBGColor;
	    context.lineWidth = handleStrokeWidth;
	    drawHandle(context, minPos, medianR, handleFillR);
	}
    }

    // Zero handle, complete color, fades in when stage complete
    Canvas {
	// Read zero handle
	id: readZeroHandle

	// Positioning & visibility
	anchors.fill: parent
	z: 9.4 // Over readZeroHandle
	opacity: base.readFade

	contextType: "2d"
	onPaint: {
	    if (!context) return;
	    context.reset();
            context.fillStyle = readColor;
	    context.strokeStyle = readBGColor;
	    context.lineWidth = handleStrokeWidth;
	    drawHandle(context, minPos, medianR, handleFillR);
	}
    }
    */

    // Handle mouse events
    MouseArea {
	/* Invisible layer for dealing with mouse button and scroll input

	   When arc is clicked, the angle is computed to determine
	   which arc, and the clicked arc and arc starting and clicked
	   position are saved in a register.

	   Then, when arc is dragged, the angle is compared with the
	   saved angle, and applied to the arc.
	*/
        id: events
	property alias numCircs: setValArc.numCircs
	//property alias numCircs: readValArc.numCircs
	property alias value: base.setValue
	//property alias value: readValArc.value
	property alias angle: setValArc.angle
	//property alias angle: readValArc.angle
        // Saved state of initial mouse press
        property double angleStart: NaN // angle where mouse pressed
	property double valueStart // value at mouse press
	// Saved total delta and last update angle
	property double angleDelta
	property double angleLast
	// Precision of set value
	property double precision: base.precision

	// Process clicks from full area, and be on top
        anchors.fill: parent
        z: 10 // On top

        function mouseInRing(m) {
            // Calculate if mouse position is in settings ring
	    // - Get distance with Pythagoras
            var d = Math.sqrt(Math.pow(m.x - outerR, 2) +
			      Math.pow(m.y - outerR, 2));
	    // - Check click is in ring
	    var res = (d <= outerR) && (d >= innerR);
            return res;
        }

        function mouseToAngle(m, numCircs) {
            // Get angle in radians from 0 radians (E)
	    var angleRaw = Math.atan2(m.x - outerR, m.y - outerR);
            var angle = angleRaw;
            return angle;
        }

        // When pressed,
        // - If not pressed in ring, disable dragging, return.  Else,
        // - Check which zone the press was closest to
        // - Register the zone, original val and clicked val
        onPressed: {
            angleStart = NaN;
            if (!mouseInRing(mouse))
		// Mouse pos'n not in ring; return
		return;

            // Get val from mouse position
            angleStart = mouseToAngle(mouse);
	    valueStart = value;
	    angleLast = angleStart;
	    angleDelta = 0;
        }
        // When moved, adjust the value by the amount dragged
        onPositionChanged: {
	    if (isNaN(angleStart) || !mouseInRing(mouse))
		// Initial or current mouse pos'n not in ring
		return;

            // Get angle delta between current and saved
	    var angleMouse = mouseToAngle(mouse);
            var angleLastDelta = (angleLast - angleMouse) % (2*Math.PI);
	    if (angleLastDelta < -Math.PI) angleLastDelta += 2*Math.PI;
	    else if (angleLastDelta > Math.PI) angleLastDelta -= 2*Math.PI;
	    angleDelta += angleLastDelta;
	    var valueDelta = angleDelta / posValueScale * mouseScale;
	    angleLast = angleMouse;
	    // New value, rounded
	    var newVal = Math.round(
		(valueStart+valueDelta) / precision) * precision;
            value = Math.min(maxLimit, Math.max(minValue, newVal));
        }

	/*
        // Mouse wheel:
        // - If not in ring, do nothing, stop.  Else,
        // - Check which zone mouse is closest to
        // - Increment/decrement the zone, respecting max/min values
        onWheel: {
            if (!mouseInRing(wheel)) return; // Ignore out of bounds

            var val = mouseToVal(wheel);
            var newv = red.value + wheel.angleDelta.y/15 * base.stepSize;
            if (newv > maximumValue) newv = maximumValue;
            if (newv < blue.value + base.minGreenZone)
                newv = blue.value + base.minGreenZone;
            setValue = newv;
        }
	*/
    }

    /*
    // Debugging readout
    Label {
        id: debug
	property string val1: ""
	property string val2: ""
	property string val3: ""

	x: 0
        y: outerR*2 + 5
	z: 10

        // Format float value with decimals in black text
        text: (val1 + "; " + val2 + "; " + val3)
        color: "#000000"

        // Proportional size, centered above handle, with l/r tweak
        font.pixelSize: 20
    }
    */

}
