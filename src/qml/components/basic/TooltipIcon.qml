import QtQuick 2.7

Image {
    id: root
    source: "../../assets/icons/tooltip.png"
    width: 24; height: 24
    fillMode: Image.PreserveAspectFit

    property alias text: tt.text
    property bool hovered: false

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            root.hovered = true
        }
        onExited: {
            root.hovered = false
        }
    }

    Tooltip {
      id: tt
      visible: root.hovered
      parent: root
    }
}
