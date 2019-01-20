clear
clc

%  Входные параметры
% k=9*10^9;
% e=1.6*10^(-19);
method=1;
% method=2;
count=1;
e=-1;
lambda=1;
% me=9.10938356*10^(-31);
me=1;
% l=100*2.8*10^(-15);
L=1;

mass = [me; me];
charges = [1; -1; 1];
dist=10;
coordinates = [dist L/2; dist -L/2; 0 0];
velocities = [0 0; 0 0; 0 0];

% Отрезок времени на всякий случай. 
Periods=100;
fin=100;
delta_t(1)=fin/(Periods-1);


u=zeros(Periods,9);

% Физика.
%Х-координаты Q1 и Q2
x_f=[];x_s=[];
%Y-координаты Q1 и Q2
y_f=[];y_s=[];
%Х-скорости Q1 и Q2
vx_f=[];vx_s=[]; 
%Y-скорости Q1 и Q2
vy_e=[];vy_s=[];
%Время
t=[];

%Начальные условия
% Q1
vx_f(1)= velocities(1,1);
vy_f(1)= velocities(1,2);
x_f(1)= coordinates(1,1);
y_f(1)= coordinates(1,2);

% Q2
vx_s(1)= velocities(2,1);
vy_s(1)= velocities(2,2);
x_s(1)= coordinates(2,1);
y_s(1)= coordinates(2,2);


u=[x_f(1) y_f(1) vx_f(1) vy_f(1)...
   x_s(1) y_s(1) vx_s(1) vy_s(1) lambda];

% a(1)=(1+1i)/2;

M=zeros(length(u) );
for count=1:length(u)
    if count < length(u) 
        M(count,count)=1;
    end;
end

if (method) ==1
    %Одностадийная схема CROS2
    a(1)=(1+1i)/2;
    w_1=[];
    
    for count=2:Periods
        w_1=((M-a(1)*delta_t(1)*Yak(mass,charges,u(count-1,:)))^(-1))*...
            funct(mass,charges,u(count-1,:),L);
        u(count,:)=u(count-1,:)+delta_t(1)*real(w_1');
    end;
    
else
%   Решение   
    %Двухстадийная схема CROS2
    a=[];
    b=[];
    c=[];
    w_1=[];
    w_2=[];
    s=2;
    
    b(1)=0.1941430241155180-1i*0.2246898944678803;
    b(2)=0.8058569758844820-1i*0.8870089521907592;
    b(3)=0;
    c(1)=0.2554708972958462-1i*0.2026195833570109;
    
    a(1)=0.1+1i*sqrt(11)/30;
    a(2)=0.2+1i*sqrt(1)/10;
    a(3)=0.5617645150714754-1i*1.148223341045841;
    
    for count=2:Periods
        w_1=((M-a(1)*delta_t(1)*Yak(mass,charges,u(count-1,:)))^(-1))*...
            funct(mass,charges,u(count-1,:),L);
        w_2=((M-a(2)*delta_t(1)*Yak(mass,charges,u(count-1,:)+...
            delta_t(1)*real(a(3)*w_1)))^(-1))*...
            funct(mass,charges,u(count-1,:)+delta_t(1)*real(c(1)*w_1),L);
        u(count,:)=u(count-1,:)+delta_t(1)*real(b(1)*w_1'+b(2)*w_2');
    end;    
end;

X1 = u(:,1);
Y1 = u(:,2);
X2 = u(:,5);
Y2 = u(:,6);
L = u(:,9);
    
% figure(1);
% plot(X1,Y1,'o', X2, Y2, 'o');

% for count = 1: Periods
% %     disp('---');
%     plot(X1(count),Y1(count),'o',X2(count),Y2(count),'o');
% %     title( sprintf('eps = %.4f', eps(count)) );
%     hold all
%     pause(30/Periods);
% end;

% axis([-2*dist 2*dist -2*dist 2*dist ]);
for count = 1: Periods
    plot(0, 0,'o');
    hold on     
    plot(X1(count),Y1(count),'o');
    hold on    
    plot(X2(count),Y2(count),'o');
    hold on
    plot([X1(count) X2(count)], [Y1(count) Y2(count)]);
    axis([0 12 -6 6]);
    hold off
    drawnow
    pause (0.1);
%     pause(30/Periods);
end;
% hold on;
% plot(u(:,5),u(:,6),'o');

