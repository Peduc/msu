clear
clc

%Параметры
N=1;
r=2;
eps=0.1;
pres=1;
peffw=2;

left=-1;
right=1;

syms X;

%Модельное решение
um=pi/2;

u=[];
h=[];
x=[];
Rrn=[];
peff=[];

for l=1:100
    if abs(peff-peffw)<eps
    quit cancel;
    else
    pres=pres+1;
    for k=1:pres
        for i=1:pres
            h(i)=((right-left)/(N*r^(i-1)));
            for j=1:r^(i-1)+1
                x(j)=left+(j-1)*h(i);
            end;   
            u(i,k)=0;
            for j=2:r^(i-1)+1
                if k==1
                    u(i,k)=u(i,k)+(funsem4(x(j-1))+funsem4(x(j)))*h(i)/2;               
                end;
                if (i>1)&&(k==1)
                    Rrn(i,k+1)= (u(i,k)-u(i-1,k))/(r^(2)-1);
                end;
                if (k==2)&&(i>1)
                    u(i,k)=u(i,k-1)+Rrn(i,k);
                end;
            end;
        end;
    end;

    for k=2:pres
        for i=k+1:pres
                Rrn(i,k+1)= (u(i,k)-u(i-1,k))/(r^(2)-1);
                u(i,k+1)=u(i,k)+Rrn(i,k);
                if (k<pres)
                    peff(i-1,k)=log(abs(Rrn(i-1,k))/abs(Rrn(i,k)))/log(r);
                     end;
                 end;
         end;
     end;
end;

