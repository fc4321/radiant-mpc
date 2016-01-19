using HDF5
using JuMP
using Cbc

numZones = parse(Int, ARGS[1])

include("finiteHorizonControllerMultiZone.jl")

A = cell(numZones)
E = cell(numZones)
d = h5read("systemParameters.hdf5", "d")
H = h5read("systemParameters.hdf5", "H")
b = h5read("systemParameters.hdf5", "b")
x_max = h5read("systemParameters.hdf5", "x_max")
x_min = h5read("systemParameters.hdf5", "x_min")
rho = h5read("systemParameters.hdf5", "rho")
x0 = zeros(2,numZones)

for zone = 0:numZones-1
    x0[:,zone+1] = h5read("systemParameters.hdf5", string("x", zone))
    systemMatrices = zeros(2,2,3)
    systemMatrices[:,:,1] = h5read("matricesCooling.hdf5", string("A", zone))
    systemMatrices[:,:,2] = h5read("matricesCoasting.hdf5", string("A", zone))
    systemMatrices[:,:,3] = h5read("matricesHeating.hdf5", string("A", zone))
    A[zone+1] = systemMatrices
    disturbanceMatrices = zeros(2,size(d,1),3)
    disturbanceMatrices[:,:,1] = h5read("matricesCooling.hdf5", string("E", zone))
    disturbanceMatrices[:,:,2] = h5read("matricesCoasting.hdf5", string("E", zone))
    disturbanceMatrices[:,:,3] = h5read("matricesHeating.hdf5", string("E", zone))
    E[zone+1] = disturbanceMatrices
end

modes = finiteHorizonControllerMultiZone(A,E,x0,H,b,d,x_max,x_min,rho)

output = zeros(numZones * 2,1)
for zone = 1:numZones
    if modes[1,1,zone] == 1
      waterFlowRate = 0.504
      waterTemperature = 283
    elseif modes[2,1,zone] == 1
      waterFlowRate = 0
      waterTemperature = 293
    else
      waterFlowRate = 0.504
      waterTemperature = 300
    end
    output[1 + (zone-1)*2] = waterFlowRate
    output[2 + (zone-1)*2] = waterTemperature
end

rm("mpcOutput.hdf5")
h5write("mpcOutput.hdf5", "output", output)
