clear
clc
% colormap(jet)
% hidden on

% Входные параметры
a=1/2;
% sigma=0.5;
l=0;
r=pi()/2;
in=0;
fin=1;

% %Только для графика
% syms Ym Xm
% % Ym=-exp(Xm)+Xm+(1-exp(1));

err=[];
x=[];
t=[];
Am=[];

% Сетка
N=20;
M=70;
h=(r-l)/(N-2);
tau=(fin-in)/(M-1);

if (tau) <= (h^2/(2*a^2))
%   Сетка
    for i=1:N
        x(i)=l-h/2+(i-1)*h;
    end;
    for j=1:M
        t(j)=in+(j-1)*tau;
    end;
%   Численное решение:
    y=zeros(M,N);
%   Начальное условие:
    for i=2:N-1
        y(1,i)=1+sin(3*x(i));
        y(2,i)=y(1,i);
    end;
    y(1,N)=y(1,N-1);
    y(2,N)=y(2,N-1);
    y(1,1)=-y(1,2)+2*cos(t(1));    
    y(2,1)=y(1,1);      
    for j=2:M-1
%       Решение уравнения на внутренних точках:
        for i=2:N-1
            y(j+1,i)=2*y(j,i)-y(j-1,i)+(a*tau/h)^2*...
                    (y(j,i+1)-2*y(j,i)+y(j,i-1))-...
                     tau^2*cos(t(j));
        end
%       Граничные условия:
%         y(j+1,1)=cos(t(j+1));
        y(j+1,1)=-y(j+1,2)+2*cos(t(j));
        y(j+1,N)=y(j+1,N-1);
    end;
    
%   Аналитическое решение и вычисление погрешности:
    sol=zeros(M,N);
    for j=1:M
        for i=1:N
            sol(j,i)=ansol4(t(j),x(i)); 
        end;
    end;
    Nxl=1;
    Nxr=N;
    %   Численное решение:
    subplot(1, 3, 1),surf(x(Nxl:Nxr),t,y(:,Nxl:Nxr));
    xlabel('x')
    ylabel('t')
    title('numerical solution')
    axis([l r in fin 0 2]);
    %   Аналитическое решение:
    subplot(1, 3, 2),surf(x(Nxl:Nxr),t,sol(:,Nxl:Nxr));
    xlabel('x')
    ylabel('t') 
    title('analytical solution')
    axis([l r in fin 0 2]);
    %   Погрешность решений:
    subplot(1, 3, 3),surf(x(Nxl:Nxr),t,...
    y(:,Nxl:Nxr)-sol(:,Nxl:Nxr));
    xlabel('x')
    ylabel('t')    
    title('error')
    axis([l r in fin -0.02 0.03]);
else
    disp(':(');
    disp(tau);
    disp((h^2/(2*a^2)));
end;

