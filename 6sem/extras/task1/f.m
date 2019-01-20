function f_vector=f(U)

mass = [1.9891*10^30; 5.9736*10^24]; %Солнце/Земля
G = 6.67300*10^(-11); % Гравитационная постоянная 
mode=2;% 1 - Солнце закреплено // 2 - Солнце не закреплено

if mode==1
    
    f_vector(1)=U(3);
    f_vector(2)=U(4);
    f_vector(3)=-G*mass(1)*U(1)/( sqrt(U(1)^2+U(2)^2) )^3;
    f_vector(4)=-G*mass(1)*U(2)/( sqrt(U(1)^2+U(2)^2) )^3;

elseif mode==2
    
    f_vector(1)=U(3);
    f_vector(2)=U(4);
    f_vector(3)=-G*mass(1)*( U(1) - U(5) )/( sqrt( ( U(1)-U(5) )^2+( U(2)-U(6) )^2) )^3;
    f_vector(4)=-G*mass(1)*( U(2) - U(6) )/( sqrt( ( U(1)-U(5) )^2+( U(2)-U(6) )^2) )^3;

    f_vector(5)=U(7);
    f_vector(6)=U(8);
    f_vector(7)=-G*mass(2)*( U(1) - U(5) )/( sqrt( ( U(1)-U(5) )^2+( U(2)-U(6) )^2) )^3;
    f_vector(8)=-G*mass(2)*( U(2) - U(6) )/( sqrt( ( U(1)-U(5) )^2+( U(2)-U(6) )^2) )^3;

end

end