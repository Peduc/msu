% 1) ����������� ���������, ������� � ������� ����������������� ����������
% ������� ����� ��������� � ����� ����������� �������� �������,
% �������� ������� ����� ��������. 
clear
clc

left=-1;
right=1;
N=6;

syms X1 Y W;

%������ ����� - �� ����� ���������, ������ - ��������/��������� ��������

%������������ �����
h=(right-left)/(N-1);
u=zeros(N,N+1);

for i=1:N
	x(i)=left+(i-1)*h;
    u(i,1)=inter(x(i));
    ye(i)=inter(x(i));
end;

%����� �������
for j=2:N
	%����� ������
	for i=j:N
        u(i,j)=(u(i-1,j-1)-u(i,j-1))/(x(j-1)-x(j));
	end;
end;

Y = inter(x(1));
W = 1;

for i=1:N-1
	W = W*(X1-x(i));
	Y=Y+(u(i+1,i+1))*W/factorial(i);
end;
    
plot(x,ye,'o');
hold on;
ezplot(Y,[left,right]);

% disp(u);
% plot(x,u);