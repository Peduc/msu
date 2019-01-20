clear;
clc;

%Начальные параметры 
%Кг, м/с
% Заданы: Солнце, Земля, Луна (Земля в афелии, для Луны взяты средние данные), комета Галлея
mass = [1.9891*10^30; 5.9736*10^24; 7.3477*10^22; 2.2*10^14];
coordinates = [0 0; 1.52098232*10^11 0; 1.52098232*10^11+3.84467*10^8 0; 5.24824*10^12 0];
velocities = [0 -0.089021687078894; 0 29270; 0 29270+1023; 0 -900];

%Приведённая масса
mu=mass(1)*mass(2)/(mass(1)+mass(2));

%Координаты центра масс
x_cm(1)=(mass(1)*coordinates(1,1)+mass(2)*coordinates(2,1))/(mass(1)+mass(2));
y_cm(1)=(mass(1)*coordinates(1,2)+mass(2)*coordinates(2,2))/(mass(1)+mass(2));

% Гравитационная постоянная
g = 6.67300*10^(-11);

% Отрезок времени на всякий случай. Одни сутки в секундах.
delta_t=86400;

%Неподвижное Солнце. Физика.
%Х-координаты
x_e=[];x_s=[];
%Y-координаты
y_e=[];y_s=[];
%Х-скорости
e_e=[];e_s=[];
%Y-скорости
f_e=[];f_s=[];
%Время
t=[];

%mass(2)*e_e'=-g*mass(1)*mass(2)*x_e/(x_e^2+y_e^2)^(3/2)=f1(x_e,y_e,e_e,f_e,t);
%mass(2)*f_e'=-g*mass(1)*mass(2)*y/(x_e^2+y_e^2)^(3/2)=f2(x_e,y_e,e_e,f_e,t);
%x_e'=e_e=f3(x_e,y_e,e_e,f_e,t);
%y_e'=f_e=f4(x_e,y_e,e_e,f_e,t);

%mass(1)*e_s'=-g*mass(1)*mass(2)*x_s/(x_s^2+y_s^2)^(3/2)=f5(x_s,y_s,e_s,f_s,t);
%mass(1)*f_s'=-g*mass(1)*mass(2)*y_s/(x_s^2+y_s^2)^(3/2)=f6(x_s,y_s,e_s,f_s,t);
%x_s'=e_s=f7(x_s,y_s,e_s,f_s,t);
%y_s'=f_s=f8(x_s,y_s,e_s,f_s,t);

%e_cm'=-(1/mass(1)+1/mass(2))*g*mass(1)*mass(2)*(x_s-x_e)/((x_s-x_e)^2+(y_s-y_e)^2)^(3/2)
%f_cm'=-(1/mass(1)+1/mass(2))*g*mass(1)*mass(2)*(y_s-y_e)/((x_s-x_e)^2+(y_s-y_e)^2)^(3/2)
%x_cm'=e_s-e_e;
%y_cm'=f_s-e_e;

%Выбор метода
method=1;

%Начальные условия
e_e(1)= velocities(2,1);
f_e(1)= velocities(2,2);
x_e(1)= coordinates(2,1);
y_e(1)= coordinates(2,2);

e_s(1)= velocities(1,1);
f_s(1)= velocities(1,2);
x_s(1)= coordinates(1,1);
y_s(1)= coordinates(1,2);

r_x(1)=x_s(1)-x_e(1);
r_y(1)=y_s(1)-y_e(1);
v_x(1)=e_s(1)-e_e(1);
v_y(1)=f_s(1)-f_e(1);

if method == 1
    %Одностадийная схема ERK1
    b=[];
    c=[];
    b(1)=1;
    c(1)=0.5;
    
    for i=2:400
        v_x(i)= v_x(i-1)+delta_t*(-g*mass(1)*r_x(i-1)/((r_x(i-1))^2+(r_y(i-1))^2)^(3/2));
        v_y(i)= v_y(i-1)+delta_t*(-g*mass(1)*r_y(i-1)/((r_x(i-1))^2+(r_y(i-1))^2)^(3/2));
        r_x(i)= r_x(i-1)+delta_t*v_x(i-1);
        r_y(i)= r_y(i-1)+delta_t*v_y(i-1);
%         x_s(i)= r_x(i)+mass(2)/(mass(1)+mass(2));
%         y_s(i)= r_y(i-1)+delta_t*v_y(i-1);       
    end;
	plot(r_x,r_y);
else
    %Двухстадийная схема ERK2
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
        %Первая стадия
        w(1,1)=-g*mass(1)*r_x(i-1)/((r_x(i-1))^2+(r_y(i-1))^2)^(3/2);
        w(1,2)=-g*mass(1)*r_y(i-1)/((r_x(i-1))^2+(r_y(i-1))^2)^(3/2);
        w(1,3)= v_x(i-1);
        w(1,4)= v_y(i-1);
        
        %Вторая стадия
        w(2,1)=-g*mass(1)*(r_x(i-1)+delta_t*a(2)*w(1,3))/((r_x(i-1)+delta_t*a(2)*w(1,3))^2+(r_y(i-1)+delta_t*a(2)*w(1,4))^2)^(3/2);
        w(2,2)=-g*mass(1)*(r_y(i-1)+delta_t*a(2)*w(1,4))/((r_x(i-1)+delta_t*a(2)*w(1,3))^2+(r_y(i-1)+delta_t*a(2)*w(1,4))^2)^(3/2);
        w(2,3)= (v_x(i-1)+delta_t*a(2)*w(1,1));
        w(2,4)= (v_y(i-1)+delta_t*a(2)*w(1,2)); 
        
        v_x(i)= v_x(i-1)+delta_t*(b(1)*w(1,1)+b(2)*w(2,1));
        v_y(i)= v_y(i-1)+delta_t*(b(1)*w(1,2)+b(2)*w(2,2));
        r_x(i)= r_x(i-1)+delta_t*(b(1)*w(1,3)+b(2)*w(2,3));
        r_y(i)= r_y(i-1)+delta_t*(b(1)*w(1,4)+b(2)*w(2,4));
    end;
	plot(r_x,r_y);
end;

