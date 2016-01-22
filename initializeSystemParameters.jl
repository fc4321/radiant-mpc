using HDF5

x0=[293;293];
H = [eye(2);-eye(2)];
b = [3200;320;-250;-250];
N = 24;
d = 293*ones(1,N,1);
x_max = 290;
x_min = 270;
rho = 1;

h5write("systemParameters.hdf5", "d", d)
h5write("systemParameters.hdf5", "H", H)
h5write("systemParameters.hdf5", "b", b)
h5write("systemParameters.hdf5", "x_max", x_max)
h5write("systemParameters.hdf5", "x_min", x_min)
h5write("systemParameters.hdf5", "rho", rho)
h5write("systemParameters.hdf5", "x0", x0)
