import QtQuick 2.7
import Qt.labs.platform 1.0

MenuBar {
    id: root

    signal aboutRequested
    signal preferencesRequested()

    Menu {
        id: fileMenu

        MenuItem {
            text: qsTr("About")
            onTriggered: {
                root.aboutRequested()
            }
        }

        MenuSeparator {
        }

        MenuItem {
            text: qsTr("Preferences")
            onTriggered: {
                root.preferencesRequested()
            }
        }
    }
}
