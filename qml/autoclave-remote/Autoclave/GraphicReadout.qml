import QtQuick 2.0

Image {
    id: img

    // Main properties
    property alias value: txt.value
    property alias timeMode: txt.timeMode
    // - Scalar value with units
    property alias decimals: txt.decimals
    property alias scale: txt.scale
    property alias suffix: txt.suffix
    // - Time value
    property alias displayHours: txt.displayHours

    fillMode: Image.PreserveAspectFit
    source: "assets/s0-burner.png"

    Readout {
	id: txt
	verticalAlignment: Text.AlignVCenter
	horizontalAlignment: Text.AlignRight
	font.pixelSize: img.height * 0.5
	
	// Line up to left of icon
	anchors.right: parent.left
	anchors.verticalCenter: parent.verticalCenter

    }
}
