clear
clc
% shading interp
s.EdgeColor = 'none';

% Входные параметры
%Пространство
lx=0;
rx=pi/2;
ly=0;
ry=pi;
%Время
in=0;
fin=0.1;
a=3;

eps=10^-10;
count=10^4;

%Инициализация
sol=[];
x=[];
y=[];
t=[];


% Смена направления движения
if a<0
    [r,l] = deal(l,r) ;
end;

%Параметры сетки
Nx=30;
Ny=30;
M=30;
hx=(rx-lx)/(Nx-1);
hy=(ry-ly)/(Ny-1);
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
        u(1,ix,iy)=sin(2*x(ix))*sin(3*y(iy));
    end;
end;
%   Численное решение:
w=zeros(Nx,Ny); 
% //вспомогательная функция при переходе со слоя на слой
alpha_x=zeros(Nx-1,1);
beta_x=zeros(Nx-1,1);
alpha_y=zeros(Ny-1,1);
beta_y=zeros(Ny-1,1);
Ax=0.5*a^2*tau/hx^2;
Cx=1+2*Ax;
Ay=0.5*a^2*tau/hy^2;
Cy=1+2*Ay;
for j=2:M
%   Вычисление вспомогательной функции w 
    for iy=2:Ny-1
%       Прямой ход прогонки по x
        for ix=2:Nx-1
%             disp(ix);
            F=u(j-1,ix,iy)+0.5*a^2*tau*...
              (u(j-1,ix,iy-1)-2*u(j-1,ix,iy)+u(j-1,ix,iy+1))/hy^2;
            alpha_x(ix)=Ax/(Cx-Ax*alpha_x(ix-1));
            beta_x(ix)=(F+Ax*beta_x(ix-1))/(Cx-Ax*alpha_x(ix-1));
        end;
        w(Nx,Ny)=0;
%       Обратный ход прогонки по x
        for ix=Nx-1:-1:1
            w(ix,iy)=alpha_x(ix)*w(ix+1,iy)+beta_x(ix);
        end;
    end;
%   Вычисление функции u на новом слое по времени
    for ix=2:Nx-1
%       Прямой ход прогонки по y
        for iy=2:Ny-1
            F=w(ix,iy)+0.5*a^2*tau*...
              (w(ix-1,iy)-2*w(ix,iy)+w(ix+1,iy))/hx^2;
            alpha_y(iy)=Ay/(Cy-Ay*alpha_y(iy-1));
            beta_y(iy)=(F+Ay*beta_y(iy-1))/(Cy-Ay*alpha_y(iy-1));
        end;
%       Обратный ход прогонки по y
        u(j+1,ix,Ny)=0;
        for iy=Ny-1:-1:1
            u(j,ix,iy)=alpha_y(iy)*u(j,ix,iy+1)+beta_y(iy);
        end;
    end;
%   Граничные условия:
    for iy=1:Ny
        u(j,Nx,iy)=0;
    end;
end;

%   Аналитическое решение:
sol=zeros(M,Nx,Ny);
for iy=1:Ny
    for ix=1:Nx
        for j=1:M
            sol(j,ix,iy)=ansol_omm(t(j),x(ix),y(iy));
        end;
    end;
end;

for j=1:10
%   Численное решение:
    num_j(1:Nx,1:Ny)=u(j,1:Nx,1:Ny);
%   Аналитическое решение:
    sol_j(1:Nx,1:Ny)=sol(j,1:Nx,1:Ny);
%   Погрешность решений:
    err_j(1:Nx,1:Ny)=sol_j-num_j;
    
    subplot(1, 3, 1), surf(x,y,num_j);
    xlabel('x')
    ylabel('y')
    title('numerical solution')
    axis([0 pi/2 0 pi -1 1]);
    
    subplot(1, 3, 2), surf(x,y,sol_j);
    xlabel('x')
    ylabel('y')
    title('analytical solution')
    axis([0 pi/2 0 pi -1 1]);
    
    subplot(1, 3, 3), surf(x,y,err_j);
    xlabel('x')
    ylabel('y')
    title('error')
    axis([0 pi/2 0 pi -10^-1 10^-1]);
  
    drawnow
    pause(4/M);
    hold off;
end;