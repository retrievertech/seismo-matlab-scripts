import sys
from time import time

timeDict = {}
def timeStart(key):
  timeDict[key] = time()
  sys.stdout.write(key+" ... ")
  sys.stdout.flush()

def timeEnd(key):
  sys.stdout.write(str(time() - timeDict[key])+"s \n")
  del timeDict[key]