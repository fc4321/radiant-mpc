using JuMP
using Cbc

include("finiteHorizonControllerMultiZone.jl")

A = {1,1,1}
E = {1,0,-1};
x0=[2]

H = [1;-1];
b = [5;5];

N= 2;
d = ones(1,N,1);

modes = finiteHorizonControllerMultiZone(A,E,x0,H,b,d,1,-1,1)
