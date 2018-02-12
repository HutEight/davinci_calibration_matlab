clc
close all
clear all

%% Reference: Result Hash Keys
% key_ = {'plane_1_param_1', 'plane_2_param_1', 'plane_1_param_2', 'plane_2_param_2', 'plane_1_param_3', 'plane_2_param_3', ...
%     'portal_rotation_wrt_polaris', ...
%     'sphere_param_1', 'sphere_param_2', 'sphere_param_3', ...
%     'small_sphere_param_1', 'small_sphere_param_2', 'small_sphere_param_3', 'small_sphere_param_4', ...
%     'small_sphere_param_5', 'small_sphere_param_6', 'small_sphere_param_7', 'small_sphere_param_8', 'small_sphere_param_9', ...
%     'portal_origin_wrt_polaris', 'small_origins_vec', 'distance_to_portal_vec', ...
%     'actual_small_ori_increments', 'ave_actual_small_ori_increment', 'rms_Sphere_vec', 'rms_Small_Spheres_vec', ...
%     'j3_line_param', 'j3_line_rms', 'small_sphere_origins_line_param', 'small_sphere_origins_line_rms', ...
%     'affine_portal_wrt_polaris'};

%% Load and Process Data

% csv_folder_1 = 'data_calibration_20180117/1/';
csv_folder_1 = 'data_calibration_20180211/';

plot_flag = 1;
[path_map_1, pt_clds_map_1, pt_mats_map_1] = createGreenRawDataHashTables(csv_folder_1, plot_flag);
[result_map_1] = createPostProcessingHashTables(pt_clds_map_1, pt_mats_map_1, plot_flag);


%% Fitting Qulitiy Summary

% [result_map_1('rms_Sphere_vec') result_map_2('rms_Sphere_vec') result_map_3('rms_Sphere_vec') result_map_4('rms_Sphere_vec')]
% 
% [result_map_1('rms_Small_Spheres_vec') result_map_2('rms_Small_Spheres_vec') result_map_3('rms_Small_Spheres_vec') result_map_4('rms_Small_Spheres_vec')]
% 
% [result_map_1('j3_line_rms') result_map_2('j3_line_rms') result_map_3('j3_line_rms') result_map_4('j3_line_rms')]
% 
% [result_map_1('small_sphere_origins_line_rms') result_map_2('small_sphere_origins_line_rms') result_map_3('small_sphere_origins_line_rms') result_map_4('small_sphere_origins_line_rms')]



%% Jiont3 Encoder Quality

% actual_small_ori_increments = [result_map_1('actual_small_ori_increments') result_map_2('actual_small_ori_increments') ...
%     result_map_3('actual_small_ori_increments') result_map_4('actual_small_ori_increments')];



%% Distance Portal Origin -> Small sphere orgin fitted line

small_sphere_origins_line_param_1 = result_map_1('small_sphere_origins_line_param');
p0 = small_sphere_origins_line_param_1.p0;
direction = small_sphere_origins_line_param_1.direction;
dist_1 = fcn_line_pt_dist(p0, direction, result_map_1('portal_origin_wrt_polaris'));


dist_portal_s_sphere_ori_line = [dist_1];

[transpose(small_sphere_origins_line_param_1.direction)]

result_map_1('portal_rotation_wrt_polaris');



%% Addition

% function [dist] = lines_dist(a, b, c, d)

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

dist = [dist_1]
dist_x = [dist_x_1] 
dist_y = [dist_y_1]

temp_1 = result_map_1('joint_1_param');
j1_vec = temp_1.vector();
j1_pt = temp_1.circle(1:3)
temp_2 = result_map_1('joint_2_param');
j2_vec = temp_2.vector();
j2_pt = temp_2.circle(1:3);

dist_j1_2 = lines_dist(j1_pt, j1_vec, j2_pt, j2_vec)

angle_j1_2 = rad2deg(subspace(transpose(j1_vec), transpose(j2_vec)))

%% Plot Circle
figure('Name', 'Joint 1 Arc Pts and Circle');
centre_1 = temp_1.circle(1:3);
normal_1 = temp_1.vector();
radius_1 = temp_1.circle(4);
plotCircle3D(centre_1,normal_1,radius_1);
hold on;
pcshow(pt_clds_map_1('greenJ1Arc01'));
centre_2 = temp_2.circle(1:3);
normal_2 = temp_2.vector();
radius_2 = temp_2.circle(4);
plotCircle3D(centre_2,normal_2,radius_2);
pcshow(pt_clds_map_1('greenJ2Arc01'));
hold off;
