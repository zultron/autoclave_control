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
    property double setValue: 239.0
    // - Readout
    property double readValue: 176.0

    // Display settings
    // - Size
    property double outerDiameter: 400.0
    property double innerDiameter: 200.0
    property double minorGradWidth: 0.10 // width of minor graduations; %
    property double majorGradWidth: 0.30 // width of major graduations; %
    property double gradLineWidth: 3.0
    property double handleDiameter: 45.0
    property double handleStrokeWidth: 5.0
    property double epsilon: 0.00001
    // - Min/max and direction
    property double minValue: 0.0
    property double maxValue: 60.0*4 // 4 hours
    //property double minPos: 135.0  // SW
    property double minPos: 270.0  // 12 o'clock
    //property double maxPos: 405.0 // Clockwise 270 deg. to SE
    property double maxPos: 360.0*4 + minPos  // 4 spins around the dial
    // - Graduations
    property double minorGrad: 1.0 // minutes
    property double majorGrad: 5.0 // like 1..12 on clock
    // - Colors
    property color baseColor: "#ff00ff"
    property color gradColor: "#000000"
    property color setColor: "#000080"
    property color setBGColor: "#ff00ff" // Set background color
    property color readColor: "#008000"
    property color readBGColor: "#00c300" // Read background color

    // Computed parameters
    // - Major sizes
    width: outerDiameter
    height: outerDiameter
    property double outerR: outerDiameter/2
    property double innerR: innerDiameter/2
    property double centerR: (outerR+innerR)/2 // Halfway between
    // - Ranges, scales and angles
    property double toRads: Math.PI/180.0
    property double valueRange: maxValue-minValue
    property double maxPosR: maxPos * toRads
    property double minPosR: minPos * toRads
    property double posRange: maxPosR-minPosR
    property int posNumCircs: Math.floor(posRange / (2*Math.PI) - epsilon)
    property double posValueScale: posRange/valueRange
    property double radsPerMajorGrad: posValueScale * majorGrad
    property double radsPerMinorGrad: posValueScale * minorGrad
    property int numMinorGrads: Math.floor( // clip to <360deg. & int amount
	valueRange/minorGrad * Math.min(Math.abs(posRange),2*Math.PI)/posRange)
    property int numMajorGrads: Math.floor( // clip to <360deg. & int amount
	valueRange/majorGrad * Math.min(Math.abs(posRange),2*Math.PI)/posRange)


    property int setNumCircs: Math.floor(
	setValue*posValueScale / (2*Math.PI) - epsilon)
    property int readNumCircs: Math.floor(
	readValue*posValueScale / (2*Math.PI) - epsilon)


    property double debug1val: -1
    property double debug2val: -1
    /* property alias debug1val: debug1.val */
    /* property alias debug2val: debug2.val */

    /*
    Rectangle {
        // Base background circle
        id: face

        // Size circle relative to frame
        width: base.width
        height: base.height
        radius: base.width/2

        // Center on base and lower
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
	z: 0

	// Background color
	color: baseColor
    }
    */

    Canvas {
	// Set base ring
	id: face

	// Positioning
	anchors.fill: parent
	z: 0

	contextType: "2d"
	onPaint: {
	    if (!context) return;
	    context.reset();
	    context.strokeStyle = base.baseColor;
	    context.lineWidth = outerR - innerR;

	    // Draw set value outer arc
	    drawArc(context, (outerR+innerR)/2, 0, 2*Math.PI);
	}
    }

    /* function moveToAng(c,ang,d) { */
    /* 	c.moveTo(Math.cos(ang)*d, Math.sin(ang)*d); */
    /* } */

    /* function lineToAng(c,ang,d) { */
    /* 	c.lineTo(Math.cos(ang)*d, Math.sin(ang)*d); */
    /* } */

    function drawArc(c, radius, start, end) {
	c.beginPath();
	c.arc(outerR, outerR,   // center
	      radius, start, end);
	c.stroke();
    }

    Label {
        // Debugging
        id: debug1
	x: 0
        y: -50
	z: 10

        // Format float value with decimals in black text
        text: "base.debug1val = " + (base.debug1val).toFixed(5)
        color: "#000000"

        // Proportional size, centered above handle, with l/r tweak
        font.pixelSize: 20
        anchors.horizontalCenter: outerR
        anchors.verticalCenter: outerR
    }

    Label {
        // Debugging
        id: debug2
        y: -25
	z: 10

        // Format float value with decimals in black text
        text: "base.debug2val = " + (base.debug2val).toFixed(5)
        color: "#000000"

        // Proportional size, centered above handle, with l/r tweak
        font.pixelSize: 20
        anchors.horizontalCenter: outerR
        anchors.verticalCenter: outerR
    }

    Canvas {
	// http://doc.qt.io/qt-5/qml-qtquick-context2d.html

	// Graduations on face dial
	id: faceGrads
	anchors.fill: parent
	z: 3

	function drawGrad(c,ang,w) {
	    var gradOuterR = centerR + (outerR-centerR)*w;
	    var gradInnerR = centerR + (innerR-centerR)*w;
	    //base.debug1val = gradOuterR;
	    //base.debug2val = gradInnerR;
	    c.moveTo(Math.cos(ang)*gradOuterR + outerR,
		     Math.sin(ang)*gradOuterR + outerR);
	    c.lineTo(Math.cos(ang)*gradInnerR + outerR,
		     Math.sin(ang)*gradInnerR + outerR);
	}

	contextType: "2d"
	onPaint: {
	    var i;
	    if (!context) return;
	    context.reset();
            context.beginPath();

	    //base.debug1val = numMajorGrads;
	    //base.debug2val = posNumCircs;
	    // Draw graduations
	    // - First major graduation
	    drawGrad(context, minPosR, majorGradWidth);
	    // - Minor graduations
	    for (i=1; i <= numMinorGrads; i++)
		drawGrad(context, minPosR + i*radsPerMinorGrad, minorGradWidth);
	    // - Major graduations
	    for (i=1; i <= numMajorGrads; i++)
		drawGrad(context, minPosR + i*radsPerMajorGrad, majorGradWidth);
	    // - Final major graduation
	    drawGrad(context, maxPosR, majorGradWidth);
	    // - Stroke lines with color and width
	    context.strokeStyle = base.gradColor;
	    context.lineWidth = base.gradLineWidth;
	    context.stroke();
	}
    }

    Canvas {
	// http://doc.qt.io/qt-5/qml-qtquick-context2d.html

	// Set value arc, <360
	id: setValArc
	property double angle: (
	    setValue * posValueScale - setNumCircs*2*Math.PI + minPosR)

	// Positioning
	anchors.fill: parent
	z: 2.1

	contextType: "2d"
	onPaint: {
	    //base.debug1val = setValue;
	    //base.debug2val = setValue * posValueScale / toRads;
	    if (!context) return;
	    context.reset();
	    context.strokeStyle = base.setColor;
	    context.lineWidth = outerR - innerR;

	    // Draw set value outer arc
	    drawArc(context, (outerR+innerR)/2, minPosR, angle);
	}
    }

    Canvas {
	// Read value arc, <360
	id: readValArc
	property double angle: (
	    readValue * posValueScale - readNumCircs*2*Math.PI + minPosR)

	// Positioning
	anchors.fill: parent
	z: 2.2

	contextType: "2d"
	onPaint: {
	    if (!context) return;
	    context.reset();
	    context.strokeStyle = base.readColor;
	    context.lineWidth = outerR - innerR;

	    // Draw read value outer arc
	    drawArc(context, (outerR+innerR)/2, minPosR, angle);
	}
    }

    function drawHandle(c, angle, radius, fillR) {
	// Draw set value handle
	c.beginPath();
	c.arc(base.outerR + Math.cos(angle)*radius,
	      base.outerR + Math.sin(angle)*radius,  // center
	      fillR, 0, 2*Math.PI);
	c.stroke();
        c.fill();
    }

    Canvas {
	// Set value handle, <360 deg.
	id: setValHandle

	// Positioning
	anchors.fill: parent
	z: 9

	contextType: "2d"
	onPaint: {
	    // Draw handle at end of arc, middle of its width
	    if (!context) return;
	    context.reset();
            context.fillStyle = setColor;
	    context.strokeStyle = setBGColor;
	    context.lineWidth = handleStrokeWidth;
	    drawHandle(context, setValArc.angle, centerR,
		       handleDiameter/2);
	}
    }

    Canvas {
	// Read value handle, <360 deg.
	id: readValHandle

	// Positioning
	anchors.fill: parent
	z: 10

	contextType: "2d"
	onPaint: {
	    // Draw handle at end of arc, middle of its width
	    if (!context) return;
	    context.reset();
            context.fillStyle = readColor;
	    context.strokeStyle = readBGColor;
	    context.lineWidth = handleStrokeWidth;
	    drawHandle(context, readValArc.angle, centerR,
		       handleDiameter/2);
	}
    }

    Canvas {
	// Set value laps, >360 deg.
	id: setValLaps

	// Positioning
	anchors.fill: parent
	z: 8

	contextType: "2d"
	onPaint: {
	    // Draw handle at end of arc, middle of its width
	    var radius = (outerR+centerR)/2;
	    var halfAngle = Math.asin(
		(handleDiameter+handleStrokeWidth)/2/radius);
	    base.debug1val = (handleDiameter/2+handleStrokeWidth);
	    base.debug2val = setNumCircs;
	    //base.debug2val = halfAngle/toRads;
	    if (!context) return;
	    context.reset();
            context.fillStyle = setColor;
	    context.strokeStyle = setBGColor;
	    context.lineWidth = handleStrokeWidth;

	    for (var i=0; i<setNumCircs; i++) {
		drawHandle(context, minPosR - (i*2+1) * halfAngle, radius,
			   handleDiameter/2, base.setColor,
			   handleStrokeWidth, base.setBGColor);
	    }
	}
    }

    Canvas {
	// Read value laps, >360 deg.
	id: readValLaps

	// Positioning
	anchors.fill: parent
	z: 8

	contextType: "2d"
	onPaint: {
	    // Draw handle at end of arc, middle of its width
	    var radius = (outerR+centerR)/2;
	    var halfAngle = Math.asin(
		(handleDiameter+handleStrokeWidth)/2/radius);
	    base.debug1val = (handleDiameter/2+handleStrokeWidth);
	    base.debug2val = readNumCircs;
	    if (!context) return;
	    context.reset();
            context.fillStyle = readColor;
	    context.strokeStyle = readBGColor;
	    context.lineWidth = handleStrokeWidth;

	    for (var i=0; i<readNumCircs; i++) {
		drawHandle(context, minPosR - (i*2+1) * halfAngle, radius,
			   handleDiameter/2, base.readColor,
			   handleStrokeWidth, base.readBGColor);
	    }
	}
    }


    

}
