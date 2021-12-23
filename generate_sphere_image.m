function [ mirror_image,sphere_image,sphere_image2] = generate_sphere_image(Image_num,K,T)

Rot = [];
for i =1:Image_num
    Rot(:,:,i) = orth(rand(3,3));
end
center=[31.7 -23.2 -24.6;
    12.7 -2.2 -2.6;
    4.2 -2.1 -2.8;
    3.7 -2.5 -2.5]';% the center of sphere

x=0:pi/100:2*pi;
[m,n]=size(x); 
x0=cos(x);
y0=sin(x);
z0=zeros(1,n);
X0=[x0;y0;z0];% the mirror contour

for i = 1:4
    l1=norm(center(:,i));
    n1=center(:,i)/l1;
    d1=sqrt(l1^2/(1+l1^2));
    r1=sqrt(1/(1+l1^2));
    o11=d1*center(1,i)./l1;
    o12=d1*center(2,i)./l1;
    o13=d1*center(3,i)./l1;
    a1=cross(n1,[1 0 0]);
    if ~any(a1)
        a1=cross(n1,[0 1 0]);
    end
    b1=cross(n1,a1);
    a1=a1/norm(a1);%the vector of  the circle a1
    b1=b1/norm(b1);%the vector of  the circle b1
    % a1£¬b1 and n1 are orthogonal each other
    %obtain the equation of the circle
    x1=o11+r1*a1(1)*cos(x)+r1*b1(1)*sin(x);
    y1=o12+r1*a1(2)*cos(x)+r1*b1(2)*sin(x);
    z1=o13+r1*a1(3)*cos(x)+r1*b1(3)*sin(x);
    Space_point(:,:,i) =[x1;y1;z1];
end

for i=1:Image_num
    mirror_image(:,:,i) = K*Rot(:,:,i)*(X0+T);
    sphere_image(:,:,i) = K*Rot(:,:,i)*(Space_point(:,:,1)+T);
    
    mirror_image(:,:,i) = mirror_image(:,:,i)./mirror_image(3,:,i);
    sphere_image(:,:,i) =  sphere_image(:,:,i)./ sphere_image(3,:,i);
    
end
for i=1:3
sphere_image2(:,:,i) = K*(Space_point(:,:,i+1)+T);
sphere_image2(:,:,i) =  sphere_image2(:,:,i)./ sphere_image2(3,:,i);
end