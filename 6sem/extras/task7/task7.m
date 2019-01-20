%{
    du/dt - eps*d^2u/dt^2 = u*du/dt - u
    0 < x <1, 0 <= t <= T
    u(0,t) = Uleft(t) = -5
    u(1,t) = Uright(t) = 2
    0 <= t <= T
    U(x,0) = Uinit(x)
    0 < x < 1
    Uinit = [ (x + 1) + (x - 5)*exp( -3*ksi ) ] / ( 1 + exp( -3*ksi ) )  
    ksi = ( x - 0.5 )/eps

%}
clear; clc;
close all;

mode = 2; % 1) - ERK1 || 2) - DIRK1 || 3) - CROS1 || 4) - KN || 5) - CROS2 
a_=[1; (1+1i)/2; 0.5];
eps = 0.25;
Uinit = @(x) ( (x + 1) + (x - 5)*exp( -3*( x - 0.5 )/eps ) ) / ( 1 + exp( -3*( x - 0.5 )/eps ) );
Uleft = -5;
Uright = 2;


N = 88;
M = 10;
T = 0.2;
a = 0;
b = 1;
h = (b - a)/( N - 1);
tau = T/(M-1);

U_1=zeros(M,N);
U_2=zeros(M,N);
tn=0:tau:T;
xn=0:h:(b - a);

U_1(1,1) = Uleft;
U_1(1,N) = Uright;

U_2(1,1) = Uleft;
U_2(1,N) = Uright;

for n=2:N-1
        U_1(1,n) = Uinit( xn(n) );
        U_2(1,n) = Uinit( xn(n) );
end

for m=1:M
        U_1(m,1) = Uleft;
        U_1(m,N) = Uright;
        
        U_2(m,1) = Uleft;
        U_2(m,N) = Uright;
end


for k=1:M-1
        F = F7_2( U_2(k,2:N-1), h, 0, eps);
        Fu = F7_2( U_2(k,2:N-1), h, 1, eps);
        w = F / ( eye(N-2) - a_(2)*tau*Fu );
        
        U_2(k+1,2:N-1) = U_2(k,2:N-1) + tau*real(w);
        
        F = F7_1( U_1(k,2:N-1), h, 0, eps);
        Fu = F7_1( U_1(k,2:N-1), h, 1, eps);
        w = F / ( eye(N-2) - a_(2)*tau*Fu );
        
        U_1(k+1,2:N-1) = U_1(k,2:N-1) + tau*real(w);
end


figure(mode+1);
surf(xn',tn,U_1);
view([-160 20]);
xlabel('X');
ylabel('T');
zlabel('U');

figure(mode+2);
surf(xn',tn,U_2);
view([-160 20]);
xlabel('X');
ylabel('T');
zlabel('U');












    