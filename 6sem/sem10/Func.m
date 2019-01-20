function F_vector = Func( V,N,H )
    for n=1:N-1
        F_vector(n)= H^2*V(N-1+n);
    end;
    
    F_vector(N)=-1/H^2*((4/3*V(1)-1/3*V(2))+V(2)-2*V(1));
    for n=N+1:2*N-3
        F_vector(n)=-1/H^2*(V(n-(N-2))-2*V(n-(N-1))+V(n-N));
    end;
     F_vector(2*N-2)=-1/H^2*...
                    ((4/3*V(N-1)-1/3*V(N-2))+V(N-2)-2*V(N-1));
     
end

