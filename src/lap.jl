function latex_form(P::LP)
    bdx = "\\mathbf{x}"    # bold x
    z = "\\ge \\mathbf{0}" # zero

    result = "\\" * string(P.objective) * latex_form(P.c) * "^T" * bdx
    result *= "\n\\quad" * latex_form("s.t.") * "\\quad"
    result *= latex_form(P.A) * bdx

    R = P.relation

    if R==:eq
        result *= "="
    end
    if R==:leq
        result *= "\\le"
    end
    if R==:geq
        result *= "\\ge"
    end

    result *= latex_form(P.b) * ",\\ "

    if P.nonneg
        result *= bdx * z
    else
        result *= bdx * latex_form(" unrestricted")
    end

    return result
end
