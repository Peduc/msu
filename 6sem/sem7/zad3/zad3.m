clear
clc
% syms U T Eps
% 
% F=[2*U*(T-U)/(Eps*sqrt(1+(2*U*(T-U)/Eps)^2)); 1/(Eps*sqrt(1+(2*U*(T-U)/Eps)^2))];
% % F=[2*U*(T-U)/E,1];
% F_u=jacobian(F, [U, T]);

%Метод
% CROS1
method = 1;
% CROS2
% method = 2;

%Входные данные
left=-1;
right=2;
L=2;
eps=[0.0001 0.001 0.01 0.1 1/2];

%Сетка
M=100;
tau=(right-left)/(M-1);
h=L/(M-1);
for count=1:M
    tm(count)=left+tau*(count-1);
    lm(count)=0+h*(count-1);
end;

for k = 1: 5
    %Граничное условие
    un=[];
    un(1,1)=3;
    un(1,2)=tm(1);
%   Решение
    if method == 1
        %Одностадийная схема CROS1
        a(1)=(1+1i)/2;
        w_1=[];
        for count=2:M^2
            if un(count-1,2)<2
%                 disp(un(count-1,2));
                w_1=((eye(2)-a(1)*tau*Yak(eps(k),un(count-1,:)))^(-1))*...
                    Matr(eps(k),un(count-1,:));
                un(count,:)=un(count-1,:)+tau*real(w_1');
            else
                break
            end;
        end;
    else
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
        
        for count=2:M^2
            if un(count-1,2)<=2
                w_1=((eye(2)-a(1)*tau*Yak(eps(k),un(count-1,:)))^(-1))*...
                    Matr(eps(k),un(count-1,:));
                w_2=((eye(2)-a(2)*tau*Yak(eps(k),un(count-1,:)+...
                    tau*real(a(3)*w_1)))^(-1))*...
                    Matr(eps(k),un(count-1,:)+tau*real(c(1)*w_1));
                un(count,:)=un(count-1,:)+tau*real(b(1)*w_1'+b(2)*w_2');
            else
                break
            end;
        end;
    end;
    plot(un(:,2), un(:,1));
    title( sprintf('eps = %.4f', eps(k)) );
    axis([left right 0 5]);
    hold all
    pause(0.5);
end;
hold off
