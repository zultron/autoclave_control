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

        Autoclave.TempStage {
            id: idle
            x: 82
            y: 332
            outerDiameter: 200.0
            width: 200
            height: 225
            setPinName: "idle-temp-set"
            readPinName: "idle-temp"
	    timePinName: "idle-time"
	    readVisible: true
            centerImage: "assets/p0-idle-green.png"
	    typeIconSource: "assets/l1-heat.png"
        }

        Autoclave.TimeStage {
            id: flush
            x: 220
            y: 102
            outerDiameter: 200.0
            width: 200
            height: 225
            setPinName: "flush-time-set"
            readPinName: "flush-time"
	    readVisible: pins.stage >= 1
            centerImage: "assets/p1-flush-blue.png"
	    typeIconSource: "assets/l3-timer.png"
        }

        Autoclave.TempStage {
            id: heat
            x: 380
            y: 332
            outerDiameter: 200.0
            width: 200
            height: 225
            setPinName: "heat-temp-set"
            readPinName: "heat-temp"
	    timePinName: "heat-time"
	    readVisible: pins.stage >= 2
            centerImage: "assets/p2-heat-blue.png"
	    typeIconSource: "assets/l1-heat.png"
        }

        Autoclave.TimeStage {
            id: ster
            x: 532
            y: 102
            outerDiameter: 200.0
            width: 200
            height: 225
            setPinName: "ster-time-set"
            readPinName: "ster-time"
	    readVisible: pins.stage >= 3
            centerImage: "assets/p3-sterilize-blue.png"
	    typeIconSource: "assets/l3-timer.png"
        }

        Autoclave.TempStage {
            id: cool
            x: 670
            y: 332
            outerDiameter: 200.0
            width: 200
            height: 225
            setPinName: "cool-temp-set"
            readPinName: "cool-temp"
	    timePinName: "cool-time"
	    readVisible: pins.stage >= 4
            centerImage: "assets/p4-cool-blue.png"
	    typeIconSource: "assets/l2-cool.png"
        }

	Autoclave.CheckButton {
            id: enable
            name: "enable-switch"
            x: 94
            y: 102
	    imageChecked: "assets/c0-power-1.png"
	    imageUnchecked: "assets/c0-power-0.png"
	}

        Autoclave.CheckButton {
            id: start
            name: "start"
            x: 94
            y: 217
	    imageChecked: "assets/c1-start-1.png"
	    imageUnchecked: "assets/c1-start-0.png"
        }

	Autoclave.HALGraphicTimeReadout {
	    id: time_elapsed
	    name: "time-elapsed"
            x: 767
            y: 108
	    height: 50
            imageSource: "assets/s3-time.png"
	}

	Autoclave.HALGraphicReadout {
	    id: burner_duty
	    name: "burner-duty"
	    scale: 100
	    suffix: "%"
            x: 799
            y: 166
	    height: 50
            imageSource: "assets/s0-burner.png"
	}

	Autoclave.HALGraphicReadout {
	    id: pressure
	    name: "pressure"
	    suffix: "PSI"
            x: 785
            y: 225
	    height: 50
            imageSource: "assets/s4-pressure.png"
	}

	Autoclave.HALGraphicReadout {
	    id: temp_pot
	    name: "temp-pot"
	    suffix: "°C"
            x: 793
            y: 281
	    height: 50
            imageSource: "assets/s5-temp.png"
	}

    Autoclave.HALGraphicBool {
	    id: steam
	    name: "valve-on"
	    invert: false
            x: 738
            y: 281
	    height: 50
	    width: 50
            source: "Autoclave/assets/s2-steam.png"
	}

    }

}

