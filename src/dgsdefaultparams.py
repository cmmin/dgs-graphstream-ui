class DGSDefaultParams:
    def __init__(self):
        self.scheme = 'communities'
        self.graphFormat = 'metis'
        self.graphFilePath = ''

        self.outputPath = ''

        self.nodeOrderListPath = ''
        self.filterPath = ''
        self.orderSeed = -1
        self.nodeWeightAttribute = 'weight'
        self.edgeWeightAttribute = 'weight'

        self.assignmentsPath = ''
        self.partitionSeed = -1
        self.visiblePartitions = []

        self.randomAssignments = False
        self.numPartitions = 4
        self.ubvec = 1.001
        self.tpwgts = [] # only with nparts

        self.graphLayout = 'springbox'
        self.layoutLinlogForce = 3.0
        self.layoutAttraction = 0.012
        self.layoutRepulsion = 0.024
        self.layoutRandomSeed = -1

        self.colorScheme = 'pastel'
        self.nodeColor = ''
        self.coloringSeed = -1
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
        self.clusterSeed = -1
        self.infomapCalls = 0
