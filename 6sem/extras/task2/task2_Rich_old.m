%{
1. ����������� ����� ERK2 � ERK3 ��� ������� ������-�����, � ������������� �������� ���� ������� � ������� ����.  

2. �������� ������� ������ 1 �� ��� ������, ����� ������ �� ����������.

3. ����������� �������� ���������� ������������� ��������� �������� � ���������������
 ������� ���������� ������������� ������ �����������.


%}
clear; clc;

mass = [1.9891*10^30; 5.9736*10^24]; %������/�����
coordinates = [0 0; 1.52098232*10^11 0]; %x,y ������ ; x,y ����� 
velocities = [0 -0.089021687078894; 0 29270]; %Vx,Vy ������; vx, Vy �����
G = 6.67300*10^(-11); % �������������� ���������� 

s=3; %����������� �����

if s==1
    b=1;
    c=1/2;
    a=0;
elseif s==2
    b=[1/4 3/4];
    c=[0 2/3];
    a=2/3;
elseif s==3
    b=[2/9 1/3 4/9];
    c=[0 1/2 3/4];
    a=[1/2 0;3/4 0];
end

UN={};
RN={};
p=[];
Ur=[];
N=[];
M=1; %��� ����������
Z=1; %��� peff
K=10; %���������� ��������
r=2;
N(1)=10^4;

%��� ����������
p(1)=s;
for i=2:100;
    p(i) = p(i-1) + 1;
end


for k=1:K
   
tau = 10*365*24*60*60/N(k);

w=zeros(s,8);
U=zeros(N(k)+1,8);

U(1,:)=[coordinates(2,1) coordinates(2,2) velocities(2,1) velocities(2,2) coordinates(1,1) coordinates(1,2) velocities(1,1) velocities(1,2)];

%ERKs
for n=1:N(k)
    sum2=zeros(1,8);
    for sk=1:s
        
        w(sk,:)=f(U);
        
        sum1=zeros(1,8);
        for l=1:sk-1
            sum1=sum1+a(l)*w(l,:);
        end
        
        w(sk,:)=f( U(n,:)+tau*sum1 )';
        sum2=sum2+b(sk)*w(sk,:);
    end
     U(n+1,:)=U(n,:)+tau*sum2;  
end

    if k==1
        Ur=U;
    end
%Richardson
    
   if (k>1)
       Ur=[];
       rk=0;
       for j=1:N(1)
           Ur(j,:)=U(rk+1,:);
           rk=r^(k-1)+rk;
       end
       Ur(N(1)+1,:)=U(N(k)+1,:);
   end
   
   UN{k,1}=Ur; 
   
   if (k>1)
       for m=1:M
           RN{k-1,m}=( UN{k,m}-UN{k-1,m} )/ ( r^p(m)-1 ) ;
           UN{k,m+1}=UN{k,m}+RN{k-1,m};
       end
        
       if M>1
            for z=1:Z
            peff(m-1,z)=log( norm( RN{m-1,z} )/ norm( RN{m,z} ) )/log(r);
            end
            Z=Z+1;
       end
           M=M+1;
   end

    N(k+1)=N(k)*r;
end








