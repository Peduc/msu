clear
clc

%Входные данные
l=0;
r=pi();
in=0;
fin=3;
%Много значений
Eps_length=30;
eps_max=0.8;
eps_min=0.1;
% 
% delta_eps=(eps_max-eps_min)/(Eps_length-1);
% for count=1:Eps_length
%     eps(count)=eps_min+delta_eps*(count-1);
% end;
eps(1)=0.7;

%Сетка
N_0=50;
M=30;
h=(r-l)/(N_0-1);
tau=(fin-in)/(M-1);

%Метод
% CROS1
% method = 1;
% CROS2
method = 2;

%Координатная сетка
for count=1:N_0
    xn(count)=l+h*(count-1);
end;

%Временная сетка
for count=1:M
    t(count)=in+tau*(count-1);
end;

for k = 1:length(eps) 
    u_init=0;
    v_init=@(x) (-sin(x)*(x*(pi-x))^2*(eps(k)+1)+...
        4*cos(x)*(x*(pi-x))*(pi-2*x )...
        +2*sin(x)*((pi-2*x)^2 - 2*(x*(pi-x))));
    g_init=-1;
    
    N=N_0+1;
    %Одна замена
    U1 = zeros(2*(N-1),M);    
    %Две замены
    U2 = zeros(3*(N-1),M);
    
    %Начальные условия
    for n = 1:N-1
        U2(n,1) = u_init;
        U1(n,1) = u_init;
    end;
    for n = N:2*(N-1)
        U2(n,1) = v_init(xn(n-(N-1)));
        U1(n,1) = v_init(xn(n-(N-1)));
    end;
    for n = 2*(N-1)+1:3*(N-1)
        U2(n,1) = g_init;
    end;  
    
    Fu_1 = Yak_1(h, N);
    Fu_2 = Yak_2(U2, h, N, eps(k) );       
    Mat_2=Matr_2(N);
    %Решение
    if method==1
        %Одностадийная схема CROS1
        a(1)=(1+1i)/2;
        w=[];
        for j=1:M-1
            %Одна замена
            Mat_1=Matr_1(U1(1:2*N-2,j),N,h,eps(k));
            F_1=Func_1(U1(1:2*N-2,j),N,h);
            w_1=(Mat_1-a(1)*tau*Fu_1 )^(-1)*F_1';
            U1(1:2*N-2,j+1)=U1(1:2*N-2,j)+tau*real(w_1);            
            %Две замены
            F_2=Func_2(U2(:,j),N,h,eps(k));
            w_2=(Mat_2-a(1)*tau*Fu_2 )^(-1)*F_2';
            U2(:,j+1)=U2(:,j)+tau*real(w_2);
        end;
    else
        %Двухстадийная схема CROS2
        a=[];
        b=[];
        c=[];
        w_1=[];
        w_2=[];
        s=2;
        
        b(1)=0.1941430241155180-1i*0.2246898944678803;
        b(2)=0.8058569758844820-1i*0.8870089521907592;
        b(3)=0;
        c(1)=0.2554708972958462-1i*0.2026195833570109;
        
        a(1)=0.1+1i*sqrt(11)/30;
        a(2)=0.2+1i*sqrt(1)/10;
        a(3)=0.5617645150714754-1i*1.148223341045841;
        
        for j=1:M-1
            %Одна замена
            Mat_1=Matr_1(U1(1:2*N-2,j),N,h,eps(k));
            F1_1=Func_1(U1(1:2*N-2,j),N,h);     
            w1_1=((Mat_1-a(1)*tau*Fu_1)^(-1))*F1_1';
            F2_1=Func_1(U1(1:2*N-2,j)+tau*real(c(1)*w1_1),N,h);
            w2_1=((Mat_1-a(2)*tau*Fu_1)^(-1))*F2_1';
            
            U1(1:2*N-2,j+1) = U1(1:2*N-2,j) + tau*real(b(1)*w1_1+b(2)*w2_1);            
            %Две замены
            F1_2=Func_2(U2(:,j),N,h,eps(k));
            w1_2=((Mat_2-a(1)*tau*Fu_2)^(-1))*F1_2';
            F2_2=Func_2(U2(:,j)+tau*real(c(1)*w1_2),N,h,eps(k));
            w2_2=((Mat_2-a(2)*tau*Fu_2)^(-1))*F2_2';

            U2(:,j+1) = U2(:,j) + tau*real(b(1)*w1_2+b(2)*w2_2);
        end;
    end;
    
    for i = 1:N-1
        u1(i,:) = U1(i,:);
        u2(i,:) = U2(i,:);
        err(i,:)= u2(i,:)-u1(i,:);
    end; 
%   3D
%     title( sprintf('eps = %.4f', eps(k)) );
%     subplot(1, 3, 1), surf(t, xn, u1);
%     xlabel('t')
%     ylabel('x')
%     title('One substitution')
%     axis([in fin l r -2 8]);    
%     
%     subplot(1, 3, 2), surf(t, xn, u2);
%     xlabel('t')
%     ylabel('x')
%     title('Two substitutions')
%     axis([in fin l r -2 8]); 
%     
%     subplot(1, 3, 3), surf(t, xn, err);
%     xlabel('t')
%     ylabel('x')
%     title('Difference')
%     text ((r-l/2),(fin-in)/2,-1, sprintf('eps = %.4f', eps(k)) );
%     axis([in fin l r -1.5 0.1]);    


%   2D  
%     for j=1:M
%         plot(xn,u1(:,j));
%         hold off;
%         title( sprintf('eps = %.4f', eps(k)) );
%         axis([ l r -20 2]);
%         pause (5/M);
%         drawnow;   
%     end;
%     hold off;
%     pause(3/length(eps));
%     drawnow;
end;
% hold off

fig = figure();
% создание первого пустого кадра
set(fig,'Position',[350,200,800,700]);
axes('xlim',[l r],'ylim',[0 8],'NextPlot','add','Parent',fig);
frame = getframe(fig);
[im,map] = rgb2ind(frame.cdata,4);
imwrite(im,map,'animation2.gif','DelayTime',0,'Loopcount',0);

% цикл анимации
for j=1:M  
    subplot(3,1,1)
    plot(xn,u1(:,j),'r.');
    xlabel('x')
    ylabel('u')
    title('One substitution')
    text ((r-l)/2,1, sprintf('time = %.4f', t(j)) );
    axis([l r -2 8]);
%     hold off;
    subplot(3,1,2)
    plot(xn,u2(:,j),'g.');
    xlabel('x')
    ylabel('u')
    title('Two substitutions')
    axis([l r -2 8]);
%     hold off;
    subplot(3,1,3)
    plot(xn,err(:,j),'.');
    xlabel('x')
    ylabel('difference')
    title('Difference')
    axis([l r -1 1]);
    
    drawnow;
    frame = getframe(fig);
    [im,map] = rgb2ind(frame.cdata,4);
    imwrite(im,map,'animation2.gif','DelayTime',0.1,'WriteMode','Append');
end;