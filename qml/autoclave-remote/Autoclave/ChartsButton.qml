import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import Machinekit.Service 1.0

Button {
    id: base
    property string imgSource: "assets/c3-charts.png"

    width: 100
    height: 100

    Service {
        id: launcherService
        type: "launcher"
    }

    property string baseURL: (
	"http://" + launcherService.hostAddress + "/autoclave/")

    enabled: launcherService.ready
    onClicked: Qt.openUrlExternally(baseURL)
    tooltip: "Open chart URL " + baseURL

    style: ButtonStyle {
	background: Image {
	    source: base.imgSource
	}
    }
}
