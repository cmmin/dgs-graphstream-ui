import os

from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot
from utils import generateRandomSeed

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
        self.graphFormat = 'metis'
        self.graphFilePath = ''

        self.graphLayout = 'springbox'
        self.layoutLinlogForce = 3.0
        self.layoutAttraction = 0.012
        self.layoutRepulsion = 0.024
        self.layoutRandomSeed = generateRandomSeed()

        self.pdfEnabled = False
        self.pdfFramePercentage = 20

    # SIGNALS
    # required
    notifyGraphFilePathChanged = pyqtSignal(str, bool, arguments=["graphFilePath", "fileExistsAtPath"])
    notifyGraphFormatChanged = pyqtSignal(str, arguments=["format"])

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

    # Scheme / Clustering
    notifySchemeChanged = pyqtSignal(str, arguments=["scheme"])

    @pyqtSlot(str)
    def slotSetScheme(self, scheme):
        self.scheme = scheme
        self.notifySchemeChanged.emit(self.scheme)

    # Layout
    notifyGraphLayoutChanged = pyqtSignal(str, arguments=["graphLayout"])
    notifyLayoutLinlogForceChanged = pyqtSignal(float, arguments=["linlogForce"])
    notifyLayoutAttractionChanged = pyqtSignal(float, arguments=["attraction"])
    notifyLayoutRepulsionChanged = pyqtSignal(float, arguments=["repulsion"])
    notifyLayoutRandomSeedChanged = pyqtSignal(int, arguments=["randomSeed"])

    @pyqtSlot(str)
    def slotSetGraphLayout(self, layout):
        self.graphLayout = layout
        self.notifyGraphLayoutChanged.emit(self.graphLayout)

    @pyqtSlot(float)
    def slotSetLayoutLinlogForce(self, force):
        force = force * 10.0
        force = float(int(force)) / 10.0
        self.layoutLinlogForce = force
        self.notifyLayoutLinlogForceChanged.emit(self.layoutLinlogForce)

    @pyqtSlot(float)
    def slotSetLayoutAttraction(self, attraction):
        attraction = attraction * 1000.0
        attraction = float(int(attraction)) / 1000.0
        self.layoutAttraction = attraction
        self.notifyLayoutAttractionChanged.emit(self.layoutAttraction)

    @pyqtSlot(float)
    def slotSetLayoutRepulsion(self, repulsion):
        factor = 1000.0
        if self.graphLayout == 'linlog':
            factor = 10.0
        repulsion = repulsion * factor
        repulsion = float(int(repulsion)) / factor
        self.layoutRepulsion = repulsion
        self.notifyLayoutRepulsionChanged.emit(self.layoutRepulsion)

    @pyqtSlot()
    def slotGenerateNewLayoutRandomSeed(self):
        self.layoutRandomSeed = generateRandomSeed()
        self.notifyLayoutRandomSeedChanged.emit(self.layoutRandomSeed)


    # PDF
    notifyPDFEnabledChanged = pyqtSignal(bool, arguments=["enabled"])
    notifyPDFFramePercentageChanged = pyqtSignal(int, arguments=["pdfFramePercentage"])

    @pyqtSlot(bool)
    def slotSetPDFEnabled(self, enabled):
        self.pdfEnabled = enabled
        self.notifyPDFEnabledChanged.emit(self.pdfEnabled)

    @pyqtSlot(int)
    def slotSetPDFFramePercentage(self, percentage):
        self.pdfFramePercentage = percentage
        self.notifyPDFFramePercentageChanged.emit(self.pdfFramePercentage)
