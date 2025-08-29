function show(io::IO, P::LP)
    obj = P.objective == :max ? "max" : "min"

    rel = "="
    if P.relation == :geq
        rel = "≥"
    end

    if P.relation == :leq
        rel = "≤"
    end

    m = nvars(P)
    n = ncons(P)
    println(io, "Linear Program with $m variables and $n constraints")
    print(io, "$obj c'*x s.t. Ax $rel b, ")
    if P.nonneg
        print(io, "x ≥ 0")
    else
        print(io, "x unconstrained")
    end
end
