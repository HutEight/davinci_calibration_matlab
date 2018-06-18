% RN@HMS Queen Elizabeth
% 16/02/18
% Notes.
% 1. Remember to update data patha and G_N_Md each time you use this code.

%% TODO

% Add logs


%%
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


affine_Mg_wrt_polaris_0 = [-0.9950474452554561, 0.03132691006328234, 0.09433560513653934, 0.06417000293731689;
 -0.0224351999524803, -0.9953303919126966, 0.09388329317833911, -0.05922000110149384;
 0.09683616831371571, 0.09130189286539885, 0.9911037891490029, -1.003489971160889;
 0, 0, 0, 1];



%% Update this when you do the test (after calibration)
% You may move the Polaris around now if you had affine_Mg_wrt_polaris_0 in
% the case you are trying to include the camera calibration. If you are
% testing the PSM intrinsic calibration and you did not record
% affine_Mg_wrt_polaris_0, do NOT move the Polaris and make sure you update
% affine_Md_wrt_polaris, which is to be used later in
% generateTestTrajectory().

% G_N_Md 
affine_Md_wrt_polaris = [-0.9950474452554561, 0.03132691006328234, 0.09433560513653934, 0.06417000293731689;
 -0.0224351999524803, -0.9953303919126966, 0.09388329317833911, -0.05922000110149384;
 0.09683616831371571, 0.09130189286539885, 0.9911037891490029, -1.003489971160889;
 0, 0, 0, 1];



% G_N_Mg 
affine_Mg_wrt_polaris =[0.0616624727435364, 0.03545504221313599, -0.997467132008277, 0.06797999888658524;
 0.01331222765540441, 0.9992507632764435, 0.03634139081399927, -0.02954000048339367;
 0.9980082785478303, -0.01551940956060793, 0.0611442873610184, -1.114820003509521;
 0, 0, 0, 1];

affine_Mg_wrt_polaris = affine_Mg_wrt_polaris_0;

% CALCULATE G_Mg_Md 
affine_Md_wrt_Mg = inv(affine_Mg_wrt_polaris) * affine_Md_wrt_polaris;

% G_Mg_Mc %%%%%
affine_Mc_wrt_Mg =[0.9751210039953122, -0.2129685514702668, 0.06150954114469739, 0.3656448769917271;
 0.2160179235300739, 0.9752065637892446, -0.04804596399417806, 0.1192484829782082;
 -0.04975222890414077, 0.06013779200329063, 0.996949427850801, 0.2613900587791926;
 0, 0, 0, 1];

G_N_Mc =[0.1390825460759876, -0.04608224808746043, -0.9892080022867923, -0.1577499955892563;
 0.2523177460703755, 0.9675968178448507, -0.009599641372682932, 0.1133799999952316;
 0.9575968882546487, -0.2482595909682532, 0.1462031979721693, -0.7352399826049805;
 0, 0, 0, 1];

G_Mg_Mc = inv(affine_Mg_wrt_polaris_0)*G_N_Mc;

affine_Mc_wrt_Mg = G_Mg_Mc;

%%%%%%%%%%%%%%%%

% G_Mc_C
affine_cam_wrt_Mc =  [    0.1257 ,   0.9916,   -0.0297,   -0.0249;
    0.9517,   -0.1289,   -0.2786,   0.0035;
   -0.2801,    0.0068,   -0.9600,   -0.0815;
         0,         0,         0,    1.0000];

% G_C_D_l{i}
affine_board_0_0_wrt_l_cam=  [0.9561741343482142, -0.1290208309114619, 0.2628395898535059, 0.003779272020672593;
 0.1048365137839022, 0.9890255019323342, 0.1041050522555558, -0.02792801050112032;
 -0.2733867776266454, -0.07198737193709934, 0.9592066972767177, 0.1969084856112268;
 0, 0, 0, 1];


%% Load and Process Data

% Update the path and flags accordingly
csv_folder_1 = 'Data/20180618_PSM2_offset_03/';

arm_index = 2;

plot_flag = 1;

joint_12_flag = 0;

[path_map_1, pt_clds_map_1, pt_mats_map_1] = createGreenRawDataHashTablesShort(csv_folder_1, plot_flag);

[result_map_1] = createPostProcessingHashTablesShort(pt_clds_map_1, pt_mats_map_1, joint_12_flag, plot_flag);


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

dist_x_1 = lines_dist(portal_1, x_vec_1, small_sphere_pt_1, small_sphere_line_vec_1, 'dist_x_1');
dist_y_1 = lines_dist(portal_1, y_vec_1, small_sphere_pt_1, small_sphere_line_vec_1, 'dist_y_1');

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
% Comment out if not used
if (joint_12_flag == 1)
    
    temp_1 = result_map_1('joint_1_param');
    j1_vec = temp_1.vector();
    j1_pt = temp_1.circle(1:3)

    temp_2 = result_map_1('joint_2_param');
    j2_vec = temp_2.vector();
    j2_pt = temp_2.circle(1:3);

    dist_j1_2 = lines_dist(j1_pt, j1_vec, j2_pt, j2_vec, 'dist_j1_2')

    angle_j1_2 = atan2(norm(cross(j1_vec, j2_vec)), dot(j1_vec, j2_vec))

end 


%% Generate DH2 param adjustment recommendation

temp_ = result_map_1('small_sphere_origins_line_param_wrt_portal');

DH_d2 = - dist_y_1
DH_theta2 = 0.5*pi - (temp_.direction(2))
DH_a2 = dist_x_1
DH_alpha2 = 0.5*pi -abs(temp_.direction(1))



%% Generate Test Trajectory based on Portal Calibration

output_folder_path = 'Kinematic_calibration_board_playfile_output/';
affine_portal_wrt_polaris_0 = result_map_1('affine_portal_wrt_polaris');
generateTestTrajectory(output_folder_path, arm_index, affine_Md_wrt_polaris, affine_portal_wrt_polaris_0); % should be updated

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
