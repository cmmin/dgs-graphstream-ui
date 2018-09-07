
def loadConfigSettings(settingsPath, simparams):
    simparams.saveEnabled = False
    with open(settingsPath, 'r+') as f:
        simparams.saveEnabled = False
        lineCount = 0
        for line in f:
            line = line.strip()
            if lineCount == 0 and line != "#DGSConfig":
                simparams.saveEnabled = True
                return False
            else:
                parts = line.split("=")
                key = ''
                value = ''
                if len(parts) >= 2:
                    key = parts[0]
                    for i in range(1, len(parts)):
                        if len(value):
                            value += '='
                        value += parts[i]

                value = value.replace('[', '')
                value = value.replace(']', '')

                # parse properties
                if key == 'scheme':
                    simparams.slotSetScheme(value)
                elif key == 'graphFormat':
                    simparams.slotGraphFormat(value)
                elif key == 'graphFilePath':
                    simparams.slotSetGraphFilePath(value)

                elif key == 'outputPath':
                    simparams.slotSetOutputPath(value)

                elif key == 'nodeOrderListPath':
                    simparams.slotSetNodeOrderListPath(value)
                elif key == 'filterPath':
                    simparams.slotSetFilterPath(value)
                elif key == 'orderSeed':
                    simparams.slotSetOrderSeed(value)

                elif key == 'assignmentsPath':
                    simparams.slotSetAssignmentsFilePath(value)
                elif key == 'partitionSeed':
                    simparams.slotSetPartitionSeed(value)

                elif key == 'visiblePartitions':
                    simparams.slotSetVisiblePartitions(value)

                elif key == 'assignmentsMode':
                    simparams.slotSetAssignmentsMode(value)

                elif key == 'numPartitions':
                    try:
                        simparams.slotSetNumPartitions(int(value))
                    except ValueError as err:
                        pass
                elif key == 'ubvec':
                    try:
                        simparams.slotSetLoadImbalance(float(value))
                    except ValueError as err:
                        pass
                elif key == 'tpwgts':
                    simparams.slotSetPartitionWeightsChanged(value)

                elif key == 'graphLayout':
                    simparams.slotSetGraphLayout(value)

                elif key == 'layoutLinlogForce':
                    try:
                        simparams.slotSetLayoutLinlogForce(float(value))
                    except ValueError as err:
                        pass

                elif key == 'layoutAttraction':
                    try:
                        simparams.slotSetLayoutAttraction(float(value))
                    except ValueError as err:
                        pass

                elif key == 'layoutRepulsion':
                    try:
                        simparams.slotSetLayoutRepulsion(float(value))
                    except ValueError as err:
                        pass

                elif key == 'layoutRandomSeed':
                    simparams.slotSetLayoutSeed(value)

                elif key == 'colorScheme':
                    simparams.slotSetColorScheme(value)

                elif key == 'nodeColor':
                    simparams.slotSetNodeColor(value)
                elif key == 'coloringSeed':
                    simparams.slotSetColoringSeed(value)

                elif key == 'imageNodeSizeMode':
                    simparams.slotSetImageNodeSizeMode(value)

                elif key == 'imageNodeSize':
                    try:
                        simparams.slotSetImageNodeSize(int(value))
                    except ValueError as err:
                        pass

                elif key == 'imageMinNodeSize':
                    try:
                        simparams.slotSetImageMinNodeSize(int(value))
                    except ValueError as err:
                        pass

                elif key == 'imageMaxNodeSize':
                    try:
                        simparams.slotSetImageMaxNodeSize(int(value))
                    except ValueError as err:
                        pass

                elif key == 'imageEdgeSize':
                    try:
                        simparams.slotSetImageEdgeSize(int(value))
                    except ValueError as err:
                        pass

                elif key == 'imageLabelSize':
                    try:
                        simparams.slotSetImageLabelSize(int(value))
                    except ValueError as err:
                        pass

                elif key == 'imageLabelType':
                    simparams.slotSetImageLabelType(value)

                elif key == 'imageBorderSize':
                    try:
                        simparams.slotSetImageBorderSize(int(value))
                    except ValueError as err:
                        pass

                elif key == 'imageWidth':
                    try:
                        simparams.slotSetImageWidth(int(value))
                    except ValueError as err:
                        pass

                elif key == 'imageHeight':
                    try:
                        simparams.slotSetImageHeight(int(value))
                    except ValueError as err:
                        pass

                elif key == 'cutEdgeLength':
                    try:
                        simparams.slotSetImageCutEdgeLength(int(value))
                    except ValueError as err:
                        pass

                elif key == 'cutEdgeNodeSize':
                    try:
                        simparams.slotSetImageCutEdgeNodeSize(int(value))
                    except ValueError as err:
                        pass

                elif key == 'videoPath':
                    simparams.slotSetVideoPath(value)
                elif key == 'videoFPS':
                    try:
                        simparams.slotSetVideoFPS(int(value))
                    except ValueError as err:
                        pass
                elif key == 'videoPaddingTime':
                    try:
                        simparams.slotSetVideoPaddingTime(float(value))
                    except ValueError as err:
                        pass

                elif key == 'pdfEnabled':
                    if value == 'True':
                        simparams.slotSetPDFEnabled(True)
                    else:
                        simparams.slotSetPDFEnabled(False)

                elif key == 'pdfFramePercentage':
                    try:
                        simparams.slotSetPDFFramePercentage(int(value))
                    except ValueError as err:
                        pass

                elif key == 'clustering':
                    simparams.slotSetClusteringMode(value)
                elif key == 'clusterSeed':
                    simparams.slotSetClusterSeed(value)

                elif key == 'infomapCalls':
                    try:
                        simparams.slotSetInfomapCalls(int(value))
                    except ValueError as err:
                        pass
            lineCount += 1
            simparams.saveEnabled = True
        return True
    return False

def saveConfigSettings(settingsPath, simparams):
    with open(settingsPath, 'w+') as f:
        f.write("#DGSConfig\n")
        f.write('scheme=' + str(simparams.scheme) + '\n')
        f.write('graphFormat=' + str(simparams.graphFormat) + '\n')
        f.write('graphFilePath=' + str(simparams.graphFilePath) + '\n')

        f.write('outputPath=' + str(simparams.outputPath) + '\n')

        f.write('nodeOrderListPath=' + str(simparams.nodeOrderListPath) + '\n')
        f.write('filterPath=' + str(simparams.filterPath) + '\n')
        f.write('orderSeed=' + str(simparams.orderSeed) + '\n')

        f.write('assignmentsPath=' + str(simparams.assignmentsPath) + '\n')
        f.write('partitionSeed=' + str(simparams.partitionSeed) + '\n')
        f.write('visiblePartitions=' + str(simparams.visiblePartitions) + '\n')

        f.write('assignmentsMode=' + str(simparams.assignmentsMode) + '\n')
        f.write('numPartitions=' + str(simparams.numPartitions) + '\n')
        f.write('ubvec=' + str(simparams.ubvec) + '\n')
        f.write('tpwgts=' + str(simparams.tpwgts) + '\n')

        f.write('graphLayout=' + str(simparams.graphLayout) + '\n')
        f.write('layoutLinlogForce=' + str(simparams.layoutLinlogForce) + '\n')
        f.write('layoutAttraction=' + str(simparams.layoutAttraction) + '\n')
        f.write('layoutRepulsion=' + str(simparams.layoutRepulsion) + '\n')
        f.write('layoutRandomSeed=' + str(simparams.layoutRandomSeed) + '\n')

        f.write('colorScheme=' + str(simparams.colorScheme) + '\n')
        f.write('nodeColor=' + str(simparams.nodeColor) + '\n')
        f.write('coloringSeed=' + str(simparams.coloringSeed) + '\n')

        f.write('imageNodeSizeMode=' + str(simparams.imageNodeSizeMode) + '\n')
        f.write('imageNodeSize=' + str(simparams.imageNodeSize) + '\n')
        f.write('imageMinNodeSize=' + str(simparams.imageMinNodeSize) + '\n')
        f.write('imageMaxNodeSize=' + str(simparams.imageMaxNodeSize) + '\n')
        f.write('imageEdgeSize=' + str(simparams.imageEdgeSize) + '\n')
        f.write('imageLabelSize=' + str(simparams.imageLabelSize) + '\n')
        f.write('imageLabelType=' + str(simparams.imageLabelType) + '\n')
        f.write('imageBorderSize=' + str(simparams.imageBorderSize) + '\n')
        f.write('imageWidth=' + str(simparams.imageWidth) + '\n')
        f.write('imageHeight=' + str(simparams.imageHeight) + '\n')

        f.write('cutEdgeLength=' + str(simparams.cutEdgeLength) + '\n')
        f.write('cutEdgeNodeSize=' + str(simparams.cutEdgeNodeSize) + '\n')

        f.write('videoPath=' + str(simparams.videoPath) + '\n')
        f.write('videoFullPath=' + str(simparams.videoFullPath) + '\n')
        f.write('videoFPS=' + str(simparams.videoFPS) + '\n')
        f.write('videoPaddingTime=' + str(simparams.videoPaddingTime) + '\n')

        f.write('pdfEnabled=' + str(simparams.pdfEnabled) + '\n')
        f.write('pdfFramePercentage=' + str(simparams.pdfFramePercentage) + '\n')

        f.write('clustering=' + str(simparams.clustering) + '\n')
        f.write('clusterSeed=' + str(simparams.clusterSeed) + '\n')
        f.write('infomapCalls=' + str(simparams.infomapCalls) + '\n')
        return True
    return False
