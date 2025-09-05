function simple_standard()
	A = [3 2 -1; 1 -1 3]
	b = [1; 6]
	c = [1, 2, 3]
	LP(A, b, c, objective = :min, relation = :eq)
end
