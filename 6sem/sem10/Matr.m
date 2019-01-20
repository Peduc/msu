function Matr = M8( V, N, H, Eps)

    Matr(1,1)=4/3-(2+Eps*H^2*exp(Eps*V(1)));
    Matr(1,2)=1-1/3;
    Matr(N-1,N-2)=1-1/3;
    Matr(N-1,N-1)=4/3-(2+Eps*H^2*exp(Eps*V(N-1)));
    
    for n = 2:N-2
        Matr(n,n-1)=1;
        Matr(n,n+1)=1;
        Matr(n,n)=-1*(2+Eps*H^2*exp(Eps*V(n))); 
    end;
    
    for n = N:2*N-2
        Matr(n,n)=1;
    end;
    
end