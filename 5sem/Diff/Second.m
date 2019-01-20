%Численное дифференцирование
% Подготовьте программу, которая вычисляет какую-нибудь производную
% (например, вторую) с заданной точностью, многократно повышая точность
% по Ричардсону, а также выводит графики зависимости погрешностей от величины шага. 

clear; clc;
syms X1;
% Ux=(x^2+1)^(-1);
Y1=X1^8;
a=0;
b=2;
N=2;
K=5;
r=2;
M=1;
eps=0.1;
L=100;
ksi=1;

Un=[];
Rn=[];
p=[];
Un_der=[];
h=[];

p(1)=2;
for i=2:L
     p(i)=p(i-1)*2;
end
    
for k=1:K
    h(k)=(b-a)/N;
    xn(1)=a;
    c=a; 
    for n=2:N+1
        xn(n)=c+h(k);
        c=c+h(k);
    end
    Un=[];
    for n=1:N+1
        Un(n)=subs(Y1,x,xn(n));
    end 
    for n=1:length(xn)
        if (xn(n)==ksi)
            ksi_n=n;
        end          
    end
    Un_der(k)=( Un(ksi_n+1)-2*Un(ksi_n)+Un(ksi_n-1) )/( ( h(k) )^2 );       
    Un(k,1)=Un_der(k);   
    if ( k>1 )
        for m=1:M
        Rn(k-1,m)=( Un(k,m)-Un(k-1,m) )/( r^p(m)-1 );
        Un(k,m+1)=Un(k,m)+Rn(k-1,m);
        R=Rn(k-1,m);
        end
        M=M+1;        
    end
    N=2*N;    
    if(k>1)
        if abs(R) < eps
            break
        end
    end
end

disp('Матрица Решений');
disp(Un);
disp('Матрица Погрешностей');
disp(Rn);
disp('Достигнутая точность');
disp(abs(R));

 disp(Rn(:,1));
% plot(h,RN(1,:));