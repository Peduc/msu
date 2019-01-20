clear
clc

% left=-4;
% right=4;
% N=8;
% 
% syms X1 Y W;
% 
% %Первый метод - по своим значениям, второй - заданная/наилучшая точность
% 
% %Формирование сетки
% if (N~=1)
%     h=(right-left)/(N-1);
%     u=zeros(N,N+1);
%     for i=1:N
%         x(i)=left+(i-1)*h;
%         u(i,1)=inter(x(i));
%         ye(i)=inter(x(i));
%     end;
% else
% 	x(1)=left;
% % 	u(i,1)=inter(x(i));
% 	ye(1)=inter(x(1));
% end;
% 
% if (N>1)
%     %Номер столбца
%     for j=2:N
%         %Номер строки
%         for i=j:N
%             u(i,j)=(1)*(u(i-1,j-1)-u(i,j-1))/(x(j-1)-x(j));
%         end;
%     end;
% end;
% 
% Y=0*X1;
% 
% for i=1:N
%     if (i==1)
%         Y = inter(x(1));
%         W = 1;
%     else
%         W = W*(X1-x(i-1));
%         Y=Y+(u(i,i))*W/factorial(i-1);
%     end;
% end;
%     
% plot(x,ye,'o');
% hold on;
% ezplot(Y,[left,right]);

%Входные параметры
left=0;
right=14;
N=10;
flag=0;
xm=7;
eps=0.1;

syms X1 Y W;
u=[];

x(1)=0;
ye(1)=4;
x(2)=1;
ye(2)=2;
x(3)=3;
ye(3)=2;
x(4)=4;
ye(4)=6;
x(5)=6;
ye(5)=7;
x(6)=8;
ye(6)=5;
x(7)=10;
ye(7)=6;
x(8)=11;
ye(8)=9;
x(9)=13;
ye(9)=9;
x(10)=14;
ye(10)=8;

%Массив расстояний до точки xm
for i=1:N
    dis(i,1)=i;
    dis(i,2)=abs(x(i)-xm);
end;

%Сортируем точки по удалённости от нужной
for i=1:N-1
	for j= 1:N-i 
        if dis(j,2)>dis(j+1,2) 
            t=dis(j,2);           
        	dis(j,2)=dis(j+1,2);   
        	dis(j+1,2)=t;
        	t=dis(j,1);
        	dis(j,1)=dis(j+1,1);   
        	dis(j+1,1)=t;
        end;
	end;
end;

for points=1:N
    if flag==0
        if (points~=1)
            h=(right-left)/(points-1);
            u=zeros(points,points+1);
            for i=1:points
                u(i,1)=ye(dis(i,1));
            end;
        else
            x(1)=left;
            ye(1)=inter(x(1));
        end;
        
        if (points>1)
            %Номер столбца
            for j=2:points
                %Номер строки
                for i=j:points
                    u(i,j)=(1)*(u(i-1,j-1)-u(i,j-1))/(x(dis(j-1,1))-x(dis(j,1)));
                end;
            end;
        end;
        
        disp(u);
        
        Y=0*X1;
        
        for i=1:points
            if (i==1)
                Y = ye(dis(i,1));
                Y1= ye(dis(i,1));
                W = 1;
                W1 = 1;
            else
                if abs(((u(i,i))*W1/factorial(i-1))/Y1)>0.01*eps
                    W = W*(X1-x(dis(i-1,1)));
                    W1 = W1*(xm-x(dis(i-1,1)));
                    disp(vpa(W));
                    Y=Y+(u(i,i))*W/factorial(i-1);
                    Y1=Y1+(u(i,i))*W1/factorial(i-1);
                    plot(x,ye,'o');
                    hold on;
                    ezplot(Y,left,right);
                else
                    disp('Done!');
                    disp(points);
                    disp(vpa(Y));
                    flag=1;
                end;
            end;
        end;        
    end;
end;

% plot(x,ye,'o');
% hold on;
% ezplot(Y,[left,right]);
disp(Y1);