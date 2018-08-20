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
    color: "whitesmoke"

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

        // NAVIGATION BAR
        Components.NavigationBar {
            id: navigationBar

            anchors.top: contents.top
            anchors.left: contents.left
            anchors.right: contents.right

            //currentPageCode: simulationGeneratorPage.pageCodeName
            //currentPageTitle: simulationGeneratorPage.pageName
        }

        Rectangle {
            // MainPage Container, this is the placeholder for each page of controls and settings
            anchors.top: navigationBar.bottom
            anchors.left: contents.left
            anchors.right: contents.right
            anchors.bottom: contents.bottoms

            color: "red"

            /*Components.SimulationGenerationPage {
                id: simulationGeneratorPage

                anchors.fill: parent

                property string pageName: "Simulation Generator"
                property string pageCodeName: "simulationGenerator"
            }*/

            /*Rectangle {
                id: simulationGeneratorPage

                anchors.fill: parent

                color: "red"

                property string pageName: "Simulation Generator"
                property string pageCodeName: "simulationGenerator"


                Rectangle {
                    id: paneList

                    color: "#ff00ff"


                    width: 200
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                }
            }*/
        }
    }
}
