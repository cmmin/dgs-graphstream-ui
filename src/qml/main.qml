import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import "./components" as Components

ApplicationWindow {
    id: root
    visible: true
    width: Screen.width * 0.75
    height: Screen.height * 0.60

    title: qsTr("DGS GraphStream")
    color: "white"

    flags: Qt.Window | Qt.WindowFullscreenButtonHint |
            Qt.WindowTitleHint | Qt.WindowSystemMenuHint | Qt.WindowMinMaxButtonsHint |
            Qt.WindowCloseButtonHint

    Component.onCompleted: {
        // center the GUI window onto the screen
        root.setX(Screen.width / 2.0 - root.width / 2.0)
        root.setY(Screen.height / 2.0 - root.height / 2.0)
    }

    Item {
        id: contents
        anchors.fill: parent

        Components.NavigationBar {
            id: navigationBar

            anchors.left: contents.left
            anchors.top: contents.top
            anchors.right: contents.right
        }

        Components.SimulationGenerationPage {
            id: simulationPage

            anchors.left: contents.left
            anchors.top: navigationBar.bottom
            anchors.right: contents.right
            anchors.bottom: contents.bottom
        }
    }
}
