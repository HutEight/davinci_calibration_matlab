clc
close all
clear all

%%
csv_folder = 'data_20180112/';
csv_folder_1 = 'data_calibration_20180117/1/';
csv_folder_2 = 'data_calibration_20180117/2/';
csv_folder_3 = 'data_calibration_20180117/3/';
csv_folder_4 = 'data_calibration_20180117/4/';

plot_flag = 1;

[path_map_1, pt_clds_map_1, pt_mats_map_1] = createGreenRawDataHashTables(csv_folder_1, plot_flag);
[result_map_1] = createPostProcessingHashTables(pt_clds_map_1, pt_mats_map_1, plot_flag);
rms_Small_Spheres_vec_1 = result_map_1('rms_Small_Spheres_vec');
% sprintf('%f', rms_Small_Spheres_vec(1));

portal_pt = result_map_1('portal_origin_wrt_polaris');
small_sphere_origins_line_param = result_map_1('small_sphere_origins_line_param');
p0 = small_sphere_origins_line_param.p0;
direction = small_sphere_origins_line_param.direction;

[dist] = fcn_line_pt_dist(p0, direction, portal_pt)

