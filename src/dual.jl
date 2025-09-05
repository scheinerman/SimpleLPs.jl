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

    # swap ≤ with ≥
    rel = P.relation == :leq ? :geq : :leq

    if P.relation == :eq
        if obj == :max
            rel = :leq
        else
            rel = :geq
        end
    end

    return LP(AA, bb, cc; objective=obj, relation=rel, nonneg=nonneg)
end
