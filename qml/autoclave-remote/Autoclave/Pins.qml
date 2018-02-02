import QtQuick 2.0
import Machinekit.HalRemote 1.0

Item {
    id: pins
    

    // Test
    property double test_pin: 42.5
    HalPin {
	id: test_pin
	name: "test-pin"
	type: HalPin.Float
	direction: HalPin.Out
    }
    Binding {
	target: pins
	property: "test_pin"
	value: test_pin.value
    }

    // Remote controls
    property alias enable: enable.value
    property alias start: start.value
    // Process stage settings and status
    // (others taken care of in TimeStage and TempStage objects)
    property alias stage: stage.value
    // Controls in
    property alias temp_set: temp_set.value
    property alias burner_duty: burner_duty.value
    property alias valve_on: valve_on.value
    // Sensors/limits
    property alias pressure: pressure.value
    property alias pressure_max: pressure_max.value
    property alias temp_pot: temp_pot.value
    property alias temp_pot_max: temp_pot_max.value
    property alias temp_burner: temp_burner.value
    property alias temp_burner_max: temp_burner_max.value
    // Other status
    property alias time_elapsed: time_elapsed.value
    property alias error: error.value
    property alias estop: estop.value

    // Remote controls
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

    // Process stage settings and status

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

    // Controls in

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

    // Sensors/limits

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
	id: pressure_max
	property double value
	property bool synced

	HalPin {
            id: pressure_max_pin
            name: "pressure-max"
            type: HalPin.Float
            direction: HalPin.In
	}

	Binding {
	    target: pressure_max;
	    property: "value";
	    value: pressure_max_pin.value;
	}

	Binding {
	    target: pressure_max;
	    property: "synced";
	    value: pressure_max_pin.synced;
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
	id: temp_pot_max
	property double value
	property bool synced

	HalPin {
            id: temp_pot_max_pin
            name: "temp-pot-max"
            type: HalPin.Float
            direction: HalPin.In
	}

	Binding {
	    target: temp_pot_max;
	    property: "value";
	    value: temp_pot_max_pin.value;
	}

	Binding {
	    target: temp_pot_max;
	    property: "synced";
	    value: temp_pot_max_pin.synced;
	}
    }

    Item {
	id: temp_burner
	property double value
	property bool synced

	HalPin {
            id: temp_burner_pin
            name: "temp-burner"
            type: HalPin.Float
            direction: HalPin.In
	}

	Binding {
	    target: temp_burner;
	    property: "value";
	    value: temp_burner_pin.value;
	}

	Binding {
	    target: temp_burner;
	    property: "synced";
	    value: temp_burner_pin.synced;
	}
    }

    Item {
	id: temp_burner_max
	property double value
	property bool synced

	HalPin {
            id: temp_burner_max_pin
            name: "temp-burner-max"
            type: HalPin.Float
            direction: HalPin.In
	}

	Binding {
	    target: temp_burner_max;
	    property: "value";
	    value: temp_burner_max_pin.value;
	}

	Binding {
	    target: temp_burner_max;
	    property: "synced";
	    value: temp_burner_max_pin.synced;
	}
    }

    // Other status

    Item {
	id: time_elapsed
	property int value
	property bool synced

	HalPin {
            id: time_elapsed_pin
            name: "time-elapsed"
            type: HalPin.S32
            direction: HalPin.In
	}

	Binding {
	    target: time_elapsed;
	    property: "value";
	    value: time_elapsed_pin.value;
	}

	Binding {
	    target: time_elapsed;
	    property: "synced";
	    value: time_elapsed_pin.synced;
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
}
