clear
clc
% ������� ���������
syms VX1 VY1 VX2 VY2 
syms X1 X2 Y1 Y2 L k C_1 C_2 C_3 e Lam M1 M2

F=[VX1; VY1; (1/M1)*((k*C_1*C_3*e^2)*X1/(X1^2+Y1^2)^(3/2)+...
                 2*Lam*(X1-X2));...
                 (1/M1)*((k*C_1*C_3*e^2)*Y1/(X1^2+Y1^2)^(3/2)+...
                 2*Lam*(Y1-Y2));...
                 VX2; VY2;...
                 (1/M2)*((k*C_2*C_3*e^2)*X2/(X2^2+Y2^2)^(3/2)-...
                 2*Lam*(X1-X2));...
                 (1/M2)*((k*C_2*C_3*e^2)*Y2/(X2^2+Y2^2)^(3/2)-...
                 2*Lam*(Y1-Y2));...
                 (X1-X2)^2+(Y1-Y2)^2-L^2];
u=[X1 Y1 VX1 VY1 X2 Y2 VX2 VY2 Lam];             

F_u=jacobian(F, u);

disp(F_u);
