import QtQuick 2.0
import Machinekit.HalRemote 1.0

Item {
    id: temp
    // Pins & values
    property alias setPinName:  gauge.setPinName
    property alias setValue:    gauge.setValue
    property alias setSynced:   gauge.setSynced
    property alias readPinName: gauge.readPinName
    property alias readValue:   gauge.readValue
    property alias readSynced:  gauge.readSynced
    property alias timeValue:   timeReadout.value
    property alias timePinName: timeReadout.name
    property alias timeSynced:  timeReadout.synced
    property bool  synced: setSynced && readSynced && timeSynced
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


    Image {
        id: typeIcon
        width: parent.height-parent.width
        height: parent.height-parent.width
        source: parent.typeIconSource
        anchors.horizontalCenter: parent.horizontalCenter
    }
    
    TempReadout {
        id: setTemp
	value: gauge.setValue
        color: temp.setTextColor
        anchors.left: typeIcon.right
        anchors.verticalCenter: typeIcon.verticalCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: typeIcon.height * 0.7
    }

    TempReadout {
        id: readTemp
	value: gauge.readValue
        color: temp.readTextColor
        anchors.right: typeIcon.left
        anchors.verticalCenter: typeIcon.verticalCenter
        horizontalAlignment: Text.AlignRight
        font.pixelSize: typeIcon.height * 0.7
    }

    DialGauge {
        id: gauge
        width: parent.width
        height: parent.width

	setValue: 121.0
	readValue: 80.0

	// HAL pins
	property string setPinName: "set-pin"
	property bool setSynced
	property string readPinName: "read-pin"
	property bool readSynced
	property bool synced: setSynced && readSynced

        minValue: 0.0
        maxValue: 130.0
        minPos: 135.0 // SW
        maxPos: 405.0 // SE
	minorGrad: 1.0
	majorGrad: 10.0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: typeIcon.bottom

	// set pin
        HalPin {
            id: setPin
            name: gauge.setPinName
            type: HalPin.Float
            direction: HalPin.Out
	}

	Binding {
            target: gauge;
            property: "setValue";
            value: setPin.value;
	}

	Binding {
            target: gauge;
            property: "setSynced";
            value: setPin.synced;
	}

	// read pin
        HalPin {
            id: readPin
            name: gauge.readPinName
            type: HalPin.Float
            direction: HalPin.In
	}

	Binding {
            target: gauge;
            property: "readValue";
            value: readPin.value;
	}

	Binding {
            target: gauge;
            property: "readSynced";
            value: readPin.synced;
	}

    }

    Image {
        id: centerImg
        width: gauge.innerDiameter
        height: gauge.innerDiameter
        anchors.horizontalCenter: gauge.horizontalCenter
        anchors.verticalCenter: gauge.verticalCenter
        source: temp.centerImage
    }

    HALTimeReadout {
        id: timeReadout
	name: "time-pin"
	value: 12*60 + 37
	dir_in: true

	// Size and position
        anchors.bottom: gauge.bottom
        anchors.bottomMargin: temp.outerDiameter * 0.01
        anchors.horizontalCenter: gauge.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: typeIcon.height * 0.7
    }
}
