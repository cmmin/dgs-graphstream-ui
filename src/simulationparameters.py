import os
import re

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

        self.scheme = 'communities'
        self.graphFormat = 'metis'
        self.graphFilePath = ''

        self.outputPath = ''

        self.nodeOrderListPath = ''
        self.filterPath = ''
        self.orderSeed = generateRandomSeed()
        self.nodeWeightAttribute = 'weight'
        self.edgeWeightAttribute = 'weight'

        self.assignmentsPath = ''
        self.partitionSeed = generateRandomSeed()
        self.visiblePartitions = []

        self.randomAssignments = False
        self.numPartitions = 4
        self.ubvec = 1.001
        self.tpwgts = [] # only with nparts
        #self.showPartitions = False

        self.graphLayout = 'springbox'
        self.layoutLinlogForce = 3.0
        self.layoutAttraction = 0.012
        self.layoutRepulsion = 0.024
        self.layoutRandomSeed = generateRandomSeed()

        self.colorScheme = 'pastel'
        self.nodeColor = ''
        self.coloringSeed = generateRandomSeed()
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

        self.cutEdgeLength = 50
        self.cutEdgeNodeSize = 10

        self.videoPath = ""
        self.videoFullPath = ""
        self.videoFPS = 8
        self.videoPaddingTime = 2.0

        self.pdfEnabled = False
        self.pdfFramePercentage = 20

        self.clustering = 'oslom2'
        self.clusterSeed = generateRandomSeed()
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
        self.videoFullPath = os.path.join(self.outputPath, self.videoPath)
        ok = self.videoFileStringRegexCheck(self.videoFullPath)
        self.notifyVideoFullPathChanged.emit(self.videoFullPath, ok)

    # SIGNALS
    # required
    notifyGraphFilePathChanged = pyqtSignal(str, bool, arguments=["graphFilePath", "fileExistsAtPath"])
    notifyGraphFormatChanged = pyqtSignal(str, arguments=["format"])

    @pyqtSlot(str)
    def slotSetGraphFilePath(self, filePath):
        path = composeAbsolutePath(filePath)
        exists = os.path.isfile(path)
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

    # Input
    notifyNodeOrderListPathChanged = pyqtSignal(str, bool, arguments=["orderListPath", "pathValid"])
    notifyFilterPathChanged = pyqtSignal(str, bool, arguments=["filterPath", "pathValid"])
    notifyOrderSeedChanged = pyqtSignal(int, arguments=["randomSeed"])
    notifyNodeWeightAttributeChanged = pyqtSignal(str, bool, arguments=["nodeWeightAttribute", "isValid"])
    notifyEdgeWeightAttributeChanged = pyqtSignal(str, bool, arguments=["edgeWeightAttribute", "isValid"])

    @pyqtSlot(str)
    def slotSetNodeOrderListPath(self, value):
        path = composeAbsolutePath(value)
        exists = os.path.exists(path)
        self.nodeOrderListPath = path
        self.notifyNodeOrderListPathChanged.emit(self.nodeOrderListPath, exists)

    @pyqtSlot(str)
    def slotSetFilterPath(self, value):
        path = composeAbsolutePath(value)
        exists = os.path.exists(path)
        self.filterPath = path
        self.notifyFilterPathChanged.emit(self.filterPath, exists)

    @pyqtSlot()
    def slotGenerateOrderSeed(self):
        self.orderSeed = generateRandomSeed()
        self.notifyOrderSeedChanged.emit(self.orderSeed)

    @pyqtSlot(str)
    def slotSetNodeWeightAttribute(self, value):
        self.nodeWeightAttribute = value
        isValid = self.attributeRegex(value)
        self.notifyNodeWeightAttributeChanged.emit(self.nodeWeightAttribute, isValid)

    @pyqtSlot(str)
    def slotSetEdgeWeightAttribute(self, value):
        self.edgeWeightAttribute = value
        isValid = self.attributeRegex(value)
        self.notifyEdgeWeightAttributeChanged.emit(self.edgeWeightAttribute, isValid)


    # Partitioning
    notifyAssignmentsFilePathChanged = pyqtSignal(str, bool, arguments=["assignmentsPath", "fileExistsAtPath"])
    notifyPartitionSeedChanged = pyqtSignal(int, arguments=["randomSeed"])
    notifyRandomAssignmentsChanged = pyqtSignal(bool, arguments=["randomAssignments"])
    notifyNumPartitionsChanged = pyqtSignal(int, arguments=["numPartitions"])
    notifyLoadImbalanceChanged = pyqtSignal(float, arguments=["loadImbalance"])
    notifyPartitionWeights = pyqtSignal(str, bool, arguments=["partitionWeights", "isValid"])
    notifyVisiblePartitionsChanged = pyqtSignal(str, bool, arguments=["visiblePartitions", "isValid"])

    @pyqtSlot(str)
    def slotSetAssignmentsFilePath(self, value):
        path = composeAbsolutePath(value)
        exists = os.path.isfile(path)

        self.assignmentsPath = path
        # todo: check for path
        isValid = True
        self.notifyAssignmentsFilePathChanged.emit(self.assignmentsPath, exists)

    @pyqtSlot()
    def slotGeneratePartitionSeed(self):
        self.partitionSeed = generateRandomSeed()
        self.notifyPartitionSeedChanged.emit(self.partitionSeed)

    @pyqtSlot(bool)
    def slotSetRandomAssignments(self, value):
        self.randomAssignments = value
        self.notifyRandomAssignmentsChanged.emit(self.randomAssignments)

    @pyqtSlot(int)
    def slotSetNumPartitions(self, value):
        self.numPartitions = value
        self.notifyNumPartitionsChanged.emit(self.numPartitions)

    @pyqtSlot(float)
    def slotSetLoadImbalance(self, value):
        self.ubvec = float(int(1000.0 * value)) / 1000.0
        self.notifyLoadImbalanceChanged.emit(self.ubvec)

    @pyqtSlot(str)
    def slotSetPartitionWeightsChanged(self, value):
        value = value.replace(' ', '')
        parts = value.split(',')

        isValid = False

        weights = []

        if len(parts) == self.numPartitions:
            # valid so far
            total = 0.0
            for part in parts:
                weight = 0.0
                try:
                    weight = float(part)
                    if(weight > 0.0):
                        weights.append(weight)
                        total += weight
                except ValueError as err:
                    break
            if total == 1.0:
                isValid = True
        self.tpwgts = weights

        self.notifyPartitionWeights.emit('[' + value + ']', isValid)

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
        self.notifyVisiblePartitionsChanged.emit('[' + value + ']', isValid)


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

    # COLORING
    notifyColorSchemeChanged = pyqtSignal(str, arguments=["colorScheme"])
    notifyNodeColorChanged = pyqtSignal(str, bool, arguments=["nodeColor", "colorValid"])
    notifyColoringRandomSeedChanged = pyqtSignal(int, arguments=["randomSeed"])
    notifyNodeShadowColorChanged = pyqtSignal(str, bool, arguments=["nodeShadowColor", "colorValid"])

    @pyqtSlot(str)
    def slotSetColorScheme(self, colorScheme):
        self.colorScheme = colorScheme
        self.notifyColorSchemeChanged.emit(self.colorScheme)

    @pyqtSlot(str)
    def slotSetNodeColor(self, nodeColor):
        self.nodeColor = nodeColor
        isValid = self.colorStringRegex(self.nodeColor)
        self.notifyNodeColorChanged.emit(self.nodeColor, isValid)

    @pyqtSlot(str)
    def slotSetNodeShadowColor(self, nodeColor):
        self.nodeShadowColor = nodeColor
        isValid = self.colorStringRegex(self.nodeShadowColor)
        self.notifyNodeShadowColorChanged.emit(self.nodeShadowColor, isValid)


    @pyqtSlot()
    def slotGenerateNewColorRandomSeed(self):
        self.coloringSeed = generateRandomSeed()
        self.notifyColoringRandomSeedChanged.emit(self.coloringSeed)

    # image
    notifyImageNodeSizeModeChanged = pyqtSignal(str, arguments=["nodeSizeMode"])
    notifyImageNodeSizeChanged = pyqtSignal(int, arguments=["nodeSize"])
    notifyImageMinNodeSizeChanged = pyqtSignal(int, arguments=["minNodeSize"])
    notifyImageMaxNodeSizeChanged = pyqtSignal(int, arguments=["maxNodeSize"])
    notifyImageEdgeSizeChanged = pyqtSignal(int, arguments=["edgeSize"])
    notifyImageLabelSizeChanged = pyqtSignal(int, arguments=["labelSize"])
    notifyImageLabelTypeChanged = pyqtSignal(str, arguments=["labelType"])
    notifyImageBorderSizeChanged = pyqtSignal(int, arguments=["borderSize"])
    notifyImageWidthChanged = pyqtSignal(int, bool, arguments=["width", "isValid"])
    notifyImageHeightChanged = pyqtSignal(int, bool, arguments=["height", "isValid"])

    notifyImageCutEdgeLengthChanged = pyqtSignal(int, arguments=["cutEdgeLength"])
    notifyImageCutEdgeNodeSizeChanged = pyqtSignal(int, arguments=["cutEdgeNodeSize"])

    @pyqtSlot(str)
    def slotSetImageNodeSizeMode(self, value):
        self.imageNodeSizeMode = value
        self.notifyImageNodeSizeModeChanged.emit(self.imageNodeSizeMode)

    @pyqtSlot(int)
    def slotSetImageNodeSize(self, value):
        self.imageNodeSize = value
        self.notifyImageNodeSizeChanged.emit(self.imageNodeSize)

    @pyqtSlot(int)
    def slotSetImageMinNodeSize(self, value):
        self.imageMinNodeSize = value
        self.notifyImageMinNodeSizeChanged.emit(self.imageMinNodeSize)

    @pyqtSlot(int)
    def slotSetImageMaxNodeSize(self, value):
        self.imageMaxNodeSize = value
        self.notifyImageMaxNodeSizeChanged.emit(self.imageMaxNodeSize)

    @pyqtSlot(int)
    def slotSetImageEdgeSize(self, value):
        self.imageEdgeSize = value
        self.notifyImageEdgeSizeChanged.emit(self.imageEdgeSize)

    @pyqtSlot(int)
    def slotSetImageLabelSize(self, value):
        self.imageLabelSize = value
        self.notifyImageLabelSizeChanged.emit(self.imageLabelSize)

    @pyqtSlot(str)
    def slotSetImageLabelType(self, value):
        self.imageLabelType = value
        self.notifyImageLabelTypeChanged.emit(self.imageLabelType)

    @pyqtSlot(int)
    def slotSetImageBorderSize(self, value):
        self.imageBorderSize = value
        self.notifyImageBorderSizeChanged.emit(self.imageBorderSize)

    @pyqtSlot(int)
    def slotSetImageWidth(self, value):
        isValid = False
        if canConvertToInteger(value):
            self.imageWidth = int(value)
            isValid = (self.imageWidth > 0)
        else:
            self.imageWidth = value
        self.notifyImageWidthChanged.emit(self.imageWidth, isinstance(self.imageWidth, int))

    @pyqtSlot(int)
    def slotSetImageHeight(self, value):
        isValid = False
        if canConvertToInteger(value):
            self.imageHeight = int(value)
            isValid = (self.imageHeight > 0)
        else:
            self.imageHeight = value
        self.notifyImageHeightChanged.emit(self.imageHeight, isValid)

    @pyqtSlot(int)
    def slotSetImageCutEdgeLength(self, value):
        self.cutEdgeLength = value
        self.notifyImageCutEdgeLengthChanged.emit(self.cutEdgeLength)

    @pyqtSlot(int)
    def slotSetImageCutEdgeNodeSize(self, value):
        self.cutEdgeNodeSize = value
        self.notifyImageCutEdgeNodeSizeChanged.emit(self.cutEdgeNodeSize)


    # Output
    notifyOutputPathChanged = pyqtSignal(str, bool, arguments=["outputPath", "folderExists"])

    @pyqtSlot(str)
    def slotSetOutputPath(self, outputPath):
        self.outputPath = composeAbsolutePath(outputPath)
        self.computeFullVideoPath()
        exists = os.path.exists(self.outputPath)
        self.notifyOutputPathChanged.emit(self.outputPath, exists)


    # VIDEO
    notifyVideoPathChanged = pyqtSignal(str, arguments=["videoPath"])
    notifyVideoFPSChanged = pyqtSignal(int, arguments=["fps"])
    notifyVideoPaddingTimeChanged = pyqtSignal(float, arguments=["paddingTime"])
    notifyVideoFullPathChanged = pyqtSignal(str, bool, arguments=["videoFullPath", "isValid"])

    @pyqtSlot(str)
    def slotSetVideoPath(self, videoPath):
        self.videoPath = videoPath
        self.computeFullVideoPath()
        self.notifyVideoPathChanged.emit(self.videoPath)

    @pyqtSlot(int)
    def slotSetVideoFPS(self, videoFPS):
        self.videoFPS = videoFPS
        self.notifyVideoFPSChanged.emit(self.videoFPS)

    @pyqtSlot(float)
    def slotSetVideoPaddingTime(self, videoPaddingTime):
        videoPaddingTime = float(int(videoPaddingTime * 10.0)) / 10.0
        self.videoPaddingTime = videoPaddingTime
        self.notifyVideoPaddingTimeChanged.emit(self.videoPaddingTime)

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

    notifyClusteringChanged = pyqtSignal(str, arguments=["clustering"])
    notifyClusterSeedChanged = pyqtSignal(int, arguments=["randomSeed"])
    notifyInfomapCallsChanged = pyqtSignal(int, arguments=["infomapCalls"])


    @pyqtSlot(str)
    def slotSetClusteringMode(self, value):
        self.clustering = value
        self.notifyClusteringChanged.emit(self.clustering)

    @pyqtSlot()
    def slotGenerateClusterSeed(self):
        self.clusterSeed = generateRandomSeed()
        self.notifyClusterSeedChanged.emit(self.clusterSeed)

    @pyqtSlot(int)
    def slotSetInfomapCalls(self, value):
        self.infomapCalls = value
        self.notifyInfomapCallsChanged.emit(self.infomapCalls)
