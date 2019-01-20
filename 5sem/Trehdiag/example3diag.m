clear;
clc;

% Определяем параметры задачи
n = 10;
A = 0;
B = 1;
C = -0.25;
tau = 0.1;

% Задаём правую часть СЛАУ
h = (B - A)/(n - 1);
for n =1:n
    d(n) = sin((A + h*(n - 1))/(B - A)*pi);
end

% Рисуем график правой части СЛАУ
plot(A:h:B,d,'-og','MarkerSize',3);
hold on;

% Задаём коэффициенты трёх диагоналей матрицы СЛАУ
a(1) = 0;
for i = 2:n
    a(i) = C*tau/h;
end
for i = 1:n
    b(i) = -(1 - C*tau/h);
end
for i = 1:n
    c(i) = 0;
end

% Реализуем прямой ход метода прогонки
ksi(1) = 0;
eta(1) = 0;
for i = 1:n
    ksi(i + 1) = c(i)/(b(i) - a(i)*ksi(i));
    eta(i + 1) = (a(i)*eta(i) - d(i))/(b(i) - a(i)*ksi(i));
end

% Реализуем прямой ход метода прогонки
x(n + 1) = 0;
for i = n:-1:1
    x(i) = ksi(i + 1)*x(i + 1) + eta(i + 1);
end

% Рисуем решение на том же графике
plot(A:h:B,x(1:n),'-or','MarkerSize',3);
