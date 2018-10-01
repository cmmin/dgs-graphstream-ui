import os
from os import walk
from distutils.dir_util import copy_tree
from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot
#import ipdb; debug=ipdb.set_trace

class ExampleManager(QObject):
    def __init__(self, parent = None):
        QObject.__init__(self, parent)

        self.exampleData = {}

    @pyqtSlot(result=int)
    def count(self):
        return len(self.exampleData.keys())

    @pyqtSlot(int, result=str)
    def at(self, i):
        return list(self.exampleData.keys())[i]

    def load(self, examplesPath):
        self.exampleData = loadExampleFolders(examplesPath)

    @pyqtSlot(str, str, result=bool)
    def createExample(self, exampleKey, destinationFolder):
        try:
            createExampleData(self.exampleData[exampleKey].examplePath, destinationFolder)
            return True
        except Exception as err:
            return False

    @pyqtSlot(result=list)
    def examples(self):
        return list(self.exampleData.keys())

    @pyqtSlot(str, result=str)
    def exampleTitle(self, key):
        val = ''
        try:
            val = self.exampleData[key].title
        except Exception as err:
            pass
        return val

    @pyqtSlot(str, result=str)
    def exampleDescription(self, key):
        val = ''
        try:
            val = self.exampleData[key].description
        except Exception as err:
            pass
        return val

    @pyqtSlot(str, result=str)
    def examplePath(self, key):
        val = ''
        try:
            val = self.exampleData[key].examplePath
        except Exception as err:
            pass
        return val

class Example:
    def __init__(self, examplePath, folderName):
        self.examplePath = examplePath
        self.folderName = folderName
        self.title = ''
        self.description = ''

        self.loadMetadata()

    def loadMetadata(self):
        if os.path.exists(self.examplePath):
            infofile = os.path.join(self.examplePath, 'info.txt')
            if os.path.exists(infofile):
                with open(infofile, 'r') as f:
                    for line in f:
                        line = line.strip()
                        parts = line.split('=')
                        if len(parts) == 2:
                            key = parts[0]
                            value = parts[1]
                            if key == 'title':
                                self.title = value
                            if key == 'description':
                                self.description = value
            else:
                self.title = self.folderName

def loadExampleFolders(examplesFolderPath):
    if not os.path.isdir(examplesFolderPath):
        os.makedirs(examplesFolderPath)

    examples = {}
    keys = []
    values = []
    keys = next(os.walk(examplesFolderPath))[1]

    for x in keys:
        values.append(Example(os.path.join(examplesFolderPath, x ), x))
        #values.append(os.path.join(examplesFolderPath, x ))

    examples = dict(zip(keys, values))
    return examples

def createExampleData(exampleFullPath,destinationFullPath):
    copy_tree(exampleFullPath, destinationFullPath)
    updateDgsConfigValues(destinationFullPath)

def updateDgsConfigValues(destinationFullPath):
    lines = []
    configPath = os.path.join(destinationFullPath, 'dgs_config.txt')
    with open(configPath, 'r+') as f:
        for line in f:
            lines.append(line.strip())
        f.truncate()
        f.seek(0)

        for line in lines:
            lineToWrite = line
            if 'path' in line or 'Path' in line:
                key = ''
                value = ''
                parts = line.split('=')
                if len(parts) == 2:
                    key = parts[0]
                    value = parts[1]

                    if len(value):
                        value = os.path.join(destinationFullPath, value)
                        lineToWrite = key + '=' + value

            f.write(lineToWrite + '\n')

if __name__ == '__main__':

    examplesFolderPath = "/Users/voreno/Development/graphstream/dgs-graphstream-ui/examples"
    examples = loadExampleFolders(examplesFolderPath)
    print(examples)

    destinationFullPath = "/Users/voreno/Desktop/tt/turd"
    createExampleData(examples['ex1'].examplePath, destinationFullPath)
