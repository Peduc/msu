function Y = NORM(A)

[N, M] = size(A);

Y = 0;

for i = 1 : N
    for j = 1 : M 
        Y = Y + A(i, j)^2;
    end
end

Y = sqrt(Y);

end
              