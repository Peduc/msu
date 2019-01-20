function F_matrix=F5(U,mod,w1,tau,eps)

coeff=[0.789343464+0.9821367i; 0.210656-0.570521i; 0.644441-1.143956i; 0.5250464+1.453646i; 0.4573733+0.23510048i; 0.0426266+0.394632i];
%coef=[b1; b2; c21; a21; a11; a22];

if mod==1   
U(1)=U(1)+tau*real(coeff(4)*w1(1));
U(2)=U(2)+tau*real(coeff(4)*w1(2));

F_matrix=[-2/eps*( 2*U(1) - U(2) ) 2/eps*U(1);0 0];

elseif mod==2
    
U(1)=U(1)+tau*real(coeff(3)*w1(1));
U(2)=U(2)+tau*real(coeff(3)*w1(2));

F_mat(1,1)=-2/eps*U(1)*( U(1) - U(2) );
F_mat(2,1)=1;

F_matrix=F_mat;

end

end