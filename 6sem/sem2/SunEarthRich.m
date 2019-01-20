clear
clc
%Ричарсонова часть

buff=[];
u=[];
Rrn=[];
peff=[];
gust=3;
pres=10;
Norm=zeros(pres,pres);

%Начальные параметры 
%Кг, м/с
% Заданы: Солнце, Земля, Луна (Земля в афелии, для Луны взяты средние данные), комета Галлея
mass = [1.9891*10^30; 5.9736*10^24; 7.3477*10^22; 2.2*10^14];
coordinates = [0 0; 1.52098232*10^11 0; 1.52098232*10^11+3.84467*10^8 0; 5.24824*10^12 0];
velocities = [0 -0.089021687078894; 0 29270; 0 29270+1023; 0 -900];

%Приведённая масса Солнца и Земли
mu=mass(1)*mass(2)/(mass(1)+mass(2));

% Гравитационная постоянная
g = 6.67300*10^(-11);

% Отрезок времени на всякий случай. Одни сутки в секундах.
delta_t(1)=86400;
fin=(5*86400);
N=fin/delta_t(1);
% u=[1];
% Rrn=zeros(N*pres,4);


% Физика.
%Х-координаты Солнца и Земли, центра масс и вектора смещения
x_e=[];x_s=[]; x_cm=[];
%Y-координаты Солнца и Земли, центра масс и вектора смещения
y_e=[];y_s=[]; y_cm=[];
%Х-скорости Солнца и Земли, центра масс и вектора смещения
e_e=[];e_s=[]; vx_cm=[];
%Y-скорости Солнца и Земли, центра масс и вектора смещения
f_e=[];f_s=[]; vy_cm=[];
%Время
t=[];

%Выбор метода
% 1 - EKR1
% 2 - EKR2
% 3 - EKR3

method=1;

%Начальные условия
%Солнце
e_s(1)= velocities(1,1);
f_s(1)= velocities(1,2);
x_s(1)= coordinates(1,1);
y_s(1)= coordinates(1,2);

%Земля
e_e(1)= velocities(2,1);
f_e(1)= velocities(2,2);
x_e(1)= coordinates(2,1);
y_e(1)= coordinates(2,2);

%Вектор смещения
r_x(1)=-(x_s(1)-x_e(1));
r_y(1)=-(y_s(1)-y_e(1));
v_x(1)=-(e_s(1)-e_e(1));
v_y(1)=-(f_s(1)-f_e(1));

%Центр масс
x_cm(1)=(mass(1)*coordinates(1,1)+mass(2)*coordinates(2,1))/(mass(1)+mass(2));
y_cm(1)=(mass(1)*coordinates(1,2)+mass(2)*coordinates(2,2))/(mass(1)+mass(2));
vx_cm(1)=(mass(1)*e_s(1)+mass(2)*e_e(1))/(mass(1)+mass(2));
vy_cm(1)=(mass(1)*f_s(1)+mass(2)*f_e(1))/(mass(1)+mass(2));

u=[x_s(1) y_s(1) x_e(1) y_e(1)];

if method == 1
%   Одностадийная схема ERK1
    b=[];
    c=[];
    b(1)=1;
    c(1)=0.5;
    for k=1:pres
        if k==1
            for i=1:pres
                delta_t(i)=(fin/(N*gust^(i-1)));
                for j=2:(N*gust^(i-1)+1)
%                   Задача для центра масс
                    x_cm(j)=x_cm(j-1)+delta_t(i)*vx_cm(1);
                    y_cm(j)=y_cm(j-1)+delta_t(i)*vy_cm(1);
%                   Задача для вектора смещения
                    v_x(j)= v_x(j-1)+delta_t(i)*(-g*(mass(1)*mass(2)/mu)*r_x(j-1)/((r_x(j-1))^2+(r_y(j-1))^2)^(3/2));
                    v_y(j)= v_y(j-1)+delta_t(i)*(-g*(mass(1)*mass(2)/mu)*r_y(j-1)/((r_x(j-1))^2+(r_y(j-1))^2)^(3/2));
                    r_x(j)= r_x(j-1)+delta_t(i)*v_x(j-1);
                    r_y(j)= r_y(j-1)+delta_t(i)*v_y(j-1);
%                   Координаты Солнца и Земли
                    x_s(j)= x_cm(j)+r_x(j)*mass(2)/(mass(1)+mass(2));
                    y_s(j)= x_cm(j)+r_y(j)*mass(2)/(mass(1)+mass(2));
                    x_e(j)= x_cm(j)+r_x(j)*mass(1)/(mass(1)+mass(2));
                    y_e(j)= x_cm(j)+r_y(j)*mass(1)/(mass(1)+mass(2));
                    
                    if (mod((j),gust^(i-1))==0)&&((j-1)/gust^(i-1)>1)
                        pos=fix((j)/gust^(i-1));
                        u=[u;x_s(j) y_s(j) x_e(j) y_e(j)];
                    end;
                end;
                if (i<pres)
                    u=[u;u(1,1) u(1,2) u(1,3) u(1,4)];
                end;
            end;
%           Считаем вектор ошибок
            for p=1:pres-1
              	buff=u(1+N*(p-1):N+N*(p-1),1:4);
                buff_n=u(N+1+N*(p-1):2*N+N*(p-1),1:4);
                Rrn=[Rrn;(buff_n-buff)/(gust^(2+1*(k-1))-1)];
            end;
            Rrn=[buff-buff;Rrn];

%           Считаем нормы ошибок Х-координат Земли
            for p=2:pres
              	buff=Rrn(1+N*(p-1):N+N*(p-1),3);
%                 disp(buff);
                Norm(p,1)=(buff.')*(buff);
%                 disp(Norm(:,1));
            end;            
        else
            u=u+Rrn;
            u(1:N*(k-1),:)=[];
            u=[zeros(N*(k-1),4);u];
            
%           Считаем новый вектор ошибок
            Rrn=[];
            for p=1:pres-1
              	buff=u((1+N*(p-1)):(N+N*(p-1)),1:4);
                buff_n=u(N+1+N*(p-1):2*N+N*(p-1),1:4);
                Rrn=[Rrn;(buff_n-buff)/(gust^(2+1*(k-1))-1)];
            end;
            Rrn=[buff-buff;Rrn];
%           Считаем нормы ошибок Х-координат Земли
            for p=k+1:pres
              	buff=Rrn(1+N*(p-1):N+N*(p-1),3);
                Norm(p,k)=(buff.')*(buff);
            end;
            for i=k:pres    
                if (i>k+1)
                    peff(i,k)=log10(abs(Norm(i-1,k-1))/abs(Norm(i,k-1)))/log10(gust);     
                end;
            end;
        end;
    end;

%     plot(x_s,y_s,'o');
%     hold on;
%     plot(x_e,y_e,'--');
    
elseif method == 2
%   Двухстадийная схема ERK2
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
    
    for k=1:pres
        if k==1
            for i=1:pres
                delta_t(i)=(fin/(N*gust^(i-1)));
                for j=2:(N*gust^(i-1)+1)
%                   Первая стадия
%                   Задача для центра масс
                    w(1,1)=vx_cm(1);
                    w(1,2)=vy_cm(1);
%                   Задача для вектора смещения  
                    w(1,3)=(-g*(mass(1)*mass(2)/mu)*r_x(j-1)/((r_x(j-1))^2+(r_y(j-1))^2)^(3/2));
                    w(1,4)=(-g*(mass(1)*mass(2)/mu)*r_y(j-1)/((r_x(j-1))^2+(r_y(j-1))^2)^(3/2));
                    w(1,5)= v_x(j-1);
                    w(1,6)= v_y(j-1);
        
%                   Вторая стадия
%                   Задача для центра масс
                    w(2,1)=vx_cm(1)+delta_t(i)*a(2)*w(1,1);
                    w(2,2)=vy_cm(1)+delta_t(i)*a(2)*w(1,2);    
%                   Задача для вектора смещения 
                    w(2,3)=-g*(mass(1)*mass(2)/mu)*(r_x(j-1)+delta_t(i)*a(2)*w(1,5))/((r_x(j-1)+delta_t(i)*a(2)*w(1,5))^2+(r_y(j-1)+delta_t(i)*a(2)*w(1,6))^2)^(3/2);
                    w(2,4)=-g*(mass(1)*mass(2)/mu)*(r_y(j-1)+delta_t(i)*a(2)*w(1,6))/((r_x(j-1)+delta_t(i)*a(2)*w(1,5))^2+(r_y(j-1)+delta_t(i)*a(2)*w(1,6))^2)^(3/2);
                    w(2,5)= (v_x(j-1)+delta_t(i)*a(2)*w(1,3));
                    w(2,6)= (v_y(j-1)+delta_t(i)*a(2)*w(1,4)); 

%                   Задача для центра масс
                    x_cm(j)=x_cm(j-1)+delta_t(i)*(b(1)*w(1,1)+b(2)*w(2,1));
                    y_cm(j)=y_cm(j-1)+delta_t(i)*(b(1)*w(1,2)+b(2)*w(2,2));
%                   Задача для вектора смещения         
                    v_x(j)= v_x(j-1)+delta_t(i)*(b(1)*w(1,3)+b(2)*w(2,3));
                    v_y(j)= v_y(j-1)+delta_t(i)*(b(1)*w(1,4)+b(2)*w(2,4));
                    r_x(j)= r_x(j-1)+delta_t(i)*(b(1)*w(1,5)+b(2)*w(2,5));
                    r_y(j)= r_y(j-1)+delta_t(i)*(b(1)*w(1,6)+b(2)*w(2,6));
%                   Координаты Солнца и Земли
                    x_s(j)= x_cm(j)+r_x(j)*mass(2)/(mass(1)+mass(2));
                    y_s(j)= x_cm(j)+r_y(j)*mass(2)/(mass(1)+mass(2));
                    x_e(j)= x_cm(j)+r_x(j)*mass(1)/(mass(1)+mass(2));
                    y_e(j)= x_cm(j)+r_y(j)*mass(1)/(mass(1)+mass(2));        
                    
                    if (mod((j),gust^(i-1))==0)&&((j-1)/gust^(i-1)>1)
                        pos=fix((j)/gust^(i-1));
                        u=[u;x_s(j) y_s(j) x_e(j) y_e(j)];
                    end;    
                end;
                if (i<pres)
                    u=[u;u(1,1) u(1,2) u(1,3) u(1,4)];
                end;                
%         plot(x_s,y_s,'o');
%         hold on;
%         plot(x_e,y_e,'--');
            end;
%           Считаем вектор ошибок
            for p=1:pres-1
              	buff=u(1+N*(p-1):N+N*(p-1),1:4);
                buff_n=u(N+1+N*(p-1):2*N+N*(p-1),1:4);
                Rrn=[Rrn;(buff_n-buff)/(gust^(2+1*(k-1))-1)];
            end;
            Rrn=[buff-buff;Rrn];

%           Считаем нормы ошибок Х-координат Земли
            for p=2:pres
              	buff=Rrn(1+N*(p-1):N+N*(p-1),3);
%                 disp(buff);
                Norm(p,1)=(buff.')*(buff);
%                 disp(Norm(:,1));
            end;            
        else
            u=u+Rrn;
            u(1:N*(k-1),:)=[];
            u=[zeros(N*(k-1),4);u];
            
%           Считаем новый вектор ошибок
            Rrn=[];
            for p=1:pres-1
              	buff=u((1+N*(p-1)):(N+N*(p-1)),1:4);
                buff_n=u(N+1+N*(p-1):2*N+N*(p-1),1:4);
                Rrn=[Rrn;(buff_n-buff)/(gust^(2+1*(k-1))-1)];
            end;
            Rrn=[buff-buff;Rrn];
%           Считаем нормы ошибок Х-координат Земли
            for p=k+1:pres
              	buff=Rrn(1+N*(p-1):N+N*(p-1),3);
                Norm(p,k)=(buff.')*(buff);
            end;
            for i=k:pres    
                if (i>k+1)
                    peff(i,k)=log10(abs(Norm(i-1,k-1))/abs(Norm(i,k-1)))/log10(gust);     
                end;
            end;            
        end;
    end;
    
    elseif method == 3
%   Трёхстадийная схема ERK3
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
    for k=1:pres
        if k==1
            for i=1:pres
                delta_t(i)=(fin/(N*gust^(i-1)));
                for j=2:(N*gust^(i-1)+1)
%                   Первая стадия
%                   Задача для центра масс
                    w(1,1)=vx_cm(1);
                    w(1,2)=vy_cm(1);
%                   Задача для вектора смещения  
                    w(1,3)=(-g*(mass(1)*mass(2)/mu)*r_x(j-1)/((r_x(j-1))^2+(r_y(j-1))^2)^(3/2));
                    w(1,4)=(-g*(mass(1)*mass(2)/mu)*r_y(j-1)/((r_x(j-1))^2+(r_y(j-1))^2)^(3/2));
                    w(1,5)= v_x(j-1);
                    w(1,6)= v_y(j-1);
        
%                   Вторая стадия
%                   Задача для центра масс
                    w(2,1)=vx_cm(1)+delta_t(i)*a(2)*w(1,1);
                    w(2,2)=vy_cm(1)+delta_t(i)*a(2)*w(1,2);    
%                   Задача для вектора смещения 
                    w(2,3)=-g*(mass(1)*mass(2)/mu)*(r_x(j-1)+delta_t(i)*a(2)*w(1,5))/((r_x(j-1)+delta_t(i)*a(2)*w(1,5))^2+(r_y(j-1)+delta_t(i)*a(2)*w(1,6))^2)^(3/2);
                    w(2,4)=-g*(mass(1)*mass(2)/mu)*(r_y(j-1)+delta_t(i)*a(2)*w(1,6))/((r_x(j-1)+delta_t(i)*a(2)*w(1,5))^2+(r_y(j-1)+delta_t(i)*a(2)*w(1,6))^2)^(3/2);
                    w(2,5)= (v_x(j-1)+delta_t(i)*a(2)*w(1,3));
                    w(2,6)= (v_y(j-1)+delta_t(i)*a(2)*w(1,4)); 
        
%                   Третья стадия
%                   Задача для центра масс
                    w(3,1)=vx_cm(1)+delta_t(i)*(a(3)*w(2,1));
                    w(3,2)=vy_cm(1)+delta_t(i)*a(3)*w(2,2);    
%                   Задача для вектора смещения 
                    w(3,3)=-g*(mass(1)*mass(2)/mu)*(r_x(j-1)+delta_t(i)*a(3)*w(2,5))/((r_x(j-1)+delta_t(i)*a(3)*w(2,5)).^2+(r_y(j-1)+delta_t(i)*a(3)*w(2,6)).^2).^(3/2);
                    w(3,4)=-g*(mass(1)*mass(2)/mu)*(r_y(j-1)+delta_t(i)*a(3)*w(2,6))/((r_x(j-1)+delta_t(i)*a(3)*w(2,5)).^2+(r_y(j-1)+delta_t(i)*a(3)*w(2,6)).^2).^(3/2);
                    w(3,5)= (v_x(j-1)+delta_t(i)*a(3)*w(2,3));
                    w(3,6)= (v_y(j-1)+delta_t(i)*a(3)*w(2,4)); 
        
%                   Задача для центра масс
                    x_cm(j)=x_cm(j-1)+delta_t(i)*(b(1)*w(1,1)+b(2)*w(2,1)+b(3)*w(3,1));
                    y_cm(j)=y_cm(j-1)+delta_t(i)*(b(1)*w(1,2)+b(2)*w(2,2)+b(3)*w(3,2));
%                   Задача для вектора смещения         
                    v_x(j)= v_x(j-1)+delta_t(i)*(b(1)*w(1,3)+b(2)*w(2,3)+b(3)*w(3,3));
                    v_y(j)= v_y(j-1)+delta_t(i)*(b(1)*w(1,4)+b(2)*w(2,4)+b(3)*w(3,4));
                    r_x(j)= r_x(j-1)+delta_t(i)*(b(1)*w(1,5)+b(2)*w(2,5)+b(3)*w(3,5));
                    r_y(j)= r_y(j-1)+delta_t(i)*(b(1)*w(1,6)+b(2)*w(2,6)+b(3)*w(3,6));
%                   Координаты Солнца и Земли
                    x_s(j)= x_cm(j)+r_x(j)*mass(2)/(mass(1)+mass(2));
                    y_s(j)= x_cm(j)+r_y(j)*mass(2)/(mass(1)+mass(2));
                    x_e(j)= x_cm(j)+r_x(j)*mass(1)/(mass(1)+mass(2));
                    y_e(j)= x_cm(j)+r_y(j)*mass(1)/(mass(1)+mass(2));
                    
                    if (mod((j),gust^(i-1))==0)&&((j-1)/gust^(i-1)>1)
                        pos=fix((j)/gust^(i-1));
                        u=[u;x_s(j) y_s(j) x_e(j) y_e(j)];
                    end;                    
                end;
                if (i<pres)
                    u=[u;u(1,1) u(1,2) u(1,3) u(1,4)];
                end;                
%     plot(x_s,y_s,'o');
%     hold on;
%     plot(x_e,y_e,'--'); 
            end;
%           Считаем вектор ошибок
            for p=1:pres-1
              	buff=u(1+N*(p-1):N+N*(p-1),1:4);
                buff_n=u(N+1+N*(p-1):2*N+N*(p-1),1:4);
                Rrn=[Rrn;(buff_n-buff)/(gust^(2+1*(k-1))-1)];
            end;
            Rrn=[buff-buff;Rrn];

%           Считаем нормы ошибок Х-координат Земли
            for p=2:pres
              	buff=Rrn(1+N*(p-1):N+N*(p-1),3);
%                 disp(buff);
                Norm(p,1)=(buff.')*(buff);
%                 disp(Norm(:,1));
            end;            
        else
            u=u+Rrn;
            u(1:N*(k-1),:)=[];
            u=[zeros(N*(k-1),4);u];
            
%           Считаем новый вектор ошибок
            Rrn=[];
            for p=1:pres-1
              	buff=u((1+N*(p-1)):(N+N*(p-1)),1:4);
                buff_n=u(N+1+N*(p-1):2*N+N*(p-1),1:4);
                Rrn=[Rrn;(buff_n-buff)/(gust^(2+1*(k-1))-1)];
            end;
            Rrn=[buff-buff;Rrn];
%           Считаем нормы ошибок Х-координат Земли
            for p=k+1:pres
              	buff=Rrn(1+N*(p-1):N+N*(p-1),3);
                Norm(p,k)=(buff.')*(buff);
            end;
            for i=k:pres    
                if (i>k+1)
                    peff(i,k)=log(abs(Norm(i-1,k-1))/abs(Norm(i,k-1)))/log(gust);     
                end;
            end;
        end;
    end;
end;
