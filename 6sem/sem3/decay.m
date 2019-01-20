clear
clc

%Входные параметры
N_in=10^12;
lambda = (1.61)*10^(-6);
tau=86410/5;
Rounds=100;

%Инициализация
u=[];

% ERK1: 
% a = 0; 
% DIRK1: 
% a= 1; 
% KN: 
% a= 1/2; 
% CROS1: 
% a= (1 + i)/2;

u(1)=N_in;
for j=2:Rounds
    w=(1-a*tau*(-lambda))^(-1)*(-lambda*u(j-1));
    u(j)=u(j-1)+tau*real(w);
end;

plot(u);