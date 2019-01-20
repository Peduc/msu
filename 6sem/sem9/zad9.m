clear
clc

% F=[2*U*(T-U)/(Eps*sqrt(1+(2*U*(T-U)/Eps)^2)); 1/(Eps*sqrt(1+(2*U*(T-U)/Eps)^2))];
% % F=[2*U*(T-U)/E,1];
% F_u=jacobian(F, [U, T]);

%Входные данные
method=1;
l=0;
r=1;
in=0;
fin=1;
eps=[0.01 0.05 0.1 1/6 1/4 1/3 0.4];

%Сетка
N=50;
M=50;
h=(r-l)/(N-1);
tau=(fin-in)/(M-1);
u=zeros(M,N);

for k = 1: length(eps)
    %Начальное условие и координатная сетка
    for count=1:N
        x(count)=l+h*(count-1);
        u(1,count)=((x(count)+1)+(x(count)-5)*exp(-3*(x(count)-0.5)/eps(k)))/...
            (1+exp(-3*(x(count)-0.5)/eps(k)));
    end;
    
    %Граничное условие и временная сетка
    for count=1:M
        t(count)=in+tau*(count-1);
        u(count,1)=-5;
        u(count,N)=2;        
    end;
    
    %Решение   
    if method ==1
        %Одностадийная схема CROS2
        a(1)=(1+1i)/2;
        w_1=[];
        
        for count=2:M
            w_1=((eye(N-2)-a(1)*tau*Yak(eps(k),h,u(count-1,2:N-1)))^(-1))*...
                Matr(eps(k),h,u(count-1,2:N-1));
            u(count,2:N-1)=u(count-1,2:N-1)+tau*real(w_1');
        end;
    elseif method ==2
        
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
            w_1=((eye(N-2)-a(1)*tau*Yak(eps(k),h,u(count-1,2:N-1)))^(-1))*...
                Matr(eps(k),h,u(count-1,2:N-1));
            w_2=((eye(N-2)-a(2)*tau*Yak(eps(k),h,u(count-1,2:N-1)+...
                tau*real(a(3)*w_1)))^(-1))*...
                Matr(eps(k),h,u(count-1,2:N-1)+tau*real(c(1)*w_1));
            u(count,2:N-1)=u(count-1,2:N-1)+tau*real(b(1)*w_1'+b(2)*w_2');
        end;
    end;

    graph=2;
    if graph == 2
        %  Вывод 2D
        for count = 1: M
            plot(x, u(count,:));
            title('u');
            xlabel('x')
            title(sprintf('eps = %.4f', eps(k)));
            axis([0 1 -5 3]);
            drawnow
            pause(0.2);
        end;
    else
        %   Вывод 3D
        surf(x,t,u);
        title(sprintf('eps = %.4f', eps(k)));
        xlabel('x')
        ylabel('t')
        drawnow
        pause(1);
    end;
   hold off
end;