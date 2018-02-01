import QtQuick 2.0
import Machinekit.HalRemote.Controls 1.0
import "Autoclave" as Autoclave
import QtQuick.Layouts 1.3

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
            setPinName: "idle-temp"
            readPinName: "temp-pot"
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
            setPinName: "flush-time"
            readPinName: "stage-elapsed-time"
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
            setPinName: "ster-temp"
            readPinName: "temp-pot"
	    readVisible: pins.stage >= 2
            centerImage: "assets/p2-heat-blue.png"
	    typeIconSource: "assets/l1-heat.png"
        }

        Autoclave.TimeStage {
            id: sterilize
            x: 532
            y: 102
            outerDiameter: 200.0
            width: 200
            height: 225
            setPinName: "ster-time"
            readPinName: "stage-elapsed-time"
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
            setPinName: "finish-temp"
            readPinName: "temp-pot"
	    readVisible: pins.stage >= 4
            centerImage: "assets/p4-cool-blue.png"
	    typeIconSource: "assets/l2-cool.png"
        }

    }

}

