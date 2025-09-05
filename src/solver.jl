"""
    solve(P::LP, verbose::Bool=false)

Solve a linear program `P` returning the pair `(z, x)`
where `z` is the optimal value and `x` is the optimal vector.

If `P` is either unbounded or infeasible, that will be reported as an 
information message and `nothing` will be returned. 
"""
function solve(P::LP, verbose::Bool=false)
    set_solver_verbose(verbose)
    MOD = Model(get_solver())

    nv = nvars(P)
    nc = ncons(P)

    if P.nonneg
        @variable(MOD, x[1:nv] >= 0)
    else
        @variable(MOD, x[1:nv])   # unconstrained
    end

    if P.objective == :min
        @objective(MOD, Min, sum(P.c[i]*x[i] for i in 1:nv))
    else
        @objective(MOD, Max, sum(P.c[i]*x[i] for i in 1:nv))
    end

    rel = P.relation

    for i in 1:nc
        if rel == :leq
            @constraint(MOD, sum(P.A[i, j] * x[j] for j in 1:(nv)) ≤ P.b[i])
        elseif rel == :geq
            @constraint(MOD, sum(P.A[i, j] * x[j] for j in 1:(nv)) ≥ P.b[i])
        else
            @constraint(MOD, sum(P.A[i, j] * x[j] for j in 1:(nv)) == P.b[i])
        end
    end

    optimize!(MOD)
    status = Int(termination_status(MOD))

    if status == 1
        obj_value = objective_value(MOD)
        xx = JuMP.value.(x)
        return obj_value, xx
    end

    if status == 2
        @info "This linear program is infeasible"
        return nothing
    end

    if status == 3
        @info "This linear program is unbounded"
        return nothing
    end

    @info "Unknown termination status"

    return nothing
end
