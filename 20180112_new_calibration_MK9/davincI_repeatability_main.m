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
%     'affine_portal_wrt_polaris', ...
%     'joint_1_param', 'joint_2_param',...
%     'small_origins_vec_wrt_portal'};

%% Load and Process Data

csv_folder_1 = 'data_calibration_20180117/1/';
csv_folder_2 = 'data_calibration_20180117/2/';
csv_folder_3 = 'data_calibration_20180117/3/';
csv_folder_4 = 'data_calibration_20180117/4/';

plot_flag = 1;
[path_map_1, pt_clds_map_1, pt_mats_map_1] = createGreenRawDataHashTables(csv_folder_1, plot_flag);
[result_map_1] = createPostProcessingHashTables(pt_clds_map_1, pt_mats_map_1, plot_flag);

plot_flag = 1;
[path_map_2, pt_clds_map_2, pt_mats_map_2] = createGreenRawDataHashTables(csv_folder_2, plot_flag);
[result_map_2] = createPostProcessingHashTables(pt_clds_map_2, pt_mats_map_2, plot_flag);

plot_flag = 1;
[path_map_3, pt_clds_map_3, pt_mats_map_3] = createGreenRawDataHashTables(csv_folder_3, plot_flag);
[result_map_3] = createPostProcessingHashTables(pt_clds_map_3, pt_mats_map_3, plot_flag);

plot_flag = 1;
[path_map_4, pt_clds_map_4, pt_mats_map_4] = createGreenRawDataHashTables(csv_folder_4, plot_flag);
[result_map_4] = createPostProcessingHashTables(pt_clds_map_4, pt_mats_map_4, plot_flag);

%% Fitting Qulitiy Summary

[result_map_1('rms_Sphere_vec') result_map_2('rms_Sphere_vec') result_map_3('rms_Sphere_vec') result_map_4('rms_Sphere_vec')]

[result_map_1('rms_Small_Spheres_vec') result_map_2('rms_Small_Spheres_vec') result_map_3('rms_Small_Spheres_vec') result_map_4('rms_Small_Spheres_vec')]

[result_map_1('j3_line_rms') result_map_2('j3_line_rms') result_map_3('j3_line_rms') result_map_4('j3_line_rms')]

[result_map_1('small_sphere_origins_line_rms') result_map_2('small_sphere_origins_line_rms') result_map_3('small_sphere_origins_line_rms') result_map_4('small_sphere_origins_line_rms')]



%% Jiont3 Encoder Quality

actual_small_ori_increments = [result_map_1('actual_small_ori_increments') result_map_2('actual_small_ori_increments') ...
    result_map_3('actual_small_ori_increments') result_map_4('actual_small_ori_increments')];


%% Power Cycle Data 3 -> 4

portal_origins_data_3_4 = [result_map_3('portal_origin_wrt_polaris'); result_map_4('portal_origin_wrt_polaris')];
portal_origins_data_3_4_delta = result_map_3('portal_origin_wrt_polaris') - result_map_4('portal_origin_wrt_polaris');

norm(portal_origins_data_3_4_delta)

small_sphere_origins_data_3_4 = [result_map_3('small_origins_vec')  result_map_4('small_origins_vec')];
small_sphere_origins_data_3_4_delta = result_map_3('small_origins_vec')- result_map_4('small_origins_vec');


%% Non Power Cycle Data 1 -> 2

portal_origins_data_1_2 = [result_map_1('portal_origin_wrt_polaris'); result_map_2('portal_origin_wrt_polaris')];
portal_origins_data_1_2_delta = result_map_1('portal_origin_wrt_polaris') - result_map_2('portal_origin_wrt_polaris');

norm(portal_origins_data_1_2_delta)

small_sphere_origins_data_1_2 = [result_map_1('small_origins_vec')  result_map_2('small_origins_vec')];
small_sphere_origins_data_1_2_delta = result_map_1('small_origins_vec')- result_map_2('small_origins_vec');

%% Distance Portal Origin -> Small sphere orgin fitted line

small_sphere_origins_line_param_1 = result_map_1('small_sphere_origins_line_param');
p0 = small_sphere_origins_line_param_1.p0;
direction = small_sphere_origins_line_param_1.direction;
dist_1 = fcn_line_pt_dist(p0, direction, result_map_1('portal_origin_wrt_polaris'));

small_sphere_origins_line_param_2 = result_map_2('small_sphere_origins_line_param');
p0 = small_sphere_origins_line_param_2.p0;
direction = small_sphere_origins_line_param_2.direction;
dist_2 = fcn_line_pt_dist(p0, direction, result_map_2('portal_origin_wrt_polaris'));

small_sphere_origins_line_param_3 = result_map_3('small_sphere_origins_line_param');
p0 = small_sphere_origins_line_param_3.p0;
direction = small_sphere_origins_line_param_3.direction;
dist_3 = fcn_line_pt_dist(p0, direction, result_map_3('portal_origin_wrt_polaris'));

small_sphere_origins_line_param_4 = result_map_4('small_sphere_origins_line_param');
p0 = small_sphere_origins_line_param_4.p0;
direction = small_sphere_origins_line_param_4.direction;
dist_4 = fcn_line_pt_dist(p0, direction, result_map_4('portal_origin_wrt_polaris'));

dist_portal_s_sphere_ori_line = [dist_1 dist_2 dist_3 dist_4];

[transpose(small_sphere_origins_line_param_1.direction); transpose(small_sphere_origins_line_param_2.direction);
    transpose(small_sphere_origins_line_param_3.direction); transpose(small_sphere_origins_line_param_4.direction)]

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
portal_2 = result_map_2('portal_origin_wrt_polaris');
portal_2 = transpose(portal_2);
rot_mat_2 = result_map_2('portal_rotation_wrt_polaris');
x_vec_2 = rot_mat_2(:,1);
y_vec_2 = rot_mat_2(:,2);
small_sphere_origins_line_param_2 = result_map_2('small_sphere_origins_line_param');
small_sphere_line_vec_2 = small_sphere_origins_line_param_2.direction;
small_sphere_pt_2 = small_sphere_origins_line_param_2.p0;
small_sphere_pt_2 =  transpose(small_sphere_pt_2);

dist_x_2 = lines_dist(portal_2, x_vec_2, small_sphere_pt_2, small_sphere_line_vec_2);
dist_y_2 = lines_dist(portal_2, y_vec_2, small_sphere_pt_2, small_sphere_line_vec_2);
%%%
portal_3 = result_map_3('portal_origin_wrt_polaris');
portal_3 = transpose(portal_3);
rot_mat_3 = result_map_3('portal_rotation_wrt_polaris');
x_vec_3 = rot_mat_3(:,1);
y_vec_3 = rot_mat_3(:,2);
small_sphere_origins_line_param_3 = result_map_3('small_sphere_origins_line_param');
small_sphere_line_vec_3 = small_sphere_origins_line_param_3.direction;
small_sphere_pt_3 = small_sphere_origins_line_param_3.p0;
small_sphere_pt_3 =  transpose(small_sphere_pt_3);

dist_x_3 = lines_dist(portal_3, x_vec_3, small_sphere_pt_3, small_sphere_line_vec_3);
dist_y_3 = lines_dist(portal_3, y_vec_3, small_sphere_pt_3, small_sphere_line_vec_3);
%%%
portal_4 = result_map_4('portal_origin_wrt_polaris');
portal_4 = transpose(portal_4);
rot_mat_4 = result_map_4('portal_rotation_wrt_polaris');
x_vec_4 = rot_mat_4(:,1);
y_vec_4 = rot_mat_4(:,2);
small_sphere_origins_line_param_4 = result_map_4('small_sphere_origins_line_param');
small_sphere_line_vec_4 = small_sphere_origins_line_param_4.direction;
small_sphere_pt_4 = small_sphere_origins_line_param_4.p0;
small_sphere_pt_4 =  transpose(small_sphere_pt_4);

dist_x_4 = lines_dist(portal_4, x_vec_4, small_sphere_pt_4, small_sphere_line_vec_4);
dist_y_4 = lines_dist(portal_4, y_vec_4, small_sphere_pt_4, small_sphere_line_vec_4);


dist = [dist_1 dist_2 dist_3 dist_4]
dist_x = [dist_x_1 dist_x_2 dist_x_3 dist_x_4] 
dist_y = [dist_y_1 dist_y_2 dist_y_3 dist_y_4]