function U_hat = ERK(u, A, B, tau, s)

L = length(u(1,:));
for k = 1 : s
    sum = zeros(1,L);
    if k > 1
        for j = 1 : k-1
            sum = sum + A(k,j) * w(j,:);
        end
    end
    w(k,:) = funct(u+tau*sum);
end;
sum1 = zeros(1,L);
for k = 1 : s
    sum1 = sum1 + B(k) * w(k,:);
end;
U_hat(1,:) = u + tau * sum1;

end