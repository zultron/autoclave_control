import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import Machinekit.HalRemote 1.0
import Machinekit.Service 1.0

Button {
    /* Time series chart

       Chart image downloaded from Goldibox; button opens browser
       window to more charts
     */
    id: base

    Service {
        id: launcherService
        type: "launcher"
    }

    property string baseURL: (
	"http://" + launcherService.hostAddress + "/goldibox/")

    enabled: launcherService.ready
    onClicked: Qt.openUrlExternally(baseURL)
    tooltip: "Open Goldibox charts in browser"

    style: ButtonStyle {
	background: Image {
	    // CGI variables
	    property int w: Math.round(width)
	    property int h: Math.round(height)
	    property int r // Random number so img source changes

	    // Don't cache images
	    cache: false

	    // Timer to periodically reload chart
	    Timer {
		interval: 60 * 1000
		repeat: true
		running: true
		triggeredOnStart: true
		onTriggered: {
		    r = Math.round(Math.random() * 1000000);
		    parent.source = (baseURL + "uichart.png.cgi?w=" +
				     w + "&h=" + h + "&r=" + r);
		}
	    }
	}
    }
}
