import os
import random

from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot
from PyQt5.QtGui import QFontDatabase

class QmlUtils(QObject):
    def __init__(self):
        QObject.__init__(self)

    randomSeedResult = pyqtSignal(int, str, arguments=['randomSeedValue', 'callerID'])

    @pyqtSlot(str)
    def createRandomSeed(self, callerID):
        seedValue = random.randint(1, 10**6)
        self.randomSeedResult.emit(seedValue, callerID)


def loadFonts():
    fontIDs = []
    fontIDs.append(QFontDatabase().addApplicationFont(os.path.join(os.getcwd(), "qml/assets/fonts/opensans/OSRegular.ttf")))
    fontIDs.append(QFontDatabase().addApplicationFont(os.path.join(os.getcwd(), "qml/assets/fonts/opensans/OSItalic.ttf")))
    fontIDs.append(QFontDatabase().addApplicationFont(os.path.join(os.getcwd(), "qml/assets/fonts/opensans/OSBold.ttf")))
    fontIDs.append(QFontDatabase().addApplicationFont(os.path.join(os.getcwd(), "qml/assets/fonts/opensans/OSBoldItalic.ttf")))
    fontIDs.append(QFontDatabase().addApplicationFont(os.path.join(os.getcwd(), "qml/assets/fonts/opensans/OSSemibold.ttf")))
    fontIDs.append(QFontDatabase().addApplicationFont(os.path.join(os.getcwd(), "qml/assets/fonts/opensans/OSSemiboldItalic.ttf")))
    fontIDs.append(QFontDatabase().addApplicationFont(os.path.join(os.getcwd(), "qml/assets/fonts/ubuntu/Ubuntu-Regular.ttf")))
    fontIDs.append(QFontDatabase().addApplicationFont(os.path.join(os.getcwd(), "qml/assets/fonts/ubuntu/Ubuntu-Italic.ttf")))
    fontIDs.append(QFontDatabase().addApplicationFont(os.path.join(os.getcwd(), "qml/assets/fonts/ubuntu/Ubuntu-Bold.ttf")))
    fontIDs.append(QFontDatabase().addApplicationFont(os.path.join(os.getcwd(), "qml/assets/fonts/ubuntu/Ubuntu-BoldItalic.ttf")))
    return fontIDs
