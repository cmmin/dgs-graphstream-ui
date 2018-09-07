import subprocess
import os
import datetime

#     args = ['python3', os.path.join(dgsPath, 'genGraphStream.py'), '-s', 'communities', '-g', os.path.join(inputPath, 'network_1.txt'), '-f', 'metis', '-a', os.path.join(inputPath, 'assignments.txt'), '-o', outputPath --video vid.mp4
#python3 genGraphStream.py -s communities -g inputs/network_1.txt -f metis -a ./inputs/assignments.txt -o output/ --video ./output/vid.mp4 --node-size-mode highlight-new

def _checkLineOutput(line):
    if(len(line)):
        output = line.decode('utf8').strip()
        now = datetime.datetime.now()
        tstamp = now.strftime("%H:%M:%S.")
        tstamp += now.strftime("%f")[:2]

        print("--", tstamp, output)

def lineCount(path):
    with open(path, 'r+') as f:
        c = 0
        for line in f:
            c += 1
        return c
    return 0

def getLineCount():
    t = 0
    for root, dirs, files in os.walk("."):
        #path = root.split(os.sep)
        for f in files:
            if f.endswith('.qml') or f.endswith('.py'):
                fp = os.path.join(root, f)
                t += lineCount(fp)
                print(fp, lineCount(fp))
    print(t)

if __name__ == '__main__':
    getLineCount()
    exit()

    dgsPath = '/Users/voreno/Development/graphstream/dgs-graphstream'
    inputPath = 'inputs'
    outputPath = '/Users/voreno/Desktop/output'
    #inputPath = '/Users/voreno/Development/graphstream/dgs-graphstream/inputs'
    #outputPath = '/Users/voreno/Development/graphstream/dgs-graphstream/output'

    args = ['python3', 'genGraphStream.py', '-s', 'communities', '-g', os.path.join(inputPath, 'network_1.txt'), '-f', 'metis', '-a', os.path.join(inputPath, 'assignments.txt'), '-o', outputPath, '--video', os.path.join(outputPath, 'vid.mp4')]
    #args = ['python3', os.path.join(dgsPath, 'genGraphStream.py'), '-s', 'communities', '-g', os.path.join(inputPath, 'network_1.txt'), '-f', 'metis', '-a', os.path.join(inputPath, 'assignments.txt'), '-o', outputPath, '--video', os.path.join(outputPath, 'vid.mp4')]
    process = subprocess.Popen(args, stderr=subprocess.PIPE,cwd=dgsPath)

    _checkLineOutput("graphstream command: " + ' '.join(args))

    while process.returncode is None:
        try:
            line = process.stderr.readline()
            _checkLineOutput(line)
            while(len(line)):
                line = process.stderr.readline()
                _checkLineOutput(line)
            process.wait(1)
        except subprocess.TimeoutExpired as err:
            pass
