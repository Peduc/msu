clear
clc
% colormap(jet)
% hidden on
% Входные параметры
a=2;
l=0;
r=pi();
in=0;
fin=1;

%Только для графика
% syms Xm Tm Ym 
% [Xm,Tm] = meshgrid(0:0.5:1,0:6);
% Ym=(cos(Xm/2))*(exp(-2*Tm))*((8/pi()+(1/3)*((exp(3*Tm))-1)));

err=[];
x=[];
t=[];
Am=[];
% Сетка
% tau<=h^2/(2*a^2);
N=10;
M=600;
h=(r-l)/(N-1);
tau=(fin-in)/(M-1);
if (tau) <= (h^2/(2*a^2))
%	Явная схема для уравнения теплопроводности на отрезке   
    for i=1:N
        x(i)=l+(i-1)*h;
    end;
    for j=1:M
        t(j)=in+(j-1)*tau;
    end;
%   Численное решение:
    y=zeros(M,N);
%   Начальное условие:
    for i=1:N
        y(1,i)=pi()-x(i);
    end;
    
    for j=1:M-1
%       Решение уравнения на внутренних узлах сетки:
        for i=2:N-1
            y(j+1,i)=y(j,i)+(a^2*tau/(h^2))*(y(j,i+1)-2*y(j,i)+y(j,i-1))+tau*cos(x(i)/2)*exp(t(j));
        end
%       Граничные условия:
        y(j+1,1)=y(j+1,2)+h; 
        y(j+1,N)=0; 
     
    end;
    
    sol=zeros(M,N);
    for j=1:M
        for i=1:N
            sol(j,i)=anso(t(j),x(i));
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
    disp(':(')
end;

