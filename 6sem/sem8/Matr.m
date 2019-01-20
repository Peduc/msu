function F_vector = F( H,U )
	N=length(U);
%     F_vector(1,1)=0;    
    F_vector(1,1)=-(U(2)^2-U(2)*U(1))/H+exp(U(2)^2);
    for count=2:N
        F_vector(count,1)=-(U(count)^2-U(count)*U(count-1))/H...
                          +exp(U(count)^2);
    end;
end

