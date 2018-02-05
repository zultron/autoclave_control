import QtQuick 2.0
import Machinekit.HalRemote.Controls 1.0
import "Autoclave" as Autoclave

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
        id: autoclave
        anchors.fill: parent

        Text {
            id: stage
            x: 0
            y: 25
            z: 10

            // Format float value with decimals in black text
            text: pins.stage
            color: "#000000"

            // Proportional size, centered above handle, with l/r tweak
            font.pixelSize: 20
        }

	// --------------- Central process stage widgets ------------------
        Autoclave.TempStage {
            id: idle
            x: 82
            y: 332
            width: 200
            height: 225
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
            x: 199
            y: 102
            width: 200
            height: 225
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
            x: 315
            y: 333
            width: 200
            height: 225
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
            x: 432
            y: 102
            width: 200
            height: 225
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
            x: 545
            y: 333
            width: 200
            height: 225
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
            x: 657
            y: 102
            width: 200
            height: 225
            setPinName: "cool-temp-set"
            readPinName: "cool-temp"
	    timePinName: "cool-time"
	    stageID: 5
	    stageCur: pins.stage
            centerImageSet: "assets/p5-cool-blue.png"
            centerImageRead: "assets/p5-cool-green.png"
	    typeIconSource: "assets/l2-cool.png"
        }

	// --------------- Left-hand-side button controls ------------------
	// Enable/disable button
	Autoclave.CheckButton {
            id: enable
            name: "enable-switch"
            x: 94
            y: 102
	    imageChecked: "assets/c0-power-1.png"
	    imageUnchecked: "assets/c0-power-0.png"
	}

	// Start/stop button
        Autoclave.CheckButton {
            id: start
            name: "start"
            x: 94
            y: 217
	    imageChecked: "assets/c1-start-1.png"
	    imageUnchecked: "assets/c1-start-0.png"
        }

	// --------------- Right-hand-side status ------------------
	// Process elapsed time
	Autoclave.HALGraphicReadout {
	    id: time_elapsed
	    name: "time-elapsed"
	    timeMode: true
            x: 855
            y: 343
	    height: 50
            source: "Autoclave/assets/s3-time.png"
    }

	// Burner % duty cycle
	Autoclave.HALGraphicReadout {
	    id: burner_duty
	    name: "burner-duty"
	    scale: 100
	    suffix: "%"
            x: 855
            y: 399
	    height: 50
            source: "Autoclave/assets/s0-burner.png"
    }

	// Pressure
	Autoclave.HALGraphicReadout {
	    id: pressure
	    name: "pressure"
	    suffix: "PSI"
            x: 855
            y: 455
	    height: 50
            source: "Autoclave/assets/s4-pressure.png"
    }

	// Temperature
	Autoclave.HALGraphicReadout {
	    id: temp_pot
	    name: "temp-pot"
	    suffix: "°C"
            x: 855
            y: 514
	    height: 50
            source: "Autoclave/assets/s5-temp.png"
    }

	// Steam icon appears when valve is open
	Autoclave.HALGraphicBool {
	    id: steam
	    name: "valve-on"
	    invert: false
            x: 751
            y: 514
	    height: 50
	    width: 50
            source: "Autoclave/assets/s2-steam.png"
	}

    }

}

