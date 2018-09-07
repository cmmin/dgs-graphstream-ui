from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot

class UITexts(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.texts = {}

    def load(self, path):
        with open(path, 'r') as f:
            for line in f:
                line = line.strip()
                parts = line.split(',')
                if len(parts) > 1:
                    key = ''
                    text = ''
                    for i, part in enumerate(parts):
                        if i == 0:
                            key = part
                        else:
                            if len(text) > 0:
                                text += ','
                            text += part
                    if len(key) and len(text):
                        self.texts[key] = text

    def _get(self, key):
        if key in self.texts:
            return self.texts[key]
        return ''

    @pyqtSlot(str, result=str)
    def get(self, key):
        return self._get(key)
