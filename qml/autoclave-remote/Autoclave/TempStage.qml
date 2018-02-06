import QtQuick 2.0
import Machinekit.HalRemote 1.0

Item {
    id: base
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
    property alias overallR: gauge.overallR
    property alias outerR: gauge.outerR
    property alias innerR: gauge.innerR
    property alias centerR: gauge.centerR
    property alias minorGradWidth: gauge.minorGradWidth
    property alias majorGradWidth: gauge.majorGradWidth
    property alias gradLineWidth: gauge.gradLineWidth
    property alias handleDiameter: gauge.handleDiameter
    property alias handleStrokeWidth: gauge.handleStrokeWidth
    property alias handleOverlap: gauge.handleOverlap
    property alias setLineWidth: gauge.setLineWidth
    // - Min/max and direction
    property alias minValue: gauge.minValue
    property alias minLimit: gauge.minLimit
    property alias maxValue: gauge.maxValue
    property alias maxLimit: gauge.maxLimit
    property alias minPos: gauge.minPos
    property alias maxPos: gauge.maxPos
    property alias precision: gauge.precision
    property int decimals: 1
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
    property double readFade: 0.0
    property bool readVisible: false
    // Center image properties
    property string centerImageSet: "assets/p1-boil-blue.png"
    property string centerImageRead: "assets/p1-boil-green.png"
    // Type icon properties
    property string typeIconSource: "assets/l1-heat.png"
    property color readTextColor: "#000000"
    property color setTextColor: "#000000"

    // State
    property int stageID: 0
    property int stageCur: 0

    width: 400
    height: 450

    // Top:  stage type image
    Image {
        id: typeIcon
        width: parent.height-parent.width
        height: parent.height-parent.width
        source: parent.typeIconSource
        anchors.horizontalCenter: parent.horizontalCenter
    }

    // Top right:  set value readout
    Readout {
        id: setReadout
	value: setPin.value
	decimals: base.decimals
        color: base.setTextColor
        anchors.left: typeIcon.right
        anchors.verticalCenter: typeIcon.verticalCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: typeIcon.height * 0.7
    }

    // Top left:  read value readout
    Readout {
        id: readReadout
	value: readPin.value
	visible: base.readVisible
	decimals: base.decimals
        color: base.readTextColor
        anchors.right: typeIcon.left
        anchors.verticalCenter: typeIcon.verticalCenter
        horizontalAlignment: Text.AlignRight
        font.pixelSize: typeIcon.height * 0.7
    }

    // The gauge
    DialGauge {
        id: gauge
	// Circular gauge takes up whole width, aligned at bottom
        width: parent.width
        height: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: typeIcon.bottom

	setValue: setPin.value
	readValue: readPin.value
	readVisible: base.readVisible
	readFade: base.readFade

	// HAL pins
	property string setPinName: "set-pin"
	property bool setSynced
	property string readPinName: "read-pin"
	property bool readSynced
	property bool synced: setSynced && readSynced

        minValue: 0.0
	minLimit: 20.0
        maxValue: 130.0
	maxLimit: 121.0
	precision: 0.1
	mouseScale: 0.2
        minPos: 3/4 * Math.PI // SW
        maxPos: minPos + 3/2 * Math.PI // SE
	minorGrad: 1.0
	majorGrad: 10.0

        // set pin
        HalPin {
            id: setPin
            name: gauge.setPinName
            type: HalPin.Float
            direction: HalPin.Out
        }

        Binding {
            target: setPin;
            property: "value";
            value: gauge.setValue;
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

    // Center:  stage icon, incomplete
    Image {
        id: centerImgSet
        width: gauge.centerR * 2
        height: gauge.centerR * 2
        anchors.horizontalCenter: gauge.horizontalCenter
        anchors.verticalCenter: gauge.verticalCenter
        source: parent.centerImageSet
	z: 0.1
	RotationAnimation on rotation {
            loops: Animation.Infinite
            from: 0
            to: 360
	    duration: 5000
	    alwaysRunToEnd: true
	    running: base.state == "progress"
	}
    }

    // Center:  stage icon, complete
    Image {
        id: centerImgRead
        width: gauge.centerR * 2
        height: gauge.centerR * 2
        anchors.horizontalCenter: gauge.horizontalCenter
        anchors.verticalCenter: gauge.verticalCenter
        source: parent.centerImageRead
	opacity: base.readFade
	z: 0.2
    }

    // Bottom:  stage elapsed time readout
    HALReadout {
        id: timeReadout
	timeMode: true
	name: "time-pin"
	value: 12*60 + 37

	// Size and position
        anchors.bottom: gauge.bottom
        anchors.bottomMargin: base.overallR * 0.1
        anchors.horizontalCenter: gauge.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: typeIcon.height * 0.7
    }

    states: [
	State {
	    name: "progress"
	    when: base.stageCur == base.stageID
	    PropertyChanges {
		target: base
		readFade: 0.0
		readVisible: true
	    }
	},
	State {
	    name: "done"
	    when: base.stageCur > base.stageID
	    PropertyChanges {
		target: base
		readFade: 1.0
		readVisible: true
	    }
	}
    ]
    transitions: [
	Transition {
	    NumberAnimation {
		properties: "readFade"
		duration: 500
	    }
	}
    ]
}
