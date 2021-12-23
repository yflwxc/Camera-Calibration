function Kc=solve_modified_intrinsic_para(C2)

[~,~,n_conics] = size(C2);
aux=1:1:n_conics;
Comb=nchoosek(aux,2); 

[n_comb,aux]=size(Comb);
W = [];
for i = 1: n_comb
    [V1,D1]=eig(inv(C2(:,:,Comb(i,1)))*C2(:,:,Comb(i,2)));
    if isreal(D1)
        [i1]=get_real_index(D1);
    else
        [i1]=get_complex_index(D1);   
    end
    x1=V1(:,i1);
    x1=x1/x1(3);
    l1=C2(:,:,Comb(i,2))*x1;
    l1=l1/l1(3);
    W=[W;
       x1(1) x1(2) 1-l1(1)*x1(1) 0 -l1(1)*x1(2) -l1(1);
       0 x1(1) -l1(2)*x1(1) x1(2) 1-l1(2)*x1(2) -l1(2);];%according to the constraints of ploe and polar with respect to MIAC
end
%solve  the linear equations
[S V DD]=svd(W);
d=DD(:,6);
w=[real(d(1)) real(d(2)) real(d(3));
   real(d(2)) real(d(4)) real(d(5));
   real(d(3)) real(d(5)) real(d(6))];
if det(w)<0
    w=-w;
end
%solve the modified intrinsic paramter matrix
K=chol(w);
K=inv(K);
Kc=K/K(3,3);

