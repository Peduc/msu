clear
clc
% shading interp
s.EdgeColor = 'none';

% Входные параметры
%Пространство
lx=0;
rx=1;
ly=0;
ry=1;
%Время
in=0;
fin=1;
a=1;


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
%   Численное решение:
for j=2:M-1
    for iy=2:Ny-1
        for ix=2:Nx-1
            u(j+1,ix,iy)=2*u(j,ix,iy)-u(j-1,ix,iy)+(a*tau)^2*...
                         ((u(j,ix+1,iy)-2*u(j,ix,iy)+u(j,ix-1,iy))/hx^2+...
                         (u(j,ix,iy+1)-2*u(j,ix,iy)+u(j,ix,iy-1))/hy^2)+...
                         2*tau^2*(x(ix)+y(iy));
        end;
    end;
%   Граничные условия:
    for iy=1:Ny
        u(j+1,Nx,iy)=t(j+1)^2*(1+y(iy));
        u(j+1,1,iy)=u(j+1,2,iy)-t(j+1)^2*hx;
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
% %   Погрешность решений:
    err_j(1:Nx,1:Ny)=sol_j-num_j;
    
    subplot(1, 3, 1), surf(x,y,num_j);
    axis([lx rx ly ry -6 6]);
    subplot(1, 3, 2), surf(x,y,sol_j);
    axis([lx rx ly ry -6 6]);
    subplot(1, 3, 3), surf(x,y,err_j);
    axis([lx rx ly ry -2 2]);
    
    drawnow
    pause(5/M);
    hold off;
end;