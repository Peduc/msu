%{
Решение с резким градиентом
eps*du/dt=-2*u*( u - t);
u(-1)=3; -1<=1<=2
10^-4<=eps<=0.5

%}
clear; clc;
close all;

mode = 3; % 1 - CROS1 || 2 - DIRK || 3 - CROS2 || 4 - Длина Дуги 
M=10^3;
a_=-1;
b=2;
tau=(b-a_)/(M - 1);
a=[(1+1i)/2; 1;];
coeff=[0.789343464+0.9821367i; 0.210656-0.570521i; 0.644441-1.143956i; 0.5250464+1.453646i; 0.4573733+0.23510048i; 0.0426266+0.394632i];
%coeff = [b1; b2; c21; a21; alpha1; alpha2];
eps=0.25;
Un=3;
U=zeros(M,1);
T=zeros(M,1);

T(1)=-1;
for m=2:M
   T(m)=T(1)+m*tau;
end

if (mode == 1)
    
    for m=1:M
        U(m)=Un;
        w=( -2/eps*U(m)*( U(m) - ( T(m) + tau/2 ) ) ) / ( 1 + tau*a(mode)*( 2/eps*( 2*U(m) - T(m) ) ) );
        Un=Un+tau*real(w);
    end
 
elseif ( mode == 2)
    
    for m=1:M
        U(m)=Un;
        w=( -2/eps*U(m)*( U(m) - ( T(m) + tau/2 ) ) ) / ( 1 + tau*a(mode)*( 2/eps*( 2*U(m) - T(m) ) ) );
        Un=Un+tau*real(w);
    end
 
elseif ( mode == 3)
   %{ 
  u=zeros(M,2);
    w1=zeros(2,1);
    w2=zeros(2,1);
    Y=eye(2);
    u(1,:)=[3 -1];
    mod=[1; 2];
  
    for m=2:M
   
        F=[-2/eps*u(m-1,1)*( u(m-1,1) - u(m-1,2) ); 1];
        Fu=[-2/eps*( 2*u(m-1,1) - u(m-1,2) ) 2/eps*u(m-1,1);0 0];
        
        w1=( Y - coeff(5)*tau*Fu )\(F);
        
        Fu=F5(u(m-1,:),mod(1),w1,tau,eps);
        F=F5(u(m-1,:),mod(2),w1,tau,eps);
        
        w2=( Y - coeff(6)*tau*Fu )\(F);
        Re=real( coeff(1)*w1'+coeff(2)*w2');
        u(m,:)=u(m-1,:)+tau*Re;
    
    end
    U=u(:,1);
    T=u(:,2);
     %}   
    w1=zeros(2,1);
    w2=zeros(2,1);
    Y=eye(2);
    Um(1,:)=[3 -1];
    
    syms u1 u2;
    u=[u1 u2];
    F=[-2/eps*u1*(u1-u2); 1];
    Fu=jacobian(F,u);
    
    f1=sym(Fu);
    f2=sym(F);
    
    v1=symvar(Fu);
    v2=symvar(F);
    
    g1=@(X1) double(subs(f1,v1,X1));
    g2=@(X2) double(subs(f2,v2,X2));
   
    for m=2:M
        G1=g1([Um(m-1,1) Um(m-1,2)]);
        G2=g2([Um(m-1,1) Um(m-1,2)]);
        w1=( Y - coeff(5)*tau*G1 )\G2;
        
        e=Um(m-1,1)+tau*real(coeff(4)*w1(1)');
        b=Um(m-1,2)+tau*real(coeff(4)*w1(2)');
        c=Um(m-1,1)+tau*real(coeff(3)*w1(2)');
        d=Um(m-1,2)+tau*real(coeff(3)*w1(2)');
        
        G1s=g1([e b]);
        G2s=g2([c d]);
        w2=( Y - coeff(6)*tau*G1s ) \G2s ;
        
        Um(m,:)=Um(m-1,:)+tau*real( coeff(1)*w1'+coeff(2)*w2') ;
        
    end
    U=Um(:,1);
    T=Um(:,2);
    
elseif (mode == 4)
    K=1000;
    l=8/K;
    
    syms u1 u2;
    u=[u1 u2];
    F=[-2/eps*u1*(u1-u2)/sqrt( 1+(2*u1/eps)^2*(u1 - u2)^2 ); 1/sqrt(1+(u1*2/eps)^2*(u1 - u2)^2 )];
    Fu=jacobian(F,u);
    
    Um=zeros(K,2);
    w1=zeros(2,1);
    Y=eye(2);
    
    Um(1,:)=[3 -1];
    
    f1=sym(Fu);
    f2=sym(F);
    v1=symvar(Fu);
    v2=symvar(F);
    
    g1=@(X1) double(subs(f1,v1,X1));
    g2=@(X2) double(subs(f2,v2,X2));
    
    for m=2:K
        
        G1=g1([Um(m-1,1) Um(m-1,2)]);
        G2=g2([Um(m-1,1) Um(m-1,2)]);
        w1=( Y-a(1)*l*G1 )\G2;
        Um(m,:)=Um(m-1,:)+l*real(w1');
    
    end
    
    U=Um(:,1);
    T=Um(:,2);
end
    

figure(mode);
plot(T,U,'o')
hold on;
  

