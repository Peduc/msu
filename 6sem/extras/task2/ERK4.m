function result = ERK4(tau, U)

    result = zeros([16, 1]);

    b(1) = 1/6;
    b(2) = 1/3;
    b(3) = 1/3;
    b(4) = 1/6;
    a(2, 1) = 1/2;
    a(3, 1) = 0;
    a(3, 2) = 1/2;
    a(4, 1) = 0;
    a(4, 2) = 0;
    a(4, 3) = 1;

    w1 = F2(U);
    w2 = F2(U + tau * a(2, 1) * w1);
    w3 = F2(U + tau * ( a(3, 1) * w1 + a(3, 2) * w2) );
    w4 = F2(U + tau * ( a(4, 1) * w1 + a(4, 2) * w2 + a(4, 3) * w3) );
    result(:, 1) = U + tau * (b(1) * w1 + b(2) * w2 + b(3) * w3 + b(4) * w4 );

end
    