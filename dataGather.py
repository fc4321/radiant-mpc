import h5py
import sys

systemMode = sys.argv[1]
numZones = sys.argv[2]
newDataX1 = dict()
newDataX2 = dict()
newDataD = dict()

for zone in range(numZones):
    newDataX1[zone] = sys.argv[3+zone*3]
    newDataX2[zone] = sys.argv[4+zone*3]
    newDataD[zone] = sys.argv[5+zone*3]

matricesData = h5py.File('matrices' + systemMode + 'Data.hdf5','a')
x1 = dict()
x2 = dict()
d = dict()

for zone in range(numZones):
    x1[zone] = matricesData['x1' + str(zone)]
    x2[zone] = matricesData['x2' + str(zone)]
    d[zone] = matricesData['d' + str(zone)]
    x1[zone].append(newDataX1[zone])
    x2[zone].append(newDataX2[zone])
    d[zone].append(newDataD[zone])
    dsetx1 = matricesData.create_dataset('x1' + str(zone), (len(x1[zone]),1))
    dsetx2 = matricesData.create_dataset('x2' + str(zone), (len(x2[zone]),1))
    dsetd = matricesData.create_dataset('d' + str(zone), (len(d[zone]),1))
    dsetx1[:] = x1[zone]
    dsetx2[:] = x2[zone]
    dsetd[:] = d[zone]
