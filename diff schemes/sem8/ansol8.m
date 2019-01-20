function ansol_omm = Analytic( T,X,Y )
lambda=(1)^2+3^2;
a=1;
ansol_omm=T^2*(X+Y)+5*cos(pi*X/2)*cos(3*pi*Y/2)*cos(a*T*pi*sqrt(lambda)/2);
end

