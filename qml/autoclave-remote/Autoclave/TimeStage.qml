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
    property bool synced: setSynced && readSynced
    // Gauge properties
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
    property alias precision: gauge.precision
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
    property string centerImageSet: "assets/p2-flush-blue.png"
    property string centerImageRead: "assets/p2-flush-green.png"
    // Type icon properties
    property string typeIconSource: "assets/l3-timer.png"
    property color readTextColor: "#000000"
    property color setTextColor: "#000000"

    // State
    property int stageID: 0
    property int stageCur: 0

    width: 400
    height: 450

    Image {
        id: typeIcon
        width: parent.height-parent.width
        height: parent.height-parent.width
        source: parent.typeIconSource
        anchors.horizontalCenter: parent.horizontalCenter
    }
    
    TimeReadout {
        id: setReadout
	value: setPin.value
        color: base.setTextColor
        anchors.left: typeIcon.right
        anchors.verticalCenter: typeIcon.verticalCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: typeIcon.height * 0.7
    }

    TimeReadout {
        id: readReadout
	value: readPin.value
	visible: base.readVisible
        color: base.readTextColor
        anchors.right: typeIcon.left
        anchors.verticalCenter: typeIcon.verticalCenter
        horizontalAlignment: Text.AlignRight
        font.pixelSize: typeIcon.height * 0.7
    }

    DialGauge {
        id: gauge
        width: parent.width
        height: parent.width

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
        maxValue: 2*60.0*60.0 // 2 hours
        minPos: -90.0 // 12 o'clock
        maxPos: 2*360 + minPos
	precision: 60.0 // 1 minute granularity
	minorGrad: 1.0 * 60.0 // 1 minute
	majorGrad: 5.0 * 60.0 // 5 minutes, like 1..12 on clock
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: typeIcon.bottom

        // set pin
        HalPin {
            id: setPin
            name: gauge.setPinName
            type: HalPin.S32
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
            type: HalPin.S32
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
        id: centerImgSet
        width: gauge.innerDiameter
        height: gauge.innerDiameter
        anchors.horizontalCenter: gauge.horizontalCenter
        anchors.verticalCenter: gauge.verticalCenter
        source: parent.centerImageSet
	z: 0.1
    }

    Image {
        id: centerImgRead
        width: gauge.innerDiameter
        height: gauge.innerDiameter
        anchors.horizontalCenter: gauge.horizontalCenter
        anchors.verticalCenter: gauge.verticalCenter
        source: parent.centerImageRead
	opacity: base.readFade
	z: 0.2
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
