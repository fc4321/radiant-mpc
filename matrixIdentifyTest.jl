using JuMP
using Ipopt

x1 = rand(10,1)
x2 = rand(10,1)
d = rand(10,1)

include("matrixIdentify.jl")

(A, E) = identMatrices(x1,x2,d)
