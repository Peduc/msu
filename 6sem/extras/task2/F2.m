function f_matrix = F2( U )

    %mass = [—олнце, «емл€, Ћуна, комета √алле€ ]
    mass = [1.9891*10^30; 5.9736*10^24; 7.3477*10^22; 2.2*10^14];
    
    Ms = mass(1);
    Mg = mass(4);
    Me = mass(2);
    Mm = mass(3);
    g = 6.67300 * 10^(-11);
    
    % 1-4 Ч —олнце, 5-8 Ч  оммета √алле€, 9-12 Ч «емл€, 13-16 Ч Ћуна
    r = @(x1, y1, x2, y2) ( sqrt( (x1 - x2)^2 + (y1 - y2)^2) );
    
    Rsg = r(U(1), U(2), U(5), U(6));
    Rse = r(U(1), U(2), U(9), U(10));
    Rsm = r(U(1), U(2), U(13), U(14));
    Rge = r(U(5), U(6), U(9), U(10));
    Rgm = r(U(5), U(6), U(13), U(14));
    Rem = r(U(9), U(10), U(13), U(14));
    
    f_matrix(1, 1) = U(3);
    f_matrix(2, 1) = U(4);
    f_matrix(3, 1) = g*Mg/Rsg^3 * (U(1) - U(5)) + g*Me/Rse^3 * (U(1) - U(9)) + g*Mm/Rsm^3 * (U(1) - U(13));
    f_matrix(4, 1) = g*Mg/Rsg^3 * (U(2) - U(6)) + g*Me/Rse^3 * (U(2) - U(10)) + g*Mm/Rsm^3 * (U(2) - U(14));
    f_matrix(5, 1) = U(7);
    f_matrix(6, 1) = U(8);
    f_matrix(7, 1) = g*Ms/Rsg^3 * (U(1) - U(5)) + g*Me/Rge^3 * (U(5) - U(9)) + g*Mm/Rgm^3 * (U(5) - U(13));
    f_matrix(8, 1) = g*Ms/Rsg^3 * (U(2) - U(6)) + g*Me/Rge^3 * (U(6) - U(10)) + g*Mm/Rgm^3 * (U(6) - U(14));
    f_matrix(9, 1) = U(11);
    f_matrix(10, 1) = U(12);
    f_matrix(11, 1) = g*Ms/Rse^3 * (U(1) - U(9)) + g*Mg/Rge^3 * (U(5) - U(9)) + g*Mm/Rem^3 * (U(9) - U(13));
    f_matrix(12, 1) = g*Ms/Rse^3 * (U(2) - U(10)) + g*Mg/Rge^3 * (U(6) - U(10)) + g*Mm/Rem^3 * (U(10) - U(14));
    f_matrix(13, 1) = U(15);
    f_matrix(14, 1) = U(16);
    f_matrix(15, 1) = g*Ms/Rsm^3 * (U(1) - U(13)) + g*Mg/Rgm^3 * (U(5) - U(13)) + g*Me/Rem^3 * (U(9) - U(13));
    f_matrix(16, 1) = g*Ms/Rsm^3 * (U(2) - U(14)) + g*Mg/Rgm^3 * (U(6) - U(14)) + g*Me/Rem^3 * (U(10) - U(14));
    
end

