clear
clc

% Входные параметры
% a=1/2;
% sigma=0.05;
l=0;
r=-1;
% l=0;
% r=1;
in=0;
fin=1;
c=-1;
% c=2;

%Инициализация
err=[];
x=[];
t=[];

% Сетка
N=50;
M=30;
h=(r-l)/(N-1);
tau=(fin-in)/(M-1); 

%   Сетка
for i=1:N
    x(i)=l+(i-1)*h;
end;
for j=1:M
    t(j)=in+(j-1)*tau;
end;

%   Начальное условие:
for i=1:N
    y(1,i)=0;
%     y(1,i)=cos(pi()*x(i));    
end;

%   Граничное условие:
for j=1:M
    y(j,1)=t(j);
%     y(j,1)=exp(-t(j));
end;

for j=2:M
    for i=2:N
%         y(j,i)=(1+c*tau/h)^(-1)*...
%             ((c*tau/h-1)*y(j,i-1)+(1+c*tau/h)*y(j-1,i-1)+...
%             (1-c*tau/h)*y(j-1,i)+2*tau*exp(-(x(i)+t(j))));
        y(j,i)=y(j-1,i-1)+((1-c*tau/h)/(1+c*tau/h))*...
               (y(j-1,i)-y(j,i-1))+...
               (2*tau/((1+c*tau/h)))*exp(-(x(i)+h/2+t(j)+tau/2));
%         y(j,i)=y(j-1,i-1)+((1-c*tau/h)/(1+c*tau/h))*...
%                (y(j-1,i)-y(j,i-1))+...
%                (2*tau/((1+c*tau/h)))*(x(i)+t(j)+h/2+tau/2);           
    end;
end;

%   Аналитическое решение и вычисление погрешности:
    sol=zeros(M,N);
    for j=1:M
        for i=1:N
            sol(j,i)=ansol5(t(j),x(i));
%             err(j,i)=anso(t(j),x(i)); 
        end;
    end;
    %   Численное решение:
    subplot(1, 3, 1),surf(x,t,y);
    %   Аналитическое решение:
    subplot(1, 3, 2),surf(x,t,sol);
    %   Погрешность решений:
    subplot(1, 3, 3),surf(x,t,y-sol);
   
