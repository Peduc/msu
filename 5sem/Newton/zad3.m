clear
clc

%Численный поиск корней многочлена y=exp(x)-2 
x0=2;
N=1000;
eps=0.01;

%Метод Ньютона 

%Понял, что можно было не писать код сверху
xr=[];
syms X;
xr(1)=-2;
pos=[];
k=0;
p=1;
psi=[];
tau=[];
tau(1)=((fexp(xr(1)))^2)/((fexp(xr(1)))^2+(fexp(xr(1)))^2)

for i=1:N
    xr(i+1)=xr(i)-tau(i)*fexp(xr(i))/(subs(diff(fexp(X)),X,xr(i)));
    tau(i+1)=((fexp(xr(i)))^2+eps*(fexp(xr(i)-tau(i)*fexp(xr(i))/(subs(diff(fexp(X)),X,xr(i)))))^2)/((fexp(xr(i)))^2+(fexp(xr(i)-tau(i)*fexp(xr(i))/(subs(diff(fexp(X)),X,xr(i)))))^2);
    if ((i>1)&(abs((xr(i+1)-xr(i))/(1-(xr(i+1)-xr(i))/(xr(i)-xr(i-1))))<eps))
        k=k+1;
        pos(k)=i+1;
        break;
    end;
end;




