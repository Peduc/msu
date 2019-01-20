function Yak = Y( H,N )
    Yak(N,1) = -1/H^2*(4/3 - 2);
    Yak(N,2) = -1/H^2*(-1/3 + 1);
    Yak(2*N-2,N-1) = -1/H^2*(4/3 - 2);
    Yak(2*N-2,N-2) = -1/H^2*(-1/3 + 1);
    
    for n = 1:N-1
        Yak(n,N-1+n) = H^2;
    end;
    
    for n = N+1:2*N-3 
        Yak(n,n-N) = -1/H^2;
        Yak(n,n-N+1) = -1/H^2*(-2);
        Yak(n,n-N+2) = -1/H^2;
    end;
end