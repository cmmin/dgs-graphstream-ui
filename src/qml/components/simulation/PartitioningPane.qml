import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

Item {
    id: root

    Text {
        id: paneTitle
        // Title
        text: "Partitioning Settings"
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
        text: "some loong text that describes this panesome loong text that describes this panesome loong text that describes this panesome loong text that describes this panesome loong text that describes this panesome loong text that describes this panesome loong text that describes this panesome loong text that describes this panesome loong text that describes this pane"
        font.family: "Open Sans"
        font.pixelSize: 14

        anchors.left: root.left
        anchors.top: paneTitle.bottom
        anchors.right: root.right

        anchors.leftMargin: 10
        anchors.topMargin: 10

        wrapMode: Text.WordWrap
    }

}
