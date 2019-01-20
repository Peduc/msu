function anso = anso( T,X )
    anso=pi-X+0.5*cos(X/2)*(exp(T) - exp(-T));
end