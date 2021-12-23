clear all;clc;close all;
K=[800 0 320
    0  850 240
    0    0  1];

ll=0.8;      %The mirror parameter
T = [0;0;ll];
WITH_Noise = true;% Adding the noise to image points
Experiment_Num = 20;
Image_num =9;
error_f = [];
error_uv0 = [];
error_s = [];
error_mirror = []; 
Errors = [];
for s = 1:Experiment_Num

    [ mirror_image,sphere_image,sphere_image1] = generate_sphere_image(Image_num,K,T);
    [~,n,~]=size(sphere_image);
%% add noise
    if WITH_Noise == true
        Mean = 0 ;
        Noise_Variance = 0.2;
        Noise = Mean + sqrt(Noise_Variance)*randn(4*Image_num,n);
        for i  = 1:Image_num
            mirror_image(1:2,:,i) = mirror_image(1:2,:,i) + Noise(4*(i-1)+(1:2),n);
            sphere_image(1:2,:,i) = sphere_image(1:2,:,i) + Noise(4*(i-1)+(3:4),n);     
        end
        Noise1 = Mean + sqrt(Noise_Variance)*randn(2*3,n);
        for i=1:3
        sphere_image1(1:2,:,i) = sphere_image1(1:2,:,i) + Noise1(2*(i-1)+(1:2),n);
        end
    end
    for i  = 1:Image_num
        mirror_point = mirror_image(:,:,i);
        [mirror_point,TT]= normalise2dpts(mirror_point);
        C0 = TT'*xx(mirror_point)*TT;
        mirror_conic(:,:,i) = C0;
        sphere_point = sphere_image(:,:,i);
        [sphere_point,TT]= normalise2dpts(sphere_point);
        C1 = TT'*xx(sphere_point)*TT;
        sphere_conic(:,:,i) =C1;
    end
    for i=1:3
        sphere_point1 = sphere_image1(:,:,i);
        [sphere_point1,TT]= normalise2dpts(sphere_point1);
        CC = TT'*xx(sphere_point1)*TT;
        sphere_conic2(:,:,i) = CC; 
    end
     est_K = solve_intrinsic_para(mirror_conic,sphere_conic)% according to Pro.1
    if ll~=1
        est_Kc=solve_modified_intrinsic_para(sphere_conic2);%according to Eq.(13)
        H=inv(est_Kc)*est_K;
        m=eig(H);
        s =(m(1)+m(2))/2;
        est_mirror= sqrt(abs(1-s^2))
    end
    est_f = [est_K(1,1) est_K(2,2)];
    est_uv0 = [est_K(1,3) est_K(2,3)];
    est_s = est_K(1,2);
    % ground truth
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



