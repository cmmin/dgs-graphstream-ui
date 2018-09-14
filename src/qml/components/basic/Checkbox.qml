import QtQuick 2.7
import QtQuick.Controls 2.2

CheckBox {
    id: control

    property int outerImplicitDimensions: 20
    property int innerImplicitDimensions: 14

    indicator: Rectangle {
        implicitWidth: control.outerImplicitDimensions
        implicitHeight: control.outerImplicitDimensions
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 3
        border.color: "#BFBFBF"

        Rectangle {
            width: control.innerImplicitDimensions
            height: control.innerImplicitDimensions
            x: 0.5 * (control.outerImplicitDimensions - control.innerImplicitDimensions)
            y: 0.5 * (control.outerImplicitDimensions - control.innerImplicitDimensions)
            radius: 2
            color: "#858585"
            visible: control.checked
        }
    }
}
