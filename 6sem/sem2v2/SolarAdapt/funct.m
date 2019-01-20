function  f_vector  = funct( Mass, U )
    g = 6.67300*10^(-11);
    for count=1:4
        f_vector(4*(count-1)+1)= U(4*(count-1)+3);
        f_vector(4*(count-1)+2)= U(4*(count-1)+4);
        f_vector(4*(count-1)+3)=0;
        f_vector(4*(count-1)+4)=0;    
        for i=1:4
            if i~=count
                f_vector(4*(count-1)+3)= f_vector(4*(count-1)+3)+g*Mass(i)*...
                             (U(4*(i-1)+1)-U(4*(count-1)+1))/...
                             ((U(4*(i-1)+1)-U(4*(count-1)+1))^2+...
                             (U(4*(i-1)+2)-U(4*(count-1)+2))^2)^(3/2);
                f_vector(4*(count-1)+4)= f_vector(4*(count-1)+4) + g*Mass(i)*...
                             (U(4*(i-1)+2)-U(4*(count-1)+2))/...
                             ((U(4*(i-1)+1)-U(4*(count-1)+1))^2+...
                             (U(4*(i-1)+2)-U(4*(count-1)+2))^2)^(3/2);
            end;
        end;
    end;
end