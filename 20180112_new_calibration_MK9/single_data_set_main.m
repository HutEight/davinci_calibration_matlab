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