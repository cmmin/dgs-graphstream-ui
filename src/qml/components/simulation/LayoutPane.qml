import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

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

    Flickable {
        id: flk
        anchors.left: root.left
        anchors.right: root.right
        anchors.top: paneDescription.bottom
        anchors.bottom: root.bottom

        property bool scrollActive: true

        ScrollBar.vertical: ScrollBar {
            id: flkSB
            active: true
            onActiveChanged: {
                if(flkSB.active !== flk.scrollActive) {
                    flkSB.active = flk.scrollActive
                }
            }
         }

        clip: true
        contentWidth: flickableContent.width
        contentHeight: flickableContent.height

        Item {
            id: flickableContent
            width: root.width
            height: childrenRect.height

                Item {
                    id: paneLayout

                    anchors.left: parent.left
                    anchors.right: parent.right

                    anchors.top: parent.top

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
                                        id: cmbxGraphLayout
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

                                        Connections {
                                            target: simulationParams
                                            onNotifyGraphLayoutChanged: {
                                                if(graphLayout === 'springbox') {
                                                    cmbxGraphLayout.currentIndex = 0
                                                }
                                                else {
                                                    cmbxGraphLayout.currentIndex = 1
                                                }
                                            }
                                        }

                                    }

                                    BasicComponents.TooltipIcon {
                                        text: uiTexts.get('tooltipGraphLayoutMode')
                                        Layout.preferredWidth: 24
                                        Layout.preferredHeight: 24
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

                                        Connections {
                                            target: simulationParams
                                            onNotifyLayoutLinlogForceChanged: {
                                                if(linlogForce !== sliderLinlogForce.value) {
                                                    sliderLinlogForce.value = linlogForce
                                                }
                                            }
                                        }
                                    }

                                    Text {
                                        id: txtForce
                                        text: "3.0"
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

                                    BasicComponents.TooltipIcon {
                                        text: uiTexts.get('tooltipForce')
                                        Layout.preferredWidth: 24
                                        Layout.preferredHeight: 24
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
                                            onNotifyLayoutAttractionChanged: {
                                                if(attraction !== sldrAttraction.value) {
                                                    sldrAttraction.value = attraction
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


                                    BasicComponents.TooltipIcon {
                                        text: uiTexts.get('tooltipAttractionFactor')
                                        Layout.preferredWidth: 24
                                        Layout.preferredHeight: 24
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
                                            onNotifyLayoutRepulsionChanged: {
                                                if(repulsion !== sldrRepulsion.value) {
                                                    sldrRepulsion.value = repulsion
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

                                    BasicComponents.TooltipIcon {
                                        text: uiTexts.get('tooltipRepulsionFactor')
                                        Layout.preferredWidth: 24
                                        Layout.preferredHeight: 24
                                    }

                                    Item {Layout.fillWidth: true}
                                }

                                RowLayout {
                                    Layout.fillWidth: true


                                    Text {
                                        property int seedValue: 0
                                        text: "Layout Random Seed"
                                        font.family: "Open Sans"
                                        Layout.leftMargin: 15
                                    }

                                    BasicComponents.Textfield {
                                        id: txtLayoutSeed
                                        Layout.preferredWidth: 100
                                        text: ""
                                        color: txtLayoutSeed.valid === false ? "#E24670" : "black"

                                        property bool disableUpdate: false
                                        property bool valid: true

                                        onTextChanged: {
                                            if (txtLayoutSeed.disableUpdate === false) {
                                                simulationParams.slotSetLayoutSeed(txtLayoutSeed.text)
                                            }
                                        }

                                        Connections {
                                            target: simulationParams
                                            onNotifyLayoutRandomSeedChanged: {
                                                txtLayoutSeed.text = randomSeed
                                                txtLayoutSeed.valid = isValid
                                            }
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

                    anchors.left: parent.left
                    anchors.right: parent.right

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
                                        id: cmbxColorScheme
                                        model: ["pastel colors", "primary colors", "single color"]

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
                                            if(index === 2) {
                                                // edges-cut
                                                simulationParams.slotSetColorScheme('node-color')
                                            }
                                        }
                                        Connections {
                                            target: simulationParams
                                            onNotifyColorSchemeChanged: {
                                                if(colorScheme === 'pastel') {
                                                    cmbxColorScheme.currentIndex = 0
                                                }
                                                else if(colorScheme === 'node-color') {
                                                    cmbxColorScheme.currentIndex = 2
                                                }
                                                else {
                                                    cmbxColorScheme.currentIndex = 1
                                                }
                                            }
                                        }
                                    }

                                    BasicComponents.TooltipIcon {
                                        text: uiTexts.get('tooltipColorScheme')
                                        Layout.preferredWidth: 24
                                        Layout.preferredHeight: 24
                                    }

                                    Item {Layout.fillWidth: true}
                                }


                                RowLayout {
                                    Layout.fillWidth: true

                                    Text {
                                        text: "Single Node Color"
                                        font.family: "Open Sans"
                                        Layout.leftMargin: 15
                                        color: cmbxColorScheme.currentIndex === 2 ? "black" : "#858585"

                                    }

                                    BasicComponents.Textfield {
                                        id: txtNodeColor
                                        Layout.preferredWidth: 100

                                        property bool colorValid: true

                                        color: txtNodeColor.colorValid ? (txtNodeColor.enabled ? "black" : "#858585") : "#E24670"

                                        text: ""

                                        enabled: cmbxColorScheme.currentIndex === 2

                                        onTextChanged: {
                                            simulationParams.slotSetNodeColor(txtNodeColor.text)
                                        }

                                        Connections {
                                            target: simulationParams
                                            onNotifyNodeColorChanged: {
                                                txtNodeColor.colorValid = colorValid
                                                if(txtNodeColor.text !== nodeColor) {
                                                    txtNodeColor.text = nodeColor
                                                }
                                            }
                                        }
                                    }

                                    BasicComponents.Button {
                                        text: "Pick Color"
                                        onClicked: {
                                            singleNodeColorPicker.visible = true
                                        }
                                        enabled: cmbxColorScheme.currentIndex === 2
                                    }

                                    BasicComponents.Colorpicker {
                                        id: singleNodeColorPicker
                                        onColorChosen: {
                                            txtNodeColor.text = color
                                        }
                                    }

                                    Rectangle {
                                        Layout.preferredHeight: txtNodeColor.height
                                        Layout.preferredWidth: txtNodeColor.height

                                        border.width: 1
                                        border.color: "#858585"

                                        color: txtNodeColor.colorValid ? txtNodeColor.text : "transparent"
                                    }

                                    BasicComponents.TooltipIcon {
                                        text: uiTexts.get('tooltipNodeColor')
                                        Layout.preferredWidth: 24
                                        Layout.preferredHeight: 24
                                    }

                                    Item {Layout.fillWidth: true}

                                }

                                RowLayout {
                                    Layout.fillWidth: true

                                    Text {
                                        property int seedValue: 0
                                        text: "Coloring Random Seed"
                                        font.family: "Open Sans"
                                        Layout.leftMargin: 15
                                    }

                                    BasicComponents.Textfield {
                                        id: txtColoringSeed
                                        Layout.preferredWidth: 100
                                        text: ""
                                        color: txtColoringSeed.valid === false ? "#E24670" : "black"

                                        property bool disableUpdate: false
                                        property bool valid: true

                                        onTextChanged: {
                                            if (txtColoringSeed.disableUpdate === false) {
                                                simulationParams.slotSetColoringSeed(txtColoringSeed.text)
                                            }
                                        }

                                        Connections {
                                            target: simulationParams
                                            onNotifyColoringRandomSeedChanged: {
                                                txtColoringSeed.text = randomSeed
                                                txtColoringSeed.valid = isValid
                                            }
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

                Item {
                    id: paneGraphProperties

                    anchors.left: parent.left
                    anchors.right: parent.right

                    anchors.top: paneColoring.bottom

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
                                        model: ["highlight-new", "centrality", "fixed"]

                                        property string mode: 'fixed'

                                        Layout.preferredWidth: 150
                                        Layout.leftMargin: 15

                                        onActivated: {
                                            if(index === 2) {
                                                // communities
                                                simulationParams.slotSetImageNodeSizeMode('fixed')
                                                cmbxNodeSizeMode.mode = 'fixed'
                                            }
                                            if(index === 0) {
                                                // cut-edges
                                                simulationParams.slotSetImageNodeSizeMode('highlight-new')
                                                cmbxNodeSizeMode.mode = 'highlight-new'
                                            }
                                            if(index === 1) {
                                                // cut-edges
                                                simulationParams.slotSetImageNodeSizeMode('centrality')
                                                cmbxNodeSizeMode.mode = 'centrality'
                                            }
                                        }
                                        Connections {
                                            target: simulationParams
                                            onNotifyImageNodeSizeModeChanged: {
                                                if(nodeSizeMode === 'fixed') {
                                                    cmbxNodeSizeMode.currentIndex = 2
                                                    cmbxNodeSizeMode.mode = 'fixed'
                                                }
                                                else if(nodeSizeMode === 'centrality') {
                                                    cmbxNodeSizeMode.currentIndex = 1
                                                    cmbxNodeSizeMode.mode = 'centrality'
                                                }
                                                else {
                                                    cmbxNodeSizeMode.currentIndex = 0
                                                    cmbxNodeSizeMode.mode = 'highlight-new'
                                                }
                                            }
                                        }
                                    }

                                    BasicComponents.TooltipIcon {
                                        text: uiTexts.get('tooltipNodeSizeMode')
                                        Layout.preferredWidth: 24
                                        Layout.preferredHeight: 24
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
                                        text: "20 pixels"
                                        font.family: "Open Sans"
                                        Layout.leftMargin: 15

                                        color: cmbxNodeSizeMode.mode === 'fixed' ? "black" : "#858585"

                                        Connections {
                                            target: simulationParams
                                            onNotifyImageNodeSizeChanged: {
                                                txtNodeSize.text = String(nodeSize) + (nodeSize == 1 ? " pixel" : " pixels")
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
                                        color: 'black'
                                        //color: cmbxNodeSizeMode.mode  === 'fixed' ? "black" : "#858585"
                                    }

                                    BasicComponents.Slider {
                                        id: sldrEdgeSize
                                        from: 1
                                        to: 10
                                        value: 1
                                        stepSize: 1

                                        //enabled: (cmbxNodeSizeMode.mode === 'fixed')

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
                                        text: "1 pixel"
                                        font.family: "Open Sans"
                                        Layout.leftMargin: 15

                                        color: "black"
                                        //color: cmbxNodeSizeMode.mode === 'fixed' ? "black" : "#858585"

                                        Connections {
                                            target: simulationParams
                                            onNotifyImageEdgeSizeChanged: {
                                                txtEdgeSize.text = String(edgeSize) + (edgeSize == 1 ? " pixel" : " pixels")
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

                                    Text {
                                        text: "0"
                                        font.family: "Open Sans"
                                        Layout.leftMargin: 15

                                        color: cmbxNodeSizeMode.mode !== 'fixed' ? "black" : "#858585"
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
                                        text: String(sldrMinNodeSize.to)
                                        font.family: "Open Sans"
                                        Layout.leftMargin: 15

                                        color: cmbxNodeSizeMode.mode !== 'fixed' ? "black" : "#858585"
                                    }

                                    Text {
                                        id: txtMinNodeSize
                                        text: "20 pixels"
                                        font.family: "Open Sans"
                                        Layout.leftMargin: 15

                                        color: cmbxNodeSizeMode.mode !== 'fixed' ? "black" : "#858585"

                                        Connections {
                                            target: simulationParams
                                            onNotifyImageMinNodeSizeChanged: {
                                                txtMinNodeSize.text = String(minNodeSize) + (minNodeSize == 1 ? " pixel" : " pixels")
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
                                        text: "Maximum Node Size"
                                        font.family: "Open Sans"
                                        Layout.leftMargin: 15

                                        color: cmbxNodeSizeMode.mode  !== 'fixed' ? "black" : "#858585"
                                    }


                                    Text {
                                        text: String(sldrMaxNodeSize.from)
                                        font.family: "Open Sans"
                                        Layout.leftMargin: 15

                                        color: cmbxNodeSizeMode.mode !== 'fixed' ? "black" : "#858585"
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
                                        text: String(sldrMaxNodeSize.to)
                                        font.family: "Open Sans"
                                        Layout.leftMargin: 15

                                        color: cmbxNodeSizeMode.mode !== 'fixed' ? "black" : "#858585"
                                    }

                                    Text {
                                        id: txtMaxNodeSize
                                        text: "60 pixels"
                                        font.family: "Open Sans"
                                        Layout.leftMargin: 15

                                        color: cmbxNodeSizeMode.mode !== 'fixed' ? "black" : "#858585"

                                        Connections {
                                            target: simulationParams
                                            onNotifyImageMaxNodeSizeChanged: {
                                                txtMaxNodeSize.text = String(maxNodeSize) + (maxNodeSize == 1 ? " pixel" : " pixels")
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
                                        model: ["none", "order", "id"]

                                        property string mode: 'none'

                                        Layout.preferredWidth: 150
                                        Layout.leftMargin: 15

                                        onActivated: {
                                            if(index === 2) {
                                                simulationParams.slotSetImageLabelType('id')
                                                cmbxLblNodeType.mode = 'id'
                                            }
                                            if(index === 1) {
                                                simulationParams.slotSetImageLabelType('order')
                                                cmbxLblNodeType.mode = 'order'
                                            }
                                            if(index === 0) {
                                                simulationParams.slotSetImageLabelType('none')
                                                cmbxLblNodeType.mode = 'none'
                                            }
                                        }

                                        Connections {
                                            target: simulationParams
                                            onNotifyImageLabelTypeChanged: {
                                                if(labelType === 'id') {
                                                    cmbxLblNodeType.mode = 'id'
                                                    cmbxLblNodeType.currentIndex = 2
                                                }
                                                else if(labelType === 'none') {
                                                    cmbxLblNodeType.mode = 'none'
                                                    cmbxLblNodeType.currentIndex = 0
                                                }
                                                else {
                                                    cmbxLblNodeType.mode = 'order'
                                                    cmbxLblNodeType.currentIndex = 1
                                                }
                                            }
                                        }

                                    }

                                    BasicComponents.TooltipIcon {
                                        text: uiTexts.get('tooltipLabelNodeType')
                                        Layout.preferredWidth: 24
                                        Layout.preferredHeight: 24
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

                                        color: cmbxLblNodeType.mode !== 'none' ? "black" : "#858585"

                                    }

                                    BasicComponents.Slider {
                                        id: sldrLabelSize
                                        from: 4
                                        to: 30
                                        value: 10
                                        stepSize: 1

                                        Layout.preferredWidth: 100

                                        enabled: cmbxLblNodeType.mode !== 'none'

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
                                        text: "10 pixels"
                                        font.family: "Open Sans"
                                        Layout.leftMargin: 15

                                        color: cmbxLblNodeType.mode !== 'none' ? "black" : "#858585"

                                        Connections {
                                            target: simulationParams
                                            onNotifyImageLabelSizeChanged: {
                                                txtLabelSize.text = String(labelSize) + (labelSize == 1 ? " pixel" : " pixels")
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
                                        text: "10 pixels"
                                        font.family: "Open Sans"
                                        Layout.leftMargin: 15

                                        color: root.scheme === 'cut-edges' ? "black" : "#858585"

                                        Connections {
                                            target: simulationParams
                                            onNotifyImageCutEdgeNodeSizeChanged: {
                                                txtCutEdgeNodeSize.text = String(cutEdgeNodeSize) + (cutEdgeNodeSize == 1 ? " pixel" : " pixels")
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

                                    BasicComponents.TooltipIcon {
                                        text: uiTexts.get('tooltipCutEdgeSize')
                                        Layout.preferredWidth: 24
                                        Layout.preferredHeight: 24
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
                                        text: "50%"
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

                                    BasicComponents.TooltipIcon {
                                        text: uiTexts.get('tooltipCutEdgePercent')
                                        Layout.preferredWidth: 24
                                        Layout.preferredHeight: 24
                                    }

                                    Item {Layout.fillWidth: true}
                                }

                                Item {Layout.preferredHeight: 10}
                            }
                        }
                    }
                } // END PANE



        } // end flickable content
    } // end flickable
}
