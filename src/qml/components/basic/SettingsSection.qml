Item {
    id: paneScheme
    anchors.left: root.left
    anchors.right: root.right

    anchors.top: paneTitle.bottom

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
                    text: "Layout Scheme"
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

                Item {Layout.preferredHeight: 10}



                Item {Layout.preferredHeight: 10}
            }
        }
    }
}
