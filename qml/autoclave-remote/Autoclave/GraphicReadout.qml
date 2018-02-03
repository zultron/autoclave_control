import QtQuick 2.0

Readout {
    id: txt
    property string imageSource: "assets/s0-burner.png"
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignRight
    font.pixelSize: height * 0.5
    

    Image {
        id: img
        height: txt.height
        fillMode: Image.PreserveAspectFit
        anchors.left: parent.right
        anchors.verticalCenter: parent.verticalCenter
	source: txt.imageSource
    }
}
