clear
clc

% Входные параметры
% a=1/2;
% sigma=0.05;
l=0;
r=-1;
in=0;
fin=1;
c=-1;

%Инициализация
err=[];
x=[];
t=[];

% Сетка
%|c|tau>=h;
N=40;
M=30;
h=(r-l)/(N-1);
tau=(fin-in)/(M-1); 

if abs(c)*tau >= h
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
    end;
    
%   Граничное условие:
    for j=1:M
        y(j,1)=t(j);
    end; 
      
    for j=1:M-1
        for i=1:N-1
            y(j+1,i+1)=(1-h/(c*tau))*y(j+1,i)+(h/(c*tau))*y(j,i)+(h/c)*exp(-(x(i)+t(j)));
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
else
    disp(':(');
    disp(abs(c)*tau);
    disp(h);
end;