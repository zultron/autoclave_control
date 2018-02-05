import QtQuick 2.0
import Machinekit.HalRemote 1.0

// This is a catch-all for pins that aren't used elsewhere

Item {
    id: pins
    
    // Process stage settings and status
    // (others taken care of in TimeStage and TempStage objects)
    property alias stage: stage.value
    // Controls in
    property alias temp_set: temp_set.value
    // Sensors/limits
    property alias pressure_max: pressure_max.value
    property alias temp_pot_max: temp_pot_max.value
    property alias temp_burner: temp_burner.value
    property alias temp_burner_max: temp_burner_max.value
    // Other status
    property alias error: error.value
    property alias estop: estop.value

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

    // Sensors/limits

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
