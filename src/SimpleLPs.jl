module SimpleLPs

using ChooseOptimizer
using JuMP

export LP, solve

"""
 LP(A, b, c; objective=:min, relation=:geq, nonneg=true, verbose=false)

 Create a linear program.
 """
struct LP
    A::AbstractMatrix
    b::AbstractVector
    c::AbstractVector

    objective::Symbol     # one of :max or :min
    relation::Symbol      # one of :leq :eq or :geq
    nonneg::Bool          # if true, variables are nonnegative
    verbose::Bool         # pass on to solver

    function LP(A, b, c; objective=:min, relation=:geq, nonneg=true, verbose=false)
        if !_size_check(A, b, c)
            error("Size mismatch")
        end

        if !_objective_check(objective)
            error("Unknown objective $objective. Use :max or :min")
        end

        if !_relation_check(relation)
            error("Unknown relation $relation. Use :leq, :eq, or :geq")
        end

        new(A, b, c, objective, relation, nonneg, verbose)
    end
end

function nvars(P::LP)
    return length(P.c)
end

function ncons(P::LP)
    length(P.b)
end

function _size_check(A, b, c)::Bool
    m, n = size(A)
    return length(b) == m && length(c) == n
end

function _objective_check(o::Symbol)::Bool
    return o==:min || o==:max
end

function _relation_check(r::Symbol)::Bool
    return r==:leq || r==:eq || r==:geq
end

include("solver.jl")

end # module SimpleLPs
