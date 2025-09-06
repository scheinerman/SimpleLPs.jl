"""
	dual(P::LP)

Create the dual linear program to `P`.
"""
function dual(P::LP)
    AA = P.A'
    bb = P.c
    cc = P.b

    # swap max/min
    obj = P.objective == :max ? :min : :max

    nonneg = true

    # equality constraints become unconstrained variables
    if P.relation == :eq
        nonneg = false
    end

    rel = :eq

    if P.relation == :eq
        if P.objective == :max
            rel = :geq
        else
            rel = :leq
        end
    else
        rel = P.relation == :leq ? :geq : :leq
    end

    if !P.nonneg
        rel = :eq
    end

    return LP(AA, bb, cc; objective=obj, relation=rel, nonneg=nonneg)
end

Base.adjoint(P::LP) = dual(P)
