import QtQuick 2.7
import QtQuick.Layouts 1.3

import "./settings/" as SettingPanes

Item {
    id: root

    SettingPanes.SettingsPane {
        anchors.fill: parent
    }
}
