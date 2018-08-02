% RN@HMS Queen Elizabeth
% 30/07/18
% Descriptions.
%
% Notes.
% There are 8 quality test small spheres which correspond to 8 different
% combination of J1, 2, and 3 values. 
% After a calibration analysis, you should get a new set of DH params. This
% would change the forward kinematic result, hence chagne to wrist point
% represented in the Cartesian space (robot base frame). 
% Therefore you should re-run the auxiliary code in the da Vinci Kinematic
% package to  get the new wrist points (in robot base frame).
% You should also read the new affine_base_wrt_polaris.
% Then this programme is going to calculate the difference between the
% forward kinematic result and the reading from the Polaris.


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
    0.0047    0.1181   -0.9930   -0.2108;
   -0.9990    0.0436    0.0005    0.0469;
    0.0434    0.9920    0.1182   -0.8402;
         0         0         0    1.0000];
     
% @ UPDATE CHECKPOINT 2/3
% This is the directory of the quality test small spheres csv files. 
file_path = 'Data/20180801_PSM1_intrinsic_1_quliaty_stray_marker/';


% @ UPDATE CHECKPOINT 3/3
% If you have changed the DH yaml file in the kinematic package, you must 
% run the auxiliary code in the kinematic package again to generate the 
% new wrist points. 

% The Centres (targets) wrt base frame.
% ---
wrist_pt_1 = [0.0268252 0.0175642  -0.14112 1];
wrist_pt_2 = [-0.00844263   0.0175283   -0.140923 1];
wrist_pt_3 = [0.0269933 0.0533732 -0.142126 1];
wrist_pt_4 = [-0.00852877   0.0532858   -0.141967 1];
wrist_pt_5 = [0.0274391 0.0180221 -0.180974 1];
wrist_pt_6 = [-0.00874929   0.0180031   -0.180845 1];
wrist_pt_7 = [0.0275624 0.0545145  -0.18175 1];
wrist_pt_8 = [-0.0087818  0.0544665  -0.181643 1];
% ---




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

% If you are using the standard marker use the following --
% [pt_cld_1, pt_mat_1] = loadCsvFileToPointCloudAndMat(strcat(file_path, '1_small_sphere.csv'));
% [small_sphere_param_1, small_residuals_1] = fitSphereLeastSquare(pt_mat_1);
%  small_origin_1 = small_sphere_param_1(:,1:3);
% [pt_cld_2, pt_mat_2] = loadCsvFileToPointCloudAndMat(strcat(file_path, '2_small_sphere.csv'));
% [small_sphere_param_2, small_residuals_2] = fitSphereLeastSquare(pt_mat_2);
%  small_origin_2 = small_sphere_param_2(:,1:3);
%  [pt_cld_3, pt_mat_3] = loadCsvFileToPointCloudAndMat(strcat(file_path, '3_small_sphere.csv'));
% [small_sphere_param_3, small_residuals_3] = fitSphereLeastSquare(pt_mat_3);
%  small_origin_3 = small_sphere_param_3(:,1:3);
%  [pt_cld_4, pt_mat_4] = loadCsvFileToPointCloudAndMat(strcat(file_path, '4_small_sphere.csv'));
% [small_sphere_param_4, small_residuals_4] = fitSphereLeastSquare(pt_mat_4);
%  small_origin_4 = small_sphere_param_4(:,1:3);
%  [pt_cld_5, pt_mat_5] = loadCsvFileToPointCloudAndMat(strcat(file_path, '5_small_sphere.csv'));
% [small_sphere_param_5, small_residuals_5] = fitSphereLeastSquare(pt_mat_5);
%  small_origin_5 = small_sphere_param_5(:,1:3);
%  [pt_cld_6, pt_mat_6] = loadCsvFileToPointCloudAndMat(strcat(file_path, '6_small_sphere.csv'));
% [small_sphere_param_6, small_residuals_6] = fitSphereLeastSquare(pt_mat_6);
%  small_origin_6 = small_sphere_param_6(:,1:3);
%  [pt_cld_7, pt_mat_7] = loadCsvFileToPointCloudAndMat(strcat(file_path, '7_small_sphere.csv'));
% [small_sphere_param_7, small_residuals_7] = fitSphereLeastSquare(pt_mat_7);
%  small_origin_7 = small_sphere_param_7(:,1:3);
%  [pt_cld_8, pt_mat_8] = loadCsvFileToPointCloudAndMat(strcat(file_path, '8_small_sphere.csv'));
% [small_sphere_param_8, small_residuals_8] = fitSphereLeastSquare(pt_mat_8);
%  small_origin_8 = small_sphere_param_8(:,1:3);
 
 % If you are using stray marker use the following
 [pt_cld_1, pt_mat_1] = loadStrayMarkerCsvFileToPointCloudAndMat(strcat(file_path, '1_small_sphere.csv'));
[small_sphere_param_1, small_residuals_1] = fitSphereLeastSquare(pt_mat_1);
 small_origin_1 = small_sphere_param_1(:,1:3);
[pt_cld_2, pt_mat_2] = loadStrayMarkerCsvFileToPointCloudAndMat(strcat(file_path, '2_small_sphere.csv'));
[small_sphere_param_2, small_residuals_2] = fitSphereLeastSquare(pt_mat_2);
 small_origin_2 = small_sphere_param_2(:,1:3);
 [pt_cld_3, pt_mat_3] = loadStrayMarkerCsvFileToPointCloudAndMat(strcat(file_path, '3_small_sphere.csv'));
[small_sphere_param_3, small_residuals_3] = fitSphereLeastSquare(pt_mat_3);
 small_origin_3 = small_sphere_param_3(:,1:3);
 [pt_cld_4, pt_mat_4] = loadStrayMarkerCsvFileToPointCloudAndMat(strcat(file_path, '4_small_sphere.csv'));
[small_sphere_param_4, small_residuals_4] = fitSphereLeastSquare(pt_mat_4);
 small_origin_4 = small_sphere_param_4(:,1:3);
 [pt_cld_5, pt_mat_5] = loadStrayMarkerCsvFileToPointCloudAndMat(strcat(file_path, '5_small_sphere.csv'));
[small_sphere_param_5, small_residuals_5] = fitSphereLeastSquare(pt_mat_5);
 small_origin_5 = small_sphere_param_5(:,1:3);
 [pt_cld_6, pt_mat_6] = loadStrayMarkerCsvFileToPointCloudAndMat(strcat(file_path, '6_small_sphere.csv'));
[small_sphere_param_6, small_residuals_6] = fitSphereLeastSquare(pt_mat_6);
 small_origin_6 = small_sphere_param_6(:,1:3);
 [pt_cld_7, pt_mat_7] = loadStrayMarkerCsvFileToPointCloudAndMat(strcat(file_path, '7_small_sphere.csv'));
[small_sphere_param_7, small_residuals_7] = fitSphereLeastSquare(pt_mat_7);
 small_origin_7 = small_sphere_param_7(:,1:3);
 [pt_cld_8, pt_mat_8] = loadStrayMarkerCsvFileToPointCloudAndMat(strcat(file_path, '8_small_sphere.csv'));
[small_sphere_param_8, small_residuals_8] = fitSphereLeastSquare(pt_mat_8);
 small_origin_8 = small_sphere_param_8(:,1:3);
 
 
 
 
 
 
 
 
 
 
[rms_1] = calculateSphereRms(pt_mat_1, small_origin_1, small_sphere_param_1(4))
 
 
% Dist vec

dist_vec(1) = norm(small_origin_1(:) - wrist_pt_1_wrt_polaris);
dist_vec(2) = norm(small_origin_2(:) - wrist_pt_2_wrt_polaris);
dist_vec(3) = norm(small_origin_3(:) - wrist_pt_3_wrt_polaris);
dist_vec(4) = norm(small_origin_4(:) - wrist_pt_4_wrt_polaris);
dist_vec(5) = norm(small_origin_5(:) - wrist_pt_5_wrt_polaris);
dist_vec(6) = norm(small_origin_6(:) - wrist_pt_6_wrt_polaris);
dist_vec(7) = norm(small_origin_7(:) - wrist_pt_7_wrt_polaris);
dist_vec(8) = norm(small_origin_8(:) - wrist_pt_8_wrt_polaris);

%
diff_vec(1,:) = small_origin_1(:) - wrist_pt_1_wrt_polaris;
diff_vec(2,:) = small_origin_2(:) - wrist_pt_2_wrt_polaris;
diff_vec(3,:) = small_origin_3(:) - wrist_pt_3_wrt_polaris;
diff_vec(4,:) = small_origin_4(:) - wrist_pt_4_wrt_polaris;
diff_vec(5,:) = small_origin_5(:) - wrist_pt_5_wrt_polaris;
diff_vec(6,:) = small_origin_6(:) - wrist_pt_6_wrt_polaris;
diff_vec(7,:) = small_origin_7(:) - wrist_pt_7_wrt_polaris;
diff_vec(8,:) = small_origin_8(:) - wrist_pt_8_wrt_polaris;

dist_vec

diff_vec

% rms

% rms = sqrt((dist_vec(1)^2 + dist_vec(2)^2 + dist_vec(3)^2 + dist_vec(4)^2)/4)

rms = sqrt((dist_vec(1)^2 + dist_vec(2)^2 + dist_vec(3)^2 + dist_vec(4)^2 + ...
    dist_vec(5)^2 + dist_vec(6)^2 + dist_vec(7)^2 + dist_vec(8)^2)/8)


