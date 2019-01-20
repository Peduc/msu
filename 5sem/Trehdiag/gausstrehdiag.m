clear
clc

%Трёхдиагональна матрица
%Постоянные
N = 10;
C1 = 0;
C2 = 1;
C3 = -0.25;
tau = 0.1;

%Неоднородность
% Задаём правую часть СЛАУ
h = (C2 - C1)/(N - 1);
dt=[];
for k =1:N
    dt(k) = sin((C1 + h*(k - 1))/(C2 - C1)*pi);
end;
d=dt';

%Создание матрицы
A=[];
for k=1:N
    for n=1:N
        if n==k
            A(k,n)= -(1 - C3*tau/h); 
        end;
        if n+1==k
            A(k,n)= C3*tau/h; 
        end;
        if n-1==k
            A(k,n)= 0; 
        end;
    end;
end;

%Модельное решение
xm=A^(-1)*d;

%Решение методом Гаусса
%Прямой ход для коэффицентов 
%Под диагональю a \\На диагонали b \\Над диагональю c
ksi=[];
eta=[];

for k=2:N+1
    if k==2
        ksi(k)=A(k-1,k)/(A(k-1,k-1));
        eta(k)=-d(k-1)/A(k-1,k-1);
    elseif k==(N+1)
        ksi(k)=0;
        eta(k)=(A(k-1,k-2)*eta(k-1)-d(k-1))/(A(k-1,k-1)-ksi(k-1)*A(k-1,k-2));
    else    
    ksi(k)=A(k-1,k)/(A(k-1,k-1)-A(k-1,k-2)*ksi(k-1));
    eta(k)=(A(k-1,k-2)*eta(k-1)-d(k-1))/(A(k-1,k-1)-ksi(k-1)*A(k-1,k-2));
    end;
end;   

%Обратный ход для коэффицентов 
xt=[];

for k=N:-1:1
    if k==N
        xt(k)=eta(k+1);
    else
    xt(k)=ksi(k+1)*xt(k+1)+eta(k+1);
    end;
end;   

x=xt';

for k=1:N
    for n=1:N
        if n==k
            b(n)=A(k,n); 
        end;
        if n+1==k
            a(n+1)=A(k,n); 
        end;
        if n-1==k
            c(n-1)=A(k,n); 
        end;
    end;
end;
c(N)=0;

ksi1=[];
eta1=[];

ksi1(1)=0;
eta1(1)=0;
for k=1:N  
    ksi1(k+1)=c(k)/(b(k)-a(k)*ksi1(k));
    eta1(k+1)=(a(k)*eta1(k)-d(k))/(b(k)-ksi1(k)*a(k));
end;   