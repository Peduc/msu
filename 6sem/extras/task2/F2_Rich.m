function f_vector = F2_Rich(U,mass,g)
    
    %Масса луны
    M_moon = mass(3);
    %Масса солнца
    M = mass(1);
    %Масса Земли
    m = mass(2);
 
    r = @(x1, y1, x2, y2) ( sqrt( (x1 - x2)^2 + (y1 - y2)^2) );
    
    % 1-4 — Солнце, 5-8 — Земля, 9-12 — Луна
    Rse = r( U(1), U(2), U(5), U(6) );
    Rsm = r( U(1), U(2), U(9), U(10) );
    Rem = r( U(5), U(6), U(9), U(10) );
    
    f_vector(1) = U(3);
    f_vector(2) = U(4);
    f_vector(3) = g*m*(U(5)-U(1))/Rse^3 - g*M_moon*(U(1)-U(9))/Rsm^3;
    f_vector(4) = g*m*(U(6)-U(2))/Rse^3 - g*M_moon*(U(2)-U(10))/Rsm^3;
    
    f_vector(5) = U(7);
    f_vector(6) = U(8);
    f_vector(7) = -g*M*(U(5)-U(1))/Rse^3 - g*M_moon*(U(5)-U(9))/Rem^3;
    f_vector(8) = -g*M*(U(6)-U(2))/Rse^3 - g*M_moon*(U(6)-U(10))/Rem^3;
    
    f_vector(9) = U(11);
    f_vector(10) = U(12);
    f_vector(11) = -g*m*(U(9)-U(5))/Rem^3 - g*M*(U(9)-U(1))/ Rsm^3;
    f_vector(12) = -g*m*(U(10)-U(6))/Rem^3 - g*M*(U(10)-U(2))/ Rsm^3;

end