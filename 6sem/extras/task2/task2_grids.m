%{
    % Заданы: Солнце, Земля, Луна (Земля в афелии, для Луны взяты средние данные), комета Галлея 
    mass = [1.9891*10^30; 5.9736*10^24; 7.3477*10^22; 2.2*10^14]; 
    coordinates = [0 0; 1.52098232*10^11 0; 1.52098232*10^11+3.84467*10^8 0; 5.24824*10^12 0]; 
    velocities = [0 -0.089021687078894; 0 29270; 0 29270+1023; 0 -900]; 

    % Гравитационная постоянная 
    g = 6.67300*10^(-11); 
    4. Реализовать построение адаптивных сеток с помощью автоматики выбора шага.
     Для этих целей прошу рассмотреть задачу движения кометы Галлея вокруг Солнца в двух вариациях:
     1) Солнце закреплено в начале координат, другие тела кроме кометы Галлея отсутствуют,
     2) Солнце и другие тела (Земля и Луна) присутствуют и не закреплены.

    4.1. Смоделируйте поведение системы Солнце - комета Галлея (начальное положение в афелии)
     и сделайте вычисления в следующих двух вариантах:
     1) с постоянным шагом (10 дней) в течение 1 периода обращения (75,3 лет);
     2) с автоматикой выбора шага* (начальный шаг - 10 дней) в течении 1 периода обращения;
     3) с переходом к длине дукги. Сравните точность (зрительно на основании графиков траекторий)
        и число шагов в обоих случаях.

    * автоматику выбора шага реализуйте как с помощью локального сгущения сетки
    , делая вычисления с помощью схемы ERK4, так и с помощью вложенных схем,
      делая вычисления с помощью схемы ERK3 и соответствующей вложенной ERK2.

    4.2. Добавьте комету Галлея в систему Солнце - Земля - Луна и проведите аналогичные вычисления.
%}
clear; clc; 
close all;

N = 1000;
K = 5;
r = 2;
year = 75;
eps = 2 * 10^(5);
sec = 365*24*60*60;
tau = year * sec/ N;
T = year * sec;

%Стадийность РК
s = 2;
p = s;
q = 1;
% 1 - Равномерная Сетка || 2  - Вложенные Схемы (ERK3 + ERK2) || 3 - ERK4 
mode = 2;

NORM_VEL = @(delta)  sqrt(delta(3)^2 + delta(4)^2 + delta(7)^2 +...
           delta(8)^2+ delta(11)^2 + delta(12)^2 + delta(15)^2 + delta(16)^2) ;

%Солнце, Земля, Луна (Земля в афелии, для Луны взяты средние данные), комета Галлея 
coord   = [  0;                              0; 
             1.52098232*10^11;               0; 
             1.52098232*10^11+3.84467*10^8;  0;
             5.24824*10^12;                  0]; 
         
vel     = [  0;                              -0.089021687078894; 
             0;                              29270; 
             0;                              29270+1023; 
             0;                              -900]; 

% Adaptive Grids
lol = [coord(1);  coord(2);   vel(1); vel(2);...
     coord(3);  coord(4);   vel(3); vel(4);...
     coord(5);  coord(6);   vel(5); vel(6);...
     coord(7);  coord(8);   vel(7); vel(8)];
 
if (mode == 1)
    
    t = 0:tau:T;
    
elseif ( mode == 2)

    t(1) = 0;
    w = [coord(1);  coord(2);   vel(1); vel(2);...
     coord(3);  coord(4);   vel(3); vel(4);...
     coord(5);  coord(6);   vel(5); vel(6);...
     coord(7);  coord(8);   vel(7); vel(8)];
    v = w;
    i = 2; 
    e = 3;
    TAU(1) = tau;
    
    while t(i-1) < T
        
        A = ERKS_AG(tau, v, w, length(w));
        v = A(:, 1);
        w = A(:, 2);
        tau1 = ( eps * tau^e /( T * NORM_VEL(w - v) ) )^(1/(e-1)); 
        
        if tau1 / tau > 2 
            tau1 = 2 * tau; 
        end
        
        v = w;
        tau = tau1;
        TAU(i) = tau;
        t(i) = t(i-1) + tau;
        i = i + 1; 
        
        if i > 10^4
            disp('ERROR! A lot of iterations!')
            break
        end
        
    end
    
elseif ( mode == 3)
    
    t(1) = 0;
    w = [coord(1);  coord(2);   vel(1); vel(2);...
     coord(3);  coord(4);   vel(3); vel(4);...
     coord(5);  coord(6);   vel(5); vel(6);...
     coord(7);  coord(8);   vel(7); vel(8)];
    v = w;
    i = 2; 
    e = 4;
    TAU(1) = tau;
    
    while t(i-1) < T 
        
        w = ERK4(tau/2, ERK4(tau/2, w));
        v = ERK4(tau, v);
        
        tau1 = ( eps * tau^(e+1) /( T * NORM_VEL(w - v) * (2^e - 1) * 2^e) )^(1/e); 
        
        if tau1 / tau > 2 
            tau1 = 2 * tau; 
        end
        
        v = w;
        tau = tau1;
        TAU(i) = tau;
        t(i) = t(i-1) + tau;
        i = i + 1;
        
        if i > 10^4
            disp('ERROR! A lot of iterations!')
            break
        end
        
    end
    
end

if mode > 1
    
    figure
    plot(TAU)
    xlabel('i')
    ylabel('tau')
    % Число шагов:
    disp('Steps (optimal ~ 1000):')
    N = length(t) - 1;
    
end
clear v w e A tau tau1 T 

% Richardson

% Создание массивов (число координат для планет, 16 при 4х):
U = zeros(K, K, length(lol), N+1);
Rn = zeros(K-1, K-1, length(lol), N+1);
p_eff = zeros(K-2, K-2);

for i = 1 : K
    
    U(i, 1, :, :) = ERKs(t, s, i, lol, r);
    % Сгущение сетки
    for j = 1 : length(t) 
        t1(r*(j-1)+1) = t(j);
        if j <= length(t)-1
            for k = 1:r-1
                t1(r*(j-1)+1+k) = (t(j+1) - t(j)) / r + t1(r*(j-1)+1+k-1);           
            end
        end
    end 
    t = t1;
    
end


for i = 2 : K
    
    z = 0;  
    for j = i : K
         
        Rn(j-1, i-1, :, :) = ( U(j, i-1, :, :) - U(j-1, i-1, :, :) ) /( r^(p + q * (i - 2)) - 1 ); 
        %R_Rel(j-1, i-1) = NormM(R(j-1, i-1, :, :)) / NormM(U(j, i-1, :, :));
        
        U(j, i, :, :) = U(j, i-1, :, :) + Rn(j-1, i-1, :, :); 

        z = z + 1;
        
        if (z > 1) && (i < K)
            temp1(:, :) = Rn(j-2, i-1, :, :);
            temp2(:, :) = Rn(j-1, i-1, :, :);
            p_eff(j-2, i-1) = log10( NORM(temp1) / NORM(temp2) ) / log10(r);
            
            %P(j-2, i-1) = log10(Norm_Coord(temp1) / Norm_Coord(temp2)) / log10(r); 
            %P(j-2, i-1) = log10(R_Rel(j-2, i-1) / R_Rel(j-1, i-1)) / log10(r); 
        end
     
    end

end


% Графики:

% m <= n
n = K;
m = K;

figure(1)
% Галлей
Xg(:, 1) = U(n, m, 5, :);
Yg(:, 2) = U(n, m, 6, :);
line(Xg(:, 1), Yg(:, 2), 'Color', 'blue')
% Земля
Xe(:, 1) = U(n, m, 9, :);
Ye(:, 2) = U(n, m, 10, :);
line(Xe(:, 1), Ye(:, 2), 'Color', 'green')
% Луна
Xm(:, 1) = U(n, m, 13, :);
Ym(:, 2) = U(n, m, 14, :);
line(Xm(:, 1), Ym(:, 2), 'Color', 'black')
% Солнце
Xs(:, 1) = U(n, m, 1, :);
Ys(:, 2) = U(n, m, 2, :);
line(Xs(:, 1), Ys(:, 2), 'Color', 'yellow', 'Marker','o', 'MarkerSize', 5, 'MarkerEdgeColor', 'yellow', 'MarkerFaceColor', 'yellow')







