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
            paneList.addPane("Community Node Coloring", "clustering")
            paneList.addPane("Layout & Coloring", "layout")
            paneList.addPane("Image Rendering", "image")
            paneList.addPane("Output", "output")
            paneList.addPane("Run", "run")

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

    SimulationPanes.ClusteringPane {
        id: clusteringPane

        anchors.top: root.top
        anchors.left: paneList.right
        anchors.right: root.right
        anchors.bottom: root.bottom

        visible: paneList.currentPaneCode === "clustering"
    }




    SimulationPanes.LayoutPane {
        id: layoutPane

        anchors.top: root.top
        anchors.left: paneList.right
        anchors.right: root.right
        anchors.bottom: root.bottom

        visible: paneList.currentPaneCode === "layout"
    }

    SimulationPanes.ImagePane {
        id: imagePane

        anchors.top: root.top
        anchors.left: paneList.right
        anchors.right: root.right
        anchors.bottom: root.bottom

        visible: paneList.currentPaneCode === "image"
    }

    SimulationPanes.OutputPane {
        id: outputPane

        anchors.top: root.top
        anchors.left: paneList.right
        anchors.right: root.right
        anchors.bottom: root.bottom

        visible: paneList.currentPaneCode === "output"
    }

    SimulationPanes.RunPane {
        id: runPane

        anchors.top: root.top
        anchors.left: paneList.right
        anchors.right: root.right
        anchors.bottom: root.bottom

        visible: paneList.currentPaneCode === "run"
    }

}
