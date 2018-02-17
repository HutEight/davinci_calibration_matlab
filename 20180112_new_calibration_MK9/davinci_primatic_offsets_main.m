% RN@HMS Queen Elizabeth
% 16/02/18
% Notes.
% 1. Remember to update data patha and G_N_Md each time you use this code.

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
affine_Md_wrt_polaris = [-0.9850744800057548, 0.02489206042986044, 0.1703192712788188, -0.07186000049114227;
 0.002626314160388893, -0.9871995363596183, 0.1594684228469242, -0.08264999836683273;
 0.1721086032577182, 0.1575355856272184, 0.972399695570585, -0.8593400120735168;
 0, 0, 0, 1];

% G_N_Mg
affine_Mg_wrt_polaris =[0.1989569756471373, -0.01444239845489186, -0.9799018006760752, -0.1590999960899353;
 0.138864118958508, 0.9902180522481778, 0.01360020101697863, -0.03192999958992004;
 0.9701200329377916, -0.1387790550792699, 0.1990163198435828, -1.178130030632019;
 0, 0, 0, 1];

% G_Mg_Md
affine_Md_wrt_Mg =[-0.04236681568176687, -0.9669071094799431, 0.251586356081024, 0.2926427609124402;
 -0.02407618297455795, -0.2507512786928744, -0.967752103406272, 0.07680221448903546;
 0.9988119894866915, -0.04705781413356479, -0.01265589928089181, 0.02613060270224771;
 0, 0, 0, 1];

% G_Mg_Mc
affine_Mc_wrt_Mg = [0.2952790233294461, 0.9554037217435692, -0.003745245004632872, 0.4231785780551462;
 -0.9486162120071466, 0.2927100689272258, -0.1202002407062117, 0.02008079125591733;
 -0.1137434864017322, 0.03904540980902808, 0.9927426027294405, 0.3860468782445587;
 0, 0, 0, 1];

% G_Mc_C
affine_cam_wrt_Mc =   [ -0.0377,    0.9992,    0.0157,   -0.0263;
    0.9635,    0.0406,   -0.2646,   -0.0004;
   -0.2650,    0.0052,   -0.9642,   -0.0809;
         0,         0,         0,   1.0000]

% G_C_D_l{i}
affine_board_0_0_wrt_l_cam= [0.9556381888033338, -0.1084893843511532, 0.273835179594937, 0.03766894387912491;
 0.08578523034745042, 0.9919069585826652, 0.09360277650541052, -0.02287606745939376;
 -0.2817739277415824, -0.06595937384780662, 0.9572109561881783, 0.290484589431916;
 0, 0, 0, 1];








%% Load and Process Data

% Update the path
csv_folder_1 = '20180216_offset_data_02/';

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

affine_Md_wrt_board_0_0 =  [0, -1,  0,    -0.08;
                        0,  0,  1,        0;
                       -1,  0,  0, -0.00877;
                        0,  0,  0,     1];


% This should be const once calibratied no matter how you move the Mg
% later on, meaning you should NOT update the affine_Mg_wrt_polaris!
affine_Mg_wrt_portal = inv(affine_portal_wrt_polaris)*affine_Mg_wrt_polaris; % Mg is Marker on Green base

% G_Pg_Md:
affine_Md_wrt_portal_via_base = affine_Mg_wrt_portal * affine_Md_wrt_Mg * inv(affine_Md_wrt_board_0_0)

goal = affine_Mg_wrt_portal*affine_Mc_wrt_Mg*affine_cam_wrt_Mc*affine_board_0_0_wrt_l_cam*[0;0;0;1]
