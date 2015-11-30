function finiteHorizonControllerMultiZone(A,E,x0,H,b,d,x_max,x_min,rho)

    N = size(d,2);
    model = Model(solver = CbcSolver());
    @defVar(model, x[1:2,1:N+1,1:length(A)])
    @defVar(model, modes[1:3,1:N,1:length(A)], Bin)
    @defVar(model, z[1:2,1:size(modes,1),1:N,1:length(A)])
    @defVar(model, slacks[1:N,1:length(A)])
    @defVar(model, coolingOn)
    @defVar(model, heatingOn)
    cost = 0;
    for system = 1:length(A)
        M = zeros(size(A[system],1),size(modes,1));
        m = zeros(size(A[system],1),size(modes,1));
        @addConstraint(model, x[:,1, system] .== x0[:,system])
        @addConstraint(model, coolingOn .>= modes[1,:,system])
        @addConstraint(model, heatingOn .>= modes[2,:,system])
        for time = 1:N
            @addConstraint(model, H*x[:,time+1, system] .<= b)
            @addConstraint(model, sum(modes[:,time, system]) == 1)
            for mode = 1:size(modes,1)
                for index = 1:size(A,1)
                    @setObjective(model, Min, sum(A[system][index,:,mode]*x[:,time+1,system] + E[system][index,:,mode]*d[:,time,system]))
                    solve(model)
                    m[index,mode] = getObjectiveValue(model)
                    @setObjective(model, Max, sum(A[system][index,:,mode]*x[:,time+1,system] + E[system][index,:,mode]*d[:,time,system]))
                    solve(model)
                    M[index,mode] = getObjectiveValue(model)
                end
            end

            for mode = 1:size(modes,1)
                @addConstraint(model, -M[:,mode]* modes[mode,time,system] + z[:,mode,time,system] .<= 0)
                @addConstraint(model, m[:,mode] * (1-modes[mode,time,system]) + z[:,mode,time,system] .<= A[system][:,:,mode]*x[:,time,system]+E[system][:,:,mode]*d[:,time,system])
                @addConstraint(model, m[:,mode] * modes[mode,time,system] - z[:,mode,time,system] .<= 0)
                @addConstraint(model, -M[:,mode] * (1-modes[mode,time,system]) - z[:,mode,time,system] .<= -A[system][:,:,mode]*x[:,time,system]-E[system][:,:,mode]*d[:,time,system])
            end

            @addConstraint(model, x[:,time+1,system] .== z[:,1,time,system] + z[:,2,time,system] + z[:,3,time,system])
            @addConstraint(model, slacks[time,system] >= 0)
            @addConstraint(model, slacks[time,system] >= x[2,time,system] - x_min)
            @addConstraint(model, slacks[time,system] >= x_max - x[2,time,system])
        end
    end
    @addConstraint(model, coolingOn + heatingOn <= 1)
    @setObjective(model, Min, sum(slacks)+ rho * sum(modes[1:2,:,:]) + rho * coolingOn + rho * heatingOn)

    solve(model)

    getValue(modes)
end
