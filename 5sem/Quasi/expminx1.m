clear
clc

%Параметры
N=10;
eps=0.01;
l=0.1;
r=10000;
syms X;
beta=[-1/12;1/720;-1/30240];
beta1=[];
%Модельное решение
um=1;

%Задание сетки
h=(r-l)/N;
x=[];
u=0;
for i=1:N+1
    x(i)=l+(i-1)*h;
end;

for i=2:N+1
    u=u+(exp1(x(i-1))+exp1(x(i)))*h/2;
end;

beta1(1)=-1/12;
for p=2:100
    b=0;
    for l=1:p-1
       b=b+(beta1(l))/(factorial(2*p-2*l+1));
    end;
    beta1(p)=(1/(2*p+1)-1/2)*(1/factorial(2*p))-b;
end;

for i=2:4
    if (u/um)>=(1-eps)
        break;
    end;
    u=u+h^(i)*beta(i-1)*(subs(diff(funsem4(X),i),X,x(N+1))-subs(diff(funsem4(X),i),X,x(1)));
end;