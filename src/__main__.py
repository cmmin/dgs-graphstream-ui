import os
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot

from utils import QmlUtils, loadFonts
from simulationparameters import SimulationParameters


if __name__ == '__main__':
    import sys

    # Create an instance of the application
    app = QGuiApplication(sys.argv)

    # Create QML engine
    engine = QQmlApplicationEngine()


    qmlUtils = QmlUtils()
    simParams = SimulationParameters()

    fontIDs = loadFonts()
    # And register root context of QML
    engine.rootContext().setContextProperty("qmlUtils", qmlUtils)
    engine.rootContext().setContextProperty("simulationParams", simParams)

    # Load the qml file into the engine
    engine.load("qml/main.qml")

    engine.quit.connect(app.quit)
    sys.exit(app.exec_())
