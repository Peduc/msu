clear
clc

%Входные данные
in=0;
fin=1.5;
r=2;
N(1)=30;
tau=(fin-in)/(N(1)-1);
Rr=[];

%Метод
% CROS1
% method = 1;
% CROS2
% method = 2;
% DIRK1
method = 3;

for g=1:3
    %Сетка
    tau=tau/r^(g-1);
    if g==1
        for count=1:N(1)
            t_0(count)=in+tau(1)*(count-1);
        end;
    end;
    % Условие и временная сетка
    count=1;
    while (in+tau*(count-1))<=fin 
        t(g,count)=in+tau*(count-1);
        count=count+1;
    end;
    
    N(g)=count-1;
    
    u(1)=1;
    
    if (method==1)
        % Решение
        % Одностадийная схема CROS1
        a=(1+1i)/2;
        w_1=[];
        s=2;
        for count=2:N(g)
            w_1=((eye(1)-a*tau*Yak(u(count-1)))^(-1))*...
                Matr(u(count-1));
            u(count)=u(count-1)+tau*real(w_1');
            u_temp(1:3,1)=1;
            if (g==1)
                u_temp(1,count)=u(count);
            else
                for count_temp=2:N(g)
                    if (t(1,count_temp)==t(g,count))
%                         disp(t(g,count));
                        u_temp(g,count_temp)=u(count);
                    end;
                end;
            end;
        end;
    elseif method==2
        % Решение
        % Двухстадийная схема CROS2
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
        
        for count=2:N(g)
            w_1=((eye(1)-a(1)*tau*Yak(u(count-1)))^(-1))*...
                Matr(u(count-1));
            w_2=((eye(1)-a(2)*tau*Yak(u(count-1)+...
                tau*real(a(3)*w_1)))^(-1))*...
                Matr(u(count-1)+tau*real(c(1)*w_1));
            u(count)=u(count-1)+tau*real(b(1)*w_1'+b(2)*w_2');
            u_temp(1:3,1)=1;
            if (g==1)
                u_temp(1,count)=u(count);
            else
                for count_temp=2:N(g)
                    if (t(1,count_temp)==t(g,count))
                        u_temp(g,count_temp)=u(count);
                    end;
                end;
            end;
        end;
    elseif (method) == 3
        % Решение
        % Одностадийная схема DIRK1
        a=1;
        w_1=[];
        s=2;
        for count=2:N(g)
            w_1=((eye(1)-a*tau*Yak(u(count-1)))^(-1))*...
                Matr(u(count-1));
            u(count)=u(count-1)+tau*real(w_1');
            u_temp(1:3,1)=1;
            if (g==1)
                u_temp(1,count)=u(count);
            else
                for count_temp=2:N(g)
                    if (t(1,count_temp)==t(g,count))
%                         disp(t(g,count));
                        u_temp(g,count_temp)=u(count);
                    end;
                end;
            end;
        end;        
    end;
    
end;

% Rr=u_temp;
for g=1:2
    Rr(g+1,:)=(u_temp(g+1,:)-u_temp(g,:))/(r^1-1);
end;
for count=1:N(1)
    peff(count)=abs(log(Rr(2,count)/Rr(3,count)))/log(r);
end;


subplot(1, 2, 1), 
xlabel('t')
ylabel('u')
% title('1')
axis([in fin 0 6]);
plot(t_0,u_temp(1,:),'-');
hold on
plot(t_0,u_temp(2,:),'-');
hold on
plot(t_0,u_temp(3,:),'');

subplot(1, 2, 2), plot(t_0,peff);
plot(t_0,peff);
xlabel('t')
ylabel('peff')
% title('peff')