function identMatrices(x1,x2,d)
    N = size(d,1)

    A=zeros(2,2)
    E=zeros(2,size(d,2))

    modelIdent = Model(solver = IpoptSolver())
    @defVar(modelIdent, row1[1:2+size(d,2)])
    @defVar(modelIdent, row2[1:2+size(d,2)])

    H = [x1 x2 d]

    errorRow1 = H[1:N-1,:]*row1-x1[2:end]
    errorRow2 = H[1:N-1,:]*row2-x2[2:end]

    @setObjective(modelIdent, Min, sum(errorRow1'errorRow1))
    solve(modelIdent)
    resultRow1=getValue(row1)
    A[1,:]=resultRow1[1:2]
    E[1,:]=resultRow1[3:end]

    @setObjective(modelIdent, Min, sum(errorRow2'errorRow2))
    solve(modelIdent)
    resultRow2=getValue(row2)
    A[2,:]=resultRow2[1:2]
    E[2,:]=resultRow2[3:end]
    A, E
end
