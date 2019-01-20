clear
clc

Start = cputime; 

%���������
%������� y=Sum(sin(x+(i-1)*Pi()/dim)), 1->Dim
%����������� ������������
Dim=5;
%���������� �����
N=1000;
%������ ����� ������
left=[];
%������ ������ ������
right=[];
%syms X;
%������-������ �����
r=[];
length=[];
length1=[];
count=0;

y=[];
u=[];
Sm=1;

%������� Dim-������� ���������������
for i=1:Dim
    left(i)=-pi()/2;
    right(i)=pi()/2;
    Sm=Sm*(right(i)-left(i));
end;

%������� ������������� ����������� ��� �������� �������
left(Dim+1)=-Dim;
right(Dim+1)=Dim;
Sm=Sm*(right(Dim+1)-left(Dim+1));

for j=1:N
    y(j)=0;
    length(j)=0;
    for i=1:Dim+1
        r(i)=left(i)+(right(i)-left(i))*rand(1);
        end;
% ��� ������� ����� ������� � ������� ������ ������������ ����������, �� �
% ����� ���� ������ ����������� Y � �����, ���� � ��� ������, �������,
% �����.
    for i=1:Dim
        y(j)=y(j)+(cos(r(i)+(i-1)*pi()/Dim));
    end;
    for i=1:Dim+1    
        if (i<Dim+1)
             length(j)=length(j)+r(i)^2;
        end;
        if ((i==Dim+1) &&(sqrt(length(j)+r(Dim+1)^2)<=sqrt(length(j)+y(j)^2)))
            count=count+1;
        end;
    end;
end;

u=Sm*(count/N);

Elapsed = cputime - Start;
disp(Elapsed);
disp(count);
disp(u);