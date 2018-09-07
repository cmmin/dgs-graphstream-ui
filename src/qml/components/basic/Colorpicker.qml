import QtQuick 2.7
import QtQuick.Dialogs 1.0

ColorDialog {
    id: root
    title: "Please choose a color"

    modality: Qt.ApplicationModal

    signal colorChosen(string color)

    onAccepted: {
        root.colorChosen(root.color)
        root.visible = false
    }
}
