using HDF5

numZones = parse(Int, ARGS[1])
fid = h5open("systemParameters.hdf5", "r+")

for zone = 0:numZones - 1
  x0 = fid[string("x", zone)]
  slabTemp = parse(Float32, ARGS[2+zone*2])
  roomTemp = parse(Float32, ARGS[3+zone*2])
  write(x0, [slabTemp;roomTemp])
end

#put in disturbance update at some point
close(fid)
