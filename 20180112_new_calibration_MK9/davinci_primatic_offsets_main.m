% RN@HMS Queen Elizabeth
% 16/02/18
% Notes.
% 1. Remember to update data patha and G_N_Md each time you use this code.

clc
close all
clear all

%% Reference

% angle = atan2(norm(cross(a,b)), dot(a,b))

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
%     'small_origins_vec_wrt_portal',...
%     'small_sphere_origins_line_param_wrt_portal', 'small_sphere_origins_line_rms_wrt_porta'};

%% Update this ONLY when you do the ARM Calibration (spheres and arcs)
% G_N_Mg_0
% RECORDED IN YOUR CALIBRATION
% MEANING THE POLARIS HAS NOT BEEN MOVED
% affine_Mg_wrt_polaris_0 =[0.04714905129531968, -0.02772806534037126, -0.9985029400830182, 0.1239200010895729;
%  0.09001994027480772, 0.9956650634981135, -0.02339854017279064, -0.1217299997806549;
%  0.9948232894915917, -0.08878195605965072, 0.04944074193770646, -1.145869970321655;
%  0, 0, 0, 1];

affine_Mg_wrt_polaris_0=[0.1689240155702601, -0.002011271326206696, -0.9856270246656547, 0.03633999824523926;
 -0.1274250124356267, 0.9915611182639736, -0.02386241716336912, -0.02151999995112419;
 0.9773574285640843, 0.1296244712033597, 0.1672421995067346, -1.111279964447021;
 0, 0, 0, 1]


%% Update this when you do the test (after calibration)
% You may move the Polaris around now.

% G_N_Md 
affine_Md_wrt_polaris =[-0.9971979623064575, -0.01916660736374668, 0.07231089222249212, 0.1331399977207184;
 -0.002812181234079059, -0.9563331510180277, -0.2922652834337954, -0.03342000022530556;
 0.07475503734569058, -0.2916496964272277, 0.9535995695077414, -0.7640900015830994;
 0, 0, 0, 1];

% G_N_Mg 
affine_Mg_wrt_polaris =[0.08185661209184185, 0.05425511005945785, -0.9951662565065608, 0.1062399968504906;
 -0.1852839842912695, 0.9819386170615376, 0.03829356980523078, 0.05116999894380569;
 0.9792697995047118, 0.1812537871486044, 0.09043077143478359, -1.038540005683899;
 0, 0, 0, 1];


% CALCULATE G_Mg_Md 
affine_Md_wrt_Mg = inv(affine_Mg_wrt_polaris) * affine_Md_wrt_polaris;

% G_Mg_Mc
affine_Mc_wrt_Mg =[0.991112743820027, 0.09321135742021028, 0.09490612143280919, 0.372731856252092;
 -0.08888790030467122, 0.9948447031263929, -0.04881554917017025, 0.08437681730407724;
 -0.09896701580306511, 0.03994570701890626, 0.9942886252360505, 0.263487508033087;
 0, 0, 0, 1];

% G_Mc_C
affine_cam_wrt_Mc =  [-0.0365,    0.9991,    0.0221,   -0.0267;
    0.9620,    0.0411,   -0.2698,    0.0011;
   -0.2705,    0.0114,   -0.9627,   -0.0818;
         0,         0,         0,    1.0000];

% G_C_D_l{i}
affine_board_0_0_wrt_l_cam=  [0.9572163575212601, -0.123324357613027, 0.261778432482635, 0.02696784736608578;
 0.09748270041882574, 0.9891890043139568, 0.1095547208632109, -0.03315416118783917;
 -0.272459112552296, -0.07934870234412669, 0.9588898870170227, 0.20443006950197;
 0, 0, 0, 1];



%% Load and Process Data

% Update the path
csv_folder_1 = '20180221_offset_data_01/';

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

small_sphere_origins_line_wrt_poratl_param_1 = result_map_1('small_sphere_origins_line_param_wrt_portal');
small_sphere_line_vec_1 = small_sphere_origins_line_wrt_poratl_param_1.direction;
portal_z = [0; 0; 1]
small_spheres_vec_portal_z_angle = atan2(norm(cross(small_sphere_line_vec_1,portal_z)), dot(small_sphere_line_vec_1,portal_z));

if small_spheres_vec_portal_z_angle > pi/2
    small_spheres_vec_portal_z_angle = pi - small_spheres_vec_portal_z_angle;
end

%%%%%%%%%
disp('dist_portal_s_sphere_ori_line:');
dist = [dist_1];
sprintf('%f', dist)

disp('dist_x_1:');
dist_x = [dist_x_1]; 
sprintf('%f', dist_x)

disp('dist_y_1:');
dist_y = [dist_y_1];
sprintf('%f', dist_y_1)

small_spheres_vec_portal_z_angle
disp('small_spheres_vec_portal_z_angle in degrees:');
sprintf('%f', rad2deg(small_spheres_vec_portal_z_angle))

%% Prismatic/DH2 Frame Rotation Mat (TODO: put into fnc.)

z_temp = small_sphere_line_vec_1/norm(small_sphere_line_vec_1);
dh1_z = [-1; 0; 0]; % is portal -x direction
x_temp = cross(dh1_z,z_temp);
x_temp = x_temp/norm(x_temp);

y_temp = cross(z_temp, x_temp);
DH2_frame_rot_mat_wrt_portal = [(x_temp) (y_temp) (z_temp)];


%% Joint 1 & 2 Circles

% temp_1 = result_map_1('joint_1_param');
% j1_vec = temp_1.vector();
% j1_pt = temp_1.circle(1:3)
% 
% temp_2 = result_map_1('joint_2_param');
% j2_vec = temp_2.vector();
% j2_pt = temp_2.circle(1:3);
% 
% dist_j1_2 = lines_dist(j1_pt, j1_vec, j2_pt, j2_vec)
% 
% angle_j1_2 = atan2(norm(cross(j1_vec, j2_vec)), dot(j1_vec, j2_vec))



%% Generate DH2 param adjustment recommendation

temp_ = result_map_1('small_sphere_origins_line_param_wrt_portal');
DH_d2 = - dist_y_1
DH_theta2 = 0.5*pi - (temp_.direction(2))
DH_a2 = dist_x_1
DH_alpha2 = 0.5*pi -abs(temp_.direction(1))



%% Generate Test Trajectory based on Portal Calibration

output_folder_path = 'Kinematic_calibration_output/';
affine_portal_wrt_polaris_0 = result_map_1('affine_portal_wrt_polaris');
generateTestTrajectory(output_folder_path, affine_Md_wrt_polaris, affine_portal_wrt_polaris_0); % should be updated

% _0_0 means the Pt(0,0) 
affine_Md_wrt_board_0_0 =  [0, -1,  0,    -0.08;
                        0,  0,  1,        0;
                       -1,  0,  0, -0.00877;
                        0,  0,  0,     1];
    
% _2_2 means the Pt(2,2)                    
affine_Md_wrt_board_2_2 =  [0, -1,  0,    -0.11;
                        0,  0,  1,        -0.03;
                       -1,  0,  0, -0.00877;
                        0,  0,  0,     1];                     

% This should be CONST once calibratied no matter how you move the Mg
% later on, meaning you should NOT update the affine_Mg_wrt_polaris!
affine_Mg_wrt_portal_0 = inv(affine_portal_wrt_polaris_0)*affine_Mg_wrt_polaris_0; % Mg is Marker on Green base

% G_Pg_Md:
affine_Md_wrt_portal_via_base_0_0 = affine_Mg_wrt_portal_0 * affine_Md_wrt_Mg * inv(affine_Md_wrt_board_0_0)
affine_Md_wrt_portal_via_base_2_2 = affine_Mg_wrt_portal_0 * affine_Md_wrt_Mg * inv(affine_Md_wrt_board_2_2)

 generate_traj_only_arm(affine_Mg_wrt_portal_0 , affine_Md_wrt_Mg,  affine_Md_wrt_board_0_0)

affine_board_2_2_wrt_board_0_0 = [1 0 0 0.03;
                                  0 1 0 0.03
                                  0 0 1 0; 
                                  0 0 0 1];
                              
affine_board_2_2_wrt_l_cam = affine_board_0_0_wrt_l_cam * affine_board_2_2_wrt_board_0_0;

goal_0_0 = affine_Mg_wrt_portal_0*affine_Mc_wrt_Mg*affine_cam_wrt_Mc*affine_board_0_0_wrt_l_cam*[0;0;0;1]
goal_2_2 = affine_Mg_wrt_portal_0*affine_Mc_wrt_Mg*affine_cam_wrt_Mc*affine_board_2_2_wrt_l_cam*[0;0;0;1]

generate_traj_2(affine_Mg_wrt_portal_0,affine_Mc_wrt_Mg,affine_cam_wrt_Mc,affine_board_0_0_wrt_l_cam)
% output_folder_path = 'Full_calibration_output/';
% affine_portal_wrt_polaris = result_map_1('affine_portal_wrt_polaris');
% generateTestTrajectory(output_folder_path, affine_Md_wrt_polaris, affine_portal_wrt_polaris);
