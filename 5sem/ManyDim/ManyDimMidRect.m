clear
clc
Start = cputime; 

%Параметры
%Функция y=Sum(cos(x(i)+(i-1)*Pi()/dim)), 1->Dim
%Размерность пространства
Dim=10;
%Количество точек
N=5;
%Массив- левых границ
left=[];
%Массив правых границ
right=[];

%Радиус-вектор точки
r=[];
length=[];
length1=[];
count=0;

syms X1 X2 X3 X4 X5 X6 X7 X8 X9 X10;
u=[];
h=[];
x=[];

%Задание Dim-мерного параллелепипеда
for i=1:Dim
    left(i)=-pi()/2;
    right(i)=pi()/2;
    h(i)=(right(i)-left(i))/(N-1);
end;


% for d=1:Dim
%       	10
    for j10=1:N
        x10(j10)=left(Dim)+(j10-1)*h(Dim);        
    end;
    for j10=1:N
        for j9=1:N
          x9(j9)=left(Dim-1)+(j9-1)*h(Dim-1);        
        end;
        for j9=1:N
        	for j8=1:N
                x8(j8)=left(Dim-2)+(j8-1)*h(Dim-2);        
            end;
            for j8=1:N
                for j7=1:N
                    x7(j7)=left(Dim-3)+(j7-1)*h(Dim-3);        
                end;
                for j7=1:N
                    for j6=1:N
                        x6(j6)=left(Dim-4)+(j6-1)*h(Dim-4);        
                    end;
                    for j6=1:N
                        for j5=1:N
                            x5(j5)=left(Dim-5)+(j5-1)*h(Dim-5);        
                        end;
                        for j5=1:N
                            for j4=1:N
                                x4(j4)=left(Dim-6)+(j4-1)*h(Dim-6);        
                            end;
                            for j4=1:N
                                for j3=1:N
                                    x3(j3)=left(Dim-7)+(j3-1)*h(Dim-7);        
                                end;
                                for j3=1:N
                                    for j2=1:N
                                        x2(j2)=left(Dim-8)+(j2-1)*h(Dim-8);        
                                    end;
                                    u3(j3)=0;
                                    for j2=1:N
                                        for j1=1:N
                                            x1(j1)=left(Dim-9)+(j1-1)*h(Dim-9);        
                                        end;
                                        u=0;
                                        for j1=2:N
                                            u=u+(fundimcos(x1(j1-1),x2(j2),x3(j3),x4(j4),x5(j5),x6(j6),x7(j7),x8(j8),x9(j9),x10(j10))+fundimcos(x1(j1),x2(j2),x3(j3),x4(j4),x5(j5),x6(j6),x7(j7),x8(j8),x9(j9),x10(j10)))*(h(1)*h(2)*h(3)*h(4)*h(5)*h(6)*h(7)*h(8)*h(9)*h(10))/2;
                                        end;
                                    end;
                                    %u3(j3)=u3(j3)+(u2(j2)+u2(j2))*h(2)/2;
                                end;    
                            end; 
                        end;    
                    end;                    
                end;    
            end; 
        end;    
    end;   
%     for j=2:N
%          u(d)=u(d)+(fundimcos(x(j-1))+fundimcos(x(j)))*h(d)/2;  
%     end;
% end;

Elapsed = cputime - Start;
disp(Elapsed);