%Подготовьте программу, которая вычисляет
% какую-нибудь производную (например, вторую)
% с заданной точностью, многократно повышая
% точность по Ричардсону, а также выводит графики
% зависимости погрешностей от величины шага. 

clear;
clc;

syms X1 Y W;
Y1=X1^4;
%Входные параметры
N=4;
r=2;
degree=2;
left=0;
right=4;
gust=4;
count=6;

h=[];
der=[];
u_matr=zeros(gust);
Rrn=zeros(gust);
p=[];

% pointx=left+rand()*(right-left);
pointx=4/3;


for k=1:gust
    u=[];
    x=[];
    y=[];
    h(k)=(right-left)/((N-1)*r^(k-1));
    %Заданиче сетки
    for i=1:(N-1)*r^(k-1)+1
        x(i)=left+(i-1)*h(k);
        u(i,1)=subs(Y1,X1,x(i));
        ye(i)=subs(Y1,X1,x(i));
    end;
%     disp(x);
    %Формирование массива разностей
    for j=2:(N-1)*r^(k-1)+1
    	%Номер строки
        for i=j:(N-1)*r^(k-1)+1
            u(i,j)=(u(i-1,j-1)-u(i,j-1))/(x(j-1)-x(j)); 
        end;
    end;    

    %Формирование многочлена Ньютона
    Y = u(1,1);
    W = 1;

    for i=1:(N-1)*r^(k-1)
        W = W*(X1-x(i));
    	Y=Y+(u(i+1,i+1)*W)/factorial(i);
    end;
    der=diff(Y,degree);
    u_matr(k,1)=vpa(subs(der,X1,pointx),4);
end;

for k=2:gust
    for j=k:gust
        Rrn(j,k)=(u_matr(j,k-1)-u_matr(j-1,k-1))/(r^(k)-1);
        u_matr(j,k)=u_matr(j,k-1)+Rrn(j,k);
%         plot(h(:),Rrr(j,:));
    end;
end;


