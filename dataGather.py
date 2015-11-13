import julia
import h5py
import sys

systemMode = sys.argv[1]
matricesData = h5py.File('matrices' + systemMode + 'Data.hdf5','r')

numZones = len(matricesData.keys()) / 3
pyjulia = julia.Julia()
pyjulia.eval('include("matrixIdentify.jl")')
for zone in range(numZones):
    x1 = matricesData['x1' + str(zone)]
    x2 = matricesData['x2' + str(zone)]
    d = matricesData['d' + str(zone)]
    x1.append
    x2.append
    d.append

#close File
#open as write
for zone in range(numZones):
    dsetx1 = matricesData.create_dataset('x1' + str(zone), (len(x1),1))
    dsetx2 = matricesData.create_dataset('x2' + str(zone), (len(x2),1))
    dsetd = matricesData.create_dataset('d' + str(zone), (len(d),1))
    dsetx1[:] = x1
    dsetx2[:] = x2
    dsetd[:] = d
