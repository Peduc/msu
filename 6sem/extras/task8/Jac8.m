function f_vector = Jac8( h, N )

    f_vector(N,1) = -1/h^2*(4/3 - 2);
    f_vector(N,2) = -1/h^2*(-1/3 + 1);
    
    f_vector(2*N-2,N-1) = -1/h^2*(4/3 - 2);
    f_vector(2*N-2,N-2) = -1/h^2*(-1/3 + 1);
    
    for n = 1:N-1
        f_vector(n,N-1+n) = h^2;
    end
    
    for n = N+1:2*N-3 
        f_vector(n,n-N) = -1/h^2;
        f_vector(n,n-N+1) = -1/h^2*(-2);
        f_vector(n,n-N+2) = -1/h^2;
    end
    
end

