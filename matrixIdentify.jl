function identMatrices(x1,x2,d)
    N = length(d)

    A=zeros(2,2)
    E=zeros(2,1)

    modelIdent = Model(solver = IpoptSolver())
    @defVar(modelIdent, row1[1:3])
    @defVar(modelIdent, row2[1:3])

    H = [x1 x2 d]

    errorRow1 = H[1:N-1,:]*row1-x1[2:end]
    errorRow2 = H[1:N-1,:]*row2-x2[2:end]

    @setObjective(modelIdent, Min, sum(errorRow1'errorRow1))
    solve(modelIdent)
    resultRow1=getValue(row1)
    A[1,:]=resultRow1[1:2]
    E[1]=resultRow1[3]

    @setObjective(modelIdent, Min, sum(errorRow2'errorRow2))
    solve(modelIdent)
    resultRow2=getValue(row2)
    A[2,:]=resultRow2[1:2]
    E[2]=resultRow2[3]
    A, E
end
