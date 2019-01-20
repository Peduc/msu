clear
clc
% colormap(jet)
% hidden on

% Входные параметры
a=1/2;
sigma=0.25;
l=0;
r=pi()/2;
in=0;
fin=1;
%Только для графика
% syms Ym Xm
% Ym=-exp(Xm)+Xm+(1-exp(1));

err=[];
x=[];
t=[];
Am=[];

% Сетка
% tau<=h^2/(2*a^2);
N=40;
M=50;
h=(r-l)/(N-1);
tau=(fin-in)/(M-1);

if (tau) <= (h/sqrt(1-4*sigma))
%   Сетка
    for i=1:N
        x(i)=l+(i-1)*h;
    end;
    for j=1:M
        t(j)=in+(j-1)*tau;
    end;
%   Численное решение:
    for i=2:N-1
        y(1,i)=1+sin(3*x(i));
        y(2,i)=y(1,i);
    end;
    y(1,N)=y(1,N-1);
    y(1,1)=1;    
    y(2,N)=y(2,N-1);
    y(2,1)=cos(tau); 
    
%   Параметры системы с трехдиагональной матрицей:
    A=sigma*(a^2)*tau^2/(h^2);
    B=A;
    C=2*A+1;
    for j=2:M-1
%       Прямой ход прогонки:
        alpha(1)=0;
        beta(1)=cos(t(j));
        for i=2:N-1
            
            F=2*y(j,i)-y(j-1,i)+(tau^2)*(...
                sigma*a^2*(y(j-1,i-1)-2*y(j-1,i)+y(j-1,i+1))/h^2 ...
                +(1-2*sigma)*a^2*(y(j,i-1)-2*y(j,i)+y(j,i+1))/h^2-...
            cos(t(j+1)));
            
            alpha(i)=B/(C-A*alpha(i-1));
            beta(i)=(A*beta(i-1)+F)/(C-A*alpha(i-1));
        end;
        kappa_2=1;
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
            sol(j,i)=ansol4(t(j),x(i));
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
    disp(tau);
    disp((h/sqrt(1-4*sigma)));
end;

