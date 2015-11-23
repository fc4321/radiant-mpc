import sys

time = sys.argv[1]
numZones = sys.arg[2]

if time < 3*60*60:
    waterFlowRate = 100
    waterTemperature = 100
    mode = 1
else:
    waterFlowRate = 0
    waterTemperature = 32
    mode = 0

output = ''
for zone in range(numZones):
    output = output + str(waterFlowRate) + ' ' + str(waterTemperature) + ' '
output = output[0:-1]
sys.stdout.write(output.append(mode))
