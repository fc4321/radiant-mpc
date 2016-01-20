using HDF5

numZones = parse(Int, ARGS[1]);

output = h5read("mpcOutput.hdf5", "output");
outputString = "";

for zone = 0:numZones-1
    outputString = string(outputString, output[1 + zone*2], " ", output[2 + zone*2], " ");
end

outputString = outputString[1:end-1];
write(STDOUT, outputString);
