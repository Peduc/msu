function U = ERKS_AG(tau, u2, u3, len)

    % Массивы координат и скоростей в данный и последующий моменты времени:
    New_U2 = zeros([len, 1]);
    New_U3 = zeros([len, 1]);
    U = zeros([len, 2]);

    % ERK2:
    b(1) = 1/4;
    b(2) = 3/4;
    a(2, 1) = 2/3;
    w1 = F2(u2);
    w2 = F2(u2 + tau * a(2, 1) * w1);
    New_U2 = u2 + tau * (b(1) * w1 + b(2) * w2);


    % ERK3:
    b(1) = 2/9;
    b(2) = 1/3;
    b(3) = 4/9;
    a(2, 1) = 1/2;
    a(3, 2) = 3/4;
    a(3, 1) = 0;
    w1 = F2(u3);
    w2 = F2(u3 + tau * a(2, 1) * w1);
    w3 = F2(u3 + tau * (a(3, 1) * w1 + a(3, 2) * w2));
    New_U3 = u3 + tau * (b(1) * w1 + b(2) * w2 + b(3) * w3);


    U(:, 1) = New_U2(:, 1);
    U(:, 2) = New_U3(:, 1);

end
    




