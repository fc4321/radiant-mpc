using HDF5

numZones = ARGS[1]

include("finiteHorizonControllerMultiZone.jl")

A = cell(numZones)
E = cell(numZones)
d = weatherPrediction['d']
H = systemConstraints['H']
b = systemConstraints['b']
x_max = systemConstraints['x_max']
x_min = systemConstraints['x_min']
rho = rho['rho']
x0 = zeros(2,numZones)

for zone = 1:numZones
    slabTemp = ARGS[zone*2]
    zoneTemp = ARGS[zone*2 + 1]
    h5read("/tmp/test2.h5", "mygroup2/A", (2:3:15, 3:5))
    x0[:,zone] = [slabTemp; zoneTemp]
    systemMatrices = zeros(2,2,3)
    systemMatrices[:,:,1] = h5read("matricesCooling[A + str(zone)]))
    systemMatrices[:,:,2] = {0}'.format(matricesCoasting[A + str(zone)]))
    systemMatrices[:,:,3] = {0}'.format(matricesHeating[A + str(zone)]))
    A[{0}] = systemMatrices')
    disturbanceMatrices = zeros(2,size(d,1),3)')
    disturbanceMatrices[:,:,1] = {0}'.format(matricesCooling[E + str(zone)]))
    disturbanceMatrices[:,:,2] = {0}'.format(matricesCoasting[E + str(zone)]))
    disturbanceMatrices[:,:,3] = {0}'.format(matricesHeating[E + str(zone)]))
    E[{0}] = disturbanceMatrices')
end

pyjulia.eval('modes = finiteHorizonControllerMultiZone(A,E,x0,H,b,d,x_max,x_min,rho)')
for zone in range(numZones):

    output = output + str(waterFlowRate) + ' ' + str(waterTemperature) + ' '
output = output[0:-1]
sys.stdout.write(output)
