function Yak = Y( U,H,N,Eps )
    Yak(1,1) = Eps*exp(Eps*U(1)) + (2-4/3)/H^2;
    Yak(1,2) = (1/3-1)/H^2;
    Yak(1,2*(N-1)+1) = 1;
    
    for n =2:N-2
        Yak(n,n) = Eps*exp(Eps*U(n)) + 2/H^2;
        Yak(n,n-1) = -1/H^2;
        Yak(n,n+1) = -1/H^2;
        Yak(n,n+2*(N-1)) = 1;
    end;
    Yak(N-1,N-1) = Eps*exp(Eps*U(N-1)) + (2-4/3)/H^2;
    Yak(N-1,N-2) = (1/3-1)/H^2;   
    Yak(N-1,3*(N-1)) = 1;
    
    Yak(N,1) = (1/3-1)/H^2;
    Yak(N,2) = (2-4/3)/H^2;
    for n =N+1:2*(N-1)-1
        Yak(n,n+1-(N-1)) = -1/H^2;
        Yak(n,n-(N-1)) = 2/H^2;
        Yak(n,n-1-(N-1)) = -1/H^2;
    end;
    Yak(2*(N-1),N-1) = (2-4/3)/H^2;
    Yak(2*(N-1),N-2) = (1/3-1)/H^2;
    
    for n =2*(N-1)+1:3*(N-1)
        Yak(n,n-(N-1)) = 1;
    end;
end