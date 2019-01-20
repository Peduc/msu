function funct = funct(u)

g = 6.67300*10^(-11);
Mass = 1.9891*10^(30);
funct(1) = u(3);
funct(2) = u(4);
funct(3) = (-1) * g * Mass * u(1) / (u(1)^2 + u(2)^2)^(3/2);
funct(4) = (-1) * g * Mass * u(2) / (u(1)^2 + u(2)^2)^(3/2);

end