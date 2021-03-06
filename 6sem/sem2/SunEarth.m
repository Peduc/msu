% 3. ����������� �������� ���������� ������������� ��������� ��������
% � ��������������� ������� ���������� ������������� ������ �����������.
% 4. ����������� ���������� ���������� ����� � ������� ���������� ������ ����. 
% ��� ���� ����� ����� ����������� ������ �������� ������ ������ ������ ������
% � ���� ���������: 1) ������ ���������� � ������ ���������, ������ ���� �����
% ������ ������ �����������, 2) ������ � ������ ���� (����� � ����)
% ������������ � �� ����������.

clear;
clc;

%��������� ��������� 
%��, �/�
% ������: ������, �����, ���� (����� � ������, ��� ���� ����� ������� ������), ������ ������
mass = [1.9891*10^30; 5.9736*10^24; 7.3477*10^22; 2.2*10^14];
coordinates = [0 0; 1.52098232*10^11 0; 1.52098232*10^11+3.84467*10^8 0; 5.24824*10^12 0];
velocities = [0 -0.089021687078894; 0 29270; 0 29270+1023; 0 -900];

%���������� ����� ������ � �����
mu=mass(1)*mass(2)/(mass(1)+mass(2));

% �������������� ����������
g = 6.67300*10^(-11);

% ������� ������� �� ������ ������. ���� ����� � ��������.
delta_t=86400;
fin=365;

% ������.
%�-���������� ������ � �����, ������ ���� � ������� ��������
x_e=[];x_s=[]; x_cm=[];
%Y-���������� ������ � �����, ������ ���� � ������� ��������
y_e=[];y_s=[]; y_cm=[];
%�-�������� ������ � �����, ������ ���� � ������� ��������
e_e=[];e_s=[]; vx_cm=[];
%Y-�������� ������ � �����, ������ ���� � ������� ��������
f_e=[];f_s=[]; vy_cm=[];
%�����
t=[];

%����� ������
% 1 - EKR1
% 2 - EKR2
% 3 - EKR3

method=3;

%��������� �������
%������
e_s(1)= velocities(1,1);
f_s(1)= velocities(1,2);
x_s(1)= coordinates(1,1);
y_s(1)= coordinates(1,2);

%�����
e_e(1)= velocities(2,1);
f_e(1)= velocities(2,2);
x_e(1)= coordinates(2,1);
y_e(1)= coordinates(2,2);

%������ ��������
r_x(1)=-(x_s(1)-x_e(1));
r_y(1)=-(y_s(1)-y_e(1));
v_x(1)=-(e_s(1)-e_e(1));
v_y(1)=-(f_s(1)-f_e(1));

%����� ����
x_cm(1)=(mass(1)*coordinates(1,1)+mass(2)*coordinates(2,1))/(mass(1)+mass(2));
y_cm(1)=(mass(1)*coordinates(1,2)+mass(2)*coordinates(2,2))/(mass(1)+mass(2));
vx_cm(1)=(mass(1)*e_s(1)+mass(2)*e_e(1))/(mass(1)+mass(2));
vy_cm(1)=(mass(1)*f_s(1)+mass(2)*f_e(1))/(mass(1)+mass(2));

if method == 1
%   ������������� ����� ERK1
    b=[];
    c=[];
    b(1)=1;
    c(1)=0.5;
    for i=2:fin
%       ������ ��� ������ ����
        x_cm(i)=x_cm(i-1)+delta_t*vx_cm(1);
        y_cm(i)=y_cm(i-1)+delta_t*vy_cm(1);
%       ������ ��� ������� ��������
        v_x(i)= v_x(i-1)+delta_t*(-g*(mass(1)*mass(2)/mu)*r_x(i-1)/((r_x(i-1))^2+(r_y(i-1))^2)^(3/2));
        v_y(i)= v_y(i-1)+delta_t*(-g*(mass(1)*mass(2)/mu)*r_y(i-1)/((r_x(i-1))^2+(r_y(i-1))^2)^(3/2));
        r_x(i)= r_x(i-1)+delta_t*v_x(i-1);
        r_y(i)= r_y(i-1)+delta_t*v_y(i-1);
%       ���������� ������ � �����
        x_s(i)= x_cm(i)+r_x(i)*mass(2)/(mass(1)+mass(2));
        y_s(i)= x_cm(i)+r_y(i)*mass(2)/(mass(1)+mass(2));
        x_e(i)= x_cm(i)+r_x(i)*mass(1)/(mass(1)+mass(2));
        y_e(i)= x_cm(i)+r_y(i)*mass(1)/(mass(1)+mass(2));   
    end;
    plot(x_s,y_s,'o');
    hold on;
    plot(x_e,y_e,'--');
elseif method == 2
%   ������������� ����� ERK2
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
    
    for i=2:fin
%       ������ ������
%       ������ ��� ������ ����
        w(1,1)=vx_cm(1);
        w(1,2)=vy_cm(1);
%       ������ ��� ������� ��������  
        w(1,3)=(-g*(mass(1)*mass(2)/mu)*r_x(i-1)/((r_x(i-1))^2+(r_y(i-1))^2)^(3/2));
        w(1,4)=(-g*(mass(1)*mass(2)/mu)*r_y(i-1)/((r_x(i-1))^2+(r_y(i-1))^2)^(3/2));
        w(1,5)= v_x(i-1);
        w(1,6)= v_y(i-1);
        
%       ������ ������
%       ������ ��� ������ ����
        w(2,1)=vx_cm(1)+delta_t*a(2)*w(1,1);
        w(2,2)=vy_cm(1)+delta_t*a(2)*w(1,2);    
%       ������ ��� ������� �������� 
        w(2,3)=-g*(mass(1)*mass(2)/mu)*(r_x(i-1)+delta_t*a(2)*w(1,5))/((r_x(i-1)+delta_t*a(2)*w(1,5))^2+(r_y(i-1)+delta_t*a(2)*w(1,6))^2)^(3/2);
        w(2,4)=-g*(mass(1)*mass(2)/mu)*(r_y(i-1)+delta_t*a(2)*w(1,6))/((r_x(i-1)+delta_t*a(2)*w(1,5))^2+(r_y(i-1)+delta_t*a(2)*w(1,6))^2)^(3/2);
        w(2,5)= (v_x(i-1)+delta_t*a(2)*w(1,3));
        w(2,6)= (v_y(i-1)+delta_t*a(2)*w(1,4)); 

%       ������ ��� ������ ����
        x_cm(i)=x_cm(i-1)+delta_t*(b(1)*w(1,1)+b(2)*w(2,1));
        y_cm(i)=y_cm(i-1)+delta_t*(b(1)*w(1,2)+b(2)*w(2,2));
%       ������ ��� ������� ��������         
        v_x(i)= v_x(i-1)+delta_t*(b(1)*w(1,3)+b(2)*w(2,3));
        v_y(i)= v_y(i-1)+delta_t*(b(1)*w(1,4)+b(2)*w(2,4));
        r_x(i)= r_x(i-1)+delta_t*(b(1)*w(1,5)+b(2)*w(2,5));
        r_y(i)= r_y(i-1)+delta_t*(b(1)*w(1,6)+b(2)*w(2,6));
%       ���������� ������ � �����
        x_s(i)= x_cm(i)+r_x(i)*mass(2)/(mass(1)+mass(2));
        y_s(i)= x_cm(i)+r_y(i)*mass(2)/(mass(1)+mass(2));
        x_e(i)= x_cm(i)+r_x(i)*mass(1)/(mass(1)+mass(2));
        y_e(i)= x_cm(i)+r_y(i)*mass(1)/(mass(1)+mass(2));        
    end;
    plot(x_s,y_s,'o');
    hold on;
    plot(x_e,y_e,'--');
    elseif method == 3
%   ������������ ����� ERK3
    a=[];
    b=[];
    c=[];
    w=[];
    
    b(1)=2/9;
    b(2)=1/3;
    b(3)=4/9;
  
    a(1)=0;
    a(2)=1/2;
    a(3)=3/4;
    
%     c(1)=0;
%     c(2)=1/2;
%     c(3)=3/4;
    
    for i=2:fin
%       ������ ������
%       ������ ��� ������ ����
        w(1,1)=vx_cm(1);
        w(1,2)=vy_cm(1);
%       ������ ��� ������� ��������  
        w(1,3)=(-g*(mass(1)*mass(2)/mu)*r_x(i-1)/((r_x(i-1))^2+(r_y(i-1))^2)^(3/2));
        w(1,4)=(-g*(mass(1)*mass(2)/mu)*r_y(i-1)/((r_x(i-1))^2+(r_y(i-1))^2)^(3/2));
        w(1,5)= v_x(i-1);
        w(1,6)= v_y(i-1);
        
%       ������ ������
%       ������ ��� ������ ����
        w(2,1)=vx_cm(1)+delta_t*a(2)*w(1,1);
        w(2,2)=vy_cm(1)+delta_t*a(2)*w(1,2);    
%       ������ ��� ������� �������� 
        w(2,3)=-g*(mass(1)*mass(2)/mu)*(r_x(i-1)+delta_t*a(2)*w(1,5))/((r_x(i-1)+delta_t*a(2)*w(1,5))^2+(r_y(i-1)+delta_t*a(2)*w(1,6))^2)^(3/2);
        w(2,4)=-g*(mass(1)*mass(2)/mu)*(r_y(i-1)+delta_t*a(2)*w(1,6))/((r_x(i-1)+delta_t*a(2)*w(1,5))^2+(r_y(i-1)+delta_t*a(2)*w(1,6))^2)^(3/2);
        w(2,5)= (v_x(i-1)+delta_t*a(2)*w(1,3));
        w(2,6)= (v_y(i-1)+delta_t*a(2)*w(1,4)); 
        
%       ������ ������
%       ������ ��� ������ ����
        w(3,1)=vx_cm(1)+delta_t*(a(3)*w(2,1));
        w(3,2)=vy_cm(1)+delta_t*a(3)*w(2,2);    
%       ������ ��� ������� �������� 
        w(3,3)=-g*(mass(1)*mass(2)/mu)*(r_x(i-1)+delta_t*a(3)*w(2,5))/((r_x(i-1)+delta_t*a(3)*w(2,5))^2+(r_y(i-1)+delta_t*a(3)*w(2,6))^2)^(3/2);
        w(3,4)=-g*(mass(1)*mass(2)/mu)*(r_y(i-1)+delta_t*a(3)*w(2,6))/((r_x(i-1)+delta_t*a(3)*w(2,5))^2+(r_y(i-1)+delta_t*a(3)*w(2,6))^2)^(3/2);
        w(3,5)= (v_x(i-1)+delta_t*a(3)*w(2,3));
        w(3,6)= (v_y(i-1)+delta_t*a(3)*w(2,4)); 
        
%       ������ ��� ������ ����
        x_cm(i)=x_cm(i-1)+delta_t*(b(1)*w(1,1)+b(2)*w(2,1)+b(3)*w(3,1));
        y_cm(i)=y_cm(i-1)+delta_t*(b(1)*w(1,2)+b(2)*w(2,2)+b(3)*w(3,2));
%       ������ ��� ������� ��������         
        v_x(i)= v_x(i-1)+delta_t*(b(1)*w(1,3)+b(2)*w(2,3)+b(3)*w(3,3));
        v_y(i)= v_y(i-1)+delta_t*(b(1)*w(1,4)+b(2)*w(2,4)+b(3)*w(3,4));
        r_x(i)= r_x(i-1)+delta_t*(b(1)*w(1,5)+b(2)*w(2,5)+b(3)*w(3,5));
        r_y(i)= r_y(i-1)+delta_t*(b(1)*w(1,6)+b(2)*w(2,6)+b(3)*w(3,6));
%       ���������� ������ � �����
        x_s(i)= x_cm(i)+r_x(i)*mass(2)/(mass(1)+mass(2));
        y_s(i)= x_cm(i)+r_y(i)*mass(2)/(mass(1)+mass(2));
        x_e(i)= x_cm(i)+r_x(i)*mass(1)/(mass(1)+mass(2));
        y_e(i)= x_cm(i)+r_y(i)*mass(1)/(mass(1)+mass(2));        
    end;
    plot(x_s,y_s,'o');
    hold on;
    plot(x_e,y_e,'--');        
end;

