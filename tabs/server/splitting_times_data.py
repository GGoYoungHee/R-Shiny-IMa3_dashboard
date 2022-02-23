import os
import pandas as pd
import numpy as np

def get_data(input_dir, start=130):
    input_file=open(input_dir)
    
    logPosterior = []
    logLik = []
    logPrior = []
    t0 = []
    t1 = []

    i = 0
    while True:
        line=input_file.readline()
        i += 1
        if not line: break
            
        if 'VALUESSTART' in line:
            start = i
            
        if i > start:
            tmp = line.split()
            logPosterior.append(float(tmp[-4])+float(tmp[-3]))
            logLik.append(tmp[-4])
            logPrior.append(tmp[-3])
            t0.append(tmp[-2])
            t1.append(tmp[-1])

    input_file.close()

    tifile = pd.DataFrame({'logPosterior' : logPosterior,
                           'logLik' : logLik,
                           'logPrior' : logPrior,
                           't0' : t0,
                           't1' : t1}).apply(pd.to_numeric)
    
    return tifile
