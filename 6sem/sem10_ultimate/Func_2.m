function F_vector=Func_2(U,N,H,Eps)
%   du/dt
    F_vector(1)=U(2*(N-1)+1)+...
                exp(Eps*U(1))-(U(2)-2*U(1)+4/3*U(1)-1/3*U(2))/H^2;
    for n=2:(N-1)-1
        F_vector(n)=U(n+2*(N-1))+exp(Eps*U(n))-(U(n+1)-2*U(n)+U(n-1))/H^2;
    end;
    F_vector(N-1)=U(2*(N-1)+N-1)+...
                  exp(Eps*U(N-1))-(U(N-2)-2*U(N-1)+4/3*U(N-1)-1/3*U(N-2))/H^2;             
    
%   dv/dt    
    F_vector(N)=-1/H^2*((4/3*U(1)-1/3*U(2))+U(2)-2*U(1));
    for n=N+1:2*N-3
        F_vector(n)=-1/H^2*(U(n-1-(N-1))-2*U(n-(N-1))+U(n+1-(N-1)));
    end;
    F_vector(2*N-2)=-1/H^2*...
                    ((4/3*U(N-1)-1/3*U(N-2))+U(N-2)-2*U(N-1));               

%   dg/dt
    for n=2*(N-1)+1:3*(N-1)
        F_vector(n)=U(n-(N-1));
    end;                
end

