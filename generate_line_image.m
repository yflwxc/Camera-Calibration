function [ mirror_image,line_image,line_image2] = generate_line_image(Image_num,K,T)
Rot = [];
Normal = [];
for i =1:Image_num
    Rot(:,:,i) = orth(rand(3,3));
    n = 10*rand(3,1);
    Normal(:,i) = n/norm(n);
end


x=0:pi/100:2*pi;
[m,n]=size(x); 
x0=cos(x);
y0=sin(x);
z0=zeros(1,n);
X0=[x0;y0;z0];

for i = 1:Image_num
    n1 = Normal(:,i);
    a1=cross(n1,[1 0 0]);
    if ~any(a1)
        a1=cross(n1,[0 1 0]);
    end
    b1=cross(n1,a1);
    a1=a1/norm(a1);
    b1=b1/norm(b1);

    x1=a1(1)*cos(x)+b1(1)*sin(x);
    y1=a1(2)*cos(x)+b1(2)*sin(x);
    z1=a1(3)*cos(x)+b1(3)*sin(x);
    Space_point(:,:,i) =[x1;y1;z1];
end

for i=1:Image_num
    mirror_image(:,:,i) = K*Rot(:,:,i)*(X0+T);
    line_image(:,:,i) = K*Rot(:,:,i)*(Space_point(:,:,i)+T);
    line_image2(:,:,i) = K*(Space_point(:,:,i)+T);
    
    mirror_image(:,:,i) = mirror_image(:,:,i)./mirror_image(3,:,i);
    line_image(:,:,i) = line_image(:,:,i)./line_image(3,:,i);
    line_image2(:,:,i) = line_image2(:,:,i)./line_image2(3,:,i);
end
