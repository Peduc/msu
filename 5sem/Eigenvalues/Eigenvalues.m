% Uxx-9Ux+lambdaU=0
% U(0)=U(1)=0
% 1% точности

clear
clc

%Входные параметры
N=5;
left=0;
right=1;
h=(right-left)/(N-1);
eps=0.01;

%Переменные
x=[];
u=[];
A=[];
x0=[];
x0old=[];
L=[];
Lf=[];

%Задание сетки
for i=1:N
   x(i)=left+(i-1)*h;
end;

for i=1:N-2
    x0(i)=1;
end;

x0=x0';

u(1)=0;
u(N)=0;

for i=1:N-2
    for j=1:N-2
        if (j==i)
            A(j,i)=-2/h^2;
        end;
        if (j==i+1)
        	A(j,i)=1/h^2-(-9)/(2*h);
        end;
        if (j==i-1)
        	A(j,i)=1/h^2+(-9)/(2*h);
        end;
    end;
end;

for s=1:10000
    x0old=x0;
    x0 = inv(A)*x0;
    L(s) = dot(x0,x0)/dot(x0,x0old);
    L(s) = 1/L(s);
%     Lold=1/L();
    if (s~=1) && (abs(L(s-1)-L(s))<= eps)
        disp(s);
        break
    end;
end

Lf=-L(s);





