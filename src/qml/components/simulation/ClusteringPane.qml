import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import "./../basic/" as BasicComponents

Item {
    id: root

    property string scheme: ""
    property string clustering: ""

    Connections {
        target: simulationParams
        onNotifySchemeChanged: {
            root.scheme = scheme
        }
        onNotifyClusteringChanged: {
            root.clustering = clustering
        }
    }

    Text {
        id: paneTitle
        // Title
        text: "Community Node Coloring"
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
        text: "Settings about the way nodes should be colored and grouped together."
        font.family: "Open Sans"
        font.pixelSize: 14

        anchors.left: root.left
        anchors.top: paneTitle.bottom
        anchors.right: root.right

        anchors.leftMargin: 10
        anchors.topMargin: 10

        wrapMode: Text.WordWrap
    }

    Item {
        id: paneClustering

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
                        id: txtClustering
                        text: "Color Clustering Properties"
                        font.family: "Ubuntu"
                        font.pixelSize: 14
                        Layout.leftMargin: 10
                        Layout.topMargin: 10
                    }

                    Rectangle {
                        //Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        Layout.preferredWidth: txtClustering.paintedWidth * 2
                        Layout.leftMargin: 10
                        //Layout.rightMargin: 100
                        color: "#BFBFBF"
                    }

                    Item {Layout.preferredHeight: 5}

                    // clustering scheme
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Color Clustering Program"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: {
                                if(root.scheme === 'cut-edges') {
                                    return "#858585"
                                }
                                else {
                                    return "black"
                                }
                            }
                        }

                        BasicComponents.Combo {
                            id: cmbxClustering
                            model: ["oslom2 + infomap", "infomap only", "graphviz"]

                            Layout.preferredWidth: 250
                            Layout.leftMargin: 15

                            enabled: {
                                if(root.scheme === 'cut-edges') {
                                    return false
                                }
                                else {
                                    return true
                                }
                            }


                            onActivated: {
                                if(index === 0) {
                                    // communities
                                    simulationParams.slotSetClusteringMode('oslom2')
                                }
                                if(index === 1) {
                                    // cut-edges
                                    simulationParams.slotSetClusteringMode('infomap')
                                }
                                if(index === 2) {
                                    // random
                                    simulationParams.slotSetClusteringMode('graphviz')
                                }
                            }

                            Connections {
                                target: simulationParams
                                onNotifyClusteringChanged: {
                                    if(clustering === 'oslom2') {
                                        cmbxClustering.currentIndex = 0
                                    }
                                    else if(clustering === 'infomap') {
                                        cmbxClustering.currentIndex = 1
                                    }
                                    else {
                                        cmbxClustering.currentIndex = 2
                                    }
                                }
                            }

                        }


                        Text {
                            text: "<i>Options only available with Communities Scheme</i>"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: "#858585"

                            visible: {
                                if(root.scheme === 'cut-edges') {
                                    return true
                                }
                                else {
                                    return false
                                }
                            }
                        }
                        Item {Layout.fillWidth: true}
                    }

                    // infomap calls
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Infomap Calls"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: {
                                if(root.scheme === 'communities' && root.clustering === 'oslom2') {
                                    return "black"
                                }
                                else {
                                    return "#858585"
                                }
                            }
                        }

                        Item {Layout.preferredWidth: 5}

                        BasicComponents.Slider {
                            id: sldrInfomapCalls
                            from: 0
                            to: 10
                            value: 0
                            stepSize: 1

                            Layout.preferredWidth: 200

                            enabled: {
                                if(root.scheme === 'communities' && root.clustering === 'oslom2') {
                                    return true
                                }
                                else {
                                    return false
                                }
                            }

                            onValueChanged: {
                                simulationParams.slotSetInfomapCalls(sldrInfomapCalls.value)
                            }
                            Connections {
                                target: simulationParams
                                onNotifyInfomapCallsChanged: {
                                    if(sldrInfomapCalls.value !== infomapCalls) {
                                        sldrInfomapCalls.value = infomapCalls
                                    }
                                }
                            }

                        }

                        Text {
                            id: txtInfomapCalls
                            text: ""
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: {
                                if(root.scheme === 'communities' && root.clustering === 'oslom2') {
                                    return "black"
                                }
                                else {
                                    return "#858585"
                                }
                            }

                            Connections {
                                target: simulationParams
                                onNotifyInfomapCallsChanged: {
                                    txtInfomapCalls.text = String(infomapCalls)
                                }
                            }
                        }

                        Text {
                            text: "<i>Available with oslom2 clustering only</i>"
                            wrapMode: Text.WordWrap
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: "#858585"

                            visible: {
                                if(root.scheme === 'communities' && root.clustering === 'oslom2') {
                                    return false
                                }
                                else {
                                    return true
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // clustering seed
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            property int seedValue: 0
                            text: "Clustering Random Seed"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: {
                                if(root.scheme === 'cut-edges' || root.clustering === 'graphviz') {
                                    return "#858585"
                                }
                                else {
                                    return "black"
                                }
                            }

                        }

                        BasicComponents.Textfield {
                            id: txtClusteringSeed
                            Layout.preferredWidth: 100
                            text: ""
                            color: txtClusteringSeed.valid === false ? "#E24670" : "black"

                            property bool disableUpdate: false
                            property bool valid: true

                            enabled: {
                                if(root.scheme === 'cut-edges' || root.clustering === 'graphviz') {
                                    return false
                                }
                                else {
                                    return true
                                }
                            }

                            onTextChanged: {
                                if (txtClusteringSeed.disableUpdate === false) {
                                    simulationParams.slotSetClusterSeed(txtClusteringSeed.text)
                                }
                            }

                            Connections {
                                target: simulationParams
                                onNotifyClusterSeedChanged: {
                                    txtClusteringSeed.text = randomSeed
                                    txtClusteringSeed.valid = isValid
                                }
                            }
                        }


                        Item {Layout.preferredWidth: 5}

                        BasicComponents.Button {
                            id: btnGenerateClusteringSeed

                            function generateNewSeed() {
                                simulationParams.slotGenerateClusterSeed()
                            }

                            enabled: {
                                if(root.scheme === 'cut-edges' || root.clustering === 'graphviz') {
                                    return false
                                }
                                else {
                                    return true
                                }
                            }


                            text: "Generate Seed"
                            onClicked: {
                                btnGenerateClusteringSeed.generateNewSeed()
                            }
                        }

                        Text {
                            text: "<i>Not available with graphviz clustering</i>"
                            wrapMode: Text.WordWrap
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: "#858585"

                            visible: {
                                if(root.scheme === 'cut-edges' || root.clustering === 'graphviz') {
                                    return true
                                }
                                else {
                                    return false
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
