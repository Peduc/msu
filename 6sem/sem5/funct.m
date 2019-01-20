% function  f_vector  = funct( Mass, X, Y, VX, VY )
function  f_vector  = funct(Mass, Charge, U,L)
%     k=9*10^9;
%     e=1.6*10^(-19);
    k=1;
    e=-1;    
    f_vector(1,1)= U(3);
    f_vector(2,1)= U(4);
    f_vector(3,1)=(1/Mass(1))*...
                (k*Charge(1)*Charge(3)*e^2)*(U(1)/(U(1)^2+U(2)^2)^(3/2)+...
                 2*U(9)*(U(1)-U(5)));
    f_vector(4,1)=(1/Mass(1))*...
                (k*Charge(1)*Charge(3)*e^2*U(2)/(U(1)^2+U(2)^2)^(3/2)+...
                 2*U(9)*(U(2)-U(6)));
    f_vector(5,1)= U(7);
    f_vector(6,1)= U(8);
    f_vector(7,1)=(1/Mass(2))*...
                (k*Charge(2)*Charge(3)*e^2*U(5)/(U(5)^2+U(6)^2)^(3/2)-...
                 2*U(9)*(U(1)-U(5)));
    f_vector(8,1)=(1/Mass(2))*...
                (k*Charge(2)*Charge(3)*e^2*U(6)/(U(5)^2+U(6)^2)^(3/2)-...
                2*U(9)*(U(2)-U(6)));
	f_vector(9,1)=(U(1)-U(5))^2+(U(2)-U(6))^2-L^2;

end
