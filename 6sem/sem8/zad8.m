clear
clc

%Входные данные
l=0;
r=1;
in=0;
fin=0.2;

%Метод
% CROS1
method = 1;
% CROS2
% method = 2;

%Сетка
N=100;
M=50;
h=(r-l)/(N-1);
tau=(fin-in)/(M-1);
u=zeros(M,N);

%Начальное условие и координатная сетка
for count=1:N
    x(count)=l+h*(count-1);
    u(1,count)=-x(count)+1;
end;

%Граничное условие и временная сетка
for count=1:M
    t(count)=in+tau*(count-1);
    u(count,1)=exp(-t(count));    
end;

%Решение
if method == 1
    %Одностадийная схема CROS2
    a(1)=(1+1i)/2;
    w_1=[];  
    for count=2:M
        w_1=((eye(N-1)-a(1)*tau*Yak(h,u(count-1,2:N)))^(-1))*...
            Matr(h,u(count-1,2:N));
        u(count,2:N)=u(count-1,2:N)+tau*real(w_1');
    end;
else
    %Двухстадийная схема CROS2
    a=[];
    b=[];
    c=[];
    w_1=[];
    w_2=[];
    s=2;
    
    b(1)=0.1941430241155180-1i*0.2246898944678803;
    b(2)=0.8058569758844820-1i*0.8870089521907592;
    b(3)=0;
    c(1)=0.2554708972958462-1i*0.2026195833570109;
    
    a(1)=0.1+1i*sqrt(11)/30;
    a(2)=0.2+1i*sqrt(1)/10;
    a(3)=0.5617645150714754-1i*1.148223341045841;
    
    for count=2:M
        w_1=((eye(N-1)-a(1)*tau*Yak(h,u(count-1,2:N)))^(-1))*...
            Matr(h,u(count-1,2:N));
        w_2=((eye(N-1)-a(2)*tau*Yak(h,u(count-1,2:N)+...
            tau*real(a(3)*w_1)))^(-1))*...
            Matr(h,u(count-1,2:N)+tau*real(c(1)*w_1));
        u(count,2:N)=u(count-1,2:N)+tau*real(b(1)*w_1'+b(2)*w_2');
    end;   
end;

% 3D
surf(x,t,u);
% 2D
% for k = 1: M
%     plot(x, u(k,:));
%     title( sprintf('t = %.4f', t(k)) );
%     hold all
%     pause(7/M);
% end;
% hold off