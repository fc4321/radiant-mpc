import sys

time = sys.argv[1]

if time < 3*60*60:
    waterFlowRate = 100
    waterTemperature = 100
else:
    waterFlowRate = 0
    waterTemperature = 32
