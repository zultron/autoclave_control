import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import Machinekit.HalRemote 1.0

Button {
    /* Checkable button

       Can switch image when checked
     */
    id: base

    property string name: "hal-pin"
    property bool synced: false
    property string imageChecked: "assets/c0-power-0.png"
    property string imageUnchecked: "assets/c0-power-1.png"

    checkable: true
    checked: pin.value

    HalPin {
        id: pin
        name: base.name
        type: HalPin.Bit
        direction: HalPin.Out
    }

    Binding {
	target: pin;
	property: "value";
	value: base.checked;
    }
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
		visible: base.checked
		z: 1
	    }
	}
    }
}
