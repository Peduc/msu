clear
clc

% Входные параметры
gust=4;
l=0;
r=1;

%Только для графика
syms Ym Xm
Ym=-exp(Xm)+Xm+(1-exp(1));

err=[];

for j=1:gust
    Am=[];
    N=10^(j);
    h(j)=(r-l)/(N-1);
    %Инициализация
    Am=zeros(N,N);
    F=[];
    alpha=[];
    beta=[];

%    Модельное решение

    %Создание правой части
    for k=1:N
        x(k)=l+(k-1)*h(j);
        if (k~=1)&&(k~=N)
            F(k,1)=(h(j)^2)*exp(x(k));
        else
            F(k,1)=0;
        end;
    end;

    %Трёхдиагональна матрица
    %Создание матрицы
    for k=1:N
        for n=1:N
            if (n==k)
                if (k~=1)&&(k~=N)
                    Am(k,n)= 2;
                    C(k)=2;
                else
                    Am(k,n)= 1;
                    C(k)=1;
                end;
            end;
            if (n+1==k)&&(k~=N)
                Am(k,n)= 1;
                B(k)=1;
            end;
            if (n-1==k)&&(k~=1)
                Am(k,n)= 1;
                A(k)=1;
            end;
        end;
    end;

    %Прямой ход для коэффицентов 
    alpha(1)=1;
    beta(1)=0;

    for k=2:N-1
            alpha(k)=B(k)...
                /(C(k)-A(k)*alpha(k-1));
            beta(k)=(A(k)*beta(k-1)+F(k))/...
                (C(k)-alpha(k-1)*A(k));    
    end;   

    % Обратный ход для значений
    sol=[];
    for k=N:-1:1
        if k==N
            sol(k)=(0+2*beta(k-1)/(2-h(j)))/(1-2*alpha(k-1)/(2-h(j)));
        elseif k>1
            sol(k)=alpha(k)*sol(k+1)+beta(k);
        else
            sol(k)=(4/3)*sol(k+1)-(1/3)*sol(k+2);
        end;
    end;   
    
    err(j)=0;
    for k=1:N
        err(j)=err(j)+h(j)*(sol(k)-funct(x(k)))^2;
    end;
    err(j)=sqrt(err(j));
    
%     plot(x,sol,'--');
    hold on
end;

% ezplot(Ym,[0,1]);
plot(err,h);
