function f_vector = F6(U,t,h, jac)
    
    Uleft = @(t) exp(-t);

    N = length( U );
    
    if ( jac == 0 )
        f_vector(1) = -1/h*( U(1)^2 - U(1)*Uleft(t) ) + exp( U(1)^2 );
    
        for n=2:N
            f_vector(n) = -1/h*(U(n)^2 - U(n)*U(n-1)) + exp(U(n)^2);
        end
    
    elseif ( jac == 1)
        f_vector(1,1) = -1/h*( 2*U(1) - Uleft(t) ) + 2*U(1)^2*exp( U(1)^2 );
        
        for n=3:N
            f_vector(n,n-1) = U(n)/h;
            f_vector(n,n) = -1/h*(2*U(n) - U(n-1)) + 2*U(n)*exp(U(n-1)^2);
        end
    end

end