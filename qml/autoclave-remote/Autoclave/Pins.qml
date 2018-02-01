import QtQuick 2.0
import Machinekit.HalRemote 1.0

Item {

    property alias enable: enable.value
    property alias start: start.value
    property alias temp_set: temp_set.value
    property alias time_set: time_set.value
    property alias valve_on: valve_on.value
    property alias elapsed_time: elapsed_time.value
    property alias stage: stage.value
    property alias stage_elapsed_time: stage_elapsed_time.value
    property alias error: error.value
    property alias estop: estop.value
    property alias temp_pot: temp_pot.value
    property alias pressure: pressure.value
    property alias burner_duty: burner_duty.value

    // Buttons
    Item {
	id: enable
	property bool checked
	property bool value

	HalPin {
            id: enable_pin
            name: "enable-switch"
            type: HalPin.Bit
            direction: HalPin.Out
	}

	Binding {
	    target: enable;
	    property: "checked";
	    value: enable_pin.value;
	}
	Binding {
	    target: enable;
	    property: "value";
	    value: enable_pin.checked;
	}
    }

    Item {
	id: start
	property bool checked
	property bool value

	HalPin {
            id: start_pin
            name: "start"
            type: HalPin.Bit
            direction: HalPin.Out
	}

	Binding {
	    target: start;
	    property: "checked";
	    value: start_pin.value;
	}
	Binding {
	    target: start;
	    property: "value";
	    value: start_pin.checked;
	}
    }

    // Status

    // - control comp
    Item {
	id: temp_set
	property double value
	property bool synced

	HalPin {
            id: temp_set_pin
            name: "temp-set"
            type: HalPin.Float
            direction: HalPin.In
	}

	Binding {
	    target: temp_set;
	    property: "value";
	    value: temp_set_pin.value;
	}

	Binding {
	    target: temp_set;
	    property: "synced";
	    value: temp_set_pin.synced;
	}
    }

    Item {
	id: time_set
	property int value
	property bool synced

	HalPin {
            id: time_set_pin
            name: "time-set"
            type: HalPin.S32
            direction: HalPin.In
	}

	Binding {
	    target: time_set;
	    property: "value";
	    value: time_set_pin.value;
	}

	Binding {
	    target: time_set;
	    property: "synced";
	    value: time_set_pin.synced;
	}
    }

    Item {
	id: valve_on
	property bool checked
	property bool value

	HalPin {
            id: valve_on_pin
            name: "valve-on"
            type: HalPin.Bit
            direction: HalPin.In
	}

	Binding {
	    target: valve_on;
	    property: "checked";
	    value: valve_on_pin.value;
	}
	Binding {
	    target: valve_on;
	    property: "value";
	    value: valve_on_pin.checked;
	}
    }

    Item {
	id: elapsed_time
	property int value
	property bool synced

	HalPin {
            id: elapsed_time_pin
            name: "elapsed-time"
            type: HalPin.S32
            direction: HalPin.In
	}

	Binding {
	    target: elapsed_time;
	    property: "value";
	    value: elapsed_time_pin.value;
	}

	Binding {
	    target: elapsed_time;
	    property: "synced";
	    value: elapsed_time_pin.synced;
	}
    }

    Item {
	id: stage
	property int value
	property bool synced

	HalPin {
            id: stage_pin
            name: "stage"
            type: HalPin.S32
            direction: HalPin.In
	}

	Binding {
	    target: stage;
	    property: "value";
	    value: stage_pin.value;
	}

	Binding {
	    target: stage;
	    property: "synced";
	    value: stage_pin.synced;
	}
    }

    Item {
	id: stage_elapsed_time
	property int value
	property bool synced

	HalPin {
            id: stage_elapsed_time_pin
            name: "stage-elapsed-time"
            type: HalPin.S32
            direction: HalPin.In
	}

	Binding {
	    target: stage_elapsed_time;
	    property: "value";
	    value: stage_elapsed_time_pin.value;
	}

	Binding {
	    target: stage_elapsed_time;
	    property: "synced";
	    value: stage_elapsed_time_pin.synced;
	}
    }

    Item {
	id: error
	property bool checked
	property bool value

	HalPin {
            id: error_pin
            name: "error"
            type: HalPin.Bit
            direction: HalPin.In
	}

	Binding {
	    target: error;
	    property: "checked";
	    value: error_pin.value;
	}
	Binding {
	    target: error;
	    property: "value";
	    value: error_pin.checked;
	}
    }

    // - other

    Item {
	id: estop
	property bool checked
	property bool value

	HalPin {
            id: estop_pin
            name: "estop"
            type: HalPin.Bit
            direction: HalPin.In
	}

	Binding {
	    target: estop;
	    property: "checked";
	    value: estop_pin.value;
	}
	Binding {
	    target: estop;
	    property: "value";
	    value: estop_pin.checked;
	}
    }

    Item {
	id: temp_pot
	property double value
	property bool synced

	HalPin {
            id: temp_pot_pin
            name: "temp-pot"
            type: HalPin.Float
            direction: HalPin.In
	}

	Binding {
	    target: temp_pot;
	    property: "value";
	    value: temp_pot_pin.value;
	}

	Binding {
	    target: temp_pot;
	    property: "synced";
	    value: temp_pot_pin.synced;
	}
    }

    Item {
	id: pressure
	property double value
	property bool synced

	HalPin {
            id: pressure_pin
            name: "pressure"
            type: HalPin.Float
            direction: HalPin.In
	}

	Binding {
	    target: pressure;
	    property: "value";
	    value: pressure_pin.value;
	}

	Binding {
	    target: pressure;
	    property: "synced";
	    value: pressure_pin.synced;
	}
    }

    Item {
	id: burner_duty
	property double value
	property bool synced

	HalPin {
            id: burner_duty_pin
            name: "burner-duty"
            type: HalPin.Float
            direction: HalPin.In
	}

	Binding {
	    target: burner_duty;
	    property: "value";
	    value: burner_duty_pin.value;
	}

	Binding {
	    target: burner_duty;
	    property: "synced";
	    value: burner_duty_pin.synced;
	}
    }
}
