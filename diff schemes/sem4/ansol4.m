function ansol4 = Analyt( T,X )
a=1/2;
ansol4=cos(T)+cos(3*a*T)*sin(3*X);
% cos(X/2)*exp(-2*T)*(8/pi()+(1/3)*(exp(3*T)-1));
end

