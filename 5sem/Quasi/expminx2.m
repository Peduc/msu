clear
clc

%Параметры
N=10;
eps=0.01;
l=0;
r=10000;
tr=1;
um=1;

syms X;
syms T;
syms M;
syms C;

tau=(tr-l)/N;

%Модельное решение
um=1.0;
c=16;
m=10;

%Задание сетки
h=(r-l)/N;
x=[];
t=[];
u=0.0;

for i=1:N+1
    x(i)=l+(i-1)*h;
    t(i)=l+(i-1)*tau;
%    disp(ksi(t(i),c,m));
end;

for i=2:N
     if (u/um)>=(1-eps)
         break;
     end;
    u=u+0.25*tau*double((subs(diff(ksi(T,C,M)),{T,C,M},{t(i),c,m}))+(subs(diff(ksi(T,C,M)),{T,C,M},{t(i-1),c,m})))*(exp1(ksi(t(i),c,m))+exp1(ksi(t(i-1),c,m)));
end;