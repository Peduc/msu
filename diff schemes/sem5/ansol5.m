function ansol5 = Analytic( T,X )
% ansol=pi()-X+cos(X/2)/2*(exp(T) - exp(-T));
% cos(X/2)*exp(-2*T)*(8/pi()+(1/3)*(exp(3*T)-1));
ansol5=(T<=-X)*( T*exp(-(X+T)) ) + (T>-X)*( -X*exp(-(X+T)) + X + T );
% ansol5=(2*T<=X)*( X*T - T^2/2 + cos(pi*(2*T-X)) ) + (2*T>X)*( X*T - T^2/2 + (2*T-X)^2/8 + exp(-(T-X/2)) );
end

