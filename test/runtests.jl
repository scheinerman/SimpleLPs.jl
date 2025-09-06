using Test
using SimpleLPs

@testset "Basic" begin
    A = [11 2 11; 8 6 9; 8 8 5; 6 5 8; 4 1 2; 2 -1 4]
    b = [0, 1, 10, 3, 2, 5]
    c = [3, 4, 7]

    P = LP(A, b, c)
    v, x = solve(P)
    @test v == 7.5
    @test c'*x == v

    A = [3 2 -1; 1 -1 3]
    b = [1; 6]
    c = [1, 2, 3]
    P = LP(A, b, c; objective=:min, relation=:eq)

    v, x = solve(P)
    @test v==6
end

@testset "Dual" begin
    A = [11 2 11; 8 6 9; 8 8 5; 6 5 8; 4 1 2; 2 -1 4]
    b = [0, 1, 10, 3, 2, 5]
    c = [3, 4, 7]
    P = LP(A, b, c)
    D = dual(P)
    @test solve(P)[1] == solve(D)[1]

    A = [3 2 -1; 1 -1 3]
    b = [1; 6]
    c = [1, 2, 3]
    P = LP(A, b, c; objective=:min, relation=:eq)
    D = P'
    @test solve(P)[1] == solve(D)[1]
end

@testset "Dual Dual" begin
    A = [11 2 11; 8 6 9; 8 8 5; 6 5 8; 4 1 2; 2 -1 4]
    b = [0, 1, 10, 3, 2, 5]
    c = [3, 4, 7]

    for rel in [:eq, :leq, :geq]
        for nonneg in [true, false]
            for obj in [:max, :min]
                @show (rel, nonneg, obj)
                P = LP(A, b, c, objective=obj, nonneg=nonneg, relation=rel)
                PP = P''
                @test P==PP
            end
        end
    end
end
