clear
clc

% ������� ���������
% a=1/2;
% sigma=0.05;
l=0;
r=-1;
in=0;
fin=1;
c=-1;

%�������������
err=[];
x=[];
t=[];

% �����
%|c|tau>=h;
N=20;
M=30;
h=(r-l)/(N-1);
tau=(fin-in)/(M-1); 

if abs(c)*tau >= h
%   �����
    for i=1:N
        x(i)=l+(i-1)*h;
    end;
    for j=1:M
        t(j)=in+(j-1)*tau;
    end;
    
%   ��������� �������:
    for i=1:N
        y(1,i)=0;
    end;
    
%   ��������� �������:
    for j=1:M
        y(j,1)=t(j);
    end; 
      
    for j=1:M-1
        for i=2:N
            y(j+1,i)=(1-c*tau/h)*y(j,i)+(c*tau/h)*y(j,i-1)+tau*exp(-(x(i)+t(j)));
        end;
    end;
    
%   ������������� ������� � ���������� �����������:
    sol=zeros(M,N);
    for j=1:M
        for i=1:N
            sol(j,i)=ansol5(t(j),x(i));
%             err(j,i)=anso(t(j),x(i)); 
        end;
    end;
    %   ��������� �������:
    subplot(1, 3, 1),surf(x,t,y);
    %   ������������� �������:
    subplot(1, 3, 2),surf(x,t,sol);
    %   ����������� �������:
    subplot(1, 3, 3),surf(x,t,y-sol);
else
    disp(':(');
    disp(abs(c)*tau);
    disp(h);
end;