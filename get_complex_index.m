function [i1]=get_complex_index(D1)

    s1 = max(abs(real(D1)));
    var1 = s1(1)-s1(2);
    var2 = s1(1)-s1(3);
    if (var1-var2)<1e-6
        i1 = 1;
    end
    if (abs(var1)<1e-6 || abs(var2)<1e-6)
        if (abs(var1)<1e-6)
            i1 = 3;
        else
            i1 = 2;
        end
    end
    
end