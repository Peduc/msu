function Yak = Y( H,U )
	N=length(U);
%     Yak(1,:)=0;    
    Yak(1,1)=-(2*U(2)-U(1))/H+2*U(2)*exp(U(2)^2);
    for count=2:N
        Yak(count,count-1)=U(count)/H;
        Yak(count,count)=-(2*U(count)-U(count-1))/H...
                                +2*U(count)*exp(U(count)^2);
    end;
end

