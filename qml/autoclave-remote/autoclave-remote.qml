import QtQuick 2.0
import Machinekit.HalRemote.Controls 1.0
import "Autoclave" as Autoclave
import QtQuick.Window 2.2

HalApplicationWindow {
    id: main
    name: "autoclave-remote"
    width: 960
    height: 600
    transformOrigin: Item.Center
    title: qsTr("Autoclave")

    Autoclave.Pins {
        id: pins
    }

    Item {
        id: base

	// Sizes
	property double isos: 0.866025 // isosceles triangle cosine
	// - Basic size units
	property double scaleW: 3.5
	property double scaleH: 2.0
	property int blockSize: Math.min(main.height/scaleH, main.width/scaleW)
	// - Content dimensions within window
        width: blockSize * scaleW
        height: blockSize * scaleH
        anchors.horizontalCenter: parent.horizontalCenter
	anchors.verticalCenter: parent.verticalCenter
	// - Size of gauges & borders within their areas
	property int gaugeWidth: blockSize * 0.8
	property int gaugeHeight: blockSize * 0.9
	property int borderSize: blockSize - gaugeWidth
	// - Size of buttons & borders
	property int buttonSize: blockSize * 0.35
	property int buttonBorder: buttonSize * 0.2
	// - Size of indicators & borders
	property int indicatorSize: blockSize * 0.15
	property int indicatorBorder: indicatorSize * 0.2

        Text {
            id: stage
            x: 0
            y: 25
            z: 10
	    visible: false

            // Format float value with decimals in black text
            text: pins.stage
            color: "#000000"

            // Proportional size, centered above handle, with l/r tweak
            font.pixelSize: 20
        }

	// --------------- Central process stage widgets ------------------

        Autoclave.TempStage {
            id: idle
            x: base.borderSize * 0.5
            y: base.borderSize * 0.5
            width: base.gaugeWidth
            height: base.gaugeHeight
            setPinName: "idle-temp-set"
            readPinName: "idle-temp"
	    timePinName: "idle-time"
	    stageID: 0
	    stageCur: pins.stage
            centerImageSet: "assets/p0-idle-blue.png"
            centerImageRead: "assets/p0-idle-green.png"
	    typeIconSource: "assets/l1-heat.png"
        }

        Autoclave.TempStage {
            id: boil
            x: base.blockSize * 0.5 + base.borderSize * 0.5
            y: base.blockSize
            width: base.gaugeWidth
            height: base.gaugeHeight
            setPinName: "boil-temp-set"
            readPinName: "boil-temp"
	    timePinName: "boil-time"
	    stageID: 1
	    stageCur: pins.stage
            centerImageSet: "assets/p1-boil-blue.png"
            centerImageRead: "assets/p1-boil-green.png"
	    typeIconSource: "assets/l1-heat.png"
        }

        Autoclave.TimeStage {
            id: flush
            x: base.blockSize * 1.0 + base.borderSize * 0.5
            y: base.borderSize * 0.5
            width: base.gaugeWidth
            height: base.gaugeHeight
            setPinName: "flush-time-set"
            readPinName: "flush-time"
	    stageID: 2
	    stageCur: pins.stage
            centerImageSet: "assets/p2-flush-blue.png"
            centerImageRead: "assets/p2-flush-green.png"
	    typeIconSource: "assets/l3-timer.png"
        }

        Autoclave.TempStage {
            id: heat
            x: base.blockSize * 1.5 + base.borderSize * 0.5
            y: base.blockSize
            width: base.gaugeWidth
            height: base.gaugeHeight
            setPinName: "heat-temp-set"
            readPinName: "heat-temp"
	    timePinName: "heat-time"
	    stageID: 3
	    stageCur: pins.stage
            centerImageSet: "assets/p3-heat-blue.png"
            centerImageRead: "assets/p3-heat-green.png"
	    typeIconSource: "assets/l1-heat.png"
        }

        Autoclave.TimeStage {
            id: ster
            x: base.blockSize * 2.0 + base.borderSize * 0.5
            y: base.borderSize * 0.5
            width: base.gaugeWidth
            height: base.gaugeHeight
            setPinName: "ster-time-set"
            readPinName: "ster-time"
	    stageID: 4
	    stageCur: pins.stage
            centerImageSet: "assets/p4-sterilize-blue.png"
            centerImageRead: "assets/p4-sterilize-green.png"
	    typeIconSource: "assets/l3-timer.png"
        }

        Autoclave.TempStage {
            id: cool
            x: base.blockSize * 2.5 + base.borderSize * 0.5
            y: base.blockSize
            width: base.gaugeWidth
            height: base.gaugeHeight
            setPinName: "cool-temp-set"
            readPinName: "cool-temp"
	    timePinName: "cool-time"
	    stageID: 5
	    stageCur: pins.stage
            centerImageSet: "assets/p5-cool-blue.png"
            centerImageRead: "assets/p5-cool-green.png"
	    typeIconSource: "assets/l2-cool.png"
	    // Reverse:  this is cooling, not heating
	    minPos: 2.25 * Math.PI // SE
            maxPos: minPos - 1.5 * Math.PI // SW
	    minorGrad: -1.0
	    majorGrad: -10.0
	    minValue: 130.0
	    maxValue: 0.0
	    minLimit: 121.0
	    maxLimit: 0.0
        }

	// --------------- Left-hand-side button controls ------------------
	// - Fit on bottom left 1/2 block

	// Enable/disable button
	Autoclave.CheckButton {
            id: enable
            name: "enable-switch"
            x: base.borderSize * 0.5
            y: base.blockSize + base.borderSize * 0.5
	    height: base.buttonSize
	    width: base.buttonSize
	    imageChecked: "assets/c0-power-1.png"
	    imageUnchecked: "assets/c0-power-0.png"
	}

	// Start/stop button
        Autoclave.CheckButton {
            id: start
            name: "start"
            x: base.borderSize * 0.5
            y: enable.y + base.buttonSize + base.buttonBorder
	    height: base.buttonSize
	    width: base.buttonSize
	    imageChecked: "assets/c1-start-1.png"
	    imageUnchecked: "assets/c1-start-0.png"
        }

	// --------------- Right-hand-side status ------------------
	// - Fit on top right 1/2 block

	// Process elapsed time
	Autoclave.HALGraphicReadout {
	    id: time_elapsed
	    name: "time-elapsed"
	    timeMode: true
            x: base.width - base.indicatorSize - base.borderSize * 0.5
            y: base.borderSize * 0.5
	    height: base.indicatorSize
	    width: base.indicatorSize
            source: "Autoclave/assets/s3-time.png"
    }

	// Burner % duty cycle
	Autoclave.HALGraphicReadout {
	    id: burner_duty
	    name: "burner-duty"
	    scale: 100
	    suffix: "%"
            x: base.width - base.indicatorSize - base.borderSize * 0.5
            y: base.borderSize * 0.5 + base.indicatorSize + base.indicatorBorder
	    height: base.indicatorSize
	    width: base.indicatorSize
            source: "Autoclave/assets/s0-burner.png"
    }

	// Pressure
	Autoclave.HALGraphicReadout {
	    id: pressure
	    name: "pressure"
	    suffix: "PSI"
            x: base.width - base.indicatorSize - base.borderSize * 0.5
            y: base.borderSize * 0.5 + (base.indicatorSize + base.indicatorBorder) * 2.0
	    height: base.indicatorSize
	    width: base.indicatorSize
            source: "Autoclave/assets/s4-pressure.png"
    }

	// Temperature
	Autoclave.HALGraphicReadout {
	    id: temp_pot
	    name: "temp-pot"
	    suffix: "°C"
            x: base.width - base.indicatorSize - base.borderSize * 0.5
            y: base.borderSize * 0.5 + (base.indicatorSize + base.indicatorBorder) * 3.0
	    height: base.indicatorSize
	    width: base.indicatorSize
            source: "Autoclave/assets/s5-temp.png"
    }

	// Steam icon appears when valve is open
	Autoclave.HALGraphicBool {
	    id: steam
	    name: "valve-on"
	    invert: false
            x: base.width - base.indicatorSize - base.borderSize * 0.5
            y: base.borderSize * 0.5 + (base.indicatorSize + base.indicatorBorder) * 4.0
	    height: base.indicatorSize
	    width: base.indicatorSize
            source: "Autoclave/assets/s2-steam.png"

	    property int cycleTime: 2000
	    SequentialAnimation {
		running: true
		NumberAnimation {
		    target: steam
		    property: "opacity"
		    to: 1.0
		    duration: steam.cycleTime/2
		}
		NumberAnimation {
		    target: steam
		    property: "opacity"
		    to: 0.0
		    duration: steam.cycleTime/2
		}
		loops: Animation.Infinite
	    }
	}

    }

}

