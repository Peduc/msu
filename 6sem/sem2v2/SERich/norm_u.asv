% function  f_vector  = funct( Mass, X, Y, VX, VY )
function  normu  = norm_u( U,Eps )
    pos=3;
    
    [N,M]=size(U);
    normu = 0;
    for i = 1 : N
        count=1;
        for j = 1 : M
            if (j==pos+4*(count-1))
                normu = normu + (Eps*U(i, j))^2;
            elseif(j-1==pos+4*(count-1))
                normu = normu + (Eps*U(i, j))^2;
                count=count+1;
            else
                normu = normu + U(i, j)^2;
            end;
        end
    end
    normu = sqrt(normu);
end
