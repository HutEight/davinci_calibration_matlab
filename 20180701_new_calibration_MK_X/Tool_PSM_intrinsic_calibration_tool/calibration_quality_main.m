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
-0.662071 0.080844 -0.745068 -0.147556 ;
-0.717635 0.218163 0.661366 0.039457 ;
0.216014 0.972558 -0.086422 -0.853921 ;
0.000000 0.000000 0.000000 1.000000 ];
     
% @ UPDATE CHECKPOINT 2/3
% This is the directory of the quality test small spheres csv files. 
file_path = 'Data/20180806_PSM2_intrinsic_2_quality/';


% @ UPDATE CHECKPOINT 3/3
% If you have changed the DH yaml file in the kinematic package, you must 
% run the auxiliary code in the kinematic package again to generate the 
% new wrist points. 

% The Centres (targets) wrt base frame.
% ---
wrist_pt_1 = [0.0263421 0.0177649 -0.141183 1];
wrist_pt_2 = [-0.00893366   0.0177316   -0.140864 1];
wrist_pt_3 = [0.0265316 0.0535058  -0.14216 1];
wrist_pt_4 = [-0.00899109    0.053419   -0.141886 1];
wrist_pt_5 = [0.0270481 0.0181897 -0.181014 1];
wrist_pt_6 = [-0.00914424   0.0181722   -0.180806 1];
wrist_pt_7 = [0.0271511 0.0546453 -0.181678 1];
wrist_pt_8 = [-0.00917509   0.0545972   -0.181491 1];
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
% ----
[pt_cld_1, pt_mat_1] = loadCsvFileToPointCloudAndMat(strcat(file_path, '1_small_sphere.csv'));
[small_sphere_param_1, small_residuals_1] = fitSphereLeastSquare(pt_mat_1);
 small_origin_1 = small_sphere_param_1(:,1:3);
[pt_cld_2, pt_mat_2] = loadCsvFileToPointCloudAndMat(strcat(file_path, '2_small_sphere.csv'));
[small_sphere_param_2, small_residuals_2] = fitSphereLeastSquare(pt_mat_2);
 small_origin_2 = small_sphere_param_2(:,1:3);
 [pt_cld_3, pt_mat_3] = loadCsvFileToPointCloudAndMat(strcat(file_path, '3_small_sphere.csv'));
[small_sphere_param_3, small_residuals_3] = fitSphereLeastSquare(pt_mat_3);
 small_origin_3 = small_sphere_param_3(:,1:3);
 [pt_cld_4, pt_mat_4] = loadCsvFileToPointCloudAndMat(strcat(file_path, '4_small_sphere.csv'));
[small_sphere_param_4, small_residuals_4] = fitSphereLeastSquare(pt_mat_4);
 small_origin_4 = small_sphere_param_4(:,1:3);
 [pt_cld_5, pt_mat_5] = loadCsvFileToPointCloudAndMat(strcat(file_path, '5_small_sphere.csv'));
[small_sphere_param_5, small_residuals_5] = fitSphereLeastSquare(pt_mat_5);
 small_origin_5 = small_sphere_param_5(:,1:3);
 [pt_cld_6, pt_mat_6] = loadCsvFileToPointCloudAndMat(strcat(file_path, '6_small_sphere.csv'));
[small_sphere_param_6, small_residuals_6] = fitSphereLeastSquare(pt_mat_6);
 small_origin_6 = small_sphere_param_6(:,1:3);
 [pt_cld_7, pt_mat_7] = loadCsvFileToPointCloudAndMat(strcat(file_path, '7_small_sphere.csv'));
[small_sphere_param_7, small_residuals_7] = fitSphereLeastSquare(pt_mat_7);
 small_origin_7 = small_sphere_param_7(:,1:3);
 [pt_cld_8, pt_mat_8] = loadCsvFileToPointCloudAndMat(strcat(file_path, '8_small_sphere.csv'));
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


