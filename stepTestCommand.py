import sys

time = float(sys.argv[1])
numZones = int(sys.argv[2])

if time < 3*60*60:
    waterFlowRate = 0.504
    waterTemperature = 283.15
    mode = 1
else:
    waterFlowRate = 0
    waterTemperature = 283.15
    mode = 2

output = ''
for zone in range(numZones):
    output = output + str(waterFlowRate) + ' ' + str(waterTemperature) + ' '
sys.stdout.write(output + str(mode))
