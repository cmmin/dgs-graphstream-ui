import os
import subprocess
import datetime

from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, QThread

from dgsdefaultparams import DGSDefaultParams

# -s communities -g inputs/network_1.txt -f metis -a ./inputs/assignments.txt -o output/ --video ./output/vid.mp4
# -s communities -g inputs/network_1.txt -f metis -a ./inputs/assignments.txt -o output/ --video ./output/vid.mp4


class DGSRunner(QThread):
    def __init__(self, dgsWrapper, parent=None):
        super(DGSRunner, self).__init__(parent)
        self.dgsWrapper = dgsWrapper
        self.simulationParams = dgsWrapper.simulationParams
        self.settings = dgsWrapper.settings

        self.process = None
        self.args = []

    def __del__(self):
        self.wait()

    notifyProcessOutputAvailable = pyqtSignal(str, str, arguments=['output', 'timestamp'])

    def terminate(self):
        if self.process:
            print('DGSRunner::terminate DGSRunner.terminate()')
            self.process.terminate()
            self.finished.emit()

    def _checkLineOutput(self, line):
        if(len(line)):
            output = None
            if type(line) is str:
                output = line
            else:
                output = line.decode('utf8').strip()
            now = datetime.datetime.now()
            tstamp = now.strftime("%H:%M:%S.")
            tstamp += now.strftime("%f")[:2]
            self.notifyProcessOutputAvailable.emit(output, tstamp)

    def run(self):
        print('DGSRunner::run starting runner thread')

        #args = self.buildArgs()
        self._checkLineOutput(' '.join(self.args))
        #print(' '.join(a))
        #return

        '''
        dgsPath = '/Users/voreno/Development/graphstream/dgs-graphstream'
        inputPath = '/Users/voreno/Development/graphstream/dgs-graphstream/inputs'
        outputPath = '/Users/voreno/Development/graphstream/dgs-graphstream/output'

        args = ['python3', os.path.join(dgsPath, 'genGraphStream.py'), '-s', 'communities', '-g', os.path.join(inputPath, 'network_1.txt'), '-f', 'metis', '-a', os.path.join(inputPath, 'assignments.txt'), '-o', outputPath, '--video', os.path.join(outputPath, 'vid.mp4')]
        print(args)
        log = ''
        # call the subprocess
        #self.process = subprocess.Popen(args, cwd=dgsPath, stderr=subprocess.PIPE)
        '''
        self.process = subprocess.Popen(self.args, stderr=subprocess.PIPE,cwd=self.settings.dgsProgramDirectory)

        while self.process.returncode is None:
            try:
                line = self.process.stderr.readline()
                self._checkLineOutput(line)
                while(len(line)):
                    line = self.process.stderr.readline()
                    self._checkLineOutput(line)
                self.process.wait(1)
            except subprocess.TimeoutExpired as err:
                pass

class DGSWrapper(QObject):
    def __init__(self, simulationParams, settings):
        QObject.__init__(self)

        self.simulationParams = simulationParams
        self.defaultParams = DGSDefaultParams()
        self.settings = settings

        self.numErrors = 0

        self.runner = DGSRunner(self, self)
        self.runner.finished.connect(self.runnerFinished)
        self.runner.notifyProcessOutputAvailable.connect(self.notifyOutputAvailable)

    notifyRunnerFinished = pyqtSignal()
    notifyRunnerStarted = pyqtSignal()
    notifyOutputAvailable = pyqtSignal(str, str, arguments=["output", "timestamp"])
    notifyErrorCount = pyqtSignal(int, arguments=["errors"])

    def runnerFinished(self):
        print("DGSWrapper::runnerFinished Runner thread FINISHED.")
        self.notifyRunnerFinished.emit()

    def runnerStarted(self):
        print("DGSWrapper::runnerStarted Runner thread STARTED")
        self.notifyRunnerStarted.emit()

    @pyqtSlot()
    def stop(self):
        self.runner.terminate()

    @pyqtSlot()
    def run(self):
        self.runner.args = self.buildArgs()
        if(self.numErrors == 0):
            self.runner.start()
            self.runnerStarted()

    @pyqtSlot(result=int)
    def checkForParamErrors(self):
        self.buildArgs()
        self.notifyErrorCount.emit(self.numErrors)
        return self.numErrors

    def buildArgs(self):
        self.numErrors = 0

        args = ['python3', 'genGraphStream.py']

        # output
        args.append('-o')
        # compute relative path from dgsgraphstream to the output folder
        # OSLOM2 fails if we give it an absolute path
        relOutputPath = self.simulationParams.outputPath
        try:
            relOutputPath = os.path.relpath(self.simulationParams.outputPath, self.settings.dgsProgramDirectory)
        except Exception as err:
            pass
        args.append(relOutputPath)

        # graph file
        args.append('-g')
        # @todo check valid
        args.append(self.simulationParams.graphFilePath)

        if self.simulationParams.graphFilePathValid == False:
            self.numErrors += 1

        # format
        args.append('-f')
        args.append(self.simulationParams.graphFormat)

        # order file list
        if(len(self.simulationParams.nodeOrderListPath)):
            args.append('-n')
            # @todo check exists
            args.append(self.simulationParams.nodeOrderListPath)

            if self.simulationParams.nodeOrderListPathValid == False:
                self.numErrors += 1

            args.append('--order-seed')
            args.append(str(self.simulationParams.orderSeed))

            if self.simulationParams.orderSeedValid == False:
                self.numErrors += 1

        if len(self.simulationParams.filterPath):
            args.append('--filter')
            # @todo check exists
            args.append(self.simulationParams.filterPath)

            if self.simulationParams.filterPathValid == False:
                self.numErrors += 1

        # partitioning
        if self.simulationParams.assignmentsMode == 'file':
            args.append('-a')
            args.append(self.simulationParams.assignmentsPath)

            if self.simulationParams.assignmentsPathValid == False:
                self.numErrors += 1

        else:
            args.append('--nparts')
            args.append(str(self.simulationParams.numPartitions))

            args.append('--tpwgts')
            for w in self.simulationParams.tpwgts:
                args.append(str(w))

            if self.simulationParams.tpwgtsValid == False:
                self.numErrors += 1

            if self.simulationParams.assignmentsMode == 'random':
                args.append('--random-assignments')
                args.append('--partition-seed')
                args.append(str(self.simulationParams.partitionSeed))

                if self.simulationParams.partitionSeedValid == False:
                    self.numErrors += 1

            else:
                args.append('--ubvec')
                args.append(str(self.simulationParams.ubvec))

        if len(self.simulationParams.visiblePartitions):
            args.append('--show-partitions')
            for p in self.simulationParams.visiblePartitions:
                args.append(str(p))

            if self.simulationParams.visiblePartitionsValid == False:
                self.numErrors += 1

        # scheme and clustering
        scheme = self.simulationParams.scheme
        clustering = self.simulationParams.clustering

        args.append('-s')
        args.append(scheme)

        if scheme == 'communities':
            args.append('-c')
            args.append(clustering)

            if clustering != 'graphviz':
                args.append('--cluster-seed')
                args.append(str(self.simulationParams.clusterSeed))

                if self.simulationParams.clusterSeedValid == False:
                    self.numErrors += 1

            if clustering == 'oslom2':
                args.append('--infomap-calls')
                args.append(str(self.simulationParams.infomapCalls))
        else:
            # edges cut scheme
            args.append('--cut-edge-length')
            args.append(str(self.simulationParams.cutEdgeLength))
            args.append('--cut-edge-node-size')
            args.append(str(self.simulationParams.cutEdgeNodeSize))


        # layout properties
        args.append('-l')
        args.append(self.simulationParams.graphLayout)

        args.append('--layout-seed')
        args.append(str(self.simulationParams.layoutRandomSeed))

        if self.simulationParams.layoutRandomSeedValid == False:
            self.numErrors += 1

        args.append('--attraction')
        args.append(str(self.simulationParams.layoutAttraction))
        args.append('--repulsion')
        args.append(str(self.simulationParams.layoutRepulsion))

        if(self.simulationParams.graphLayout == 'linlog'):
            args.append('--force')
            args.append(str(self.simulationParams.layoutLinlogForce))

        #coloring

        if self.simulationParams.colorScheme != 'node-color':
            args.append('--color-scheme')
            args.append(self.simulationParams.colorScheme)
        else:
            if(len(self.simulationParams.nodeColor)) and self.simulationParams.colorScheme == 'node-color':
                #@todo check valid color
                args.append('--node-color')
                args.append(self.simulationParams.nodeColor)

                if self.simulationParams.nodeColorValid == False:
                    self.numErrors += 1

        args.append('--color-seed')
        args.append(str(self.simulationParams.coloringSeed))

        if self.simulationParams.coloringSeedValid == False:
            self.numErrors += 1

        # image properties
        args.append('--width')
        args.append(str(self.simulationParams.imageWidth))

        if self.simulationParams.imageWidthValid == False:
            self.numErrors += 1

        args.append('--height')
        args.append(str(self.simulationParams.imageHeight))

        if self.simulationParams.imageHeightValid == False:
            self.numErrors += 1

        args.append('--border-size')
        args.append(str(self.simulationParams.imageBorderSize))
        args.append('--label-type')
        args.append(self.simulationParams.imageLabelType)
        args.append('--label-size')
        args.append(str(self.simulationParams.imageLabelSize))

        args.append('--node-size-mode')
        args.append(self.simulationParams.imageNodeSizeMode)
        if self.simulationParams.imageNodeSizeMode == 'fixed':
            args.append('--node-size')
            args.append(str(self.simulationParams.imageNodeSize))
        else:
            args.append('--min-node-size')
            args.append(str(self.simulationParams.imageMinNodeSize))
            args.append('--max-node-size')
            args.append(str(self.simulationParams.imageMaxNodeSize))

        args.append('--edge-size')
        args.append(str(self.simulationParams.imageEdgeSize))

        # video
        args.append('--video')
        args.append(self.simulationParams.videoFullPath)

        if self.simulationParams.videoPathValid == False:
            self.numErrors += 1

        args.append('--fps')
        args.append(str(self.simulationParams.videoFPS))
        args.append('--padding-time')
        args.append(str(self.simulationParams.videoPaddingTime))

        # pdf
        if self.simulationParams.pdfEnabled:
            args.append('--pdf')
            args.append(str(self.simulationParams.pdfFramePercentage))

        return args
