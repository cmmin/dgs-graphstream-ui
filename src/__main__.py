import os
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot

from utils import QmlUtils, loadFonts
from simulationparameters import SimulationParameters
from dgswrapper import DGSWrapper
from settings import DGSSettings
from uitexts import UITexts
from examples import ExampleManager

if __name__ == '__main__':
    import sys

    # Create an instance of the application
    app = QGuiApplication(sys.argv)

    # Create QML engine
    engine = QQmlApplicationEngine()

    qmlUtils = QmlUtils()

    uiTexts = UITexts()
    uiTexts.load('qml/assets/uitext.csv')

    examples = ExampleManager(app)
    examples.load(os.path.abspath(os.path.join(os.getcwd(), '..', 'examples')))

    dgsSettings = DGSSettings(app)
    simParams = SimulationParameters()
    dgsWrapper = DGSWrapper(simParams, dgsSettings)

    simParams.notifySavingSettings.connect(dgsWrapper.checkForParamErrors)

    #dgsSettings.load()

    fontIDs = loadFonts()
    # And register root context of QML
    engine.rootContext().setContextProperty("qmlUtils", qmlUtils)
    engine.rootContext().setContextProperty("simulationParams", simParams)
    engine.rootContext().setContextProperty("dgsGraphstream", dgsWrapper)
    engine.rootContext().setContextProperty("dgsSettings", dgsSettings)
    engine.rootContext().setContextProperty("uiTexts", uiTexts)
    engine.rootContext().setContextProperty("examples", examples)

    # Load the qml file into the engine
    engine.load("qml/main.qml")

    engine.quit.connect(app.quit)
    sys.exit(app.exec_())
