import os
import re

from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot
from utils import generateRandomSeed
from configwriter import saveConfigSettings, loadConfigSettings

import ipdb; debug = ipdb.set_trace

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

def canConvertToInteger(value):
    converted = False
    try:
        int(value)
        converted = True
    except ValueError as err:
        pass
    return converted


class SimulationParameters(QObject):
    def __init__(self):
        QObject.__init__(self)

        self.projectFolder = ''
        self.settingsPath = ''
        self.saveEnabled = False

        self.scheme = 'communities'
        self.graphFormat = 'random'
        self.graphFilePath = ''
        self.graphFilePathValid = False

        self.outputPath = ''

        self.nodeOrderListPath = ''
        self.nodeOrderListPathValid = False

        self.filterPath = ''
        self.filterPathValid = False
        self.orderSeed = generateRandomSeed()
        self.orderSeedValid = False

        # @deprecated, do not export this
        self.nodeWeightAttribute = 'weight'
        # @deprecated, do not export this
        self.edgeWeightAttribute = 'weight'

        self.assignmentsPath = ''
        self.assignmentsPathValid = False

        self.partitionSeed = generateRandomSeed()
        self.partitionSeedValid = False

        self.visiblePartitions = []
        self.visiblePartitionsValid = False

        self.assignmentsMode = 'metis' # random, file
        self.numPartitions = 4
        self.ubvec = 1.001
        self.tpwgts = [] # only with nparts
        self.tpwgtsValid = False
        #self.showPartitions = False

        self.graphLayout = 'springbox'
        self.layoutLinlogForce = 3.0
        self.layoutAttraction = 0.012
        self.layoutRepulsion = 0.024
        self.layoutRandomSeed = generateRandomSeed()
        self.layoutRandomSeedValid = False

        self.colorScheme = 'pastel'
        self.nodeColor = ''
        self.nodeColorValid = False
        self.coloringSeed = generateRandomSeed()
        self.coloringSeedValid = False

        # @deprecated, do not export this
        self.nodeShadowColor = ''

        self.imageNodeSizeMode = 'fixed'
        self.imageNodeSize = 20
        self.imageMinNodeSize = 20
        self.imageMaxNodeSize = 60
        self.imageEdgeSize = 1
        self.imageLabelSize = 10
        self.imageLabelType = 'id'
        self.imageBorderSize = 1
        self.imageWidth = 1280
        self.imageHeight = 780

        self.imageWidthValid = False
        self.imageHeightValid = False

        self.cutEdgeLength = 50
        self.cutEdgeNodeSize = 10

        self.videoPath = ""
        self.videoPathValid = False
        self.videoFullPath = ""
        self.videoFPS = 8
        self.videoPaddingTime = 2.0

        self.pdfEnabled = False
        self.pdfFramePercentage = 20

        self.clustering = 'oslom2'
        self.clusterSeed = generateRandomSeed()
        self.clusterSeedValid = False
        self.infomapCalls = 0

    def regexMatches(self, regex, line):
        matches = re.finditer(regex, line, re.MULTILINE)
        matchList = list(enumerate(matches))
        if len(matchList) > 0:
            return True
        return False

    def videoFileStringRegexCheck(self, videoFilePath):
        regex = r"[\w\-. ]+\.mp4$"
        return self.regexMatches(regex, videoFilePath)

    def colorStringRegex(self, color):
        regex = r"^#[abcdefABCDEF1234567890]{6}$"
        return self.regexMatches(regex, color)

    def attributeRegex(self, value):
        regex = r"^[a-zA-Z\-_0-9]+$"
        return self.regexMatches(regex, value)

    def computeFullVideoPath(self):
        self.videoFullPath = os.path.join(self.outputPath, self.videoPath + '.mp4')
        ok = self.videoFileStringRegexCheck(self.videoFullPath)
        self.videoPathValid = ok
        self.notifyVideoFullPathChanged.emit(self.videoFullPath, ok)

    def loadSettings(self):
        return loadConfigSettings(self.settingsPath, self)

    notifySavingSettings = pyqtSignal()

    def saveSettings(self):
        if self.saveEnabled == False:
            return True
        self.notifySavingSettings.emit()
        return saveConfigSettings(self.settingsPath, self)

    @pyqtSlot(str, result=bool)
    def slotLoadProject(self, projectPath):
        if os.path.exists(projectPath):
            self.projectFolder = projectPath
            self.settingsPath = os.path.join(projectPath, 'dgs_config.txt')
            loaded = self.loadSettings()
            self.saveEnabled = True
            return loaded
        return False

    @pyqtSlot(str, str, result=bool)
    def slotCreateNewProject(self, projectPath, exampleID):
        if (os.path.exists(projectPath)):
            # create output subfolder
            self.settingsPath = os.path.join(projectPath, 'dgs_config.txt')
            self.outputPath = os.path.join(projectPath, 'output')
            os.makedirs(self.outputPath)
            if len(exampleID):
                pass
            else:
                self.saveEnabled = True
                loaded = self.saveSettings()
                self.saveEnabled = False
                loaded = self.loadSettings()
                self.saveEnabled = True
                return loaded
        return False


    # SIGNALS
    # required
    notifyGraphFilePathChanged = pyqtSignal(str, bool, arguments=["graphFilePath", "fileExistsAtPath"])
    notifyGraphFormatChanged = pyqtSignal(str, arguments=["format"])

    @pyqtSlot(str)
    def slotSetGraphFilePath(self, filePath):
        path = ''
        if len(filePath):
            path = composeAbsolutePath(filePath)
        exists = os.path.isfile(path)
        self.graphFilePath = path
        self.graphFilePathValid = exists
        self.notifyGraphFilePathChanged.emit(self.graphFilePath, exists)
        self.saveSettings()

    @pyqtSlot(str)
    def slotGraphFormat(self, format):
        self.graphFormat = format
        self.notifyGraphFormatChanged.emit(self.graphFormat)
        self.saveSettings()

    # Scheme / Clustering
    notifySchemeChanged = pyqtSignal(str, arguments=["scheme"])

    @pyqtSlot(str)
    def slotSetScheme(self, scheme):
        self.scheme = scheme
        self.notifySchemeChanged.emit(self.scheme)
        self.saveSettings()

    # Input
    notifyNodeOrderListPathChanged = pyqtSignal(str, bool, arguments=["orderListPath", "pathValid"])
    notifyFilterPathChanged = pyqtSignal(str, bool, arguments=["filterPath", "pathValid"])
    notifyOrderSeedChanged = pyqtSignal(str, bool, arguments=["randomSeed", "isValid"])
    notifyNodeWeightAttributeChanged = pyqtSignal(str, bool, arguments=["nodeWeightAttribute", "isValid"])
    notifyEdgeWeightAttributeChanged = pyqtSignal(str, bool, arguments=["edgeWeightAttribute", "isValid"])

    @pyqtSlot(str)
    def slotSetNodeOrderListPath(self, value):
        path = ''
        if len(value):
            path = composeAbsolutePath(value)
        exists = os.path.isfile(path)
        self.nodeOrderListPath = path
        self.nodeOrderListPathValid = exists
        self.notifyNodeOrderListPathChanged.emit(self.nodeOrderListPath, exists)
        self.saveSettings()

    @pyqtSlot(str)
    def slotSetFilterPath(self, value):
        path = ''
        if len(value):
            path = composeAbsolutePath(value)
        exists = os.path.exists(path)
        self.filterPath = path
        self.filterPathValid = exists
        self.notifyFilterPathChanged.emit(self.filterPath, exists)
        self.saveSettings()

    @pyqtSlot()
    def slotGenerateOrderSeed(self):
        self.orderSeed = generateRandomSeed()
        self.orderSeedValid = True
        self.notifyOrderSeedChanged.emit(str(self.orderSeed), True)
        self.saveSettings()

    @pyqtSlot(str)
    def slotSetOrderSeed(self, val):
        try:
            intVal = int(val)
            self.orderSeed = intVal
            self.orderSeedValid = True
            self.notifyOrderSeedChanged.emit(str(self.orderSeed), True)
            self.saveSettings()
        except ValueError as err:
            self.orderSeedValid = False
            self.notifyOrderSeedChanged.emit(val, False)

    @pyqtSlot(str)
    def slotSetNodeWeightAttribute(self, value):
        self.nodeWeightAttribute = value
        isValid = self.attributeRegex(value)
        self.notifyNodeWeightAttributeChanged.emit(self.nodeWeightAttribute, isValid)
        self.saveSettings()

    @pyqtSlot(str)
    def slotSetEdgeWeightAttribute(self, value):
        self.edgeWeightAttribute = value
        isValid = self.attributeRegex(value)
        self.notifyEdgeWeightAttributeChanged.emit(self.edgeWeightAttribute, isValid)
        self.saveSettings()


    # Partitioning
    notifyAssignmentsFilePathChanged = pyqtSignal(str, bool, arguments=["assignmentsPath", "fileExistsAtPath"])
    notifyPartitionSeedChanged = pyqtSignal(str, bool, arguments=["randomSeed", "isValid"])
    notifyAssignmentModeChanged = pyqtSignal(str, arguments=["assignmentsMode"])
    notifyNumPartitionsChanged = pyqtSignal(int, arguments=["numPartitions"])
    notifyLoadImbalanceChanged = pyqtSignal(float, arguments=["loadImbalance"])
    notifyPartitionWeights = pyqtSignal(str, bool, arguments=["partitionWeights", "isValid"])
    notifyVisiblePartitionsChanged = pyqtSignal(str, bool, arguments=["visiblePartitions", "isValid"])

    @pyqtSlot(str)
    def slotSetAssignmentsMode(self, value):
        self.assignmentsMode = value
        self.notifyAssignmentModeChanged.emit(self.assignmentsMode)
        self.saveSettings()

    @pyqtSlot(str)
    def slotSetAssignmentsFilePath(self, value):
        path = ''
        if len(value):
            path = composeAbsolutePath(value)
        exists = os.path.isfile(path)

        self.assignmentsPath = path
        self.assignmentsPathValid = exists
        self.notifyAssignmentsFilePathChanged.emit(self.assignmentsPath, exists)
        self.saveSettings()

    @pyqtSlot()
    def slotGeneratePartitionSeed(self):
        self.partitionSeed = generateRandomSeed()
        self.partitionSeedValid = True
        self.notifyPartitionSeedChanged.emit(str(self.partitionSeed), True)
        self.saveSettings()

    @pyqtSlot(str)
    def slotSetPartitionSeed(self, val):
        try:
            intVal = int(val)
            self.partitionSeedValid = True
            self.partitionSeed = intVal
            self.notifyPartitionSeedChanged.emit(str(self.partitionSeed), True)
            self.saveSettings()
        except ValueError as err:
            self.partitionSeedValid = False
            self.notifyPartitionSeedChanged.emit(val, False)

    @pyqtSlot(int)
    def slotSetNumPartitions(self, value):
        if value == self.numPartitions:
            return
        self.numPartitions = value
        self.notifyNumPartitionsChanged.emit(self.numPartitions)
        self.saveSettings()

    @pyqtSlot(float)
    def slotSetLoadImbalance(self, value):
        self.ubvec = float(int(1000.0 * value)) / 1000.0
        self.notifyLoadImbalanceChanged.emit(self.ubvec)
        self.saveSettings()

    @pyqtSlot(str)
    def slotSetPartitionWeightsChanged(self, value):
        value = value.replace(' ', '')
        parts = value.split(',')

        isValid = False

        weights = []
        lastWeight = 0.0

        if len(parts) == self.numPartitions:
            # valid so far
            total = 0.0
            for i, part in enumerate(parts):
                weight = 0.0
                try:
                    weight = float(part)
                    if(weight > 0.0):
                        if (i + 1) == self.numPartitions:
                            lastWeight = 1.0 - total
                        weights.append(weight)
                        total += weight

                except ValueError as err:
                    break
            if total == 1.0:
                isValid = True
            elif total >= 0.99 and total <= 1.0:
                if lastWeight > 0.0 and len(weights) == self.numPartitions:
                    weights[self.numPartitions - 1] = lastWeight
                isValid = True
            self.tpwgts = weights
            self.tpwgtsValid = isValid
            self.notifyPartitionWeights.emit('[' + value + ']', isValid)
            self.saveSettings()

    @pyqtSlot(str)
    def slotSetVisiblePartitions(self, value):
        value = value.replace(' ', '')
        parts = value.split(',')
        isValid = False
        partitions = []
        if len(parts) <= self.numPartitions:
            for part in parts:
                partition = 0
                try:
                    partition = int(part)
                    if partition > 0 and partition <= self.numPartitions:
                        partitions.append(partition)
                        isValid = True
                    else:
                        isValid = False
                        break
                except ValueError as err:
                    isValid = False
                    break
        self.visiblePartitions = partitions
        self.visiblePartitionsValid = isValid
        self.notifyVisiblePartitionsChanged.emit('[' + value + ']', isValid)
        self.saveSettings()


    # Layout
    notifyGraphLayoutChanged = pyqtSignal(str, arguments=["graphLayout"])
    notifyLayoutLinlogForceChanged = pyqtSignal(float, arguments=["linlogForce"])
    notifyLayoutAttractionChanged = pyqtSignal(float, arguments=["attraction"])
    notifyLayoutRepulsionChanged = pyqtSignal(float, arguments=["repulsion"])
    notifyLayoutRandomSeedChanged = pyqtSignal(str, bool, arguments=["randomSeed", "isValid"])

    @pyqtSlot(str)
    def slotSetGraphLayout(self, layout):
        self.graphLayout = layout
        self.notifyGraphLayoutChanged.emit(self.graphLayout)
        self.saveSettings()

    @pyqtSlot(float)
    def slotSetLayoutLinlogForce(self, force):
        force = force * 10.0
        force = float(int(force)) / 10.0
        self.layoutLinlogForce = force
        self.notifyLayoutLinlogForceChanged.emit(self.layoutLinlogForce)
        self.saveSettings()

    @pyqtSlot(float)
    def slotSetLayoutAttraction(self, attraction):
        attraction = attraction * 1000.0
        attraction = float(int(attraction)) / 1000.0
        self.layoutAttraction = attraction
        self.notifyLayoutAttractionChanged.emit(self.layoutAttraction)
        self.saveSettings()

    @pyqtSlot(float)
    def slotSetLayoutRepulsion(self, repulsion):
        factor = 1000.0
        if self.graphLayout == 'linlog':
            factor = 10.0
        repulsion = repulsion * factor
        repulsion = float(int(repulsion)) / factor
        self.layoutRepulsion = repulsion
        self.notifyLayoutRepulsionChanged.emit(self.layoutRepulsion)
        self.saveSettings()

    @pyqtSlot()
    def slotGenerateNewLayoutRandomSeed(self):
        self.layoutRandomSeed = generateRandomSeed()
        self.layoutRandomSeedValid = True
        self.notifyLayoutRandomSeedChanged.emit(str(self.layoutRandomSeed), True)
        self.saveSettings()

    @pyqtSlot(str)
    def slotSetLayoutSeed(self, val):
        try:
            intVal = int(val)
            self.layoutRandomSeedValid = True
            self.layoutRandomSeed = intVal
            self.notifyLayoutRandomSeedChanged.emit(str(self.layoutRandomSeed), True)
            self.saveSettings()
        except ValueError as err:
            self.layoutRandomSeedValid = False
            self.notifyLayoutRandomSeedChanged.emit(val, False)

    # COLORING
    notifyColorSchemeChanged = pyqtSignal(str, arguments=["colorScheme"])
    notifyNodeColorChanged = pyqtSignal(str, bool, arguments=["nodeColor", "colorValid"])
    notifyColoringRandomSeedChanged = pyqtSignal(str, bool, arguments=["randomSeed", "isValid"])
    notifyNodeShadowColorChanged = pyqtSignal(str, bool, arguments=["nodeShadowColor", "colorValid"])

    @pyqtSlot(str)
    def slotSetColorScheme(self, colorScheme):
        self.colorScheme = colorScheme
        self.notifyColorSchemeChanged.emit(self.colorScheme)
        self.saveSettings()

    @pyqtSlot(str)
    def slotSetNodeColor(self, nodeColor):
        self.nodeColor = nodeColor
        isValid = self.colorStringRegex(self.nodeColor)
        self.nodeColorValid = isValid
        self.notifyNodeColorChanged.emit(self.nodeColor, isValid)
        self.saveSettings()

    @pyqtSlot(str)
    def slotSetNodeShadowColor(self, nodeColor):
        self.nodeShadowColor = nodeColor
        isValid = self.colorStringRegex(self.nodeShadowColor)
        self.notifyNodeShadowColorChanged.emit(self.nodeShadowColor, isValid)
        self.saveSettings()


    @pyqtSlot()
    def slotGenerateNewColorRandomSeed(self):
        self.coloringSeed = generateRandomSeed()
        self.coloringSeedValid = True
        self.notifyColoringRandomSeedChanged.emit(str(self.coloringSeed), True)
        self.saveSettings()

    @pyqtSlot(str)
    def slotSetColoringSeed(self, val):
        try:
            intVal = int(val)
            self.coloringSeedValid = True
            self.coloringSeed = intVal
            self.notifyColoringRandomSeedChanged.emit(str(self.coloringSeed), True)
            self.saveSettings()
        except ValueError as err:
            self.coloringSeedValid = False
            self.notifyColoringRandomSeedChanged.emit(val, False)

    # image
    notifyImageNodeSizeModeChanged = pyqtSignal(str, arguments=["nodeSizeMode"])
    notifyImageNodeSizeChanged = pyqtSignal(int, arguments=["nodeSize"])
    notifyImageMinNodeSizeChanged = pyqtSignal(int, arguments=["minNodeSize"])
    notifyImageMaxNodeSizeChanged = pyqtSignal(int, arguments=["maxNodeSize"])
    notifyImageEdgeSizeChanged = pyqtSignal(int, arguments=["edgeSize"])
    notifyImageLabelSizeChanged = pyqtSignal(int, arguments=["labelSize"])
    notifyImageLabelTypeChanged = pyqtSignal(str, arguments=["labelType"])
    notifyImageBorderSizeChanged = pyqtSignal(int, arguments=["borderSize"])
    notifyImageWidthChanged = pyqtSignal(str, bool, arguments=["width", "isValid"])
    notifyImageHeightChanged = pyqtSignal(str, bool, arguments=["height", "isValid"])

    notifyImageCutEdgeLengthChanged = pyqtSignal(int, arguments=["cutEdgeLength"])
    notifyImageCutEdgeNodeSizeChanged = pyqtSignal(int, arguments=["cutEdgeNodeSize"])

    @pyqtSlot(str)
    def slotSetImageNodeSizeMode(self, value):
        self.imageNodeSizeMode = value
        self.notifyImageNodeSizeModeChanged.emit(self.imageNodeSizeMode)
        self.saveSettings()

    @pyqtSlot(int)
    def slotSetImageNodeSize(self, value):
        self.imageNodeSize = value
        self.notifyImageNodeSizeChanged.emit(self.imageNodeSize)
        self.saveSettings()

    @pyqtSlot(int)
    def slotSetImageMinNodeSize(self, value):
        self.imageMinNodeSize = value
        self.notifyImageMinNodeSizeChanged.emit(self.imageMinNodeSize)
        self.saveSettings()

    @pyqtSlot(int)
    def slotSetImageMaxNodeSize(self, value):
        self.imageMaxNodeSize = value
        self.notifyImageMaxNodeSizeChanged.emit(self.imageMaxNodeSize)
        self.saveSettings()

    @pyqtSlot(int)
    def slotSetImageEdgeSize(self, value):
        self.imageEdgeSize = value
        self.notifyImageEdgeSizeChanged.emit(self.imageEdgeSize)
        self.saveSettings()

    @pyqtSlot(int)
    def slotSetImageLabelSize(self, value):
        self.imageLabelSize = value
        self.notifyImageLabelSizeChanged.emit(self.imageLabelSize)
        self.saveSettings()

    @pyqtSlot(str)
    def slotSetImageLabelType(self, value):
        self.imageLabelType = value
        self.notifyImageLabelTypeChanged.emit(self.imageLabelType)
        self.saveSettings()

    @pyqtSlot(int)
    def slotSetImageBorderSize(self, value):
        self.imageBorderSize = value
        self.notifyImageBorderSizeChanged.emit(self.imageBorderSize)
        self.saveSettings()

    @pyqtSlot(int)
    def slotSetImageWidth(self, value):
        isValid = False
        if canConvertToInteger(value):
            self.imageWidth = int(value)
            isValid = (self.imageWidth > 0)
            self.imageWidthValid = True
        else:
            self.imageWidth = value
            self.imageWidthValid = False
        self.notifyImageWidthChanged.emit(str(self.imageWidth), isinstance(self.imageWidth, int))
        self.saveSettings()

    @pyqtSlot(int)
    def slotSetImageHeight(self, value):
        isValid = False
        if canConvertToInteger(value):
            self.imageHeight = int(value)
            isValid = (self.imageHeight > 0)
            self.imageHeightValid = True
        else:
            self.imageHeight = value
            self.imageHeightValid = False
        self.notifyImageHeightChanged.emit(str(self.imageHeight), isValid)
        self.saveSettings()

    @pyqtSlot(int)
    def slotSetImageCutEdgeLength(self, value):
        self.cutEdgeLength = value
        self.notifyImageCutEdgeLengthChanged.emit(self.cutEdgeLength)
        self.saveSettings()

    @pyqtSlot(int)
    def slotSetImageCutEdgeNodeSize(self, value):
        self.cutEdgeNodeSize = value
        self.notifyImageCutEdgeNodeSizeChanged.emit(self.cutEdgeNodeSize)
        self.saveSettings()


    # Output
    notifyOutputPathChanged = pyqtSignal(str, bool, arguments=["outputPath", "folderExists"])

    @pyqtSlot(str)
    def slotSetOutputPath(self, outputPath):
        path = ''
        if len(outputPath):
            path = composeAbsolutePath(outputPath)
        self.outputPath = path
        self.computeFullVideoPath()
        exists = os.path.exists(self.outputPath)
        self.notifyOutputPathChanged.emit(self.outputPath, exists)
        self.saveSettings()


    # VIDEO
    notifyVideoPathChanged = pyqtSignal(str, arguments=["videoPath"])
    notifyVideoFPSChanged = pyqtSignal(int, arguments=["fps"])
    notifyVideoPaddingTimeChanged = pyqtSignal(float, arguments=["paddingTime"])
    notifyVideoFullPathChanged = pyqtSignal(str, bool, arguments=["videoFullPath", "isValid"])

    @pyqtSlot(str)
    def slotSetVideoPath(self, videoPath):
        self.videoPath = videoPath
        self.videoPathValid = True
        self.computeFullVideoPath()
        self.notifyVideoPathChanged.emit(self.videoPath)
        self.saveSettings()

    @pyqtSlot(int)
    def slotSetVideoFPS(self, videoFPS):
        self.videoFPS = videoFPS
        self.notifyVideoFPSChanged.emit(self.videoFPS)
        self.saveSettings()

    @pyqtSlot(float)
    def slotSetVideoPaddingTime(self, videoPaddingTime):
        videoPaddingTime = float(int(videoPaddingTime * 10.0)) / 10.0
        self.videoPaddingTime = videoPaddingTime
        self.notifyVideoPaddingTimeChanged.emit(self.videoPaddingTime)
        self.saveSettings()

    # PDF
    notifyPDFEnabledChanged = pyqtSignal(bool, arguments=["enabled"])
    notifyPDFFramePercentageChanged = pyqtSignal(int, arguments=["pdfFramePercentage"])

    @pyqtSlot(bool)
    def slotSetPDFEnabled(self, enabled):
        self.pdfEnabled = enabled
        self.notifyPDFEnabledChanged.emit(self.pdfEnabled)
        self.saveSettings()

    @pyqtSlot(int)
    def slotSetPDFFramePercentage(self, percentage):
        self.pdfFramePercentage = percentage
        self.notifyPDFFramePercentageChanged.emit(self.pdfFramePercentage)
        self.saveSettings()

    notifyClusteringChanged = pyqtSignal(str, arguments=["clustering"])
    notifyClusterSeedChanged = pyqtSignal(str, bool, arguments=["randomSeed", "isValid"])
    notifyInfomapCallsChanged = pyqtSignal(int, arguments=["infomapCalls"])


    @pyqtSlot(str)
    def slotSetClusteringMode(self, value):
        self.clustering = value
        self.notifyClusteringChanged.emit(self.clustering)
        self.saveSettings()

    @pyqtSlot()
    def slotGenerateClusterSeed(self):
        self.clusterSeed = generateRandomSeed()
        self.clusterSeedValid = True
        self.notifyClusterSeedChanged.emit(str(self.clusterSeed), True)
        self.saveSettings()

    @pyqtSlot(str)
    def slotSetClusterSeed(self, val):
        try:
            intVal = int(val)
            self.clusterSeed = intVal
            self.clusterSeedValid = True
            self.notifyClusterSeedChanged.emit(str(self.clusterSeed), True)
            self.saveSettings()
        except ValueError as err:
            self.clusterSeedValid = False
            self.notifyClusterSeedChanged.emit(val, False)

    @pyqtSlot(int)
    def slotSetInfomapCalls(self, value):
        self.infomapCalls = value
        self.notifyInfomapCallsChanged.emit(self.infomapCalls)
        self.saveSettings()
