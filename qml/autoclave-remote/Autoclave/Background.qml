import QtQuick 2.0
import QtQuick.Controls 2.0

Canvas {
    id: base
    z: 0

    property int blockSize: 200
    property int borderSize: 20
    property color pendingColor: "#000080"
    property color doneColor: "#008000"
    property int lineWidth: blockSize * 0.2
    property int stage: 0

    anchors.fill: parent

    onStageChanged: requestPaint()

    contextType: "2d"
    onPaint: {
	if (!context) return;
	context.reset();
	context.lineWidth = base.lineWidth;

	// Draw lines connecting stages
	var hiY = base.blockSize * 0.5;
	var lowY = base.blockSize * 1.5 - borderSize*0.5;
	for (var i=1; i <5; i++) {
	    context.beginPath();
	    context.strokeStyle = (
		i < base.stage ? base.doneColor : base.pendingColor);
	    var startLow = Math.floor(i/2) != i/2;
	    context.moveTo(base.blockSize * (i/2+0.5),
			   (startLow ? lowY : hiY));
	    context.lineTo(base.blockSize * (i/2+1.0),
			   (startLow ? hiY : lowY));
	    context.stroke();
	}
    }
}
