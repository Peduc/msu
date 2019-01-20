clear;
clc;

%Начальные параметры 
%Кг, м/с
% Заданы: Солнце, Земля, Луна (Земля в афелии, для Луны взяты средние данные), комета Галлея
mass = [1.9891*10^30; 5.9736*10^24];
coordinates = [0 0; 1.52098232*10^11 0];
velocities = [0 -0.089021687078894; 0 29270];

% Гравитационная постоянная
g = 6.67300*10^(-11);

% Отрезок времени на всякий случай. Одни сутки в секундах.
delta_t(1)=86400;
N=365;
maxgust=7;
r=2;
%Множитель нормы
eps=10^7;

u=zeros(N,8);

% Физика.
%Х-координаты Солнца и Земли
x_e=[];x_s=[]; 
%Y-координаты Солнца и Земли
y_e=[];y_s=[]; 
%Х-скорости Солнца и Земли
vx_e=[];vx_s=[]; 
%Y-скорости Солнца и Земли
vy_e=[];vy_s=[];
%Время
t=[];

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

u=[x_s(1) y_s(1) vx_s(1) vy_s(1)...
   x_e(1) y_e(1) vx_e(1) vy_e(1)];

u_temp=u;

% Стадийность Схемы (2 , 3 ) 
s = 3;
p = s;
q=2;
a=[];
b=[];
w=[];
if  (s == 2)   
    b(1)=0.25;
    b(2)=0.75;
    
    a(1)=0;
    a(2)=2/3;
elseif  (s == 3)
    b(1)=2/9;
    b(2)=1/3;
    b(3)=4/9;
    
    a(1)=0;
    a(2)=1/2;
    a(3)=3/4;
end;

u_rich=zeros(maxgust,maxgust);
R=zeros(maxgust,maxgust);
peff=zeros(maxgust,maxgust);

for stol=1:maxgust
    if stol == 1
        for i=1:maxgust
            delta_t(i)=(delta_t(1)/(r^(i-1)));
            pos=2;
            %Нахождение U в каждой точке
            for j=2:N
                for k=1:s
                    sum=zeros(1,8);
                    for L=1:k-1
                        sum(:)=sum(:)+a(L)*w(L);
                    end;
                    w(k,:)=funct(mass,u(j-1,:)+delta_t(i)*sum);
                end;
                sum=zeros(1,8);
                for k=1:s
                    sum=sum+b(k)*w(k,:);
                end;
                u(j,:)=u(j-1,:)+delta_t(i)*sum;
                %Отбор кратных точек
                if i==1
                    u_temp(j,:)=u(j,:);
%                     u_temp(j,1)=u(j,1);
                else
                    if ((j-1)/r^(i-1))==pos-1
                        u_temp(pos,:)=u(j,:);
%                         u_temp(pos,1:2)=u(j,1:2);
%                         disp(pos);
                        pos=pos+1;
                    end;
                end;
            end;
%             disp(u_temp);
%             disp('---');
            N=r*(N-1)+1;
            u_rich(i,1)=norm_u(u_temp,eps);
            if i>1
                R(i,1)=(u_rich(i,1)-u_rich(i-1,1))/(r^(p+q)-1);
            end;
            if i>2
                peff(i,1)=s-1+abs(log(R(i-1,1)/R(i,1))/log(r));
            end;
%         plot(u(:,1),u(:,2),'o');
%         hold on;
%         plot(u(:,5),u(:,6),'.');
%         hold on;
        end;

    else
        for i=stol:maxgust
            u_rich(i,stol)=(u_rich(i,stol-1)+R(i,stol-1));
        end;
        for i=stol+1:maxgust
            R(i,stol)=(u_rich(i,stol)-u_rich(i-1,stol))/(r^(p+q)-1);
        end;
        for i=stol+2:maxgust
            peff(i,stol)=s-1+abs(log(R(i-1,stol)/R(i,stol))/log(r));
        end;
    end;
end;

disp(u_rich);
disp(R);
disp(peff);
% plot(u(:,1),u(:,2),'o');
% hold on;
% plot(u(:,5),u(:,6),'--');

