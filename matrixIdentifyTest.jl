using JuMP
using Ipopt

include("matrixIdentify.jl")

x1 = rand(10,1)
x2 = rand(10,1)
d = rand(10,1)

(A, E) = identMatrices(x1,x2,d);
println("Done")
