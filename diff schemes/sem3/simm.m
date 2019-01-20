clear
clc
% colormap(jet)
% hidden on

% Входные параметры
a=2;
sigma=0.5;
l=0;
r=pi();
in=0;
fin=1;
%Только для графика
syms Ym Xm
% Ym=-exp(Xm)+Xm+(1-exp(1));

err=[];
x=[];
t=[];
Am=[];

% Сетка
% tau<=h^2/(2*a^2);
N=20;
M=500;
h=(r-l)/(N-1);
tau=(fin-in)/(M-1);

if (tau) <= (h^2/(2*a^2))
%   Сетка
    for i=1:N
        x(i)=l+(i-1)*h;
    end;
    for j=1:M
        t(j)=in+(j-1)*tau;
    end;
%   Численное решение:
    y=zeros(M,N);
    for i=1:N
        y(1,i)=pi()-x(i);
    end
    
%   Параметры системы с трехдиагональной матрицей:
    A=sigma*(a^2)*tau/(h^2);
    B=A;
    C=2*A+1;
    for j=1:M-1
%       Прямой ход прогонки:
        alpha(1)=1;
        beta(1)=h;
        for i=2:N-1
            F=y(j,i)+tau*cos(x(i)/2)*exp(t(j))+(tau*(1-sigma)*...
                a^2/h^2)*(y(j,i-1)-2*y(j,i)+y(j,i+1));
            alpha(i)=B/(C-A*alpha(i-1));
            beta(i)=(A*beta(i-1)+F)/(C-A*alpha(i-1));
        end;
        kappa_2=0;
        mu_2=0;        
%       Обратный ход прогонки:
        y(j+1,N)=(mu_2+kappa_2*beta(N-1))/(1-kappa_2*alpha(N-1));
        for i=N-1:-1:1
            y(j+1,i)=alpha(i)*y(j+1,i+1)+beta(i);
        end;
    end;
%   Аналитическое решение и вычисление погрешности:

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

