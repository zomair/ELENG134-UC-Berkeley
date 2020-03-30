function Prod = mymult(x,y)
    if isnan(x.*y)
         Prod=0;
    else 
        Prod= x.*y;
    end
end

