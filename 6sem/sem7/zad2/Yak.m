function Yak = Yak(Eps, U )
    Yak(1,1)=(2/Eps)*(U(2)-2*U(1));
    Yak(2,1)=0;
    Yak(1,2)=(2/Eps)*U(1);
    Yak(2,1)=0;
end

