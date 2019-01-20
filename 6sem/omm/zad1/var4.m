clear
clc

% ������� ���������
%������������
l=-pi/2;
r=0;
%�����
in=0;
fin=1/2;
c=-2;

eps=10^-10;
count=10^3;

%�������������
sol=[];
x=[];
t=[];

% ����� ����������� ��������
if c<0
    [r,l] = deal(l,r) ;
end;

%��������� �����
N=40;
M=40;
h=(r-l)/(N-1);
tau=(fin-in)/(M-1); 

%���������� �����
for i=1:N
    x(i)=l+(i-1)*h;
end;
for j=1:M
    t(j)=in+(j-1)*tau;
%   ����� - ����������, ������� ��� ���������� ������: 
    alpha(j)=(c*tau/h)*(t(j)+tau/2);
end;

%   ��������� �������:
for i=1:N
    y(1,i)=-2*sin(2*x(i));  
end;

%   ��������� �������:
for j=1:M
    y(j,1)=-2*sin(2*(t(j)^2))/...
           (1+3*(t(j)^2)*sin(2*(t(j)^2)));
end;

%   ���������� ����� ��� �������� (n+1,j+1)
for j=2:M
    for i=2:N
%         a=-6*tau*(t(j)+tau/2)/4;
%         b= 1+alpha(j);
%         c=(y(j,i-1)-y(j-1,i))*(1-alpha(j))-y(j-1,i-1)*(1+alpha(j))-...
%           6*tau*(t(j)+tau/2)*(y(j,i-1)^2+y(j-1,i)^2+y(j-1,i-1)^2)/4;
%       newt_old=y(j-1,i-1);
%       for k=1:count         
%           newt_new=newt_old-(a*newt_old^2+b*newt_old+c)/(2*a*newt_old+b);
%           if abs(newt_new-newt_old)<eps*abs(newt_old)
%               break
%           end;
%       end;
%       y(j-1,i-1)=newt_new;  
        y(j,i)=(y(j-1,i)-y(j,i-1))*(1-alpha(j))/(1+alpha(j))+...
        y(j-1,i-1)*(1+6*tau*(t(j)+tau/2)*y(j-1,i-1)/(1+alpha(j)));        
    end;
end;

%   ������������� �������:
sol=zeros(M,N);
for i=1:N
    for j=1:M
        sol(j,i)=ansol_omm(t(j),x(i));        
    end;
end;

%   ��������� �������:
subplot(1, 3, 1),surf(x,t,y);
%   ������������� �������:
subplot(1, 3, 2),surf(x,t,sol); 
%   ����������� �������:
subplot(1, 3, 3),surf(x,t,y-sol);