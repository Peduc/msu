function F_vector = F( Eps,H,U )
	N=length(U);
    Uleft = -5;
    Uright = 2;
    F_vector(1,1)=Eps/H^2*( U(2) -2*U(1) + Uleft) +...
                  U(1)/(2*H)*( U(2) - Uleft ) - U(1);
    for count=2:N-1
        F_vector(count,1)=(Eps/H^2)*(U(count+1)-2*U(count)+U(count-1))+...
                          U(count)*(U(count+1)-U(count-1))/(2*H)-U(count);
    end;
    F_vector(N,1)=Eps/H^2*( Uright -2*U(N-1) + U(N-2)) + ...
                  U(N-1)/(2*H)*( Uright - U(N-2) ) - U(N-1);
    
end

