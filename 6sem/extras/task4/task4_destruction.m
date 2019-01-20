%{
    Диагностика Разрушения Решения
    du/dt = u^2
    u(0) = 1
    Решить с помощью CROS1 и DIRK
    Графики p_eff(t) 
%}

clear; clc;
close all;

T = 1.5;
J(1) = 10;
tau = T/( J );
r = 4;
K = 8;

U0 = 1;
a = [(1+1i)/2; 1]; % CROS1 || DIRK1

U_dirk = [];
U_cros = [];
peff_cros = [];
peff_dirk = [];

% tj = 0:tau:T;
% "Keep calm and thicken grids" (c)
for k = 1:K
    
    U_dirk(k,1) = U0;
    U_cros(k,1) = U0;
    tau = T/( J(k) );
    %DIRK
    for j = 1:J(k)
            w = U_dirk(k,j)^2/( 1 - a(2)*tau*2*U_dirk(k,j) );
            U_dirk(k,j+1)=U_dirk(k,j)+tau*real(w);
    end
    
    %CROS
    for j = 1:J(k)
            w = U_cros(k,j)^2/( 1 - a(1)*tau*2*U_cros(k,j) );
            U_cros(k,j+1)=U_cros(k,j)+tau*real(w);
    end
    
%     if (k == 1)
%         U_cros(k,:) = U_1(k,:);
%         U_dirk(k,:) = U_2(k,:);
%     end
%     
%     if ( k >1 )
%        rk = 0;
%        for j = 1:J(1)
%            U_cros(k,j) = U_1(k,rk+1);
%            U_dirk(k,j) = U_2(k,rk+1);
%            rk = r^(2-1)+rk;
%        end
%     end
%    
    J(k+1) = J(k)*r;
end

k = K-2;
for j = 1:J(1)*r^(k-1)
    
    peff_cros(j) = log( abs( U_cros(k+1,r*j+1) - U_cros(k,j+1) )/abs( U_cros(k+2,r^2*j+1) - U_cros(k+1,r*j+1) ) )/log(r);
    peff_dirk(j) = log( abs( U_dirk(k+1,r*j+1) - U_dirk(k,j+1) )/abs( U_dirk(k+2,r^2*j+1) - U_dirk(k+1,r*j+1) ) )/log(r);
  
end

tau_t = T/( length(peff_cros) - 1 );
t = 0:tau_t:T;

figure(1)
plot(t,peff_dirk, 'o');
grid on;

figure(2)
plot(t,peff_cros,'o');
grid on;



