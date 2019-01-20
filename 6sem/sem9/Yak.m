function Yak = Y( Eps,H,U )
	N=length(U);
    Uleft = -5;
    Uright = 2;
       
    Yak(1,1) = -2*Eps/(H^2) + 1/(2*H)*( U(2) - Uleft ) - 1;
    Yak(1,2) = Eps/(H^2) + U(1)/(2*H);
    Yak(N,N) = -2*Eps/(H^2) + 1/(2*H)*( Uright -U(N-2) ) - 1;
    Yak(N,N-1) = Eps/(H^2) - U(N-1)/(2*H);
    for count=2:N-1
        Yak(count,count-1)=Eps/H^2-U(count)/(2*H);
        Yak(count,count)=-2*Eps/H^2+(U(count+1)-U(count-1))/(2*H)-1;
        Yak(count,count+1)=Eps/H^2+U(count)/(2*H);                    
    end;
end

