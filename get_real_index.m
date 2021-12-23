function [i1]=get_real_index(D1)

    s1 = [D1(1,1) D1(2,2) D1(3,3)];
    if prod(s1) > 0
        [~,i1]=max(s1);
    else
        [~,i1]=min(s1);
    end
end