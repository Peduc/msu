clear;
clc;

%��������� ��������� 
%��, �/�
% ������: ������, �����, ���� (����� � ������, ��� ���� ����� ������� ������), ������ ������
mass = [1.9891*10^30; 5.9736*10^24; 7.3477*10^22; 2.2*10^14];
coordinates = [0 0; 1.52098232*10^11 0; 1.52098232*10^11+3.84467*10^8 0; 5.24824*10^12 0];
velocities = [0 -0.089021687078894; 0 29270; 0 29270+1023; 0 -900];

% �������������� ����������
g = 6.67300*10^(-11);

% ������� ������� �� ������ ������. ���� ����� � ��������.
delta_t=86400;

%����������� ������. ������.
%�-����������
x=[];
%Y-����������
y=[];
%�-��������
e=[];
%Y-��������
f=[];
%�����
t=[];

%e'=-M*x/(x^2+y^2)^(3/2)=f1(x,y,e,f,t);
%f'=-M*y/(x^2+y^2)^(3/2)=f2(x,y,e,f,t);
%x'=e=f3(x,y,e,f,t);
%y'=f=f4(x,y,e,f,t);

%����� ������
method=2;

%��������� �������
e(1)= velocities(2,1);
f(1)= velocities(2,2);
x(1)= coordinates(2,1);
y(1)= coordinates(2,2);

if method == 1
    %������������� ����� ERK1
    b=[];
    c=[];
    b(1)=1;
    c(1)=0.5;
    
    for i=2:365
        e(i)= e(i-1)+delta_t*(-g*mass(1)*x(i-1)/((x(i-1))^2+(y(i-1))^2)^(3/2));
        f(i)= f(i-1)+delta_t*(-g*mass(1)*y(i-1)/((x(i-1))^2+(y(i-1))^2)^(3/2));
        x(i)= x(i-1)+delta_t*e(i-1);
        y(i)= y(i-1)+delta_t*f(i-1);
    end;
	plot(x,y);
else
    %������������� ����� ERK2
    a=[];
    b=[];
    c=[];
    w=[];
    
    b(1)=0.25;
    b(2)=0.75;
    a(1)=0;
    a(2)=2/3;
    c(1)=0;
    c(2)=2/3;
    
    for i=2:365
        %������ ������
        w(1,1)=-g*mass(1)*x(i-1)/((x(i-1))^2+(y(i-1))^2)^(3/2);
        w(1,2)=-g*mass(1)*y(i-1)/((x(i-1))^2+(y(i-1))^2)^(3/2);
        w(1,3)= e(i-1);
        w(1,4)= f(i-1);
        
        %������ ������
        w(2,1)=-g*mass(1)*(x(i-1)+delta_t*a(2)*w(1,3))/((x(i-1)+delta_t*a(2)*w(1,3))^2+(y(i-1)+delta_t*a(2)*w(1,4))^2)^(3/2);
        w(2,2)=-g*mass(1)*(y(i-1)+delta_t*a(2)*w(1,4))/((x(i-1)+delta_t*a(2)*w(1,3))^2+(y(i-1)+delta_t*a(2)*w(1,4))^2)^(3/2);
        w(2,3)= (e(i-1)+delta_t*a(2)*w(1,1));
        w(2,4)= (f(i-1)+delta_t*a(2)*w(1,2)); 
        
        e(i)= e(i-1)+delta_t*(b(1)*w(1,1)+b(2)*w(2,1));
        f(i)= f(i-1)+delta_t*(b(1)*w(1,2)+b(2)*w(2,2));
        x(i)= x(i-1)+delta_t*(b(1)*w(1,3)+b(2)*w(2,3));
        y(i)= y(i-1)+delta_t*(b(1)*w(1,4)+b(2)*w(2,4));
    end;
	plot(x,y);
end;

