function [Fu,var] = Jac4(L)
    
    q1 = 1;
    q2 = -1;
    Q = 1;
    m1 = 1;
    m2 = 1;
    k = 1;
    
    syms x1 y1 vx1 vy1 x2 y2 vx2 vy2 l;
    u = [x1; y1; vx1; vy1; x2; y2; vx2; vy2; l;];
    betta_1 = k*q1*Q/( m1*( y1^2 + x1^2 )^(3/2) );
    betta_2 = k*Q*q2/( m2*( x2^2 + y2^2 )^(3/2) );

    F = [vx1; vy1; betta_1*x1 + 2*l/m1*( x1 - x2 ); betta_1*y1 + 2*l/m1*( y1 - y2 ); vx2; vy2; betta_2*x2 - 2*l/m2*( x1 - x2 ); betta_2*y2  - 2*l/m2*( y1 - y2 ); ( x1 - x2 )^2 + ( y1 - y2 )^2 - L^2];
    Fu = jacobian(F,u);
    var = symvar(Fu); %[ l, x1, x2, y1, y2]
  
end


%{
    Скопируйте код внижу( в комментах ) в командную строку
    Для проверки того, что запихивать в вектор VAL
    CИ:
    q1 = -1.6022*10^(-19)
    q2 = -q1
    Q = 400*q1
    m1 = 9.1*10^(-31)
    m2 = 9.1*10^(-31)
    eps0 = 8.8541*10^(-12)
    k = 1/(4*pi*eps0)
    
    CГC:
    q1 = 1;
    q2 = 1;
    Q = 1;
    m1 = 1;
    m2 = 1;
    k = 1;
    L = 1;    

    syms x1 y1 vx1 vy1 x2 y2 vx2 vy2 l;
    u = [x1; y1; vx1; vy1; x2; y2; vx2; vy2; l;]
    betta_1 = k*q1*Q/(m1*( y1^2 + x1^2 )^(3/2) )
    betta_2 = k*Q*q2/(m2*( x2^2 + y2^2 )^(3/2) )
    F = [vx1; vy1; betta_1*x1 + 2*l/m1*( x1 - x2 ); betta_1*y1 + 2*l/m1*( y1 - y2 ); vx2; vy2; betta_2*x2 - 2*l/m1*( x1 - x2 ); betta_2*y2  - 2*l/m1*( y1 - y2 ); ( x1 - x2 )^2 + ( y1 - y2 )^2 - L^2];
    Fu = jacobian(F,u);
    U=[5; L/2; 0; 0; 5; -L/2; 0; 0; l];

    var = symvar(Fu);

%}
