function f_vector = F7_1(U,h, jac, eps)
    
    Uleft = -5;
    Uright = 2;
    N = length( U );
    
    if ( jac == 0 )
        f_vector(1) = eps/h^2*( U(2) -2*U(1) + Uleft) + U(1)/(h)*( U(1) - Uleft ) - U(1);
        f_vector(N) = eps/h^2*( Uright -2*U(N-1) + U(N-2)) + U(N-1)/(h)*( U(N-1) - U(N-2) ) - U(N-1);
    
        for n=2:N-1
            f_vector(n) = eps/h^2*(U(n+1) - 2*U(n) + U(n-1)) + U(n)/(h)*( U(n) - U(n-1) ) - U(n);
        end
    
    
    elseif ( jac == 1)
        
        f_vector(1,1) = -2*eps/(h)^2 + 1/(h)*( 2*U(1) - Uleft ) - 1;
        f_vector(1,2) = eps/(h)^2;
        f_vector(N,N) = -2*eps/(h)^2 + 1/(h)*( 2*U(N-1) -U(N-2) ) - 1;
        f_vector(N,N-1) = eps/(h)^2 - U(N-1)/(h);
        
        for n=2:N-1
            
            f_vector(n,n-1) = eps/h^2;
            f_vector(n,n+1) = eps/h^2;
            f_vector(n,n) = eps/h^2*( -2 ) + ( 2*U(n) - U(n-1) )/(h) - 1;
            
        end
        
    end

end