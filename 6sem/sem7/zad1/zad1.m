clear
clc

%Входные данные
l=-1;
r=2;
eps=[0.0001 0.001 0.01 0.1 1/2];

a=1;
% a=0.5*(1+i);

%Сетка
M=100;
tau=(r-l)/(M-1);
for i=1:M
    t(i)=l+tau*(i-1);
end;

%Граничное условие
u=zeros(M,1);
u(1)=3;

for k = 1: 5
    %Решение
    for i=2:M
        w=(2/eps(k))*u(i-1)*(t(i)+tau/2-u(i-1))*(1-a*tau*(2/eps(k))*(t(i)-2*u(i-1)))^(-1);
        u(i)=u(i-1)+tau*real(w);
    end;
  plot(t, u);
  title( sprintf('eps = %.4f', eps(k)) );
  hold all
  pause(1.0);
end
hold off
