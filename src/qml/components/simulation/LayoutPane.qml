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
        text: "Layout & Coloring Settings"
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


    // Layout SELECTION

    Item {
        id: paneLayout

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
                            text: "Force (linlog only)"
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

                    // attraction
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Attraction Factor  "
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Slider {
                            id: sldrAttraction

                            from: 0.0
                            to: 0.1
                            value: 0.012
                            stepSize: 0.001

                            Layout.preferredWidth: 200

                            onValueChanged: {
                                simulationParams.slotSetLayoutAttraction(sldrAttraction.value)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetLayoutAttraction(sldrAttraction.value)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyGraphLayoutChanged: {
                                    if (graphLayout === 'springbox') {
                                        sldrAttraction.value = 0.012
                                    }
                                    else {
                                        sldrAttraction.value = 0.0
                                    }
                                }
                            }
                        }

                        Text {
                            id: txtAttraction
                            text: ""
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            Connections {
                                target: simulationParams
                                onNotifyLayoutAttractionChanged: {
                                    txtAttraction.text = String(attraction)
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // repulsion
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Repulsion Factor  "
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Slider {
                            id: sldrRepulsion

                            from: 0.0
                            to: 0.3
                            value: 0.024
                            stepSize: 0.001

                            Layout.preferredWidth: 200

                            onValueChanged: {
                                simulationParams.slotSetLayoutRepulsion(sldrRepulsion.value)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetLayoutRepulsion(sldrRepulsion.value)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyGraphLayoutChanged: {
                                    if (graphLayout === 'springbox') {
                                        sldrRepulsion.value = 0.024
                                        sldrRepulsion.from = 0.0
                                        sldrRepulsion.to = 0.3
                                        sldrRepulsion.stepSize = 0.001
                                    }
                                    else {
                                        sldrRepulsion.from = -5.0
                                        sldrRepulsion.to = 5.0
                                        sldrRepulsion.stepSize = 0.1
                                        sldrRepulsion.value = -1.2
                                    }
                                }
                            }
                        }

                        Text {
                            id: txtRepulsion
                            text: ""
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            Connections {
                                target: simulationParams
                                onNotifyLayoutRepulsionChanged: {
                                    txtRepulsion.text = String(repulsion)
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            id: txtLayoutRandomSeed
                            property int seedValue
                            text: "Layout Random Seed: <b>" + String(txtLayoutRandomSeed.seedValue) + "</b>"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            Connections {
                                target: simulationParams
                                onNotifyLayoutRandomSeedChanged: {
                                    txtLayoutRandomSeed.seedValue = randomSeed
                                }
                            }

                            Component.onCompleted: {
                                btnGenerateLayoutSeed.generateNewSeed()
                            }

                        }

                        Item {Layout.preferredWidth: 5}

                        BasicComponents.Button {
                            id: btnGenerateLayoutSeed

                            function generateNewSeed() {
                                simulationParams.slotGenerateNewLayoutRandomSeed()
                            }

                            text: "Generate Seed"
                            onClicked: {
                                btnGenerateLayoutSeed.generateNewSeed()
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    Item {Layout.preferredHeight: 10}
                }
            }
        }
    } // END PANE

    // Coloring Options
    Item {
        id: paneColoring

        anchors.left: root.left
        anchors.right: root.right

        anchors.top: paneLayout.bottom

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
                        id: txtColoring
                        text: "Coloring Options"
                        font.family: "Ubuntu"
                        font.pixelSize: 14
                        Layout.leftMargin: 10
                        Layout.topMargin: 10
                    }

                    Rectangle {
                        //Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        Layout.preferredWidth: txtColoring.paintedWidth * 2
                        Layout.leftMargin: 10
                        //Layout.rightMargin: 100
                        color: "#BFBFBF"
                    }

                    Item {Layout.preferredHeight: 5}

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Coloring Scheme"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Combo {

                            model: ["pastel", "primary-colors"]

                            Layout.preferredWidth: 200
                            Layout.leftMargin: 15

                            onActivated: {
                                if(index === 0) {
                                    // communities
                                    simulationParams.slotSetColorScheme('pastel')
                                }
                                if(index === 1) {
                                    // edges-cut
                                    simulationParams.slotSetColorScheme('primary-colors')
                                }
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetColorScheme('pastel')
                            }
                        }

                        Item {Layout.fillWidth: true}

                    }


                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Node Color"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Textfield {
                            id: txtNodeColor
                            Layout.preferredWidth: 100

                            property bool colorValid: true

                            color: txtNodeColor.colorValid ? txtNodeColor.text : "#E24670"

                            text: ""

                            onTextChanged: {
                                simulationParams.slotSetNodeColor(txtNodeColor.text)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetNodeColor(txtNodeColor.text)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyNodeColorChanged: {
                                    txtNodeColor.colorValid = colorValid
                                }
                            }
                        }

                        Rectangle {
                            Layout.preferredHeight: txtNodeColor.height
                            Layout.preferredWidth: txtNodeColor.height

                            color: txtNodeColor.colorValid ? txtNodeColor.text : "transparent"
                        }

                        Item {Layout.fillWidth: true}

                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            id: txtColoringSeed
                            property int seedValue
                            text: "Coloring Random Seed: <b>" + String(txtColoringSeed.seedValue) + "</b>"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            Connections {
                                target: simulationParams
                                onNotifyColoringRandomSeedChanged: {
                                    txtColoringSeed.seedValue = randomSeed
                                }
                            }

                            Component.onCompleted: {
                                btnGenerateColorSeed.generateNewSeed()
                            }

                        }

                        Item {Layout.preferredWidth: 5}

                        BasicComponents.Button {
                            id: btnGenerateColorSeed

                            function generateNewSeed() {
                                simulationParams.slotGenerateNewColorRandomSeed()
                            }

                            text: "Generate Seed"
                            onClicked: {
                                btnGenerateColorSeed.generateNewSeed()
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
