import os
import re

def popvals(file):
  f=open(file)

  outputfile=[]

  sentences=f.readlines()

  for i in sentences:
    if re. search("poptopologysequence.vals",i):
      pop=i[35:]
      outputfile.append(pop)

  f.close()

  return outputfile

