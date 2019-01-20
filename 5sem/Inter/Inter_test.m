clear
clc

%������� ���������
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
ye(5)=6.5;
x(6)=8;
ye(6)=5.5;
x(7)=10;
ye(7)=6;
x(8)=11;
ye(8)=9;
x(9)=13;
ye(9)=9;
x(10)=14;
ye(10)=8;

%������ ���������� �� ����� xm
for i=1:N
    dis(i,1)=i;
    dis(i,2)=abs(x(i)-xm);
end;

%��������� ����� �� ���������� �� ������
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

% for points=1:5
for points=1:N
    if flag==0
        newseq=[];
        %������������ ������ ������, �� �������� ����� ������� ��������� �
        %������� ���������� �� �������� �����
        for i=1:points
            newseq(i,1)=x(dis(i,1));
            newseq(i,2)=ye(dis(i,1));
        end;
%         disp(newseq);
        
        %���������� ������ � ������� ����������� ����������
        for i=1:points
            %�-����������
            newseq(i,1)=x(dis(i,1));
            %y-����������
            newseq(i,2)=ye(dis(i,1));
        end;
%         disp(newseq);
        
        for i=1:points-1
            for j= 1:points-i 
                if newseq(j,1)>newseq(j+1,1) 
                    t=newseq(j,1);           
                    newseq(j,1)=newseq(j+1,1);   
                    newseq(j+1,1)=t;
                    t=newseq(j,2);           
                    newseq(j,2)=newseq(j+1,2);   
                    newseq(j+1,2)=t;
                end;
            end;
        end;
%         disp(newseq);
        
        if (points~=1)
%             h=(right-left)/(points-1);
            u=zeros(points,points+1);
            for i=1:points
                u(i,1)=newseq(i,2);
            end;
        else
            %������� ���� ������������� ��������
            newseq(1,1)=newseq(1,1);
            newseq(1,2)=newseq(1,2);
        end;
        
        if (points>1)
            %����� �������
            for j=2:points
                %����� ������
                for i=j:points
                    u(i,j)=(1)*(u(i-1,j-1)-u(i,j-1))/(newseq(j-1,1)-newseq(j,1));
                end;
            end;
        end;
        
%         disp(u);        
        Y=0*X1;
        
        for i=1:points
            if (i==1)
                Y = newseq(1,2);
                Y1= newseq(1,2);
                W = 1;
                W1 = 1;
            else
                if abs(((u(i,i))*W1/factorial(i-1))/Y1)>(0.1)*eps
                    W = W*(X1-newseq(i-1,1));
                    W1 = W1*(xm-newseq(i-1,1));
%                     disp(vpa(W));
                    Y=Y+(u(i,i))*W/factorial(i-1);
                    Y1=Y1+(u(i,i))*W1/factorial(i-1);
%                     disp(vpa(Y));
                    plot(x,ye,'o');
                    hold on;
                    ezplot(Y,[left right]);
                else
                    disp('Done!');
                    disp(points-1);
                    flag=1;
                    break;
                end;
            end;
        end;        
    else
        break;
    end;
end;

% plot(x,ye,'o');
% hold on;
% ezplot(Y,[left right]);
disp(vpa(subs(Y,X1,xm)));