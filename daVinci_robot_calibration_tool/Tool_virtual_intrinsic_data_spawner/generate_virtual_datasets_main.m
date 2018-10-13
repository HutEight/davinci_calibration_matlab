% RN@HMS Queen Elizabeth
% 01/08/18
% Descriptions.
%
% Notes.
% 1. All the generated points are in Robot Base Frame. Or you may think of
% that the Polaris frame is overlapping the base frame. 
% 2. The main programme to run the analysis of the generated data is in the
% PSM_intrinsic_calibration_tool directory.

%% THERE ARE 2 UPDATE POINTS THAT YOU NEED TO CHECK EVERYTIME YOU RUN THIS PROGRAMME.
% Search for 'checkpoint' to locate them. 


%%
clc
close all
clear all


%% User defined DH parameters.
% @ UPDATE CHECKPOINT 1/2
% Update the DH parameters.

a_1 = 0.0053;
% a_1 = 0.0;
d_1 = 0.0000; 
a_2 = 0.0008; 
d_2 = -0.0029; 
d_3 = -0.0087; 
% d_3 = -0.0;
j3_scale_factor = 0.9888;
% j3_scale_factor = 1;

% Assuming --
% theta_1 = pi
% alpha_1 = -pi/2
% theta_2 = -pi/2
% alpha_2 = pi/2

% @ UPDATE CHECKPOINT 2/2
% Update save folder.
save_file_path = "../Tool_PSM_intrinsic_calibration_tool/Data/20180801_Sim_intrinsic/";

%% Initialisation

% This is the point where the marker would be when J1 and J2 are both home
% (0). 
pt_0 = [0.01; 0.03; -0.20];


%% Generate J1&2+ Arc data

% Dist between pt_0 and z_0, or J1. 
j1_arc_radius = sqrt(pt_0(1)^2 +pt_0(3)^2); 
% Dist between pt_0 and z_1, or J2. 
j2_arc_radius = sqrt(pt_0(2)^2 + (abs(pt_0(3))+a_1)^2);

j1_arc_centre = [0; pt_0(2); 0];
j2_arc_centre = [pt_0(1); 0; a_1];

j1_vec = [0; -1; 0];
j2_vec = [-1; 0; 0];

j1_angle_1 = pi/2;
j1_angle_2 = -pi/2;
j1_arc_mat = generateArcMat(j1_vec, j1_arc_centre, j1_arc_radius, pt_0, j1_angle_1, j1_angle_2);

j2_angle_1 = 2*pi/5;
j2_angle_2 = -2*pi/5;
j2_arc_mat = generateArcMat(j2_vec, j2_arc_centre, j2_arc_radius, pt_0, j2_angle_1, j2_angle_2);

% figure('name', 'Simulated J1 and J2 Arcs')
% scatter3(j1_arc_mat(:,1), j1_arc_mat(:,2), j1_arc_mat(:,3), '.')
% hold on;
% scatter3(j2_arc_mat(:,1), j2_arc_mat(:,2), j2_arc_mat(:,3), '.')
% scatter3(pt_0(1), pt_0(2), pt_0(3), 'filled');
% axis equal;
% hold off;

filename = strcat(save_file_path, 'j1_arc_mat.mat');
save(filename, 'j1_arc_mat')
filename = strcat(save_file_path, 'j2_arc_mat.mat');
save(filename, 'j2_arc_mat')

%% Generate Small sphere data
% Small sphere radius
radius = 0.03;

% O_3 is the origin of the DH frame_3 which is attached to the wrist bend.
O_3 = [-d_2; -a_2; (a_1-d_3)]
q_3 = 0.05;
origin_1 = O_3 + [0; 0; -q_3*j3_scale_factor]
small_sphere_01_mat = generateSmallSphereMat(origin_1, radius);
m_size = size(small_sphere_01_mat,1);
start = int16(0.01*m_size)
finish = int16(0.4*m_size)
small_sphere_01_mat = small_sphere_01_mat(start:finish,:);

q_3 = 0.11;
origin_2 = O_3 + [0; 0; -q_3*j3_scale_factor]
small_sphere_02_mat = generateSmallSphereMat(origin_2, radius);
m_size = size(small_sphere_02_mat,1);
start = int16(0.01*m_size)
finish = int16(0.4*m_size)
small_sphere_02_mat = small_sphere_02_mat(start:finish,:);


q_3 = 0.17;
origin_3 = O_3 + [0; 0; -q_3*j3_scale_factor]
small_sphere_03_mat = generateSmallSphereMat(origin_3, radius);
m_size = size(small_sphere_03_mat,1);
start = int16(0.01*m_size)
finish = int16(0.4*m_size)
small_sphere_03_mat = small_sphere_03_mat(start:finish,:);


q_3 = 0.23;
origin_4 = O_3 + [0; 0; -q_3*j3_scale_factor]
small_sphere_04_mat = generateSmallSphereMat(origin_4, radius);
m_size = size(small_sphere_04_mat,1);
start = int16(0.01*m_size)
finish = int16(0.4*m_size)
small_sphere_04_mat = small_sphere_04_mat(start:finish,:);


filename = strcat(save_file_path, 'small_sphere_01_mat.mat');
save(filename, 'small_sphere_01_mat')
filename = strcat(save_file_path, 'small_sphere_02_mat.mat');
save(filename, 'small_sphere_02_mat')
filename = strcat(save_file_path, 'small_sphere_03_mat.mat');
save(filename, 'small_sphere_03_mat')
filename = strcat(save_file_path, 'small_sphere_04_mat.mat');
save(filename, 'small_sphere_04_mat')


figure('name', 'Small spberes')
scatter3(small_sphere_01_mat(:,1), small_sphere_01_mat(:,2), small_sphere_01_mat(:,3), '.')
hold on;
scatter3(0,0,0,'filled','black');
axis equal;
scatter3(small_sphere_02_mat(:,1), small_sphere_02_mat(:,2), small_sphere_02_mat(:,3), '.')
scatter3(small_sphere_03_mat(:,1), small_sphere_03_mat(:,2), small_sphere_03_mat(:,3), '.')
scatter3(small_sphere_04_mat(:,1), small_sphere_04_mat(:,2), small_sphere_04_mat(:,3), '.')
scatter3(j1_arc_mat(:,1), j1_arc_mat(:,2), j1_arc_mat(:,3), '.')
scatter3(j2_arc_mat(:,1), j2_arc_mat(:,2), j2_arc_mat(:,3), '.')
hold off;
