%{
    ���������������-�������������� �������
    � �.�. ����� ����� � Q, � ��� ��������������� ������, ������ � �����
    �������� qi, mi (i=1,2). 
    ����� ����� ��������?
    ������� � ���
%}
clear; clc;
close all;
tic;
    
N = 9;
J = 2000;
T = 60;
tau = T/(J - 1);
a = (1+1i)/2; 
%���������� ����� ���������� ( ����� ������ )
L = 1;
%������
lam = 1;

[Fu,var] = Jac4(L);
funct = @(X) double(subs(Fu,var,X));

M = horzcat( eye(N,N-1),zeros(N,1) );
tj = 0:tau:T;
U = zeros(N,J);

U(:,1)=[5; L/2; 0; 0; 5; -L/2; 0; 0; lam];
%U(1,:)=[x1 y1 vx1 vy1 x2 y2 vx2 vy2 lam]; 

for i=1:J-1
    
    VAL = [U(9,i) U(1,i) U(5,i) U(2,i) U(6,i)]; %��������� ����������, ������ ���� Jac4
    Fu = funct(VAL);
    F = F4( U(:,i), L);
    w =  ( M - tau*a*Fu ) \ F';

    U(:,i+1) = U(:,i) + tau*real(w);
end
    
X1 = U(1,:);
Y1 = U(2,:);
X2 = U(5,:);
Y2 = U(6,:);

figure(1);
plot(X1,Y1,'o', X2, Y2, 'o');


toc;
