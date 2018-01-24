import QtQuick 2.0
import QtQuick.Controls 1.1
import Machinekit.HalRemote 1.0
import "Private" as Private

Item {
    /* Outside temperature */
    property alias tempOutName: outGauge.pinName
    property alias tempOut: outGauge.value
    /* Inside temperature */
    property alias tempInName: inGauge.pinName
    property alias tempIn: inGauge.tempIn
    /* Too Cold:  Lower boundary of Goldilocks zone */
    property alias blueZoneName: set.pinMinName
    property alias blueZone: set.blueZone
    /* Too Hot:  Upper boundary of Goldilocks zone */
    property alias redZoneName: set.pinMaxName
    property alias redZone: set.redZone
    /* Range in degrees for allowed setting; centers around tempOut */
    property double range: 90.0

    /* Synch */
    property bool synched: set.synched && inGauge.synched && outGauge.synched

    // Debugging
    // - Angles
    property double redAngle: set.redAngle
    property double blueAngle: set.blueAngle
    // - Mouse
    property double mouseX: set.mouseX
    property double mouseY: set.mouseY
    property alias inring: set.inring
    property double totemp: set.totemp
    property double dragged: set.dragged
    // - Register
    property int rzone: set.rzone
    property double rtemporig: set.rtemporig
    property double rtempstart: set.rtempstart

    // Increment for mouse wheel
    property double stepSize: 0.1

    id: root
    height: width * 1.35

    Private.GoldistatOut {
        id: outGauge
        z: 1

        // Fits root item
        anchors.fill: parent
    }


    Private.GoldistatIn {
        id: inGauge

        // This circle centers on the settings dial
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        height: width
        z: 0

	// Connect signals needed to calculate rotation
	range: root.range
	redZone: root.redZone
	blueZone: root.blueZone
	tempOut: root.tempOut
    }

    Private.GoldistatSet {
        id: set
        height: width
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        z: 2
	
	// Connect signals needed to calculate rotation
	range: root.range
        tempOut: root.tempOut
    }
}
