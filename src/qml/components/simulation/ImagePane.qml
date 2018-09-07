import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import "./../basic/" as BasicComponents

Item {
    id: root

    property string scheme: ""

    Connections {
        target: simulationParams
        onNotifySchemeChanged: {
            root.scheme = scheme
        }
    }

    Text {
        id: paneTitle
        // Title
        text: "Image Settings"
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
        text: "Settings for the images that are generated for the PDF or Video outputs."
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
        id: paneImage

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
                        text: "Image Properties"
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

                    // width = textfield
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Width"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Textfield {
                            id: txtWidth
                            Layout.preferredWidth: 100
                            property bool isValid: true

                            text: "1280"

                            color: txtWidth.isValid ? "black" : "#E24670"

                            onTextChanged: {
                                simulationParams.slotSetImageWidth(txtWidth.text)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyImageWidthChanged: {
                                    txtWidth.isValid = isValid
                                    if(txtWidth.text !== width) {
                                        txtWidth.text = width
                                    }
                                }
                            }
                        }

                        Text {
                            text: "pixels"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }
                    }

                    // height = textfield
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Height"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Textfield {
                            id: txtHeight
                            Layout.preferredWidth: 100
                            property bool isValid: true

                            text: "780"

                            color: txtHeight.isValid ? "black" : "#E24670"

                            onTextChanged: {
                                simulationParams.slotSetImageHeight(txtHeight.text)
                            }


                            Connections {
                                target: simulationParams
                                onNotifyImageHeightChanged: {
                                    txtHeight.isValid = isValid
                                    if(txtHeight.text !== height) {
                                        txtHeight.text = height
                                    }
                                }
                            }
                        }

                        Text {
                            text: "pixels"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }
                    }

                    // border size = textfield
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Border Size"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Slider {
                            id: sldrBorderSize
                            from: 1
                            to: 5
                            value: 1
                            stepSize: 1

                            Layout.preferredWidth: 100

                            onValueChanged: {
                                simulationParams.slotSetImageBorderSize(sldrBorderSize.value)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyImageBorderSizeChanged: {
                                    if(sldrBorderSize.value !== borderSize) {
                                        sldrBorderSize.value = borderSize
                                    }
                                }
                            }
                        }

                        Text {
                            id: txtBorderSize
                            text: ""
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            Connections {
                                target: simulationParams
                                onNotifyImageBorderSizeChanged: {
                                    txtBorderSize.text = String(borderSize)
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


    Item {
        id: paneGraphProperties

        anchors.left: root.left
        anchors.right: root.right

        anchors.top: paneImage.bottom

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
                        id: txtGraphImg
                        text: "Graph Image Properties"
                        font.family: "Ubuntu"
                        font.pixelSize: 14
                        Layout.leftMargin: 10
                        Layout.topMargin: 10
                    }

                    Rectangle {
                        //Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        Layout.preferredWidth: txtGraphImg.paintedWidth * 2
                        Layout.leftMargin: 10
                        //Layout.rightMargin: 100
                        color: "#BFBFBF"
                    }

                    Item {Layout.preferredHeight: 5}

                    // node side mode = combo
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Node Size Mode"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Combo {
                            id: cmbxNodeSizeMode
                            model: ["fixed", "highlight-new", "centrality"]

                            property string mode: 'fixed'

                            Layout.preferredWidth: 150
                            Layout.leftMargin: 15

                            onActivated: {
                                if(index === 0) {
                                    // communities
                                    simulationParams.slotSetImageNodeSizeMode('fixed')
                                    cmbxNodeSizeMode.mode = 'fixed'
                                }
                                if(index === 1) {
                                    // cut-edges
                                    simulationParams.slotSetImageNodeSizeMode('highlight-new')
                                    cmbxNodeSizeMode.mode = 'highlight-new'
                                }
                                if(index === 2) {
                                    // cut-edges
                                    simulationParams.slotSetImageNodeSizeMode('centrality')
                                    cmbxNodeSizeMode.mode = 'centrality'
                                }
                            }
                            Connections {
                                target: simulationParams
                                onNotifyImageNodeSizeModeChanged: {
                                    if(nodeSizeMode === 'fixed') {
                                        cmbxNodeSizeMode.currentIndex = 0
                                        cmbxNodeSizeMode.mode = 'fixed'
                                    }
                                    else if(nodeSizeMode === 'centrality') {
                                        cmbxNodeSizeMode.currentIndex = 2
                                        cmbxNodeSizeMode.mode = 'centrality'
                                    }
                                    else {
                                        cmbxNodeSizeMode.currentIndex = 1
                                        cmbxNodeSizeMode.mode = 'highlight-new'
                                    }
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // node size = slider
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Node Size"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: cmbxNodeSizeMode.mode  === 'fixed' ? "black" : "#858585"
                        }

                        BasicComponents.Slider {
                            id: sldrNodeSize
                            from: 1
                            to: 100
                            value: 20
                            stepSize: 1

                            enabled: (cmbxNodeSizeMode.mode === 'fixed')

                            Layout.preferredWidth: 100

                            onValueChanged: {
                                simulationParams.slotSetImageNodeSize(sldrNodeSize.value)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyImageNodeSizeChanged: {
                                    if(sldrNodeSize.value !== nodeSize) {
                                        sldrNodeSize.value = nodeSize
                                    }
                                }
                            }
                        }

                        Text {
                            id: txtNodeSize
                            text: ""
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: cmbxNodeSizeMode.mode === 'fixed' ? "black" : "#858585"

                            Connections {
                                target: simulationParams
                                onNotifyImageNodeSizeChanged: {
                                    txtNodeSize.text = String(nodeSize)
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // edge size = slider
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Edge Size"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: cmbxNodeSizeMode.mode  === 'fixed' ? "black" : "#858585"
                        }

                        BasicComponents.Slider {
                            id: sldrEdgeSize
                            from: 1
                            to: 10
                            value: 1
                            stepSize: 1

                            enabled: (cmbxNodeSizeMode.mode === 'fixed')

                            Layout.preferredWidth: 100

                            onValueChanged: {
                                simulationParams.slotSetImageEdgeSize(sldrEdgeSize.value)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyImageEdgeSizeChanged: {
                                    if(sldrEdgeSize.value !== edgeSize) {
                                        sldrEdgeSize.value = edgeSize
                                    }
                                }
                            }                        }

                        Text {
                            id: txtEdgeSize
                            text: ""
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: cmbxNodeSizeMode.mode === 'fixed' ? "black" : "#858585"

                            Connections {
                                target: simulationParams
                                onNotifyImageEdgeSizeChanged: {
                                    txtEdgeSize.text = String(edgeSize)
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // min node size = slider
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Minimum Node Size"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: cmbxNodeSizeMode.mode  !== 'fixed' ? "black" : "#858585"
                        }

                        BasicComponents.Slider {
                            id: sldrMinNodeSize
                            from: 1
                            to: 59
                            value: 20
                            stepSize: 1

                            enabled: (cmbxNodeSizeMode.mode !== 'fixed')

                            Layout.preferredWidth: 100

                            onValueChanged: {
                                simulationParams.slotSetImageMinNodeSize(sldrMinNodeSize.value)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyImageMinNodeSizeChanged: {
                                    if(sldrMinNodeSize.value !== minNodeSize) {
                                        sldrMinNodeSize.value = minNodeSize
                                    }
                                }
                            }

                        }

                        Text {
                            id: txtMinNodeSize
                            text: ""
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: cmbxNodeSizeMode.mode !== 'fixed' ? "black" : "#858585"

                            Connections {
                                target: simulationParams
                                onNotifyImageMinNodeSizeChanged: {
                                    txtMinNodeSize.text = String(minNodeSize)
                                }
                                onNotifyImageMaxNodeSizeChanged: {
                                    // when min node is increased
                                    sldrMinNodeSize.to = maxNodeSize - 1
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }
                    // max node size = slider
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Minimum Node Size"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: cmbxNodeSizeMode.mode  !== 'fixed' ? "black" : "#858585"
                        }

                        BasicComponents.Slider {
                            id: sldrMaxNodeSize
                            from: 21
                            to: 100
                            value: 60
                            stepSize: 1

                            enabled: (cmbxNodeSizeMode.mode !== 'fixed')

                            Layout.preferredWidth: 100

                            onValueChanged: {
                                simulationParams.slotSetImageMaxNodeSize(sldrMaxNodeSize.value)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyImageMaxNodeSizeChanged: {
                                    if(sldrMaxNodeSize.value !== maxNodeSize) {
                                        sldrMaxNodeSize.value = maxNodeSize
                                    }
                                }
                            }


                        }

                        Text {
                            id: txtMaxNodeSize
                            text: ""
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: cmbxNodeSizeMode.mode !== 'fixed' ? "black" : "#858585"

                            Connections {
                                target: simulationParams
                                onNotifyImageMaxNodeSizeChanged: {
                                    txtMaxNodeSize.text = String(maxNodeSize)
                                }
                                onNotifyImageMinNodeSizeChanged: {
                                    // when min node is increased
                                    sldrMaxNodeSize.from = minNodeSize + 1
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // label type = combo
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Label Node Type"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Combo {
                            id: cmbxLblNodeType
                            model: ["id", "order"]

                            property string mode: 'id'

                            Layout.preferredWidth: 150
                            Layout.leftMargin: 15

                            onActivated: {
                                if(index === 0) {
                                    // communities
                                    simulationParams.slotSetImageLabelType('id')
                                    cmbxLblNodeType.mode = 'id'
                                }
                                if(index === 1) {
                                    // cut-edges
                                    simulationParams.slotSetImageLabelType('order')
                                    cmbxLblNodeType.mode = 'order'
                                }
                            }

                            Connections {
                                target: simulationParams
                                onNotifyImageLabelTypeChanged: {
                                    if(labelType === 'id') {
                                        cmbxLblNodeType.mode = 'id'
                                        cmbxLblNodeType.currentIndex = 0
                                    }
                                    else {
                                        cmbxLblNodeType.mode = 'order'
                                        cmbxLblNodeType.currentIndex = 1
                                    }
                                }
                            }

                        }

                        Item {Layout.fillWidth: true}
                    }

                    // label size = slider
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Label Size"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Slider {
                            id: sldrLabelSize
                            from: 4
                            to: 30
                            value: 10
                            stepSize: 1

                            Layout.preferredWidth: 100

                            onValueChanged: {
                                simulationParams.slotSetImageLabelSize(sldrLabelSize.value)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyImageLabelSizeChanged: {
                                    if(sldrLabelSize.value !== labelSize) {
                                        sldrLabelSize.value = labelSize
                                    }
                                }
                            }
                        }

                        Text {
                            id: txtLabelSize
                            text: ""
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            Connections {
                                target: simulationParams
                                onNotifyImageLabelSizeChanged: {
                                    txtLabelSize.text = String(labelSize)
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // cut edge node size = slider
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Cut Edge Node Size"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                            color: root.scheme === 'cut-edges' ? "black" : "#858585"
                        }

                        BasicComponents.Slider {
                            id: sldrCutEdgeNodeSize
                            from: 0
                            to: 100
                            value: 10
                            stepSize: 1

                            Layout.preferredWidth: 100

                            enabled: root.scheme === 'cut-edges'

                            onValueChanged: {
                                simulationParams.slotSetImageCutEdgeNodeSize(sldrCutEdgeNodeSize.value)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyImageCutEdgeNodeSizeChanged: {
                                    if(sldrCutEdgeNodeSize.value !== cutEdgeNodeSize) {
                                        sldrCutEdgeNodeSize.value = cutEdgeNodeSize
                                    }
                                }
                            }

                        }

                        Text {
                            id: txtCutEdgeNodeSize
                            text: ""
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: root.scheme === 'cut-edges' ? "black" : "#858585"

                            Connections {
                                target: simulationParams
                                onNotifyImageCutEdgeNodeSizeChanged: {
                                    txtCutEdgeNodeSize.text = String(cutEdgeNodeSize)
                                }
                            }
                        }

                        Text {

                            visible: root.scheme !== 'cut-edges'
                            color: root.scheme === 'cut-edges' ? "black" : "#858585"

                            text: "<i>only for cut-edges scheme</i>"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        Item {Layout.fillWidth: true}
                    }


                    // cut edge length = slider
                    RowLayout {
                        Layout.fillWidth: true


                        Text {
                            text: "Cut Edge Percentage of Length"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                            color: root.scheme === 'cut-edges' ? "black" : "#858585"
                        }

                        BasicComponents.Slider {
                            id: sldrCutEdgeLength
                            from: 0
                            to: 100
                            value: 50
                            stepSize: 1

                            Layout.preferredWidth: 100

                            enabled: root.scheme === 'cut-edges'

                            onValueChanged: {
                                simulationParams.slotSetImageCutEdgeLength(sldrCutEdgeLength.value)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyImageCutEdgeLengthChanged: {
                                    if(sldrCutEdgeLength.value !== cutEdgeLength) {
                                        sldrCutEdgeLength.value = cutEdgeLength
                                    }
                                }
                            }
                        }

                        Text {
                            id: txtCutEdgeLength
                            text: ""
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: root.scheme === 'cut-edges' ? "black" : "#858585"

                            Connections {
                                target: simulationParams
                                onNotifyImageCutEdgeLengthChanged: {
                                    txtCutEdgeLength.text = String(cutEdgeLength) + "%"
                                }
                            }
                        }

                        Text {

                            visible: root.scheme !== 'cut-edges'
                            color: root.scheme === 'cut-edges' ? "black" : "#858585"

                            text: "<i>only for cut-edges scheme</i>"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        Item {Layout.fillWidth: true}
                    }

                    Item {Layout.preferredHeight: 10}
                }
            }
        }
    } // END PANE
}
