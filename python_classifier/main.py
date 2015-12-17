import helper,config,enf


if __name__ == '__main__':
    signals = helper.loadData(config.trainingDirectory)
    enf.weightedEnergyENFExtractor(signals[0],2**14,96,0.5)