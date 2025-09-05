# SimpleLPs

This is an extremely basic package for solving linear programs. It's purpose is to simplify 
solving LPs given by a matrix and two vectors. There are only two functions:
* `LP` to set up a linear program.
* `solve` to solve it. 


## Creating Linear Programs

The function to create linear programs is `LP`. It takes three mandatory arguments followed by three named optional arguments arguments. 

The mandatory arguments are:
* `A`: an $m\times n$-matrix,
* `b`: an $n$-vector, and
* `c`: an $m$-vector. 

The optional arguments (which must be named are):
* `objective` (Symbol): must be one of the symbols `:min` (default) or `:max`.
* `relation` (Symbol): must be one of `:geq` (default), `:eq`, or `:leq`.
* `nonneg` (Bool): must be one of `true` (default) or `false`. When this is `false`, the variables are not bounded (may be negative).

For example, `LP(A, b, c, objective=:max, relation=:leq)` creates a linear program of the form $\max c^Tx$ subject to $Ax \le  b$, $x \ge 0$. 

## Solving Linear Programs

The `solve` function returns a pair `(z, x)` where `z` is the optimal value and `x` is the optimal vector. T
he `solve` function takes an optional second, Boolean, argument which, if set to `true` gives verbose output during the solving process.

If the linear program is either unbounded or infeasible, an information message is printed and `nothing` is returned. 

## Examples

```
julia> using SimpleLPs

julia> A = rand(1:10,4,7);

julia> b = rand(3:8,4);

julia> c = rand(2:9,7);

julia> P = LP(A,b,c)
Linear Program with 7 variables and 4 constraints
min c'*x s.t. Ax ≥ b, x ≥ 0

julia> solve(P)
(1.6, [0.0, 0.0, 0.0, 0.0, 0.8, 0.0, 0.0])

julia> P = LP(A,b,c,relation=:eq)
Linear Program with 7 variables and 4 constraints
min c'*x s.t. Ax = b, x ≥ 0

julia> (v,x)=solve(P)
(1.8647430117222725, [0.005410279531109108, 0.0, 0.0, 0.02164111812443643, 0.7069431920649234, 0.0, 0.03426510369702434])

julia> A*x
4-element Vector{Float64}:
 4.0
 6.0
 4.0
 6.000000000000001

julia> c'*x
1.8647430117222723

julia> A = rand(10:20,4,4);

julia> b = rand(10:20,4);

julia> c = rand(-10:-6,4);

julia> P = LP(A,b,c)
Linear Program with 4 variables and 4 constraints
min c'*x s.t. Ax ≥ b, x ≥ 0

julia> solve(P)
[ Info: This linear program is unbounded

julia> A = rand(10:20,4,4);

julia> b = rand(10:20,4);

julia> c = rand(5:12,4);

julia> P = LP(A,b,-c,relation=:eq)
Linear Program with 4 variables and 4 constraints
min c'*x s.t. Ax = b, x ≥ 0

julia> solve(P)
[ Info: This linear program is infeasible.
```

## Random Data

Use `random_Abc(m,n,lo,hi)` to create matrix $A$ and vectors $b$ and $c$ with integer entries 
between `lo` and `hi` (inclusive). Here $A$ is an $m\times n$ matrix, and the vectors are sized appropriately. 

## LaTeX Form

```
julia> A,b,c= random_Abc(3,5,1,8);

julia> P = LP(A, b, c, objective=:max, relation=:eq)
Linear Program with 5 variables and 3 constraints
max c'*x s.t. Ax = b, x ≥ 0

julia> solve(P)
(1.666666666666666, [0.48484848484848503, 0.0, 0.0606060606060605, 0.6969696969696969, 0.0])

julia> lap(P)
\max\left[
\begin{array}{r}
1 \\
3 \\
8 \\
1 \\
7 \\
\end{array}
\right]^T\mathbf{x}
\quad\text{s.t.}\quad\left[
\begin{array}{rrrrr}
4 & 4 & 6 & 1 & 6 \\
6 & 3 & 5 & 4 & 4 \\
4 & 5 & 8 & 8 & 7 \\
\end{array}
\right]\mathbf{x}=\left[
\begin{array}{r}
3 \\
6 \\
8 \\
\end{array}
\right],\ \mathbf{x}\ge \mathbf{0}
```
![](LP.png)


## Dual

The `dual` function works, but only sort-of. Needs a lot of love. 

```
julia> P
Linear Program with 5 variables and 3 constraints
max c'*x s.t. Ax = b, x ≥ 0

julia> dual(P)
Linear Program with 3 variables and 5 constraints
min c'*x s.t. Ax ≥ b, x unconstrained
```

## Comments

* The `LP` datastructure is immutable. To make changes, such as from minimization to maximization, just create a new `LP`. 
* The `solve` function's work is done by the [HiGHS](https://github.com/jump-dev/HiGHS.jl) solver. This can be changed using the [ChooseOptimizer](https://github.com/scheinerman/ChooseOptimizer.jl) module. 
* To do anything more interesting, use [JuMP](https://jump.dev/JuMP.jl/stable/) instead of this.
* I have no plans to register this. 
