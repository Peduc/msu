% ����������� ���������, ������� � ������ ������������������
% ������������� ��������� ������ ����� � ��������� �������������
% ����� ��������� � ����� ����������� �������� �������,
% ������������� ������� ����������� ����� �������� �������.
clear
clc

syms X1 Y W S P;

left=-1;
right=1;
N=12;
M=N-1;
delta=[];

%������� � �������� ����������
trans=(right+left)/2;
scale=(right-left);

%������������ ������. 
h=(right-left)/(N-1);

for i=1:N
	x(i)=left+(i-1)*h;
	ye(i)=extra(x(i));
    err(i)=0.5;
end;

for count=1:M+1
    %���������� ������� ������������ �� 
    A=[];
    for i=1:count
        for j=1:count
%            if ((mod(j+i,2)) == 0)
%                 A(j,i)=2/(j+i+1);
%            else 
%             A(j,i)=0;
%            end;
            if (i==j)
                A(j,i)=2/(2*(j-1)+1);
            end;
        end;
    end;
    
    B=[];
    %���������� ������� ��������  
    for i=1:count
    	%������������ ���������
        P(i)=(1/(factorial(i-1)*(2^(i-1))))*(diff((X1^2-1)^(i-1),'X1',(i-1)));
        B(i)=0;
        for j=2:N
%             B(i)=B(i)+(h/2)*((ye(j)*((x(j)-trans)/trans)^(i-1))+(ye(j-1)*((x(j)-trans)/trans)^(i-1)));        
            B(i)=B(i)+(h/2)*(ye(j)*subs(P(i),'X1',x(j))+ye(j-1)*subs(P(i),'X1',x(j-1)));
        end;
    end;

    C=[];
    % %�������� C ��� ������� ���������
    % C=(inv(A'*A))*A'*B';
    
    %�������� C ��� ��������� ��������
    for i=1:count
        C(i)=(B(i)/A(i,i));
    end;

    %��������� ������� ������ �������
    Y = 0;
    for i=1:count
%         Y=Y+((X1+trans)*(trans))^(i-1)*Xr(i);
        Y=Y+C(i)*P(i);
    end;
%     disp(vpa(Y));
    
    delta(count)=0;
    for i=1:N
        delta(count)=delta(count)+(1/(N-count))*((subs(Y,X1,x(i))-ye(i))/(err(i)))^2;
    end;
    if ((count)==1) || ((delta(count))<min)
    	min=delta(count);
    	S=Y;
%         disp(vpa(Y));
    end;
end;

% disp(vpa(S));
 ezplot(S,left,right);
hold on;
 errorbar(x,ye,err)