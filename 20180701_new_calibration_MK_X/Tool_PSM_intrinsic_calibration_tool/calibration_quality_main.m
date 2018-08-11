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
0.052927 -0.007706 -0.998569 -0.066479 ;
-0.997794 0.039726 -0.053192 0.003664 ;
0.040079 0.999181 -0.005586 -0.881258 ;
0.000000 0.000000 0.000000 1.000000 ];
     
% @ UPDATE CHECKPOINT 2/3
% This is the directory of the quality test small spheres csv files. 
file_path = 'Data/20180809_PSM2_intrinsic_1_quality/';


% @ UPDATE CHECKPOINT 3/3
% If you have changed the DH yaml file in the kinematic package, you must 
% run the auxiliary code in the kinematic package again to generate the 
% new wrist points. 

% The Centres (targets) wrt base frame.
% --- without J2 scale factor
wrist_pt_1 = [0.0248585 0.0167289 -0.142448 1];
wrist_pt_2 = [-0.0105949  0.0166581  -0.142223 1];
wrist_pt_3 = [0.0253588 0.0523765 -0.144366 1];
wrist_pt_4 = [-0.0105133  0.0521436  -0.143126 1];
wrist_pt_5 = [0.0260552 0.0165619 -0.182538 1];
wrist_pt_6 = [-0.0102637  0.0165782  -0.182112 1];
wrist_pt_7 = [0.0264681 0.0530215 -0.183861 1];
wrist_pt_8 = [-0.0101208   0.052867  -0.183466 1];
% ---

% % --- With J2 scale factor
% wrist_pt_1 = [0.0248715 0.0162037 -0.142505 1];
% wrist_pt_2 = [-0.0105962   0.016136  -0.142282 1];
% wrist_pt_3 = [0.0254538 0.0509432 -0.144848 1];
% wrist_pt_4 = [-0.0105395  0.0507196  -0.143622 1];
% wrist_pt_5 = [0.0260648 0.0160171 -0.182585 1];
% wrist_pt_6 = [-0.0102634  0.0160341  -0.182159 1];
% wrist_pt_7 = [0.0265357 0.0515311 -0.184266 1];
% wrist_pt_8 = [-0.0101344  0.0513824  -0.183878 1];
% % ---



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

[pt_cld_1, pt_mat_1] = loadCsvFileToPointCloudAndMat(strcat(file_path, '1_small_sphere.csv'), remove_static_flag);
[small_sphere_param_1, small_residuals_1] = fitSphereLeastSquare(pt_mat_1);
 small_origin_1 = small_sphere_param_1(:,1:3);
[pt_cld_2, pt_mat_2] = loadCsvFileToPointCloudAndMat(strcat(file_path, '2_small_sphere.csv'), remove_static_flag);
[small_sphere_param_2, small_residuals_2] = fitSphereLeastSquare(pt_mat_2);
 small_origin_2 = small_sphere_param_2(:,1:3);
 [pt_cld_3, pt_mat_3] = loadCsvFileToPointCloudAndMat(strcat(file_path, '3_small_sphere.csv'), remove_static_flag);
[small_sphere_param_3, small_residuals_3] = fitSphereLeastSquare(pt_mat_3);
 small_origin_3 = small_sphere_param_3(:,1:3);
 [pt_cld_4, pt_mat_4] = loadCsvFileToPointCloudAndMat(strcat(file_path, '4_small_sphere.csv'), remove_static_flag);
[small_sphere_param_4, small_residuals_4] = fitSphereLeastSquare(pt_mat_4);
 small_origin_4 = small_sphere_param_4(:,1:3);
 [pt_cld_5, pt_mat_5] = loadCsvFileToPointCloudAndMat(strcat(file_path, '5_small_sphere.csv'), remove_static_flag);
[small_sphere_param_5, small_residuals_5] = fitSphereLeastSquare(pt_mat_5);
 small_origin_5 = small_sphere_param_5(:,1:3);
 [pt_cld_6, pt_mat_6] = loadCsvFileToPointCloudAndMat(strcat(file_path, '6_small_sphere.csv'), remove_static_flag);
[small_sphere_param_6, small_residuals_6] = fitSphereLeastSquare(pt_mat_6);
 small_origin_6 = small_sphere_param_6(:,1:3);
 [pt_cld_7, pt_mat_7] = loadCsvFileToPointCloudAndMat(strcat(file_path, '7_small_sphere.csv'), remove_static_flag);
[small_sphere_param_7, small_residuals_7] = fitSphereLeastSquare(pt_mat_7);
 small_origin_7 = small_sphere_param_7(:,1:3);
 [pt_cld_8, pt_mat_8] = loadCsvFileToPointCloudAndMat(strcat(file_path, '8_small_sphere.csv'), remove_static_flag);
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


