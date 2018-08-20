import QtQuick 2.7
import QtQuick.Layouts 1.3

import "./simulation/" as SimulationPanes

Item {
    id: root

    //color: "#F7F7F7"

    SimulationSettingsList {
        id: paneList

        z: 1

        width: 250
        anchors.top: root.top
        anchors.left: root.left
        anchors.bottom: root.bottom

        Component.onCompleted: {
            paneList.addPane("Simulation", "simulation")
            paneList.addPane("Partitioning", "partition")
            paneList.addPane("Layout", "layout")
            paneList.addPane("Output", "output")

            paneList.changePane("simulation")
        }
    }

    SimulationPanes.SimulationPane {
        id: simulationPane

        anchors.top: root.top
        anchors.left: paneList.right
        anchors.right: root.right
        anchors.bottom: root.bottom

        visible: paneList.currentPaneCode === "simulation"
    }

    SimulationPanes.PartitioningPane {
        id: partitionPane

        anchors.top: root.top
        anchors.left: paneList.right
        anchors.right: root.right
        anchors.bottom: root.bottom

        visible: paneList.currentPaneCode === "partition"
    }

    SimulationPanes.LayoutPane {
        id: layoutPane

        anchors.top: root.top
        anchors.left: paneList.right
        anchors.right: root.right
        anchors.bottom: root.bottom

        visible: paneList.currentPaneCode === "layout"
    }
}
