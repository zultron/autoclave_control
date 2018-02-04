import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import Machinekit.HalRemote 1.0

Button {
    /* Checkable button

       Can switch image when checked
     */
    id: base

    property alias name: pin.name
    property bool synced: false
    property string imageChecked: "assets/c0-power-0.png"
    property string imageUnchecked: "assets/c0-power-1.png"

    checked: pin.value
    checkable: true

    onClicked: {
	pin.value = ! pin.value;
    }

    HalPin {
        id: pin
        name: "hal-pin"
        type: HalPin.Bit
        direction: HalPin.Out
    }

    /*
    Binding {
	target: pin;
	property: "value";
	value: base.checked;
    }
    */
    Binding {
	target: base;
	property: "synced";
	value: pin.synced;
    }

    style: ButtonStyle {
	background: Image {
	    anchors.fill: parent
	    source: base.imageUnchecked
	    z: 0
	    Image {
		anchors.fill: parent
		source: base.imageChecked
		visible: pin.value
		z: 1
	    }
	}
    }
}
