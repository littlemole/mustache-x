from pathlib import Path
import glob
import os


class Templates:
    def __init__(self,prefix):
        self.prefix = prefix
        self.templates = Templates.load_tpls(prefix)

    def __getitem__(self, key):            
        return self.templates[self.prefix + "/" + key]

    def load_tpl(path):
        return Path(path).read_text() 

    def load_tpls(prefix):
        result = {}
        entries = glob.glob(prefix + "/*")
        for entry in entries:
            if os.path.isdir(entry):
                r = Templates.load_tpls(entry)
                for i in r:
                    result[i] = r[i]
            else:
                result[entry] = Templates.load_tpl(entry)
        return result
    
