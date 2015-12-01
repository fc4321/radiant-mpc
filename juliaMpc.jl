using HDF5

numZones = ARGS[1]

include("finiteHorizonControllerMultiZone.jl")

A = cell(numZones)
E = cell(numZones)
d = h5read("weatherPrediction.hdf5", "d")
H = h5read("systemConstraints.hdf5", "H")
b = h5read("systemConstraints.hdf5", "b")
x_max = h5read("systemConstraints.hdf5", "x_max")
x_min = h5read("systemConstraints.hdf5", "x_min")
rho = h5read("rho.hdf5", "rho")
x0 = zeros(2,numZones)

for zone = 1:numZones
    x0[:,zone] = h5read("x0.hdf5", string(zone))
    systemMatrices = zeros(2,2,3)
    systemMatrices[:,:,1] = h5read("matricesCooling.hdf5", string("A", zone))
    systemMatrices[:,:,2] = h5read("matricesCoasting.hdf5", string("A", zone))
    systemMatrices[:,:,3] = h5read("matricesHeating.hdf5", string("A", zone))
    A[zone] = systemMatrices
    disturbanceMatrices = zeros(2,size(d,1),3)
    disturbanceMatrices[:,:,1] = h5read("matricesCooling.hdf5", string("E", zone))
    disturbanceMatrices[:,:,2] = h5read("matricesCoasting.hdf5", string("E", zone))
    disturbanceMatrices[:,:,3] = h5read("matricesHeating.hdf5", string("E", zone))
    E[zone] = disturbanceMatrices
end

modes = finiteHorizonControllerMultiZone(A,E,x0,H,b,d,x_max,x_min,rho)

output = zeros(numZones * 2,1)
for zone = 1:numZones
    if mode[1,1,zone] == 1
      waterFlowRate = 100
      waterTemperature = 32
    elseif mode[2,1,zone] == 1
      waterFlowRate = 0
      waterTemperature = 32
    else
      waterFlowRate = 100
      waterTemperature = 100
    end
    output[1 + (zone-1)*2] = waterFlowRate
    output[2 + (zone-1)*2] = waterTemperature
end

h5write("mpcOutput.hdf5", "output", output)
