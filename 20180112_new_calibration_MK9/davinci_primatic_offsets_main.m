clc
close all
clear all

%% Reference

% Keys
% key_ = {'plane_1_param_1', 'plane_2_param_1', ...
%     'portal_rotation_wrt_polaris', ...
%     'sphere_param_1', ...
%     'small_sphere_param_1', 'small_sphere_param_2', 'small_sphere_param_3', 'small_sphere_param_4', ...
%     'portal_origin_wrt_polaris', 'small_origins_vec', 'distance_to_portal_vec', ...
%     'actual_small_ori_increments', 'ave_actual_small_ori_increment', 'rms_Sphere_vec', 'rms_Small_Spheres_vec', ...
%     'small_sphere_origins_line_param', 'small_sphere_origins_line_rms', ...
%     'affine_portal_wrt_polaris', ...
%     'joint_1_param', 'joint_2_param',...
%     'small_origins_vec_wrt_portal'};

%% Update this everytime you do the test

% G_N_Md
affine_Md_wrt_polaris = [-0.9958920320026502, 0.02817981160363598, 0.08605207035054949, 0.09613999724388123;
 -0.01669489720704399, -0.9911918570957992, 0.1313772538692569, -0.06460999697446823;
 0.08899629768073822, 0.1294009298458265, 0.9875905317256521, -0.674310028553009;
 0, 0, 0, 1];


%% Load and Process Data

% Update the path
csv_folder_1 = '20180216_offset_cal_1/';

plot_flag = 1;

[path_map_1, pt_clds_map_1, pt_mats_map_1] = createGreenRawDataHashTablesShort(csv_folder_1, plot_flag);

[result_map_1] = createPostProcessingHashTablesShort(pt_clds_map_1, pt_mats_map_1, plot_flag);


%% Fitting Qulitiy Summary
disp('rms_Sphere_vec: ');[result_map_1('rms_Sphere_vec')]
disp('rms_Small_Spheres_vec: ');[result_map_1('rms_Small_Spheres_vec')]
disp('small_sphere_origins_line_rms: ');[result_map_1('small_sphere_origins_line_rms')]

%% Distance Portal Origin -> Small sphere orgin fitted line

small_sphere_origins_line_param_1 = result_map_1('small_sphere_origins_line_param');
p0 = small_sphere_origins_line_param_1.p0;
direction = small_sphere_origins_line_param_1.direction;
dist_1 = fcn_line_pt_dist(p0, direction, result_map_1('portal_origin_wrt_polaris'));

dist_portal_s_sphere_ori_line = [dist_1];

disp('transpose(small_sphere_origins_line_param_1.direction):');
[transpose(small_sphere_origins_line_param_1.direction)]

%% Offset

% function [dist] = lines_dist(a, b, c, d)

result_map_1('portal_rotation_wrt_polaris');

portal_1 = result_map_1('portal_origin_wrt_polaris');
portal_1 = transpose(portal_1);
rot_mat_1 = result_map_1('portal_rotation_wrt_polaris');
x_vec_1 = rot_mat_1(:,1);
y_vec_1 = rot_mat_1(:,2);
small_sphere_origins_line_param_1 = result_map_1('small_sphere_origins_line_param');
small_sphere_line_vec_1 = small_sphere_origins_line_param_1.direction;
small_sphere_pt_1 = small_sphere_origins_line_param_1.p0;
small_sphere_pt_1 =  transpose(small_sphere_pt_1);

dist_x_1 = lines_dist(portal_1, x_vec_1, small_sphere_pt_1, small_sphere_line_vec_1);
dist_y_1 = lines_dist(portal_1, y_vec_1, small_sphere_pt_1, small_sphere_line_vec_1);

%%%
disp('dist_portal_s_sphere_ori_line:');
dist = [dist_1];
sprintf('%f', dist)

disp('dist_x_1:');
dist_x = [dist_x_1]; 
sprintf('%f', dist_x)

disp('dist_y_1:');
dist_y = [dist_y_1];
sprintf('%f', dist_y_1)

%% Generate Test Trajectory based on Portal Calibration

output_folder_path = 'test_output/';
affine_portal_wrt_polaris = result_map_1('affine_portal_wrt_polaris');
generateTestTrajectory(output_folder_path, affine_Md_wrt_polaris, affine_portal_wrt_polaris);