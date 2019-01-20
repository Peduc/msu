function Matr = Matr_2(N)
    Matr=zeros(3*(N-1));
    for j=N-1+1:3*(N-1)
        Matr(j,j)=1;
    end;
end