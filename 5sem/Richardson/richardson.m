clear
clc

%Параметры
N=1;
gust=2;
eps=0.01;
pres=10;

left=0;
right=1;

syms X;

%Метод левых прямоугольников
% method=1;
%Метод правых прямоугольников
method=2;
%Метод средних прямоугольников
% method=3;
%Метод трапеций
% method=4;


u=[];
h=[];
x=[];
Rrn=[];
peff=[];

for k=1:pres
    if k==1
        for i=1:pres
            h(i)=((right-left)/(N*gust^(i-1)));
            for j=1:gust^(i-1)+1
                x(j)=left+(j-1)*h(i);
            end;   
            u(i,k)=0;
        
            if method == 1
                sigma=1;
                po=1;
                for j=1:(N*gust^(i-1))
                    if k==1
                        u(i,k)=u(i,k)+(funsem4(x(j))*h(i));                
                    end;
                    if (i>1)&&(k==1)
                    	Rrn(i,k)= (u(i,k)-u(i-1,k))/(gust^(po+sigma*(k-1))-1);
                    end;
                    if (k==2)&&(i>1)
                        u(i,k)=u(i,k-1)+Rrn(i,k-1);
                    end;
                end;
            end;        
        
            if method == 2
                sigma=1;
                po=1;
                for j=2:(N*gust^(i-1))+1
                    if k==1
                        u(i,k)=u(i,k)+(funsem4(x(j-1)))*h(i);                
                    end;
                    if (i>1)&&(k==1)
                         Rrn(i,k)= (u(i,k)-u(i-1,k))/(gust^(po+sigma*(k-1))-1);
                    end;
                    if (k==2)&&(i>1)
                        u(i,k)=u(i,k-1)+Rrn(i,k-1);
                    end;
                end;
            end;        
        
            if method == 3
                sigma=2;
                po=2;            
                for j=2:(N*gust^(i-1))+1
                    if k==1
                        u(i,k)=u(i,k)+(funsem4((x(j-1)+h(i)*0.5))*h(i));                
                    end;
                    if (i>1)&&(k==1)
                         Rrn(i,k)= (u(i,k)-u(i-1,k))/(gust^(po+sigma*(k-1))-1);
                    end;
                    if (k==2)&&(i>1)
                        u(i,k)=u(i,k-1)+Rrn(i,k-1);
                    end;
                end;
            end;
        
            if method == 4
                sigma=1;
                po=2;            
                for j=2:(N*gust^(i-1))+1
                    if k==1
                        u(i,k)=u(i,k)+(funsem4(x(j-1))+funsem4(x(j)))*h(i)/2;                
                    end;
                    if (i>1)&&(k==1)
                        Rrn(i,k)= (u(i,k)-u(i-1,k))/(gust^(po+sigma*(k-1))-1);
                    end;
                    if (k==2)&&(i>1)
                        u(i,k)=u(i,k-1)+Rrn(i,k-1);
                    end;
                end;
            end;        
        end;
    else 
        for i=k:pres
            u(i,k)=u(i,k-1)+Rrn(i,k-1);
            if (i>k)
                Rrn(i,k)= (u(i,k)-u(i-1,k))/(gust^(po+sigma*(k-1))-1);
            end;
            if (i>k+1)
                 peff(i,k)=log10(abs(Rrn(i-1,k))/abs(Rrn(i,k)))/log10(gust);
            end;
        end;
    end;
end;

disp(u);
disp(peff);
