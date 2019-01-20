clear
clc

% Входные параметры
gust=6;
l=0;
r=1;

%Только для графика
syms Ym Xm
Ym=-exp(Xm)+Xm+(1-exp(1));

err=[];

for j=1:gust
%     Am=[];
	N=10*2^(j-1);
    h(j)=(r-l)/(N-2/2);
    %Инициализация
    F=[];
    x=[];
    %Создание правой части
    for k=1:N
        x(k)=l+(k-1)*h(j);
        if (k~=1)&&(k~=N)
            F(k)=(h(j)^2)*exp(x(k));
        else
            F(k)=0;
        end;
    end;

    alpha=[];
    beta=[];   

    A=1;
    B=1;
    C=2;
    
    %Прямой ход для коэффицентов 
    alpha(1)=1;
    beta(1)=h(j)^2*exp(h(j))/2;

    for k=2:N-1
            alpha(k)=B...
                /(C-A*alpha(k-1));
            beta(k)=(A*beta(k-1)+F(k))/...
                (C-alpha(k-1)*A);    
    end;   

    % Обратный ход для значений
    sol=[];
    
    kappa_2=1/(1-0.5*h(j));
    mu_2=0;
    
    for k=N:-1:1
        if k==N
            sol(k)=(mu_2+kappa_2*beta(k-1))/(1-kappa_2*alpha(k-1));
        else
            sol(k)=alpha(k)*sol(k+1)+beta(k);
        end;
    end;   
    
    err(j)=0;
    for k=1:N
        err(j)=err(j)+h(j)*(sol(k)-funct(x(k)))^2;
    end;
    err(j)=sqrt(err(j));
    
%     plot(x,sol,'--');
%     hold on
end;

% ezplot(Ym,[0,1]);
plot(h,err,'--');