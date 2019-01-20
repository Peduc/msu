clear;
clc;

mass = [1.9891*10^30; 5.9736*10^24; 7.3477*10^22; 2.2*10^14];
coordinates = [0 0; 1.52098232*10^11 0; 1.52098232*10^11+3.84467*10^8 0; 5.24824*10^12 0];
velocities = [0 -0.089021687078894; 0 29270; 0 29270+1023; 0 -900];

%Начальные условия
%Солнце
vx_s(1)= velocities(1,1);
vy_s(1)= velocities(1,2);
x_s(1)= coordinates(1,1);
y_s(1)= coordinates(1,2);

%Земля
vx_e(1)= velocities(2,1);
vy_e(1)= velocities(2,2);
x_e(1)= coordinates(2,1);
y_e(1)= coordinates(2,2);

%Луна
vx_m(1)= velocities(3,1);
vy_m(1)= velocities(3,2);
x_m(1)= coordinates(3,1);
y_m(1)= coordinates(3,2);

%Комета Галлея
vx_g(1)= velocities(4,1);
vy_g(1)= velocities(4,2);
x_g(1)= coordinates(4,1);
y_g(1)= coordinates(4,2);

u=[x_s(1) y_s(1) vx_s(1) vy_s(1)...
   x_e(1) y_e(1) vx_e(1) vy_e(1)...
   x_m(1) y_m(1) vx_m(1) vy_m(1)...
   x_g(1) y_g(1) vx_g(1) vy_g(1)];

delta_t(1) = 86400*10;
N=2738;
T= 2365200000;

% Стадийность главной схемы (3 , 4 ) 
s_main = 4;
p=s_main;
t = 0;
j = 2;
if  (s_main == 3)
    eps = 10^8;
    
    a_2 = [0; 2/3];
    b_2 = [1/4 3/4];
    c_2 = [0 2/3];
    a_3 = [0 0; 1/2 0; 0 3/4];
    b_3 = [2/9 1/3 4/9];
    c_3=[0 0 0];
    
    u3=u;
    u2=u;
    while t<T
        %Считаем u(j-1) по EKR3
        u3 = ERK(mass,u(j-1,:),a_3,b_3,delta_t(j-1),3);
        %Считаем u(j-1) по EKR2   
        u2 = ERK(mass,u(j-1,:),a_2,b_2,delta_t(j-1),2);
        %Выбираем новый временной шаг
        delta_t1=(eps*delta_t(j-1)^p/T/norm_u(u3-u2))^(1/(p-1));
        if delta_t1 / delta_t(j-1) > 2
            delta_t1 = 2 * delta_t(j-1);
        end;
        delta_t(j) = delta_t1;
        %Считаем u(j-1) по EKR3
        u(j,:) = ERK(mass,u(j-1,:),a_3,b_3,delta_t(j),3);
        t(j) = t(j-1) + delta_t(j-1);
        j=j+1;
%         disp(j);
    end;
elseif  (s_main == 4)
    eps = 10^6;
    a_4 = [0 0 0; 1/2 0 0; 0 1/2 0; 0 0 1];
    b_4 = [1/6 1/3 1/3 1/6];
    c_4 = [0 1/2 1/2 1];
    u_t=u;
    u_t2=u;
    u_3t2=u;
    while t<T
        %Считаем u(t) по EKR4
        u_t = ERK(mass,u(j-1,:),a_4,b_4,delta_t(j-1),4);
        %Считаем u(t/2) по EKR4   
        u_t2 = ERK(mass,u(j-1,:),a_4,b_4,delta_t(j-1)/2,4);
        u_3t2=ERK(mass,u_t2,a_4,b_4,delta_t(j-1)/2,4);
        %Выбираем новый временной шаг
        delta_t1=(eps*delta_t(j-1)^p/T/norm_u(u_3t2-u_t))^(1/(p-1));
        if delta_t1 / delta_t(j-1) > 2
            delta_t1 = 2 * delta_t(j-1);
        end;
        delta_t(j) = delta_t1;
        %Считаем u(j-1) по EKR3
        u(j,:) = ERK(mass,u(j-1,:),a_4,b_4,delta_t(j),4);
        t(j) = t(j-1) + delta_t(j-1);
        j=j+1;
%         disp(j);
    end;    
end;

plot(u(:,1),u(:,2),'o');
hold on;
plot(u(:,5),u(:,6),'--');
hold on;
plot(u(:,9),u(:,10),'-.');
hold on;
plot(u(:,13),u(:,14),'-');