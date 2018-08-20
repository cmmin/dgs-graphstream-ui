import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import "./../basic/" as BasicComponents

Item {
    id: root

    property string graphLayout: ""

    Connections {
        target: simulationParams
        onNotifyGraphLayoutChanged: {
            root.graphLayout = graphLayout
        }
    }

    Text {
        id: paneTitle
        // Title
        text: "Layout Settings & Parameters"
        font.family: "Ubuntu"
        font.pixelSize: 18
        color: "#333"

        anchors.left: root.left
        anchors.top: root.top

        anchors.leftMargin: 10
        anchors.topMargin: 10
    }

    Text {
        id: paneDescription
        text: "The basic parameters for modifying the simulation layouting."
        font.family: "Open Sans"
        font.pixelSize: 14

        anchors.left: root.left
        anchors.top: paneTitle.bottom
        anchors.right: root.right

        anchors.leftMargin: 10
        anchors.topMargin: 10

        wrapMode: Text.WordWrap
    }


    // SCHEME SELECTION

    Item {
        id: paneScheme

        anchors.left: root.left
        anchors.right: root.right

        anchors.top: paneDescription.bottom

        height: childrenRect.height

        ColumnLayout {
            width: parent.width

            Rectangle {
                radius: 5
                color: "#F7F7F7"

                Layout.fillWidth: true
                Layout.margins: 10
                Layout.preferredHeight: childrenRect.height

                ColumnLayout {
                    width: parent.width

                    // contents go here
                    Text {
                        id: txtLayout
                        text: "Layout Properties"
                        font.family: "Ubuntu"
                        font.pixelSize: 14
                        Layout.leftMargin: 10
                        Layout.topMargin: 10
                    }

                    Rectangle {
                        //Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        Layout.preferredWidth: txtLayout.paintedWidth * 2
                        Layout.leftMargin: 10
                        //Layout.rightMargin: 100
                        color: "#BFBFBF"
                    }

                    Item {Layout.preferredHeight: 5}

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Graph Layouting Mode"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Combo {
                            model: ["springbox", "linlog"]

                            Layout.preferredWidth: 200
                            Layout.leftMargin: 15

                            onActivated: {
                                if(index === 0) {
                                    simulationParams.slotSetGraphLayout('springbox')
                                }
                                if(index === 1) {
                                    simulationParams.slotSetGraphLayout('linlog')
                                }
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetGraphLayout('springbox')
                            }
                        }
                        Item {Layout.fillWidth: true}
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "linlog Layout Force"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: root.graphLayout === "linlog" ? "black" : "#858585"
                        }

                        BasicComponents.Slider {
                            id: sliderLinlogForce
                            from: 0.0
                            to: 10.0
                            value: 3.0
                            stepSize: 0.1

                            Layout.preferredWidth: 200

                            enabled: (root.graphLayout === "linlog")

                            onValueChanged: {
                                simulationParams.slotSetLayoutLinlogForce(sliderLinlogForce.value)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetLayoutLinlogForce(sliderLinlogForce.value)
                            }
                        }

                        Text {
                            id: txtForce
                            text: ""
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: root.graphLayout === "linlog" ? "black" : "#858585"

                            Connections {
                                target: simulationParams
                                onNotifyLayoutLinlogForceChanged: {
                                    txtForce.text = String(linlogForce)
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }



                    Item {Layout.preferredHeight: 10}
                }
            }
        }
    } // END PANE
}
