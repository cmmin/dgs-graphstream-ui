from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot


class SimulationParameters(QObject):
    def __init__(self):
        QObject.__init__(self)

        self.scheme = 'communities'

    # signals
    notifySchemeChanged = pyqtSignal(str, arguments=["scheme"])

    @pyqtSlot(str)
    def slotSetScheme(self, scheme):
        self.scheme = scheme
        self.notifySchemeChanged.emit(self.scheme)
