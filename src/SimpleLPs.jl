module SimpleLPs

using ChooseOptimizer
using LatexPrint
using JuMP

import Base: adjoint, show
import LatexPrint: latex_form
export LP, dual, random_Abc, solve, show

"""
 LP(A, b, c; objective=:min, relation=:geq, nonneg=true, verbose=false)

 Create a linear program. For the named arguments:
 * `objective` must be one of `:min` or `:max` [default: `:min`]
 * `nonneg` must be either `true` or `false` [default: `true`]
 * `relation` must be one of `:leq`, `:eq`, or `:geq` [default: `:geq`]
 """
struct LP
    A::AbstractMatrix
    b::AbstractVector
    c::AbstractVector

    objective::Symbol     # one of :max or :min
    relation::Symbol      # one of :leq :eq or :geq
    nonneg::Bool          # if true, variables are nonnegative

    function LP(A, b, c; objective::Symbol=:min, relation::Symbol=:geq, nonneg::Bool=true)
        if !_size_check(A, b, c)
            error("Size mismatch")
        end

        if !_objective_check(objective)
            error("Unknown objective $objective. Use :max or :min")
        end

        if !_relation_check(relation)
            error("Unknown relation $relation. Use :leq, :eq, or :geq")
        end

        new(A, b, c, objective, relation, nonneg)
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
include("show.jl")
include("dual.jl")
include("lap.jl")

function random_Abc(m::Int, n::Int, lo::Int, hi::Int)
    A = rand(lo:hi, m, n)
    b = rand(lo:hi, m)
    c = rand(lo:hi, n)
    return A, b, c
end

end # module SimpleLPs
