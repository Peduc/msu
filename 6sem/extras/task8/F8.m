function f_vector = F8(V,N,h)
   
    for n = 1:N-1
        f_vector(n) = h^2*V(N-1+n);
    end
    f_vector(N) = -1/h^2*( (4/3*V(1) - 1/3*V(2)) + V(2) - 2*V(1) );
    
    for n = N+1:2*N-3
        f_vector(n) = -1/h^2*( V(n-(N-2)) - 2*V(n-(N-1)) + V(n-N) );
    end
     f_vector(2*N-2) = -1/h^2*( (4/3*V(N-1) - 1/3*V(N-2)) + V(N-2) - 2*V(N-1) );
     
end