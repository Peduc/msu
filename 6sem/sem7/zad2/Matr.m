function Matr = Matr(Eps, U )
%MATR Summary of this function goes here
%   Detailed explanation goes here
    Matr(1,1)=(2/Eps)*U(1)*(U(2)-U(1));
    Matr(2,1)=1;
end

