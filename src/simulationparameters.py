import os
from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot

def composeAbsolutePath(path):
    '''
        Given a path, this function composes the absolute path to that folder/file
        input: '', returns current working directory
        input: '/something/that/seems/like/an/absolute/path': return what is passed
        input: 'something/that/is/not/absolute': return currentWorkingDir + path
    '''
    cwd = os.getcwd()
    if len(path) == 0:
        return cwd
    if path[0] == '/':
        return path
    return os.path.normpath(os.path.join(cwd, path))

class SimulationParameters(QObject):
    def __init__(self):
        QObject.__init__(self)

        self.scheme = 'communities'

    # SIGNALS
    # required
    notifyGraphFilePathChanged = pyqtSignal(str, bool, arguments=["graphFilePath", "fileExistsAtPath"])
    notifyGraphFormatChanged = pyqtSignal(str, arguments=["format"])

    # Scheme / Clustering
    notifySchemeChanged = pyqtSignal(str, arguments=["scheme"])


    # SLOTS
    @pyqtSlot(str)
    def slotSetGraphFilePath(self, filePath):
        path = composeAbsolutePath(filePath)
        exists = os.path.isfile(path)
        print(path, exists)
        self.graphFilePath = path
        self.notifyGraphFilePathChanged.emit(self.graphFilePath, exists)

    @pyqtSlot(str)
    def slotGraphFormat(self, format):
        self.graphFormat = format
        self.notifyGraphFormatChanged.emit(self.graphFormat)


    @pyqtSlot(str)
    def slotSetScheme(self, scheme):
        self.scheme = scheme
        self.notifySchemeChanged.emit(self.scheme)
