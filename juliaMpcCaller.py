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
pyjulia.eval('d = {0}'.format(weatherPrediction['d']))
pyjulia.eval('H = {0}'.format(systemConstraints['H']))
pyjulia.eval('b = {0}'.format(systemConstraints['b']))
pyjulia.eval('x_max = {0}'.format(systemConstraints['x_max']))
pyjulia.eval('x_min = {0}'.format(systemConstraints['x_min']))
pyjulia.eval('rho = {0}'.format(rho['rho']))
pyjulia.eval('x0 = zeros(2,{0})'.format(numZones))

for zone in range(numZones):
    slabTemp = sys.argv[zone*2]
    zoneTemp = sys.argv[zone*2 + 1]
    pyjulia.eval('x0[:,zone] = [{0};{1}]'.format(slabTemp,zoneTemp))
    pyjulia.eval('systemMatrices = zeros(2,2,3)')
    pyjulia.eval('systemMatrices[:,:,1] = {0}'.format(matricesCooling[A + str(zone)]))
    pyjulia.eval('systemMatrices[:,:,2] = {0}'.format(matricesCoasting[A + str(zone)]))
    pyjulia.eval('systemMatrices[:,:,3] = {0}'.format(matricesHeating[A + str(zone)]))
    pyjulia.eval('A[{0}] = systemMatrices')
    pyjulia.eval('disturbanceMatrices = zeros(2,size(d,1),3)')
    pyjulia.eval('disturbanceMatrices[:,:,1] = {0}'.format(matricesCooling[E + str(zone)]))
    pyjulia.eval('disturbanceMatrices[:,:,2] = {0}'.format(matricesCoasting[E + str(zone)]))
    pyjulia.eval('disturbanceMatrices[:,:,3] = {0}'.format(matricesHeating[E + str(zone)]))
    pyjulia.eval('E[{0}] = disturbanceMatrices')

pyjulia.eval('modes = finiteHorizonControllerMultiZone(A,E,x0,H,b,d,x_max,x_min,rho)')
for zone in range(numZones):
    
    output = output + str(waterFlowRate) + ' ' + str(waterTemperature) + ' '
output = output[0:-1]
sys.stdout.write(output)
