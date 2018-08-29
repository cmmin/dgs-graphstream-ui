import logging


def longOperation():
    logging.info('Starting the LONG OPERATION')
    for i in range(100):
        te = 0
        for e in range(10000):
            te += 1
            tf = 0
            for f in range(100):
                tf += 1
        logging.info('   i=%d', i)
    logging.info('Ending the LONG OPERATION')

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
    longOperation()
