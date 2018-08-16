% RN@HMS Queen Elizabeth
% 30/07/18
% Descriptions.
%
% Notes.
% There are 8 quality test small spheres which correspond to 8 different
% combination of J1, 2, and 3 values. 
% After a calibration analysis, you should get a new set of DH params. This
% would change the forward kinematic result, hence change the wrist point
% represented in the Cartesian space (robot base frame). 
% Therefore you should re-run the auxiliary code in the da Vinci Kinematic
% package to  get the new wrist points (in robot base frame).
% You should also read the new affine_base_wrt_polaris.
% Then this programme is going to calculate the difference between the
% forward kinematic result and the reading from the Polaris.
%
% Also look at the calibration_quality_small_spheres_generation_main.m for
% more information.


%% THERE ARE 3 UPDATE POINTS THAT YOU NEED TO CHECK EVERYTIME YOU RUN THIS PROGRAMME.
% Search for 'checkpoint' to locate them. 

%%
clc
close all
clear all

%%

% @ UPDATE CHECKPOINT 1/3
% Update this transform from you latest calibration result.
affine_base_wrt_polaris = [... 
-0.030395 0.106307 -0.993869 -0.191327 ;
-0.999527 0.001349 0.030712 -0.060187 ;
0.004605 0.994332 0.106216 -0.789158 ;
0.000000 0.000000 0.000000 1.000000 ] ;
     
% @ UPDATE CHECKPOINT 2/3
% This is the directory of the quality test small spheres csv files. 
file_path = 'Data/20180813_PSM1_intrinsic_1_quality/';


% @ UPDATE CHECKPOINT 3/3
% If you have changed the DH yaml file in the kinematic package, you must 
% run the auxiliary code in the kinematic package again to generate the 
% new wrist points. 

% The Centres (targets) wrt base frame.
% ---
wrist_pt_1 = [0.0264036 0.0182171 -0.140253 1];
wrist_pt_2 = [-0.00860601   0.0181077   -0.140474 1];
wrist_pt_3 = [0.0266926 0.0532926 -0.142052 1];
wrist_pt_4 = [-0.00868646   0.0530059   -0.141224 1];
wrist_pt_5 = [0.0270456 0.0188565  -0.18042 1];
wrist_pt_6 = [-0.008924 0.0188322  -0.18023 1];
wrist_pt_7 = [0.0272655  0.054678 -0.181507 1];
wrist_pt_8 = [-0.0089246   0.054487  -0.181321 1];
% ---



% Reference -- Currently deployed joint space points. 
%   q_vec <<  0.177, -0.132, 0.160, 0, 0, 0, 0;
%   q_vec << -0.070, -0.133, 0.158, 0, 0, 0, 0;
%   q_vec <<  0.179, -0.355, 0.170, 0, 0, 0, 0;
%   q_vec << -0.068, -0.360, 0.167, 0, 0, 0, 0;
%   q_vec <<  0.144, -0.108, 0.200, 0, 0, 0, 0;
%   q_vec << -0.054, -0.109, 0.198, 0, 0, 0, 0;
%   q_vec <<  0.146, -0.293, 0.208, 0, 0, 0, 0;
%   q_vec << -0.052, -0.295, 0.206, 0, 0, 0, 0;


wrist_pt_vec = [wrist_pt_1(:,1:3);
    wrist_pt_2(:,1:3);
    wrist_pt_3(:,1:3);
    wrist_pt_4(:,1:3);
    wrist_pt_5(:,1:3);
    wrist_pt_6(:,1:3);
    wrist_pt_7(:,1:3);
    wrist_pt_8(:,1:3)];





wrist_pt_1_wrt_polaris = affine_base_wrt_polaris*wrist_pt_1(:);
wrist_pt_2_wrt_polaris = affine_base_wrt_polaris*wrist_pt_2(:);
wrist_pt_3_wrt_polaris = affine_base_wrt_polaris*wrist_pt_3(:);
wrist_pt_4_wrt_polaris = affine_base_wrt_polaris*wrist_pt_4(:);
wrist_pt_5_wrt_polaris = affine_base_wrt_polaris*wrist_pt_5(:);
wrist_pt_6_wrt_polaris = affine_base_wrt_polaris*wrist_pt_6(:);
wrist_pt_7_wrt_polaris = affine_base_wrt_polaris*wrist_pt_7(:);
wrist_pt_8_wrt_polaris = affine_base_wrt_polaris*wrist_pt_8(:);

wrist_pt_1_wrt_polaris = wrist_pt_1_wrt_polaris(1:3,1);
wrist_pt_2_wrt_polaris = wrist_pt_2_wrt_polaris(1:3,1);
wrist_pt_3_wrt_polaris = wrist_pt_3_wrt_polaris(1:3,1);
wrist_pt_4_wrt_polaris = wrist_pt_4_wrt_polaris(1:3,1);
wrist_pt_5_wrt_polaris = wrist_pt_5_wrt_polaris(1:3,1);
wrist_pt_6_wrt_polaris = wrist_pt_6_wrt_polaris(1:3,1);
wrist_pt_7_wrt_polaris = wrist_pt_7_wrt_polaris(1:3,1);
wrist_pt_8_wrt_polaris = wrist_pt_8_wrt_polaris(1:3,1);

% The small spheres collected by the Polaris

% If you are using a standard marker use the following --
% ----
    
    remove_static_flag = 1;
    data_mask_begin = 10;
    data_mask_end = 10;

[pt_cld_1, pt_mat_1] = loadCsvFileToPointCloudAndMat(strcat(file_path, '1_small_sphere.csv'), data_mask_begin, data_mask_end,remove_static_flag);
[small_sphere_param_1, small_residuals_1] = fitSphereLeastSquare(pt_mat_1);
 small_origin_1 = small_sphere_param_1(:,1:3);
[pt_cld_2, pt_mat_2] = loadCsvFileToPointCloudAndMat(strcat(file_path, '2_small_sphere.csv'), data_mask_begin, data_mask_end,remove_static_flag);
[small_sphere_param_2, small_residuals_2] = fitSphereLeastSquare(pt_mat_2);
 small_origin_2 = small_sphere_param_2(:,1:3);
 [pt_cld_3, pt_mat_3] = loadCsvFileToPointCloudAndMat(strcat(file_path, '3_small_sphere.csv'), data_mask_begin, data_mask_end,remove_static_flag);
[small_sphere_param_3, small_residuals_3] = fitSphereLeastSquare(pt_mat_3);
 small_origin_3 = small_sphere_param_3(:,1:3);
 [pt_cld_4, pt_mat_4] = loadCsvFileToPointCloudAndMat(strcat(file_path, '4_small_sphere.csv'), data_mask_begin, data_mask_end,remove_static_flag);
[small_sphere_param_4, small_residuals_4] = fitSphereLeastSquare(pt_mat_4);
 small_origin_4 = small_sphere_param_4(:,1:3);
 [pt_cld_5, pt_mat_5] = loadCsvFileToPointCloudAndMat(strcat(file_path, '5_small_sphere.csv'), data_mask_begin, data_mask_end,remove_static_flag);
[small_sphere_param_5, small_residuals_5] = fitSphereLeastSquare(pt_mat_5);
 small_origin_5 = small_sphere_param_5(:,1:3);
 [pt_cld_6, pt_mat_6] = loadCsvFileToPointCloudAndMat(strcat(file_path, '6_small_sphere.csv'), data_mask_begin, data_mask_end,remove_static_flag);
[small_sphere_param_6, small_residuals_6] = fitSphereLeastSquare(pt_mat_6);
 small_origin_6 = small_sphere_param_6(:,1:3);
 [pt_cld_7, pt_mat_7] = loadCsvFileToPointCloudAndMat(strcat(file_path, '7_small_sphere.csv'), data_mask_begin, data_mask_end,remove_static_flag);
[small_sphere_param_7, small_residuals_7] = fitSphereLeastSquare(pt_mat_7);
 small_origin_7 = small_sphere_param_7(:,1:3);
 [pt_cld_8, pt_mat_8] = loadCsvFileToPointCloudAndMat(strcat(file_path, '8_small_sphere.csv'), data_mask_begin, data_mask_end,remove_static_flag);
[small_sphere_param_8, small_residuals_8] = fitSphereLeastSquare(pt_mat_8);
 small_origin_8 = small_sphere_param_8(:,1:3);
%  
 % If you are using stray marker use the following
 % ----
%  [pt_cld_1, pt_mat_1] = loadStrayMarkerCsvFileToPointCloudAndMat(strcat(file_path, '1_small_sphere.csv'));
% [small_sphere_param_1, small_residuals_1] = fitSphereLeastSquare(pt_mat_1);
%  small_origin_1 = small_sphere_param_1(:,1:3);
% [pt_cld_2, pt_mat_2] = loadStrayMarkerCsvFileToPointCloudAndMat(strcat(file_path, '2_small_sphere.csv'));
% [small_sphere_param_2, small_residuals_2] = fitSphereLeastSquare(pt_mat_2);
%  small_origin_2 = small_sphere_param_2(:,1:3);
%  [pt_cld_3, pt_mat_3] = loadStrayMarkerCsvFileToPointCloudAndMat(strcat(file_path, '3_small_sphere.csv'));
% [small_sphere_param_3, small_residuals_3] = fitSphereLeastSquare(pt_mat_3);
%  small_origin_3 = small_sphere_param_3(:,1:3);
%  [pt_cld_4, pt_mat_4] = loadStrayMarkerCsvFileToPointCloudAndMat(strcat(file_path, '4_small_sphere.csv'));
% [small_sphere_param_4, small_residuals_4] = fitSphereLeastSquare(pt_mat_4);
%  small_origin_4 = small_sphere_param_4(:,1:3);
%  [pt_cld_5, pt_mat_5] = loadStrayMarkerCsvFileToPointCloudAndMat(strcat(file_path, '5_small_sphere.csv'));
% [small_sphere_param_5, small_residuals_5] = fitSphereLeastSquare(pt_mat_5);
%  small_origin_5 = small_sphere_param_5(:,1:3);
%  [pt_cld_6, pt_mat_6] = loadStrayMarkerCsvFileToPointCloudAndMat(strcat(file_path, '6_small_sphere.csv'));
% [small_sphere_param_6, small_residuals_6] = fitSphereLeastSquare(pt_mat_6);
%  small_origin_6 = small_sphere_param_6(:,1:3);
%  [pt_cld_7, pt_mat_7] = loadStrayMarkerCsvFileToPointCloudAndMat(strcat(file_path, '7_small_sphere.csv'));
% [small_sphere_param_7, small_residuals_7] = fitSphereLeastSquare(pt_mat_7);
%  small_origin_7 = small_sphere_param_7(:,1:3);
%  [pt_cld_8, pt_mat_8] = loadStrayMarkerCsvFileToPointCloudAndMat(strcat(file_path, '8_small_sphere.csv'));
% [small_sphere_param_8, small_residuals_8] = fitSphereLeastSquare(pt_mat_8);
%  small_origin_8 = small_sphere_param_8(:,1:3);
 
 

small_sphere_r = [small_sphere_param_1(4);
    small_sphere_param_2(4);
    small_sphere_param_3(4);
    small_sphere_param_4(4);
    small_sphere_param_5(4);
    small_sphere_param_6(4);
    small_sphere_param_7(4);
    small_sphere_param_8(4);];



 small_origin_1 = small_origin_1(:);
 small_origin_1 = [small_origin_1; 1];
 actual_wrist_pt_1_wrt_base = inv(affine_base_wrt_polaris)*small_origin_1;
 actual_wrist_pt_1_wrt_base = actual_wrist_pt_1_wrt_base(1:3,1);
 
 small_origin_2 = small_origin_2(:);
 small_origin_2 = [small_origin_2; 1];
 actual_wrist_pt_2_wrt_base = inv(affine_base_wrt_polaris)*small_origin_2;
 actual_wrist_pt_2_wrt_base = actual_wrist_pt_2_wrt_base(1:3,1);
 
 small_origin_3 = small_origin_3(:);
 small_origin_3 = [small_origin_3; 1];
 actual_wrist_pt_3_wrt_base = inv(affine_base_wrt_polaris)*small_origin_3;
 actual_wrist_pt_3_wrt_base = actual_wrist_pt_3_wrt_base(1:3,1);
 
 small_origin_4 = small_origin_4(:);
 small_origin_4 = [small_origin_4; 1];
 actual_wrist_pt_4_wrt_base = inv(affine_base_wrt_polaris)*small_origin_4;
 actual_wrist_pt_4_wrt_base = actual_wrist_pt_4_wrt_base(1:3,1);
 
 small_origin_5 = small_origin_5(:);
 small_origin_5 = [small_origin_5; 1];
 actual_wrist_pt_5_wrt_base = inv(affine_base_wrt_polaris)*small_origin_5;
 actual_wrist_pt_5_wrt_base = actual_wrist_pt_5_wrt_base(1:3,1);
 
 small_origin_6 = small_origin_6(:);
 small_origin_6 = [small_origin_6; 1];
 actual_wrist_pt_6_wrt_base = inv(affine_base_wrt_polaris)*small_origin_6;
 actual_wrist_pt_6_wrt_base = actual_wrist_pt_6_wrt_base(1:3,1);
 
 small_origin_7 = small_origin_7(:);
 small_origin_7 = [small_origin_7; 1];
 actual_wrist_pt_7_wrt_base = inv(affine_base_wrt_polaris)*small_origin_7;
 actual_wrist_pt_7_wrt_base = actual_wrist_pt_7_wrt_base(1:3,1);
 
 small_origin_8 = small_origin_8(:);
 small_origin_8 = [small_origin_8; 1];
 actual_wrist_pt_8_wrt_base = inv(affine_base_wrt_polaris)*small_origin_8;
 actual_wrist_pt_8_wrt_base = actual_wrist_pt_8_wrt_base(1:3,1);
 
 
 
sphere_rms(1,:) = calculateSphereRms(pt_mat_1, small_origin_1, small_sphere_param_1(4));
sphere_rms(2,:) = calculateSphereRms(pt_mat_2, small_origin_2, small_sphere_param_2(4));
sphere_rms(3,:) = calculateSphereRms(pt_mat_3, small_origin_3, small_sphere_param_3(4));
sphere_rms(4,:) = calculateSphereRms(pt_mat_4, small_origin_4, small_sphere_param_4(4));
sphere_rms(5,:) = calculateSphereRms(pt_mat_5, small_origin_5, small_sphere_param_5(4));
sphere_rms(6,:) = calculateSphereRms(pt_mat_6, small_origin_6, small_sphere_param_6(4));
sphere_rms(7,:) = calculateSphereRms(pt_mat_7, small_origin_7, small_sphere_param_7(4));
sphere_rms(8,:) = calculateSphereRms(pt_mat_8, small_origin_8, small_sphere_param_8(4));


 
wrist_pt_1 = wrist_pt_1(:);
wrist_pt_1 = wrist_pt_1(1:3,:);
wrist_pt_2 = wrist_pt_2(:);
wrist_pt_2 = wrist_pt_2(1:3,:);
wrist_pt_3 = wrist_pt_3(:);
wrist_pt_3 = wrist_pt_3(1:3,:);
wrist_pt_4 = wrist_pt_4(:);
wrist_pt_4 = wrist_pt_4(1:3,:);
wrist_pt_5 = wrist_pt_5(:);
wrist_pt_5 = wrist_pt_5(1:3,:);
wrist_pt_6 = wrist_pt_6(:);
wrist_pt_6 = wrist_pt_6(1:3,:);
wrist_pt_7 = wrist_pt_7(:);
wrist_pt_7 = wrist_pt_7(1:3,:);
wrist_pt_8 = wrist_pt_8(:);
wrist_pt_8 = wrist_pt_8(1:3,:);
 
% Dist vec

dist_vec(1) = norm(actual_wrist_pt_1_wrt_base(:) - wrist_pt_1);
dist_vec(2) = norm(actual_wrist_pt_2_wrt_base(:) - wrist_pt_2);
dist_vec(3) = norm(actual_wrist_pt_3_wrt_base(:) - wrist_pt_3);
dist_vec(4) = norm(actual_wrist_pt_4_wrt_base(:) - wrist_pt_4);
dist_vec(5) = norm(actual_wrist_pt_5_wrt_base(:) - wrist_pt_5);
dist_vec(6) = norm(actual_wrist_pt_6_wrt_base(:) - wrist_pt_6);
dist_vec(7) = norm(actual_wrist_pt_7_wrt_base(:) - wrist_pt_7);
dist_vec(8) = norm(actual_wrist_pt_8_wrt_base(:) - wrist_pt_8);

%
diff_vec(1,:) = actual_wrist_pt_1_wrt_base(:) - wrist_pt_1;
diff_vec(2,:) = actual_wrist_pt_2_wrt_base(:) - wrist_pt_2;
diff_vec(3,:) = actual_wrist_pt_3_wrt_base(:) - wrist_pt_3;
diff_vec(4,:) = actual_wrist_pt_4_wrt_base(:) - wrist_pt_4;
diff_vec(5,:) = actual_wrist_pt_5_wrt_base(:) - wrist_pt_5;
diff_vec(6,:) = actual_wrist_pt_6_wrt_base(:) - wrist_pt_6;
diff_vec(7,:) = actual_wrist_pt_7_wrt_base(:) - wrist_pt_7;
diff_vec(8,:) = actual_wrist_pt_8_wrt_base(:) - wrist_pt_8;

sphere_rms

small_sphere_r

dist_vec

diff_vec

% rms

% rms = sqrt((dist_vec(1)^2 + dist_vec(2)^2 + dist_vec(3)^2 + dist_vec(4)^2)/4)

rms = sqrt((dist_vec(1)^2 + dist_vec(2)^2 + dist_vec(3)^2 + dist_vec(4)^2 + ...
    dist_vec(5)^2 + dist_vec(6)^2 + dist_vec(7)^2 + dist_vec(8)^2)/8)


%% Error Source Auxiliary
co_error_x_x = [wrist_pt_vec(:,1) diff_vec(:,1)];
co_error_x_x = sortrows(co_error_x_x);
co_error_x_x(:,2) = co_error_x_x(:,2)*100;
co_error_x_x = normalize(co_error_x_x);

co_error_x_y = [wrist_pt_vec(:,1) diff_vec(:,2)];
co_error_x_y = sortrows(co_error_x_y);
co_error_x_y(:,2) = co_error_x_y(:,2)*100;
co_error_x_y = normalize(co_error_x_y);

co_error_x_z = [wrist_pt_vec(:,1) diff_vec(:,3)];
co_error_x_z = sortrows(co_error_x_z);
co_error_x_z(:,2) = co_error_x_z(:,2)*100;
co_error_x_z = normalize(co_error_x_z);

co_error_y_x = [wrist_pt_vec(:,2) diff_vec(:,1)];
co_error_y_x = sortrows(co_error_y_x);
co_error_y_x(:,2) = co_error_y_x(:,2)*100;
co_error_y_x = normalize(co_error_y_x);

co_error_y_y = [wrist_pt_vec(:,2) diff_vec(:,2)];
co_error_y_y = sortrows(co_error_y_y);
co_error_y_y(:,2) = co_error_y_y(:,2)*100;
co_error_y_y = normalize(co_error_y_y);

co_error_y_z = [wrist_pt_vec(:,2) diff_vec(:,3)];
co_error_y_z = sortrows(co_error_y_z);
co_error_y_z(:,2) = co_error_y_z(:,2)*100;
co_error_y_z = normalize(co_error_y_z);

co_error_z_x = [wrist_pt_vec(:,3) diff_vec(:,1)];
co_error_z_x = sortrows(co_error_z_x);
co_error_z_x(:,2) = co_error_z_x(:,2)*100;
co_error_z_x = normalize(co_error_z_x);

co_error_z_y = [wrist_pt_vec(:,3) diff_vec(:,2)];
co_error_z_y = sortrows(co_error_z_y);
co_error_z_y(:,2) = co_error_z_y(:,2)*100;
co_error_z_y = normalize(co_error_z_y);

co_error_z_z = [wrist_pt_vec(:,3) diff_vec(:,3)];
co_error_z_z = sortrows(co_error_z_z);
co_error_z_z(:,2) = co_error_z_z(:,2)*100;
co_error_z_z = normalize(co_error_z_z);

figure('Name','Error Corelation x vs. x_err')
plot(co_error_x_x);

figure('Name','Error Corelation x vs. y_err')
plot(co_error_x_y);

figure('Name','Error Corelation x vs. z_err')
plot(co_error_x_z);

figure('Name','Error Corelation y vs. x_err')
plot(co_error_y_x);

figure('Name','Error Corelation y vs. y_err')
plot(co_error_y_y);

figure('Name','Error Corelation y vs. z_err')
plot(co_error_y_z);


figure('Name','Error Corelation z vs. x_err')
plot(co_error_z_x);

figure('Name','Error Corelation z vs. y_err')
plot(co_error_z_y);

figure('Name','Error Corelation z vs. z_err')
plot(co_error_z_z);



actual_wrist_pt_vec_base = [...
    actual_wrist_pt_1_wrt_base';
    actual_wrist_pt_2_wrt_base';
    actual_wrist_pt_3_wrt_base';
    actual_wrist_pt_4_wrt_base';
    actual_wrist_pt_5_wrt_base';
    actual_wrist_pt_6_wrt_base';
    actual_wrist_pt_7_wrt_base';
    actual_wrist_pt_8_wrt_base'];



figure('Name', 'Points and error')
scatter3(wrist_pt_vec(:,1), wrist_pt_vec(:,2), wrist_pt_vec(:,3), 'filled');
hold on;
scatter3(actual_wrist_pt_vec_base(:,1),actual_wrist_pt_vec_base(:,2),actual_wrist_pt_vec_base(:,3),'o','red');
for i = 1:8
   text(wrist_pt_vec(i,1)-0.003, wrist_pt_vec(i,2), wrist_pt_vec(i,3), strcat('Pt ',num2str(i)),'Color', 'black'); 
   text(wrist_pt_vec(i,1), wrist_pt_vec(i,2), wrist_pt_vec(i,3), num2str(diff_vec(i,1)),'Color', 'black'); 
   text(wrist_pt_vec(i,1), wrist_pt_vec(i,2), wrist_pt_vec(i,3)+0.003,num2str(diff_vec(i,2)),'Color', 'black'); 
   text(wrist_pt_vec(i,1), wrist_pt_vec(i,2), wrist_pt_vec(i,3)+0.006,num2str(diff_vec(i,3)),'Color', 'black'); 
    
end
% Polaris Frame

    scale = 0.01;
    % Y axis
    yx_0 = wrist_pt_vec(1,1);
    yy_0 = wrist_pt_vec(1,2);
    yz_0 = wrist_pt_vec(1,3);
    yx_t = 0*scale +yx_0;
    yy_t = 1*scale +yy_0;
    yz_t = 0*scale +yz_0;
    v0_y= [yx_0 yy_0 yz_0];
    vz_y= [yx_t yy_t yz_t];
    v0z_y=[vz_y;v0_y];
    plot3(v0z_y(:,1),v0z_y(:,2),v0z_y(:,3),'g');
    % X axis
    xx_0 = wrist_pt_vec(1,1);
    xy_0 = wrist_pt_vec(1,2);
    xz_0 = wrist_pt_vec(1,3);
    xx_t = 1*scale+xx_0;
    xy_t = 0*scale+xy_0;
    xz_t = 0*scale+xz_0;
    v0_y= [xx_0 xy_0 xz_0];
    vx_y= [xx_t xy_t xz_t];
    v0x_y=[vx_y;v0_y];
    plot3(v0x_y(:,1),v0x_y(:,2),v0x_y(:,3),'r');       
    % Z axis
    zx_0 = wrist_pt_vec(1,1);
    zy_0 = wrist_pt_vec(1,2);
    zz_0 = wrist_pt_vec(1,3);
    zx_t = 0*scale+zx_0;
    zy_t = 0*scale+zy_0;
    zz_t = 1*scale+zz_0;
    v0_y= [zx_0 zy_0 zz_0];
    vy_y= [zx_t zy_t zz_t];
    v0y_y=[vy_y;v0_y];
    plot3(v0y_y(:,1),v0y_y(:,2),v0y_y(:,3),'b');
    
    
    axis equal;
    hold off;