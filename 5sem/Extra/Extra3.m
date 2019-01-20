% Подготовьте программу, которая с помощь среднеквадратичной
% аппроксимации заданного набора точек с заданными погрешностями
% будет вычислять в точке приближённое значение функции,
% автоматически выбирая оптимальное число базисных функций.
clear
clc

syms X1 Y W S;

left=-1;
right=1;
N=7;
M=6;
delta=[];

A=[];
B=[];

%Сжимаем и сдвигаем координаты
trans=(right+left)/2;
scale=(right-left);

%Формирование кривой. 
h=(right-left)/(N-1);

for i=1:N
	x(i)=left+(i-1)*h;
	ye(i)=extra(x(i));
    err(i)=ye(i)*0.1;
end;

for count=1:M+1
    %Заполнение матрицы произведений СФ 
    for i=1:count
        for j=1:count
           if ((mod(j+i,2)) == 0)
                A(j,i)=2/(j+i+1);
           else 
            A(j,i)=0;
           end;
        end;
    end;

    %Заполнение вектора проекций  
    for i=1:count
        B(i)=0;
        for j=2:N
            B(i)=B(i)+(h/2)*((ye(j)*((x(j)-trans)/trans)^(i-1))+(ye(j-1)*((x(j)-trans)/trans)^(i-1)));        
        end;
    end;

    %Получаем х
    Xr=(inv(A'*A))*A'*B';

    %Формируем полином нужной степени
    Y = 0;
    for i=1:count
        Y=Y+X1^(i-1)*Xr(i);
    end;
            disp(vpa(Y));
    
    delta(count)=0;
    for i=1:N
        delta(count)=delta(count)+(1/(N-count))*((subs(Y,X1,x(i))-ye(i))/(err(i)))^2;        
    end;
    if ((count)==1) | ((delta(count))<min)
    	min=delta(count);
    	S=Y;
%         disp(vpa(Y));
    end;
end;
% ezplot(Y,left,right);
% errorbar(x,ye,err)