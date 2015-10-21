import julia
import h5py
import sys

systemMode = sys.argv[1]
matricesData = h5py.File('matrices' + systemMode + 'Data.hdf5','r')
matrices = h5py.File('matrices' + systemMode + '.hdf5','w')

numZones = len(matricesData.keys()) / 3
pyjulia = julia.Julia()
pyjulia.eval('include("matrixIdentify.jl")')
for zone in range(numZones):
    x1 = matricesData['x1' + str(zone)]
    x2 = matricesData['x2' + str(zone)]
    d = matricesData['d' + str(zone)]
    [A, E] = pyjulia.eval('identMatices({0},{1},{2})'.format(x1,x2,d))
    dsetA = matrices.create_dataset('A' + str(zone), (2,2))
    dsetE = matrices.create_dataset('E' + str(zone), (2,1))
    dsetA[:] = A
    dsetE[:] = E
