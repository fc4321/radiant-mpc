using JuMP
using Cbc

include("finiteHorizonControllerMultiZone.jl")

systemModes = ones(2,2,3);
systemModes[:,:,1] = eye(2);
systemModes[:,:,2] = eye(2);
systemModes[:,:,3] = eye(2);
A = {systemModes}
disturbanceModes = ones(2,1,3);
disturbanceModes[:,1,2] = zeros(2,1);
disturbanceModes[:,1,3] = -ones(2,1);
E = {disturbanceModes};
x0=[3;3];

H = [eye(2);-eye(2)];
b = 5*ones(4,1);

N= 5;
d = ones(1,N,1);

x_max = 1;
x_min = -1;
rho = 1;
modes = finiteHorizonControllerMultiZone(A,E,x0,H,b,d,x_max,x_min,rho);
println(modes)
