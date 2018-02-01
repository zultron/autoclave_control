import QtQuick 2.0
import Machinekit.HalRemote 1.0

Item {
    id: temp
    // Pins & values
    property alias setValue: setPin.value
    property alias readValue: readPin.value
    property string setPinName: "set-pin"
    property string readPinName: "read-pin"
    property bool setSynced
    property bool readSynced
    property bool synced: setSynced && readSynced
    // Gauge properties
    property alias readVisible: gauge.readVisible
    property alias outerDiameter: gauge.outerDiameter
    property alias innerDiameter: gauge.outerDiameter
    property alias minorGradWidth: gauge.minorGradWidth
    property alias majorGradWidth: gauge.majorGradWidth
    property alias gradLineWidth: gauge.gradLineWidth
    property alias handleDiameter: gauge.handleDiameter
    property alias handleStrokeWidth: gauge.handleStrokeWidth
    property alias handleOverlap: gauge.handleOverlap
    property alias setLineWidth: gauge.setLineWidth
    // - Min/max and direction
    property alias minValue: gauge.minValue
    property alias maxValue: gauge.maxValue
    property alias minPos: gauge.minPos
    property alias maxPos: gauge.maxPos
    // - Graduations
    property alias minorGrad: gauge.minorGrad
    property alias majorGrad: gauge.majorGrad
    // - Colors
    property alias baseColor: gauge.baseColor
    property alias gradColor: gauge.gradColor
    property alias setColor: gauge.setColor
    property alias setBGColor: gauge.setBGColor
    property alias readColor: gauge.readColor
    property alias readBGColor: gauge.readBGColor
    // Center image properties
    property string centerImage: "assets/p0-idle-green.png"
    // Type icon properties
    property string typeIconSource: "assets/l1-heat.png"
    property color readTextColor: "#000000"
    property color setTextColor: "#000000"

    width: 400
    height: 450


    HalPin {
	id: setPin
	name: temp.setPinName
	type: HalPin.Float
        direction: HalPin.Out
    }

    Binding {
	target: gauge;
	property: "setValue";
	value: setPin.value;
    }

    Binding {
	target: temp;
	property: "setSynced";
	value: setPin.synced;
    }

    HalPin {
	id: readPin
	name: temp.readPinName
	type: HalPin.Float
        direction: HalPin.In
    }

    Binding {
	target: gauge;
	property: "readValue";
	value: readPin.value;
    }

    Binding {
	target: temp;
	property: "readSynced";
	value: readPin.synced;
    }

    Image {
        id: typeIcon
	width: parent.height-parent.width
	height: parent.height-parent.width
        source: parent.typeIconSource
        anchors.horizontalCenter: parent.horizontalCenter
    }
    
    Text {
        id: readText
        color: temp.readTextColor
        text: gauge.readValue.toFixed(1) + "°C"
        anchors.right: typeIcon.left
        anchors.verticalCenter: typeIcon.verticalCenter
        horizontalAlignment: Text.AlignRight
        font.pixelSize: typeIcon.height * 0.7
    }

    Text {
        id: setText
        color: temp.setTextColor
        text: gauge.setValue.toFixed(1) + "°C"
        anchors.left: typeIcon.right
        anchors.verticalCenter: typeIcon.verticalCenter
        font.pixelSize: typeIcon.height * 0.7
    }

    DialGauge {
        id: gauge
	width: parent.width
	height: parent.width

	setValue: 121.0
	readValue: 20.0
        minValue: 0.0
        maxValue: 130.0
        minPos: 135.0 // SW
        maxPos: 405.0 // SE
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: typeIcon.bottom
    }

    Image {
        id: centerImg
        width: gauge.innerDiameter
        height: gauge.innerDiameter
        anchors.horizontalCenter: gauge.horizontalCenter
        anchors.verticalCenter: gauge.verticalCenter
        source: temp.centerImage
    }
    

}
