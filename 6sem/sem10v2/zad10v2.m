clear
clc

%Входные данные
l=0;
r=pi();
in=0;
fin=3;
%Много значений
Eps_length=30;
eps_max=0.8;
eps_min=0.1;
% 
delta_eps=(eps_max-eps_min)/(Eps_length-1);
for count=1:Eps_length
    eps(count)=eps_min+delta_eps*(count-1);
end;
% eps(1)=0.5;

%Сетка
N_0=30;
M=30;
h=(r-l)/(N_0-1);
tau=(fin-in)/(M-1);

%Метод
% CROS1
% method = 1;
% CROS2
method = 2;

%Координатная сетка
for count=1:N_0
    xn(count)=l+h*(count-1);
end;

%Временная сетка
for count=1:M
    t(count)=in+tau*(count-1);
end;

for k = 1:length(eps) 
    u_init=0;
    v_init=@(x) (-sin(x)*(x*(pi-x))^2*(eps(k)+1)+...
        4*cos(x)*(x*(pi-x))*(pi-2*x )...
        +2*sin(x)*((pi-2*x)^2 - 2*(x*(pi-x))));
    g_init=-1;
    
    N=N_0+1;
    U = zeros(3*(N-1),M);
    
    %Начальные условия
    for n = 1:N-1
        U(n,1) = u_init;
    end;
    for n = N:2*(N-1)
        U(n,1) = v_init(xn(n-(N-1)));
    end;
    for n = 2*(N-1)+1:3*(N-1)
        U(n,1) = g_init;
    end;  
    
    Fu = Yak(U, h, N, eps(k) );
    Mat=Matr(N);
    %Решение
    if method==1
        %Одностадийная схема CROS1
        a(1)=(1+1i)/2;
        w=[];
        for j=1:M-1
            F=Func(U(:,j),N,h,eps(k));
            w=(Mat-a(1)*tau*Fu )^(-1)*F';
            U(:,j+1)=U(:,j)+tau*real(w);
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
        
        for j=1:M-1
            F1=Func(U(:,j),N,h,eps(k));
            w_1=((Mat-a(1)*tau*Fu)^(-1))*F1';
            F2=Func(U(:,j)+tau*real(c(1)*w_1),N,h,eps(k));
            w_2=((Mat-a(2)*tau*Fu)^(-1))*F2';

            U(:,j+1) = U(:,j) + tau*real(b(1)*w_1+b(2)*w_2);
        end;
    end;
    
    for i = 1:N-1
        u1(i,:) = U(i,:);
    end; 
%   3D
    surf(t, xn, u1)
    axis([in fin l r -2 14]);
    title( sprintf('eps = %.4f', eps(k)) );
    xlabel('t')
    ylabel('x')
    zlabel('u')

%   2D  
%     for j=1:M
%         plot(xn,u1(:,j));
%         hold off;
%         title( sprintf('eps = %.4f', eps(k)) );
%         axis([ l r -20 2]);
%         pause (5/M);
%         drawnow;   
%     end;
    hold off;
    pause(3/length(eps));
    drawnow;
end;
hold off