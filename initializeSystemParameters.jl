using HDF5

x0=[293.0;293.0];
H = [eye(2);-eye(2)];
b = [320.0;320.0;-250.0;-250.0];
N = 4;
d = 293.0*ones(1,N,1);
x_max = 300.0;
x_min = 295.0;
rho = 1.0;

h5write("systemParameters.hdf5", "d", d)
h5write("systemParameters.hdf5", "H", H)
h5write("systemParameters.hdf5", "b", b)
h5write("systemParameters.hdf5", "x_max", x_max)
h5write("systemParameters.hdf5", "x_min", x_min)
h5write("systemParameters.hdf5", "rho", rho)
h5write("systemParameters.hdf5", "x0", x0)
