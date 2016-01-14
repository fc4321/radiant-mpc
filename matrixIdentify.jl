using HDF5
include("identMatrices.jl")

systemMode = parse(Int, ARGS[1])
numZones = parse(Int, ARGS[2])

if systemMode == 1
    systemMode = "Cooling";
elseif systemMode == 2
    systemMode = "Coasting";
else
    systemMode = "Heating";
end

for zone = 0:numZones-1
    x1 = h5read(string("matrices", systemMode, "Data.hdf5"), string("x1", zone))
    x2 = h5read(string("matrices", systemMode, "Data.hdf5"), string("x2", zone))
    d = h5read(string("matrices", systemMode, "Data.hdf5"), string("d", zone))
    (A, E) = identMatrices(x1,x2,d)
    h5write(string("matrices", systemMode, ".hdf5"), string("A", zone), A)
    h5write(string("matrices", systemMode, ".hdf5"), string("E", zone), E)
end
