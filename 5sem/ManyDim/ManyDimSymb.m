clear
clc
Start = cputime; 

%Размерность пространства
Dim=5;
%Количество точек на каждой оси
N=20;
%Массив- левых границ
left=[];
%Массив правых границ
right=[];

%Радиус-вектор точки
r=[];
length=[];
length1=[];
count=0;

syms X U Y X1 X2 X3 X4 X5 X6 X7 X8 X9 X10;
% X1 X2 X3 X4 X5 X6 X7 X8 X9 X10
X=[X1 X2 X3 X4 X5 X6 X7 X8 X9 X10];
Y=(cos(X1+pi*(0/10))+cos(X2+pi*(1/10))+cos(X3+pi*(2/10))+cos(X4+pi*(3/10))...
+cos(X5+pi*(4/10)));
% +cos(X6+pi*(5/10))+cos(X7+pi*(6/10)) ...
% +cos(X8+pi*(7/10))+cos(X9+pi*(8/10))+cos(X10+pi*(9/10)));
sym U=[];

h=[];
xe=[];

%Задание Dim-мерного параллелепипеда
for i=1:Dim
    left(i)=-pi()/2;
    right(i)=pi()/2;
    h(i)=(right(i)-left(i))/(N-1);
    for j=1:N
        xe(j,i)=left(i)+(j-1)*h(i);        
    end;
    for j=2:N
        mid(j,i)=0.5*(xe(j-1,i)+xe(j,i));        
    end;        
end;

%Расчёт интеграла
U(Dim+1)=Y;

for i=Dim:-1:1
    U(i)=0;
end;

for i=Dim:-1:1
%     U(i)=0;
	for j=2:N
        U(i)=U(i)+(subs(U(i+1),X(i),mid(j))*h(i));
	end;
%         U(i)=U(i)+(subs(U(i-1),X(i),mid(j))*h(i));
end;

Ur=vpa(U(1));
% for j=2:N
% 	Ur=Ur+(subs(U(i+1),X(i),mid(j))*h(i));
% end;

% U(10)=0;
% 	U(10)=U(10)+((subs(Y,'X10',xe(j-1,i)))+(subs(Y,'X10',xe(j,i))))*h(i)/2;


Elapsed = cputime - Start;
disp(Elapsed);