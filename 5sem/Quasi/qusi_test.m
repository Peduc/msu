clear
clc

%Параметры
N=4;
eps=0.01;
l=0;
r=10000;
tr=1;
um=1;
c=1;
m=1;
pres=30;

syms X;
syms T;
syms M;
syms C;
x=[];
t=[];
u=[];
h=[];
Rrn=[];
peff=[];
peff1=[];
gust=2;

for k=1:pres
    if k==1
        for i=1:pres
            tau(i)=((tr-l)/(N*gust^(i-1)));
            for j=1:N*gust^(i-1)+1
                t(j)=l+(j-1)*tau(i);
            end;   
            u(i,k)=0;
            for j=2:(N*gust^(i-1))+1
                u(i,k)=u(i,k)+tau(i)*double(subs(diff(ksi(T,C,M)),{T,C,M},{t(j-1)+0.5*tau(i),c,m}))*exp1(ksi(t(j-1)+0.5*tau(i),c,m));
                if (i>1)
                    Rrn(i,k)= (u(i,k)-u(i-1,k))/(gust^(2+2*(k-1))-1);
                end;
            end;        
        end;
    else    
        for i=k:pres
            u(i,k)=u(i,k-1)+Rrn(i,k-1);
            if (i>k)
                Rrn(i,k)= (u(i,k)-u(i-1,k))/(gust^(2+2*(k-1))-1);
            end;
            if (i>k+1)
%                  peff(i,k)=log10(abs(Rrn(i-1,k))/abs(Rrn(i,k)))/log10(gust);
                 peff1(i,k)=log10(abs(Rrn(i-1,k-1))/abs(Rrn(i,k-1)))/log10(gust);     
            end;
        end;
    end;
end;

disp(u);
disp(Rrn);
disp(peff1);