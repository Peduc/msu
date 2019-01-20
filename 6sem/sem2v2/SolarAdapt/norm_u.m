function normu = norm_u(u)
N = length(u);
normu = 0;
for i = 1 : N
    normu = normu + u(i)^2;
end
normu = sqrt(normu);

end