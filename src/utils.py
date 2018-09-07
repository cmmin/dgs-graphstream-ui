import os
import random
import platform
import subprocess

from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot
from PyQt5.QtGui import QFontDatabase

import ipdb; debug =ipdb.set_trace

def generateRandomSeed():
    return random.randint(1, 10**6)

def cleanFolderPath(path):
    if path.startswith('file:///'):
        path = path.replace('file://', '')
    if path.startswith('file://'):
        path = path.replace('file:/', '')
    return path


class QmlUtils(QObject):
    def __init__(self):
        QObject.__init__(self)

    randomSeedResult = pyqtSignal(int, str, arguments=['randomSeedValue', 'callerID'])

    @pyqtSlot(str)
    def createRandomSeed(self, callerID):
        seedValue = generateRandomSeed()
        self.randomSeedResult.emit(seedValue, callerID)

    @pyqtSlot(str, result=str)
    def parseSystemPath(self, path):
        return cleanFolderPath(path)

    @pyqtSlot(str, result=bool)
    def checkProjectFolderValid(self, path):
        settingsFile = os.path.join(path, 'dgs_config.txt')
        if(os.path.exists(settingsFile)):
            with open(settingsFile, 'r+') as f:
                for line in f:
                    line = line.strip()
                    if line == '#DGSConfig':
                        return True
                    else:
                        return False
        return False

    @pyqtSlot(str, result=bool)
    def checkNewProjectFolderValid(self, path):
        if(os.path.exists(path)):
            files = os.listdir(path)
            if len(files) == 0:
                return True

            for f in files:
                if os.path.isfile(f) and not f.startswith('.'):
                    return False
                if os.path.isfile(f) == False:
                    return False
            return True
        return False

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

def getProgramPathWithWhich(programName):
    whichPath = ''
    try:
        if platform.system() == 'Darwin':
            whichPath = subprocess.check_output(['which', programName]).decode("utf-8").strip()
        if platform.system() == 'Linux':
            whichPath = subprocess.check_output(['which', programName]).decode("utf-8").strip()
    except Exception as err:
        print(err)
    return whichPath
