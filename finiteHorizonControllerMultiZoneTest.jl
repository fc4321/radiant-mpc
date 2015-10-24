using JuMP
using Cbc

include("finiteHorizonControllerMultiZone.jl")

A = {rand(2,2,3)-0.5, rand(2,2,3)-0.5};
E = {rand(2,2,3), rand(2,2,3)};
x0=[1;1];

H = [eye(2);-eye(2)];
b = 50*ones(4);

N=2
d = rand(2,N,2);

modes = finiteHorizonControllerMultiZone(A,E,x0,H,b,d,1,-1,1)
