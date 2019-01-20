%{
    1. Реализовать схемы ERK2 и ERK3 для системы Солнце-Земля, и смоделировать эволюцию этой системы в течение года.  

    2. Обобщить задание пункта 1 на тот случай, когда Солнце не закреплено.

    3. Реализовать методику Ричардсона рекуррентного повышения точности и асимптотических
     точного выполнения апостериорных оценок погрешности.

    % Заданы: Солнце, Земля, Луна (Земля в афелии, для Луны взяты средние данные), комета Галлея 
    mass = [1.9891*10^30; 5.9736*10^24; 7.3477*10^22; 2.2*10^14]; 
    coordinates = [0 0; 1.52098232*10^11 0; 1.52098232*10^11+3.84467*10^8 0; 5.24824*10^12 0]; 
    velocities = [0 -0.089021687078894; 0 29270; 0 29270+1023; 0 -900]; 

%}
clear; clc;
close all;

%Заданы: Солнце, Земля, Луна (Земля в афелии, для Луны взяты средние данные)
mass = [1.9891*10^30; 
        5.9736*10^24; 
        7.3477*10^22]; 
r = [0                                0;
     1.52098232*10^11                 0;
     1.52098232*10^11+3.84467*10^8    0];
           
v = [0                                 -0.089021687078894;
     0                                 29270;
     0                                 29270+1023];
%Время измерений (дни)
T = 8;
sec = 24*60*60;
%Шаг (дни)
tau = 1;
%Масса луны
M_moon = mass(3);
%Масса солнца
M = mass(1);
%Масса Земли
m = mass(2);

g = 6.67300*10^(-11); 

% Стадийность Схемы (2 , 3 , 4) 
s = 2;
p = s;

if  s == 2
    
    b = [1/4; 3/4];
    a = zeros(2,2);
    a(2,1) = 2/3;
    c = [0; 2/3];

elseif  s == 3
    
    b = [2/9; 1/3; 4/9];
    a = zeros(3,3);
    a(2,1) = 1/2;
    a(3,2) = 3/4;

elseif  s == 4
    
    b = [1/6; 1/3; 1/3; 1/6];
    a = zeros(4,4);
    a(2,1) = 1/2;
    a(3,2) = 1/2;
    a(4,3) = 1;

end

T = T*sec;
tau0 = tau*sec;
const = T/tau0+1;
rich = 1;
kd = 1;

while rich <= 32 
    N = 1;
    tau = tau0/rich;
    t = tau;
    u = zeros(N,12);
    u(1,:) = [r(1,1); r(1,2); v(1,1); v(1,2);
            r(2,1); r(2,2); v(2,1); v(2,2);
            r(3,1); r(3,2); v(3,1); v(3,2)];
    
    while t < T
        N = N+1;
        for n = 1:N
            for k = 1:s
                sum = zeros(1,12);
                for l = 1:(k-1)
                    sum = sum+a(k,l)*w(l,:);
                end
                w(k,:) = F2_Rich( u(n,:) + tau*sum, mass, g );
            end
            sum = zeros(1,12);
            for k=1:s
                sum = sum + b(k)*w(k,:);
            end
            u(n+1,:) = u(n,:) + tau*sum;
        end
        t=t+tau;
    end
    
    if rich == 1
        A = u;
        size = N+1;
    else
        U = zeros(size,12);
        e = 1;
        j = 1;
        while e <= (N+1)
            U(j,:) = u(e,:);
            e = e + rich;
            j = j + 1;
        end
        A = cat(1,A,U);
        kd = kd+1;
    end
    rich = rich*2;
end

clear r;

delta = zeros(kd-1,kd-1);
C = zeros(kd-1,kd-1);
p_eff = zeros(kd-1,kd-1);

r = 2;
q = 0; 
z = 1; 
o = 0;

while z <= (kd-1)
    for i = o:(kd-2)
        dop1 = A(1+(i-o)*const : const+(i-o)*const,:);
        dop2 = A(1+(i-o+1)*const : const+(i-o+1)*const,:);
        R = ( dop2 - dop1 )/( r^(p+q)-1 );
        
        if i == o
            B = dop2 + R;
            C = R;
        else
            B = cat(1, B, dop2 + R);
            C = cat(1, C, R);
        end
        
        delta(i+1,o+1) = norm(R)/norm(B(1+(i-o)*const : const+(i-o)*const,:))*100;
    end
    
    for j = o:(kd-3)
        p_eff(j+2,o+1) = log( norm( C(1+(j-o)*const : const+(j-o)*const,:) )/norm( C(1+(j-o+1)*const : const+(j-o+1)*const,:) ) )/log(r);
    end
    
    A = B;
    C = zeros(kd-1,kd-1);
    q = q+1;
    z = z+1;
    o = o+1;
    
end
disp(delta);
disp(p_eff);
