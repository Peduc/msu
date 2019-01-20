%{
    Решить Задачу:
    d^2{ Uxx - exp(eps*U) }/dt^2 + Uxx = 0
    0 < x < l
    0 < t < T
    Ux(0,t) = 0
    Ux(l,t) = 0
    0 < t < T
    U(x,0) = Uinit0(x) = 0
    Ut(x,0) = Uinit1(x) = sin(x)*( x*(pi - x) )^2
    l = pi
    T = "На вкус и цвет"

%}

clear; clc;
close all;

l = pi;
T = 1;
eps = 0.5;
N = 40;
J = 25;
h = (l - 0)/( N - 1 );
tau = (T - 0)/( J - 1 );
a = ( 1+1i )/2;

Uinit0 = 0;
Uinit1_xx = @(x) ( -sin(x)*( x*( pi - x ) )^2*( eps + 1 ) + 4*cos(x)*( x*( pi - x ) )*( pi - 2*x )...
                + 2*sin(x)*((pi - 2*x )^2 - 2*( x*( pi - x ) )) ) ;
N = N+1;            
xn = 0:h:l;
tj = 0:tau:T;

V = zeros(2*N-2,J);
Fu = Jac8( h, N );

for n = 1:N-1
   V(n,1) = Uinit0;
end

for n = N:2*N-2
   V(n,1) = Uinit1_xx( xn(n-N+1 ) );
end

for j = 1:J-1
    
    M = M8( V(1:2*N-2,j), N, h, eps );
    F = F8( V(1:2*N-2,j),N,h );
    w = ( M - a*tau*Fu )^(-1)*F';
    
    V(1:2*N-2,j+1) = V(1:2*N-2,j) + tau*real(w);
end


for i = 1:N-1
    u(i,:) = V(i,:);
end

% for j = 1:J
%     u(N,j) = Uright;
% end

surf(tj, xn, u)
xlabel('t')
ylabel('x')
zlabel('u')















