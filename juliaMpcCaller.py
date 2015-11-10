import julia
import sys
import h5py

matricesCooling = h5py.File('matricesCooling.hdf5','r')
matricesHeating = h5py.File('matricesHeating.hdf5','r')
matricesCoasting = h5py.File('matricesCoasting.hdf5','r')
weatherPrediction = h5py.File('weatherPrediction.hdf5','r')
systemConstraints = h5py.File('systemConstraints.hdf5','r')
rho = h5py.File('rho.hdf5','r')

numZones = len(matricesCooling.keys()) / 2

pyjulia = julia.Julia()
pyjulia.eval('include("finiteHorizonControllerMultiZone.jl")')
pyjulia.eval('A = cell({0})'.format(numZones))
pyjulia.eval('E = cell({0})'.format(numZones))
pyjulia.eval('d = zeros()')

for zone in range(numZones):
    pyjulia.eval('systemMatrices = zeros(2,2,3)')
    pyjulia.eval('systemMatrices[:,:,1] = {0}')
    pyjulia.eval('systemMatrices[:,:,2] = {0}')
    pyjulia.eval('systemMatrices[:,:,3] = {0}')
    pyjulia.eval('A[{0}] = systemMatrices')
    pyjulia.eval('disturbanceMatrices = zeros(2,1,3)')
    pyjulia.eval('disturbanceMatrices[:,:,1] = {0}')
    pyjulia.eval('disturbanceMatrices[:,:,2] = {0}')
    pyjulia.eval('disturbanceMatrices[:,:,3] = {0}')
    pyjulia.eval('E[{0}] = disturbanceMatrices')
    pyjulia.eval('')
