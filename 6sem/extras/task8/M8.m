function f_matrix = M8( V, N, h, eps)

    f_matrix(1,1) = 4/3 - (2 + eps*h^2*exp( eps*V(1) ) );
    f_matrix(1,2) = 1 - 1/3;
    f_matrix(N-1,N-2) = 1 - 1/3;
    f_matrix(N-1,N-1) = 4/3 - (2 + eps*h^2*exp( eps*V(N-1) ) );
    
    for n = 2:N-2
        f_matrix(n,n-1) = 1;
        f_matrix(n,n+1) = 1;
        f_matrix(n,n) = -1*( 2 + eps*h^2*exp( eps*V(n) ) ); 
    end
    
    for n = N:2*N-2
        f_matrix(n,n) = 1;
    end
    
end

