clear
clc

%Входные данные
l=-1;
r=2;
eps=[0.0001 0.001 0.01 0.1 1/2];

% a=1;
% a=0.5*(1+i);

%Сетка
M=100;
tau=(r-l)/(M-1);
for count=1:M
    t(count)=l+tau*(count-1);
end;

%Граничное условие
u=zeros(M,1);
u(1,1)=3;
u(1,2)=t(1);

for k = 1: 5
    %Решение
    
    %Двухстадийная схема CROS2
    a=[];
    b=[];
    c=[];
    w_1=[];
    s=2;
    
    b(1)=0.1941430241155180-1i*0.2246898944678803;
    b(2)=0.8058569758844820-1i*0.8870089521907592;
    b(3)=0;
    c(1)=0.2554708972958462-1i*0.2026195833570109;
    
    a(1)=0.1+1i*sqrt(11)/30;
    a(2)=0.2+1i*sqrt(1)/10;
    a(3)=0.5617645150714754-1i*1.148223341045841;
    
    for count=2:M
        w_1=((eye(2)-a(1)*tau*Yak(eps(k),u(count-1,:)))^(-1))*...
            Matr(eps(k),u(count-1,:));
        w_2=((eye(2)-a(2)*tau*Yak(eps(k),u(count-1,:)+...
            tau*real(a(3)*w_1)))^(-1))*...
            Matr(eps(k),u(count-1,:)+tau*real(c(1)*w_1));
        u(count,:)=u(count-1,:)+tau*real(b(1)*w_1'+b(2)*w_2');
%         w(1)=((eye(2)-a(1)*tau*Yak(eps(k),u(i-1,:)))^(-1))*Matr(eps(k),u(i-1,:));
%         w(2)=((eye(2)-a(2)*tau*Yak(eps(k),u(i-1,:)+tau*real(a(3)*w(1))))^(-1))*...
%             Matr(eps(k),u(i-1,:)+tau*real(c(1)*w(1)));
%         u(i)=u(i-1)+tau*real(b(1)*w(1)+b(2)*w(2));
    end;
    
    plot(t, u(:,1));
    title( sprintf('eps = %.4f', eps(k)) );
    hold all
    pause(1.0);
end
hold off
