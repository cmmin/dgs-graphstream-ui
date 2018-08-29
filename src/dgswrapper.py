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
        #QThread.__init__(parent)
        self.dgsWrapper = dgsWrapper
        self.process = None

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
            output = line.decode('utf8').strip()
            now = datetime.datetime.now()
            tstamp = now.strftime("%H:%M:%S.")
            tstamp += now.strftime("%f")[:2]
            self.notifyProcessOutputAvailable.emit(output, tstamp)


    def run(self):
        print('DGSRunner::run starting runner thread')

        dgsPath = '/Users/voreno/Development/graphstream/dgs-graphstream'
        inputPath = '/Users/voreno/Development/graphstream/dgs-graphstream/inputs'
        outputPath = '/Users/voreno/Development/graphstream/dgs-graphstream/output'

        # compute the arguments list
        '''
        args = ['python3', os.path.join(dgsPath, 'genGraphStream.py'), '-s', 'communities', '-g', os.path.join(inputPath, 'network_1.txt'), '-f', 'metis', '-a', os.path.join(inputPath, 'assignments.txt'), '-o', outputPath, '--video', os.path.join(outputPath, 'vid.mp4')]

        print(args)

        log = ''
        # call the subprocess
        self.process = subprocess.Popen(args, cwd=dgsPath, stderr=subprocess.PIPE)

        '''
        args = ['python3', 'dummyRunScript.py']
        self.process = subprocess.Popen(args, stderr=subprocess.PIPE)

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
    def __init__(self, simulationParams):
        QObject.__init__(self)

        self.simulationParams = simulationParams
        self.defaultParams = DGSDefaultParams()

        self.runner = DGSRunner(self, self)
        self.runner.finished.connect(self.runnerFinished)
        self.runner.notifyProcessOutputAvailable.connect(self.notifyOutputAvailable)

    notifyRunnerFinished = pyqtSignal()
    notifyRunnerStarted = pyqtSignal()
    notifyOutputAvailable = pyqtSignal(str, str, arguments=["output", "timestamp"])

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
        self.runner.start()
        self.runnerStarted()
