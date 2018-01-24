import QtQuick 2.0
import QtQuick.Controls 1.1
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0
import Machinekit.Service 1.0

ApplicationWindow {
    id: applicationWindow

    visible: true
    width: 500
    height: 800
    title: connectionWindow.title

    ConnectionWindow {
        id: connectionWindow
        color: "#fdb3c0"

        anchors.fill: parent
        defaultTitle: "Goldibox"
        //autoSelectInstance: true
        autoSelectApplication: true
        mode: "local"
        applications: [
            ApplicationDescription {
                sourceDir: "qrc:/goldibox-remote/"
            }
        ]
        instanceFilter: ServiceDiscoveryFilter{ name: "" }
    }
}


