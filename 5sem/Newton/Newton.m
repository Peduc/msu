clear
clc

%Численный поиск корней многочлена y=(x - 1) (x - 2)^2 (x - 3)^3 
%Задание пано
l=0.7;
r=4.1;
N=1000;
h=(r-l)/N;
x0=4;
eps=0.1;

%Формирование многочлена
x=[];
y=[];
for i=1:N+1
    x(i)=l+h*(i-1);
    disp('');
    y(i)=(x(i) - 1)*((x(i) - 2)^2)*((x(i) - 3)^3);
end;

%Дихотомия
xdih=[];
xdih(1)=l;
xdih(2)=r;
i=1;
while abs(xdih(i+1)-xdih(i))<eps
    xdih(i)=(xdih(i)+xdih(i+1))/2;
    if ((i>1)&(fun(xdih(i))*fun(xdih(i+1))>0))
        xdih(i)=xdih(i+1);
        break;
    end;
end;

%Метод Ньютона 
%Массив производных
der=[];
%for i=2:N+1
%    der(i)=(y(i)-y(i-1))/h
%end;

%Понял, что можно было не писать код сверху
xr=[];
syms X;
xr(1)=4;
pos=[];
k=0;
p=1;
while p>=1
    for i=1:N
      xr(i+1)=xr(i)-fun(xr(i))/(subs(diff(fun(X)),X,xr(i)));
     if ((i>1)&(abs((xr(i+1)-xr(i))/(1-(xr(i+1)-xr(i))/(xr(i)-xr(i-1))))<eps))
         k=k+1;
         pos(k)=i+1;
         p=1/(1-(xr(pos(k))-xr(pos(k)-1))/(xr(pos(k)-1)-xr(pos(k)-2)));
         disp(p);
         disp(xr(pos(k)));
         break;
     end;
    end;
    fun(X)=fun(X)/(X-xr(pos(k)))^p;
end;


