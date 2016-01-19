import sys
import h5py

numZones = int(sys.argv[1])

mpcCommands = h5py.File('mpcOutput.hdf5','r')
output = mpcCommands['output'][:][0]
outputString = ''
for zone in range(numZones):
    outputString = outputString + str(output[2*zone]) + ' ' + str(output[2*zone + 1]) + ' '
outputString = outputString[0:-1]
sys.stdout.write(outputString)
