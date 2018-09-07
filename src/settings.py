import os
from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, pyqtProperty
from utils import getProgramPathWithWhich, cleanFolderPath

class DGSSettingsData:
    def __init__(self, settingsPath=None):
        if settingsPath is None:
            self.settingsPath = "config.txt"
        elif os.path.exists(settingsPath):
            self.settingsPath = settingsPath
        else:
            self.settingsPath = "config.txt"

        self._dgsProgramDirectory = ''
        self._dgsProgramPath = ''
        self._dgsConfigIniPath = ''

        self._oslom2ProgramDirectory = ''
        self._oslom2ProgramPath = ''

        self._infomapProgramDirectory = ''
        self._infomapProgramPath = ''

        self._gvmapProgramDirectory = ''
        self._gvmapProgramPath = ''


        self._montageProgramPath = getProgramPathWithWhich('montage')
        self._ffmpegProgramPath = getProgramPathWithWhich('ffmpeg')

        # CONSTANT
        self._dgsProgramRelPath = 'genGraphStream.py'
        self._oslom2ProgramRelPath = 'oslom_undir'
        self._infomapProgramRelPath = 'Infomap'
        self._gvmapProgramRelPath = 'gvmap'
        self._dgsConfigIniRelPath = 'config.ini'

    def load(self):
        if os.path.exists(self.settingsPath):
            # do the load
            with open(self.settingsPath, 'r') as f:
                for line in f:
                    line = line.strip()
                    if len(line) == 0:
                        continue
                    if line.startswith('#'):
                        continue
                    parts = line.split("=")
                    if(len(parts) == 2):
                        key = parts[0].strip()
                        value = parts[1].strip()

                        if key == 'dgsProgramDirectory':
                            self._dgsProgramDirectory = value
                            self._dgsProgramPath = os.path.join(self._dgsProgramDirectory, self._dgsProgramRelPath)
                            self._dgsConfigIniPath = os.path.join(self._dgsProgramDirectory, self._dgsConfigIniRelPath)
                        elif key == 'montage':
                            self._montageProgramPath = value
                        elif key == 'ffmpeg':
                            self._ffmpegProgramPath = value
                        elif key == 'oslom2':
                            self._oslom2ProgramDirectory = value
                            self._oslom2ProgramPath = os.path.join(self._oslom2ProgramDirectory, self._oslom2ProgramRelPath)
                        elif key == 'infomap':
                            self._infomapProgramDirectory = value
                            self._infomapProgramPath = os.path.join(self._infomapProgramDirectory, self._infomapProgramRelPath)
                        elif key == 'gvmap':
                            self._gvmapProgramDirectory = value
                            self._gvmapProgramPath = os.path.join(self._gvmapProgramDirectory, self._gvmapProgramRelPath)

        else:
            # create new and store defaults
            self.save()

    def save(self):
        with open(self.settingsPath, 'w') as f:
            f.write('dgsProgramDirectory=' + self._dgsProgramDirectory + '\n')
            f.write('montage=' + self._montageProgramPath + '\n')
            f.write('ffmpeg=' + self._ffmpegProgramPath + '\n')
            f.write('oslom2=' + self._oslom2ProgramDirectory + '\n')
            f.write('infomap=' + self._infomapProgramDirectory + '\n')
            f.write('gvmap=' + self._gvmapProgramDirectory + '\n')

    def updateIni(self, tmpData):
        pass

    def printSettings(self):
        with open(self.settingsPath, 'r') as f:
            for line in f:
                line = line.strip()
                print(line)
        print('dgsProgramPath=' + self._dgsProgramPath)

    def syncDataFromOther(self, data):
        self._dgsProgramDirectory = data._dgsProgramDirectory
        self._dgsProgramPath = data._dgsProgramPath

        self._oslom2ProgramDirectory = data._oslom2ProgramDirectory
        self._oslom2ProgramPath = data._oslom2ProgramPath

        self._infomapProgramDirectory = data._infomapProgramDirectory
        self._infomapProgramPath = data._infomapProgramPath

        self._gvmapProgramDirectory = data._gvmapProgramDirectory
        self._gvmapProgramPath = data._gvmapProgramPath

        self._montageProgramPath = data._montageProgramPath
        self._ffmpegProgramPath = data._ffmpegProgramPath

    def otherIsSame(self, data):
        isSame = True
        if self._dgsProgramDirectory != data._dgsProgramDirectory:
            isSame = False
        if self._dgsProgramPath != data._dgsProgramPath:
            isSame = False
        if self._oslom2ProgramDirectory != data._oslom2ProgramDirectory:
            isSame = False
        if self._oslom2ProgramPath != data._oslom2ProgramPath:
            isSame = False
        if self._infomapProgramDirectory != data._infomapProgramDirectory:
            isSame = False
        if self._infomapProgramPath != data._infomapProgramPath:
            isSame = False
        if self._gvmapProgramDirectory != data._gvmapProgramDirectory:
            isSame = False
        if self._gvmapProgramPath != data._gvmapProgramPath:
            isSame = False

        if self._montageProgramPath != data._montageProgramPath:
            isSame = False
        if self._ffmpegProgramPath != data._ffmpegProgramPath:
            isSame = False
        return isSame

class DGSSettings(QObject):
    def __init__(self, parent=None, settingsPath=None):
        QObject.__init__(self, parent)

        self.data = DGSSettingsData(settingsPath)
        self.dataTemp = DGSSettingsData(settingsPath)

        self.data.load()
        self.dataTemp.load()

    # SIGNALS
    notifyDGSProgramDirectoryChanged = pyqtSignal(str, bool, arguments=["dgsDirectoryPath", "isValid"])
    notifyDGSProgramPathChanged = pyqtSignal(str, bool, arguments=["dgsProgramPath", "isValid"])

    notifyOslom2ProgramDirectoryChanged = pyqtSignal(str, bool, arguments=["oslom2DirectoryPath", "isValid"])
    notifyOslom2ProgramPathChanged = pyqtSignal(str, bool, arguments=["oslom2ProgramPath", "isValid"])

    notifyInfomapProgramDirectoryChanged = pyqtSignal(str, bool, arguments=["infomapDirectoryPath", "isValid"])
    notifyInfomapProgramPathChanged = pyqtSignal(str, bool, arguments=["infomapProgramPath", "isValid"])

    notifyGvmapProgramDirectoryChanged = pyqtSignal(str, bool, arguments=["gvmapDirectoryPath", "isValid"])
    notifyGvmapProgramPathChanged = pyqtSignal(str, bool, arguments=["gvmapProgramPath", "isValid"])


    notifyOverallValidationChanged = pyqtSignal(bool, arguments=["settingsValid"])

    # program paths
    notifyMontageProgramPathChanged = pyqtSignal(str, bool, arguments=["programPath", "exists"])
    notifyFfmpegProgramPathChanged = pyqtSignal(str, bool, arguments=["programPath", "exists"])

    # PROPERTIES
    @pyqtProperty(str)
    def dgsProgramPath(self):
        return self.dataTemp._dgsProgramPath

    @pyqtProperty(str)
    def oslom2ProgramPath(self):
        return self.dataTemp._oslom2ProgramPath

    @pyqtProperty(str)
    def infomapProgramPath(self):
        return self.dataTemp._infomapProgramPath

    @pyqtProperty(str)
    def gvmapProgramPath(self):
        return self.dataTemp._gvmapProgramPath

    @pyqtProperty(str)
    def dgsProgramDirectory(self):
        return self.dataTemp._dgsProgramDirectory

    @pyqtProperty(str)
    def oslom2ProgramDirectory(self):
        return self.dataTemp._oslom2ProgramDirectory

    @pyqtProperty(str)
    def infomapProgramDirectory(self):
        return self.dataTemp._infomapProgramDirectory

    @pyqtProperty(str)
    def gvmapProgramDirectory(self):
        return self.dataTemp._gvmapProgramDirectory

    @pyqtProperty(str)
    def montageProgramPath(self):
        return self.dataTemp._montageProgramPath

    @pyqtProperty(str)
    def ffmpegProgramPath(self):
        return self.dataTemp._ffmpegProgramPath

    @pyqtProperty(bool)
    def packageNetworkxInstalled(self):
        try:
            import networkx
            return True
        except:
            return False

    @pyqtProperty(bool)
    def packageNxmetisInstalled(self):
        try:
            import nxmetis
            return True
        except:
            return False

    @pyqtProperty(bool)
    def packageConfigparserInstalled(self):
        try:
            import configparser
            return True
        except:
            return False

    @pyqtProperty(bool)
    def packagePydotInstalled(self):
        try:
            import pydot
            return True
        except:
            return False

    @pyqtProperty(bool)
    def packageScipyInstalled(self):
        try:
            import scipy
            return True
        except:
            return False

    @pyqtProperty(bool)
    def packageSvglibInstalled(self):
        try:
            import svglib
            return True
        except:
            return False

    @pyqtProperty(bool)
    def packageSvgutilsInstalled(self):
        try:
            import svgutils
            return True
        except:
            return False

    @pyqtProperty(bool)
    def packagePyparsingInstalled(self):
        try:
            import pyparsing
            return True
        except:
            return False

    @pyqtProperty(bool)
    def packageReportlabInstalled(self):
        try:
            import reportlab
            return True
        except:
            return False

    @pyqtProperty(bool)
    def packagePygraphvizInstalled(self):
        try:
            import pygraphviz
            return True
        except:
            return False

    @pyqtProperty(bool)
    def packageFpdfInstalled(self):
        try:
            import fpdf
            return True
        except:
            return False

    @pyqtProperty(bool)
    def packagePillowInstalled(self):
        try:
            from PIL import Image
            return True
        except:
            return False

    @pyqtProperty(bool)
    def packageDecoratorInstalled(self):
        try:
            import decorator
            return True
        except:
            return False

    @pyqtProperty(bool)
    def packageColourInstalled(self):
        try:
            import colour
            return True
        except:
            return False

    @pyqtProperty(bool)
    def packageCythonInstalled(self):
        try:
            import Cython
            return True
        except:
            return False

    # VALIDATIONS
    @pyqtProperty(bool)
    def dgsProgramPathValid(self):
        return os.path.exists(self.dataTemp._dgsProgramPath) and os.path.isfile(self.dataTemp._dgsProgramPath)

    @pyqtProperty(bool)
    def dgsProgramDirectoryValid(self):
        return len(self.dataTemp._dgsProgramDirectory) > 0 and os.path.exists(self.dataTemp._dgsProgramDirectory) and os.path.isdir(self.dataTemp._dgsProgramDirectory) and self.dgsProgramPathValid

    @pyqtProperty(bool)
    def oslom2ProgramPathValid(self):
        return os.path.exists(self.dataTemp._oslom2ProgramPath) and os.path.isfile(self.dataTemp._oslom2ProgramPath)

    @pyqtProperty(bool)
    def oslom2ProgramDirectoryValid(self):
        return len(self.dataTemp._oslom2ProgramDirectory) > 0 and os.path.exists(self.dataTemp._oslom2ProgramDirectory) and os.path.isdir(self.dataTemp._oslom2ProgramDirectory) and self.oslom2ProgramPathValid

    @pyqtProperty(bool)
    def infomapProgramPathValid(self):
        return os.path.exists(self.dataTemp._infomapProgramPath) and os.path.isfile(self.dataTemp._infomapProgramPath)

    @pyqtProperty(bool)
    def infomapProgramDirectoryValid(self):
        return len(self.dataTemp._infomapProgramDirectory) > 0 and os.path.exists(self.dataTemp._infomapProgramDirectory) and os.path.isdir(self.dataTemp._infomapProgramDirectory) and self.infomapProgramPathValid

    @pyqtProperty(bool)
    def gvmapProgramPathValid(self):
        return os.path.exists(self.dataTemp._gvmapProgramPath) and os.path.isfile(self.dataTemp._gvmapProgramPath)

    @pyqtProperty(bool)
    def gvmapProgramDirectoryValid(self):
        return len(self.dataTemp._gvmapProgramDirectory) > 0 and os.path.exists(self.dataTemp._gvmapProgramDirectory) and os.path.isdir(self.dataTemp._gvmapProgramDirectory) and self.gvmapProgramPathValid

    @pyqtProperty(bool)
    def montageProgramPathValid(self):
        return os.path.exists(self.dataTemp._montageProgramPath)

    @pyqtProperty(bool)
    def ffmpegProgramPathValid(self):
        return os.path.exists(self.dataTemp._ffmpegProgramPath)


    @pyqtProperty(bool)
    def dgsSettingsValid(self):
        return self.checkDGSSettingsValid()

    def checkDGSSettingsValid(self):
        valid = True

        if self.dgsProgramPathValid == False:
            valid = False
        if self.oslom2ProgramPathValid == False:
            valid = False
        if self.infomapProgramPathValid == False:
            valid = False
        if self.gvmapProgramPathValid == False:
            valid = False
        if self.montageProgramPathValid == False:
            valid = False
        if self.ffmpegProgramPathValid == False:
            valid = False

        if self.packageNetworkxInstalled == False:
            valid = False

        if self.packageNxmetisInstalled == False:
            valid = False

        if self.packageConfigparserInstalled == False:
            valid = False

        if self.packagePydotInstalled == False:
            valid = False

        if self.packageScipyInstalled == False:
            valid = False

        if self.packageSvglibInstalled == False:
            valid = False

        if self.packageSvgutilsInstalled == False:
            valid = False

        if self.packagePyparsingInstalled == False:
            valid = False

        if self.packageReportlabInstalled == False:
            valid = False

        if self.packagePygraphvizInstalled == False:
            valid = False

        if self.packageFpdfInstalled == False:
            valid = False

        if self.packagePillowInstalled == False:
            valid = False

        if self.packageDecoratorInstalled == False:
            valid = False

        if self.packageColourInstalled == False:
            valid = False

        if self.packageCythonInstalled == False:
            valid = False



        self.notifyOverallValidationChanged.emit(valid)
        return valid

    @pyqtSlot(str)
    def slotSetDGSProgramDirectory(self, path):
        path = cleanFolderPath(path)
        self.dataTemp._dgsProgramDirectory = path
        self._createDGSProgramPath()
        isValid = self.dgsProgramDirectoryValid
        #self.save()
        self.notifyDGSProgramDirectoryChanged.emit(self.dataTemp._dgsProgramDirectory, isValid)
        self.checkDGSSettingsValid()

    @pyqtSlot(str)
    def slotSetOslom2ProgramDirectory(self, path):
        path = cleanFolderPath(path)
        self.dataTemp._oslom2ProgramDirectory = path
        self._createOslom2ProgramPath()
        isValid = self.oslom2ProgramDirectoryValid
        #self.save()
        self.notifyOslom2ProgramDirectoryChanged.emit(self.dataTemp._oslom2ProgramDirectory, isValid)
        self.checkDGSSettingsValid()

    @pyqtSlot(str)
    def slotSetInfomapProgramDirectory(self, path):
        path = cleanFolderPath(path)
        self.dataTemp._infomapProgramDirectory = path
        self._createInfomapProgramPath()
        isValid = self.infomapProgramDirectoryValid
        #self.save()
        self.notifyInfomapProgramDirectoryChanged.emit(self.dataTemp._infomapProgramDirectory, isValid)
        self.checkDGSSettingsValid()

    @pyqtSlot(str)
    def slotSetGvmapProgramDirectory(self, path):
        path = cleanFolderPath(path)
        self.dataTemp._gvmapProgramDirectory = path
        self._createGvmapProgramPath()
        isValid = self.gvmapProgramDirectoryValid
        #self.save()
        self.notifyGvmapProgramDirectoryChanged.emit(self.dataTemp._gvmapProgramDirectory, isValid)
        self.checkDGSSettingsValid()

    @pyqtSlot(str)
    def slotSetMontagePath(self, path):
        path = cleanFolderPath(path)

        self.dataTemp._montageProgramPath = path
        isValid = self.montageProgramPathValid

        self.notifyMontageProgramPathChanged.emit(self.dataTemp._montageProgramPath, isValid)
        self.checkDGSSettingsValid()

    @pyqtSlot(str)
    def slotSetFfmpegPath(self, path):
        path = cleanFolderPath(path)

        self.dataTemp._ffmpegProgramPath = path
        isValid = self.ffmpegProgramPathValid

        self.notifyFfmpegProgramPathChanged.emit(self.dataTemp._ffmpegProgramPath, isValid)
        self.checkDGSSettingsValid()

    @pyqtSlot()
    def cancelSettingsChanges(self):
        self.dataTemp.syncDataFromOther(self.data)

        self.notifyDGSProgramDirectoryChanged.emit(self.dataTemp._dgsProgramDirectory, self.dgsProgramDirectoryValid)
        self.notifyDGSProgramPathChanged.emit(self.dataTemp._dgsProgramPath, self.dgsProgramPathValid)

        self.notifyOslom2ProgramDirectoryChanged.emit(self.dataTemp._oslom2ProgramDirectory, self.oslom2ProgramDirectoryValid)
        self.notifyOslom2ProgramPathChanged.emit(self.dataTemp._oslom2ProgramPath, self.oslom2ProgramPathValid)

        self.notifyInfomapProgramDirectoryChanged.emit(self.dataTemp._infomapProgramDirectory, self.infomapProgramDirectoryValid)
        self.notifyInfomapProgramPathChanged.emit(self.dataTemp._infomapProgramPath, self.infomapProgramPathValid)

        self.notifyGvmapProgramDirectoryChanged.emit(self.dataTemp._gvmapProgramDirectory, self.gvmapProgramDirectoryValid)
        self.notifyGvmapProgramPathChanged.emit(self.dataTemp._gvmapProgramPath, self.gvmapProgramPathValid)


        self.notifyMontageProgramPathChanged.emit(self.dataTemp._montageProgramPath, self.montageProgramPathValid)
        self.notifyFfmpegProgramPathChanged.emit(self.dataTemp._ffmpegProgramPath, self.ffmpegProgramPathValid)

        self.notifyOverallValidationChanged.emit(self.dgsSettingsValid)


    @pyqtSlot()
    def updateConfigIni(self):
        self.data.updateIni(self.dataTemp)
    @pyqtSlot()
    def commitSettingsChanges(self):
        self.data.syncDataFromOther(self.dataTemp)
        self.data.save()

    def _createDGSProgramPath(self):
        self.dataTemp._dgsProgramPath = os.path.join(self.dataTemp._dgsProgramDirectory, self.dataTemp._dgsProgramRelPath)
        self.dataTemp._dgsConfigIniPath = os.path.join(self.dataTemp._dgsProgramDirectory, self.dataTemp._dgsConfigIniRelPath)

        isValid = self.dgsProgramPathValid
        self.notifyDGSProgramPathChanged.emit(self.dataTemp._dgsProgramPath, isValid)
        self.checkDGSSettingsValid()

    def _createOslom2ProgramPath(self):
        self.dataTemp._oslom2ProgramPath = os.path.join(self.dataTemp._oslom2ProgramDirectory, self.dataTemp._oslom2ProgramRelPath)
        isValid = self.oslom2ProgramPathValid
        self.notifyOslom2ProgramPathChanged.emit(self.dataTemp._oslom2ProgramPath, isValid)
        self.checkDGSSettingsValid()

    def _createInfomapProgramPath(self):
        self.dataTemp._infomapProgramPath = os.path.join(self.dataTemp._infomapProgramDirectory, self.dataTemp._infomapProgramRelPath)
        isValid = self.infomapProgramPathValid
        self.notifyInfomapProgramPathChanged.emit(self.dataTemp._infomapProgramPath, isValid)
        self.checkDGSSettingsValid()

    def _createGvmapProgramPath(self):
        self.dataTemp._gvmapProgramPath = os.path.join(self.dataTemp._gvmapProgramDirectory, self.dataTemp._gvmapProgramRelPath)
        isValid = self.gvmapProgramPathValid
        self.notifyGvmapProgramPathChanged.emit(self.dataTemp._gvmapProgramPath, isValid)
        self.checkDGSSettingsValid()
