clear
clc
% shading interp
s.EdgeColor = 'none';

% Входные параметры
a=1;
sigma=1/4;
%Пространство
lx=0;
rx=1;
ly=0;
ry=1;
%Время
in=0;
fin=1;

%Инициализация
sol=[];
x=[];
y=[];
t=[];

%Параметры сетки
Nx=30;
Ny=30;
hx=(rx-lx)/(Nx-1);
hy=(ry-ly)/(Ny-1);
M=2+round(2*(fin-in)*sqrt(1/hx^2+1/hy^2));
tau=(fin-in)/(M-1); 

u=zeros(M,Nx,Ny);

%Координаты узлов
for i=1:Nx
    x(i)=lx+(i-1)*hx;
end;
for i=1:Ny
    y(i)=ly+(i-1)*hy;
end;
for j=1:M
    t(j)=in+(j-1)*tau;
end;

%   Начальное условие:
for ix=1:Nx
    for iy=1:Ny
        u(1,ix,iy)=5*cos(pi*x(ix)/2)*cos(3*pi*y(iy)/2);
        u(2,ix,iy)=u(1,ix,iy);
    end;
end;
%Численное решение:
w=zeros(Nx,Ny); 
% Вспомогательная функция при переходе со слоя на слой
alpha_x=zeros(Nx-1,1);
beta_x=zeros(Nx-1,1);
alpha_y=zeros(Ny-1,1);
beta_y=zeros(Ny-1,1);
Ax=a^2*sigma*tau^2/hx^2;
Cx=1+2*Ax;
Ay=a^2*sigma*tau^2/hy^2;
Cy=1+2*Ay;
for j=2:M-1
%   Вычисление вспомогательной функции w 
    for iy=2:Ny-1
%       Прямой ход прогонки по x
    alpha_x(ix)=1;
    beta_x(ix)=-hx*2;
        for ix=2:Nx-1
            F=a^2*(u(j,ix-1,iy)-2*u(j,ix,iy)+u(j,ix+1,iy))/hx^2+...
              a^2*(u(j,ix,iy-1)-2*u(j,ix,iy)+u(j,ix,iy+1))/hy^2+...
              2*(x(ix)+y(iy));
          alpha_x(ix)=Ax/(Cx-Ax*alpha_x(ix-1));
          beta_x(ix)=(F+Ax*beta_x(ix-1))/(Cx-Ax*alpha_x(ix-1));
        end;
        w(Nx,iy)=2*(1+y(iy));
%       Обратный ход прогонки по x
        for ix=Nx-1:-1:1
            w(ix,iy)=alpha_x(ix)*w(ix+1,iy)+beta_x(ix);
        end;
    end;
%   Вычисление функции v на новом слое по времени
    for ix=2:Nx-1
%       Прямой ход прогонки по y
        alpha_y(1)=1;
        beta_y(1)=-hy*t(j)^2;
        for iy=2:Ny-1
            F=tau^2*w(ix,iy)+Ay*(u(j-1,ix,iy-1)-2*u(j,ix,iy-1))-...
              Cy*(u(j-1,ix,iy)-2*u(j,ix,iy))+...
              Ay*(u(j-1,ix,iy+1)-2*u(j,ix,iy+1));
            alpha_y(iy)=Ay/(Cy-Ay*alpha_y(iy-1));
            beta_y(iy)=(F+Ay*beta_y(iy-1))/(Cy-Ay*alpha_y(iy-1));
        end;
%       Обратный ход прогонки по y
        u(j+1,ix,Ny)=(t(j+1))^2*(x(ix)+1);
        for iy=Ny-1:-1:1
            u(j+1,ix,iy)=alpha_y(iy)*u(j+1,ix,iy+1)+beta_y(iy);
        end;
    end;
%   Граничные условия:
    for iy=1:Ny
        u(j+1,1,iy)=u(j+1,2,iy)-t(j+1)^2*hx;
        u(j+1,Nx,iy)=t(j+1)^2*(1+y(iy));
    end;
    for ix=1:Nx
        u(j+1,ix,Ny)=t(j+1)^2*(1+x(ix));
        u(j+1,ix,1)=u(j+1,ix,2)-t(j+1)^2*hy;
    end;
end;

%   Аналитическое решение:
sol=zeros(M,Nx,Ny);
for iy=1:Ny
    for ix=1:Nx
        for j=1:M
            sol(j,ix,iy)=ansol8(t(j),x(ix),y(iy));
        end;
    end;
end;

for j=1:M
%   Численное решение:
    num_j(1:Nx,1:Ny)=u(j,1:Nx,1:Ny);
%   Аналитическое решение:
    sol_j(1:Nx,1:Ny)=sol(j,1:Nx,1:Ny);
%   Погрешность решений:
    err_j(1:Nx,1:Ny)=sol_j-num_j;
    
    subplot(1, 3, 1), surf(x,y,num_j);
    xlabel('x')
    ylabel('y')
    axis([lx rx ly ry -6 6]);
    subplot(1, 3, 2), surf(x,y,sol_j);
    xlabel('x')
    ylabel('y')    
    axis([lx rx ly ry -6 6]);
    subplot(1, 3, 3), surf(x,y,err_j);
    xlabel('x')
    ylabel('y')
    axis([lx rx ly ry -3 3]);
    
    drawnow
    pause(5/M);
    hold off;
end;

% syms mu1 mu2 e r yy
% mu1 = e^2;
% mu2 = e^2*(1+r);
% yy=diff(mu2,e,2);

