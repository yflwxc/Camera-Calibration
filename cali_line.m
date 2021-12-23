clc
clear all
K=[800 0 320
    0  850 240
    0    0  1];%The simulation intrinsic matrix
   
ll=0.8;  %The mirror parameter
T = [0;0;ll];%The translation parameter

WITH_Noise = true;
Experiment_num = 20;
error_f = [];
error_uv0 = [];
Image_num =9;
error_mirror = []; 
Errors = [];
for s = 1:Experiment_num

    [ mirror_image,line_image,line_image2] = generate_line_image(Image_num,K,T);% generate the simulation images of lines
    [~,n,~]=size(line_image);
    if WITH_Noise == true  %add noise
        Mean = 0 ;
        T_Variance = 0.2;
        Noise = Mean + sqrt(T_Variance)*randn(6*Image_num,n);
        for i  = 1:Image_num
            mirror_image(1:2,:,i) = mirror_image(1:2,:,i) + Noise(6*(i-1)+(1:2),n);
            line_image(1:2,:,i) = line_image(1:2,:,i) + Noise(6*(i-1)+(3:4),n);
            line_image2(1:2,:,i) = line_image2(1:2,:,i)+ Noise(6*(i-1)+(5:6),n);
        end
    end

for i  = 1:Image_num
    mirror_point = mirror_image(:,:,i);
    [mirror_point,TT]= normalise2dpts(mirror_point);
    C0 = TT'*xx(mirror_point)*TT;
    mirror_conic(:,:,i) = C0;
    line_point = line_image(:,:,i);
    [line_point,TT]= normalise2dpts(line_point);
    C1 = TT'*xx(line_point)*TT;
    line_conic(:,:,i) =C1;
    line_point2 = line_image2(:,:,i);
    [line_point2,TT]= normalise2dpts(line_point2);
    C2 = TT'*xx(line_point2)*TT;
    line_conic2(:,:,i) = C2;
end

est_K = solve_intrinsic_para(mirror_conic,line_conic)% according to Pro.2
if ll~=1
    est_Kc=solve_modified_intrinsic_para(line_conic2);%according to Eq.(13)
    H=inv(est_Kc)*est_K;
    m=eig(H);
    s =(m(1)+m(2))/2;
    est_mirror= sqrt(abs(1-s^2))
end
est_f = [est_K(1,1) est_K(2,2)];
est_uv0 = [est_K(1,3) est_K(2,3)];
est_s = est_K(1,2);
f = [K(1,1) K(2,2)];
uv0 = [K(1,3) K(2,3)];
s = K(1,2);


error_f = [error_f norm(est_f-f)];
error_uv0 = [error_uv0 norm(est_uv0-uv0)];
if ll~=1
    error_mirror = [error_mirror 1000*norm(est_mirror-ll)];
    error_total = norm(est_f-f) + norm(est_uv0-uv0) + 1000*norm(est_mirror-ll);
else
    error_total = norm(est_f-f) + norm(est_uv0-uv0);
end
Errors = [Errors error_total];
end
% mean_f=mean(error_f);
% std_f=std(error_f);
% 
% mean_uv0=mean(error_uv0);
% std_uv0=std(error_uv0);
% 
% mean_mirror=mean(error_mirror);
% std_mirror=std(error_mirror);
% 
% mean_Errors=mean(Errors);
% std_Errors=std(Errors);
