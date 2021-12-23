function K=solve_intrinsic_para(C0,C1)
[~,~,n] = size(C0);
W = [];
for i = 1:n
    [V,D]=eig(inv(C0(:,:,i))*C1(:,:,i));
    if isreal(D)
        [i1]=get_real_index(D);
    else
        [i1]=get_complex_index(D);   
    end
    x1=V(:,i1);
    x1=x1/x1(3) ;
    l1=C1(:,:,i)*x1;
    l1=l1/l1(3) ;
     W=[W;
        x1(1) x1(2) 1-l1(1)*x1(1) 0 -l1(1)*x1(2) -l1(1);
        0 x1(1) -l1(2)*x1(1) x1(2) 1-l1(2)*x1(2) -l1(2);];%according to the constraints of ploe and polar with respect to IAC
end

%solve  the linear equations
[S,V,DD]=svd(W);
d=DD(:,6);
w=[real(d(1)) real(d(2)) real(d(3));
   real(d(2)) real(d(4)) real(d(5));
   real(d(3)) real(d(5)) real(d(6))];
if det(w)<0
    w=-w;
end
%solve the intrinsic paramter matrix
K=chol(w);
K=inv(K);
K=K/K(3,3);