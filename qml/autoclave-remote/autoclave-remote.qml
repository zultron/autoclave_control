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

        Autoclave.DialGauge {
            id: idle
            x: 82
            y: 332
            outerDiameter: 200.0
            setValue: pins.idle_temp
            readValue: pins.temp_pot
            minValue: 0.0
            maxValue: 130.0
            minPos: 135.0 // SW
            maxPos: 405.0

     Image {
         id: image
         x: 50
         y: 50
         width: 100
         height: 100
         source: "assets/p0-idle-green.png"
     } // SE
        }

        Autoclave.DialGauge {
            id: flush
            x: 220
            y: 102
	    outerDiameter: 200.0
        setValue: pins.flush_time
        minValue: 0.0
        maxValue: 60
        minPos: -90 // 12 o'clock
        maxPos: 360 + minPos // one hour
        property double majorGrad: 5.0

     Image {
         id: image1
         x: 50
         y: 50
         width: 100
         height: 100
         source: "assets/p1-flush-blue.png"
     } // like 1..12 on clock
        }

        Autoclave.DialGauge {
            id: heat
            x: 380
            y: 332
            outerDiameter: 200.0
            setValue: pins.ster_temp
            readValue: pins.temp_pot
            minValue: 0.0
            maxValue: 130.0
            minPos: 135.0 // SW
            maxPos: 405.0

     Image {
         id: image2
         x: 50
         y: 50
         width: 100
         height: 100
         source: "assets/p2-heat-blue.png"
     } // SE
        }

        Autoclave.DialGauge {
            id: sterilize
            x: 532
            y: 108
	    outerDiameter: 200.0
	    setValue: pins.ster_time
        minValue: 0.0
        maxValue: 4*60 // four hours
        minPos: -90 // 12 o'clock
        maxPos: 4*360 + minPos // four hours
        property double majorGrad: 5.0

     Image {
         id: image3
         x: 50
         y: 50
         width: 100
         height: 100
         source: "assets/p3-sterilize-blue.png"
     } // like 1..12 on clock
        }

        Autoclave.DialGauge {
            id: cool
            x: 670
            y: 332
            outerDiameter: 200.0
            setValue: pins.finish_temp
            readValue: pins.temp_pot
            minValue: 0.0
            maxValue: 130.0
            minPos: 135.0 // SW
            maxPos: 405.0

     Image {
         id: image4
         x: 50
         y: 50
         width: 100
         height: 100
         source: "assets/p4-cool-blue.png"
     } // SE
        }


    }
}

