import QtQuick 2.7
import QtQuick.Layouts 1.3

Rectangle {
    id: root
    color: "#F7F7F7"

    property string currentPaneCode: ""

    signal changePane(string paneCode)
    onChangePane: {
        root.currentPaneCode = paneCode
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        SimulationPageButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            paneCode: "simulation"
            paneTitle: "Simulation"
            currentPaneCode: root.currentPaneCode
            onClicked: {
                root.changePane(paneCode)
            }
        }

        SimulationPageButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            paneCode: "partition"
            paneTitle: "Partitioning"
            currentPaneCode: root.currentPaneCode
            onClicked: {
                root.changePane(paneCode)
            }
        }

        SimulationPageButtonIcon {
            id: advanced

            Layout.fillWidth: true
            Layout.preferredHeight: 40


            paneCode: "unchecked"
            paneTitle: "Advanced Options"
            currentPaneCode: "checked"

            //property bool checked: false

            colorChecked: "#E3E3E3"
            //colorUnchecked: "#E3E3E3"

            onClicked: {
                advanced.checked = !advanced.checked
                if(advanced.checked) {
                    advanced.paneCode = "checked"
                }
                else {
                    advanced.paneCode = "unchecked"
                }
            }
        }

        SimulationPageButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 40

            visible: advanced.checked

            colorUnchecked: "#E3E3E3"

            paneCode: "clustering"
            paneTitle: "Community Node Coloring"
            currentPaneCode: root.currentPaneCode
            onClicked: {
                root.changePane(paneCode)
            }
        }

        SimulationPageButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 40

            visible: advanced.checked

            colorUnchecked: "#E3E3E3"

            paneCode: "layout"
            paneTitle: "Layout & Coloring"
            currentPaneCode: root.currentPaneCode
            onClicked: {
                root.changePane(paneCode)
            }
        }

        SimulationPageButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 40

            visible: advanced.checked

            colorUnchecked: "#E3E3E3"


            paneCode: "image"
            paneTitle: "Image Size"
            currentPaneCode: root.currentPaneCode
            onClicked: {
                root.changePane(paneCode)
            }
        }

        SimulationPageButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 40

            visible: advanced.checked
            colorUnchecked: "#E3E3E3"

            paneCode: "output"
            paneTitle: "Output"
            currentPaneCode: root.currentPaneCode
            onClicked: {
                root.changePane(paneCode)
            }
        }

        SimulationPageButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            paneCode: "run"
            paneTitle: "Run"
            currentPaneCode: root.currentPaneCode
            onClicked: {
                root.changePane(paneCode)
            }
        }

        Item {Layout.fillHeight: true}
    }

    Rectangle {
        anchors.right: root.right
        anchors.top: root.top
        anchors.bottom: root.bottom
        width: 1
        color: "#BFBFBF"
    }

}
