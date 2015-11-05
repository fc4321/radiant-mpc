import julia
import sys
import h5py

matricesCooling = h5py.File('matricesCooling.hdf5','r')
matricesHeating = h5py.File('matricesHeating.hdf5','r')
matricesCoasting = h5py.File('matricesCoasting.hdf5','r')

pyjulia = julia.Julia()
pyjulia.eval('include("finiteHorizonControllerMultiZone.jl")')
