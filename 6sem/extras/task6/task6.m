%{
    Решение нелиненйного уравнения переноса с помощью
    1) - ERK1
    2) - DIRK1
    3) - CROS1
    4) - CROS2
    4) - KN

    du/dt + u*du/dx = exp( u^2 );
    u(0,t) = exp( -t ); // Uleft
    u(x,t) = -x+1; // Uinit
    0 < X < 1;
    0 < T <= 0.03; 
%}
clear; clc;
close all;

mode = 1; % 1) - ERK1 || 2) - DIRK1 || 3) - CROS1 || 4) - KN || 5) - CROS2 
a_=[1; (1+1i)/2; 0.5];
coeff = [0.789343464+0.9821367i; 0.210656-0.570521i; 0.644441-1.143956i; 0.5250464+1.453646i; 0.4573733+0.23510048i; 0.0426266+0.394632i];
%coeff = [b1; b2; c21; a21; a11; a22];
Uleft = @(t) exp(-t);
Uinit = @(x) (-x + 1);

N = 100;
M = 100;
T = 0.03;
a = 0;
b = 1;
h = (b - a)/( N - 1);
tau = T/(M-1);

U=zeros(M,N);
tn=0:tau:T;
xn=0:h:(b - a);
   
for n=1:N
        U(1,n) = Uinit( xn(n) );
end

for m=1:M
    U(m,1) = Uleft( tn(m) );
end
    

if ( mode == 1 )
   
    for k=1:M-1
       w(k,2:N) = F6( U(k,2:N), tn(k) + tau/2, h, 0);
       U(k+1,2:N) = U(k,2:N) + tau*w(k,2:N);
    end
    
elseif (mode == 2 )
    
    for k=1:M-1
        F = F6( U(k,2:N), tn(k) + tau/2, h, 0);
        Fu = F6( U(k,2:N), tn(k), h, 1);
        w = F / ( eye(N-1) - a_(1)*tau*Fu );
        
        U(k+1,2:N) = U(k,2:N) + tau*real(w);
    end
    
elseif (mode == 3 )
        
    for k=1:M-1
        F = F6( U(k,2:N), tn(k) + tau/2, h, 0);
        Fu = F6( U(k,2:N), tn(k), h, 1);
        w = F / ( eye(N-1) - a_(2)*tau*Fu );
        
        U(k+1,2:N) = U(k,2:N) + tau*real(w);
    end
    
elseif (mode == 4 )
    
    for k=1:M-1
        F = F6( U(k,2:N), tn(k) + tau/2, h, 0);
        Fu = F6( U(k,2:N), tn(k), h, 1);
        w = F / ( eye(N-1) - a_(3)*tau*Fu );
        
        U(k+1,2:N) = U(k,2:N) + tau*real(w);
    end
    
elseif (mode == 5 )
    
    for k=1:M-1
    F1  = F6( U(k,2:N), tn(k) + tau/2, h, 0);
    Fu1 = F6( U(k,2:N), tn(k), h, 1);
    w1  = F1 / ( eye(N-1) - coeff(5)*tau*Fu1 ); 
    F2  = F6( U(k,2:N) + tau*real( coeff(3)*w1 ), tn(k) + tau/2, h, 0);
    Fu2 = F6( U(k,2:N) + tau*real( coeff(4)*w1 ), tn(k), h, 1);
    w2  = F2 / ( eye(N-1) - coeff(6)*tau*Fu2 );
    
    U(k+1,2:N) = U(k,2:N) + tau*real( coeff(1)*w1 + coeff(2)*w2);
    end
end
    
%Построение Графиков
figure(mode+1);
surf(xn',tn,U);
view([120 45]);
xlabel('X');
ylabel('T');
zlabel('U');




