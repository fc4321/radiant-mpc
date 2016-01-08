import h5py
import sys

systemMode = sys.argv[1]
numZones = sys.argv[2]

if systemMode == 1:
    systemMode = 'Cooling'
elif systeMode == 2:
    systemMode = 'Coasting'
else:
    systemMode = 'Heating'

matricesData = h5py.File('matrices' + systemMode + 'Data.hdf5','a')

if not matricesData.keys():
    for zone in range(numZones):
        x1 = matricesData.create_dataset('x1' + str(zone), (1,), maxshape=(100000,))
        x2 = matricesData.create_dataset('x2' + str(zone), (1,), maxshape=(100000,))
        d = matricesData.create_dataset('d' + str(zone), (1,), maxshape=(100000,))
        x1[1] = sys.argv[3+zone*3]
        x2[1] = sys.argv[4+zone*3]
        d[1] = sys.argv[5+zone*3]
else:
    for zone in range(numZones):
        x1 = matricesData['x1' + str(zone)]
        x2 = matricesData['x2' + str(zone)]
        d = matricesData['d' + str(zone)]
        x1.resize(len(x1)+1)
        x2.resize(len(x2)+1)
        d.resize(len(d)+1)
        x1[-1] = sys.argv[3+zone*3]
        x2[-1] = sys.argv[4+zone*3]
        d[-1] = sys.argv[5+zone*3]
