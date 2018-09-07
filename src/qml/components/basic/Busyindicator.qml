import QtQuick 2.7

import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

BusyIndicator {
    id: root

    running: false

    property string indicatorSource: "../../assets/icons/wait.png"

    style: BusyIndicatorStyle {
        indicator: Image {
            id: indicatorImg

            fillMode: Image.PreserveAspectFit

            visible: root.running
            source: root.indicatorSource

            RotationAnimator on rotation {
                running: root.running
                loops: Animation.Infinite
                duration: 2000
                from: 0 ; to: 360
            }
        }
    }
}
