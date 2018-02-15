clc
close all
clear all


%% Loading data
csv_folder = 'old_fashion_data/20180213_03/'; % Modify this everytime
joint_1_arc_file = strcat(csv_folder, '1_g.csv')
joint_2_arc_file = strcat(csv_folder, '2_g.csv')
sphere_file = strcat(csv_folder, 'sphere_g.csv')

[joint_1_arc_cld, joint_1_arc_mat] = load_csv_data(joint_1_arc_file)
[joint_2_arc_cld, joint_2_arc_mat] = load_csv_data(joint_2_arc_file)
[sphere_cld, sphere_mat] = load_csv_data(sphere_file)

pcshow(sphere_cld);

%% Fittings

[plane_1_param, plane_2_param, fval_1, rot_mat] = davinci_planes_fit(joint_1_arc_mat, joint_2_arc_mat);

plane_1_param = plane_1_param/norm(plane_1_param(1:3));
plane_2_param = plane_2_param/norm(plane_2_param(1:3));

portal_x_axis = plane_2_param(1:3);
portal_y_axis = plane_1_param(1:3);
portal_z_axis = cross(portal_x_axis, portal_y_axis);
portal_rotation_wrt_polaris = [transpose(portal_x_axis) transpose(portal_y_axis) transpose(portal_z_axis)];

if portal_rotation_wrt_polaris(2,1) > 0
    portal_rotation_wrt_polaris(:,1) = - portal_rotation_wrt_polaris(:,1);
end
if portal_rotation_wrt_polaris(3,2) < 0
    portal_rotation_wrt_polaris(:,2) = - portal_rotation_wrt_polaris(:,2);
end
if portal_rotation_wrt_polaris(1,3) > 0
    portal_rotation_wrt_polaris(:,3) = - portal_rotation_wrt_polaris(:,3);
end

[sphere_param, residuals] = davinci_sphere_fit_least_square(sphere_mat);

portal_origin_wrt_polaris = [sphere_param(1); 
    sphere_param(2);
    sphere_param(3)];

affine_portal_wrt_polaris = zeros(4,4);
affine_portal_wrt_polaris(4,4) = 1;
affine_portal_wrt_polaris(1:3,1:3) = portal_rotation_wrt_polaris;
affine_portal_wrt_polaris(1:3,4) = transpose(portal_origin_wrt_polaris);

%% Extra TF
affine_Md_wrt_board =  [0, -1,  0,    -0.08;
                        0,  0,  1,        0;
                       -1,  0,  0, -0.00877;
                        0,  0,  0,     1];
                    
affine_Md_wrt_board_2 =  [0, -1,  0,    -0.095;
                        0,  0,  1,        0;
                       -1,  0,  0, -0.00877;
                        0,  0,  0,     1];  
                    
affine_Md_wrt_board_3 =  [0, -1,  0,    -0.11;
                        0,  0,  1,        0;
                       -1,  0,  0, -0.00877;
                        0,  0,  0,     1]; 
                    
affine_Md_wrt_board_4 =  [0, -1,  0,    -0.125;
                        0,  0,  1,        0;
                       -1,  0,  0, -0.00877;
                        0,  0,  0,     1]; 
                    
affine_Md_wrt_board_5 =  [0, -1,  0,    -0.14;
                        0,  0,  1,        0;
                       -1,  0,  0, -0.00877;
                        0,  0,  0,     1];                     

affine_Md_wrt_board_6 =  [0, -1,  0,    -0.155;
                        0,  0,  1,        0;
                       -1,  0,  0, -0.00877;
                        0,  0,  0,     1];                     
                    
%% Update this every time    
% G_N_Md
affine_Md_wrt_polaris =[-0.9903664507460902, 0.08056744902336488, 0.112619622599525, 0.06089000031352043;
 -0.006030209524304879, -0.8376291184738702, 0.5462060933912949, -0.05192999914288521;
 0.1383399067864545, 0.5402650701670009, 0.8300456157029933, -0.7827799916267395;
 0, 0, 0, 1];



%% TF calculation

% affine_Md_wrt_portal = affine_polaris_wrt_portal * affine_Md_wrt_polaris
affine_Md_wrt_portal = inv(affine_portal_wrt_polaris)*affine_Md_wrt_polaris;

% affine_board_wrt_portal = affine_Md_wrt_portal * affine_board_wrt_Md
affine_board_wrt_portal = affine_Md_wrt_portal * inv(affine_Md_wrt_board);

affine_board_2_wrt_portal = affine_Md_wrt_portal * inv(affine_Md_wrt_board_2);
affine_board_3_wrt_portal = affine_Md_wrt_portal * inv(affine_Md_wrt_board_3);
affine_board_4_wrt_portal = affine_Md_wrt_portal * inv(affine_Md_wrt_board_4);
affine_board_5_wrt_portal = affine_Md_wrt_portal * inv(affine_Md_wrt_board_5);
affine_board_6_wrt_portal = affine_Md_wrt_portal * inv(affine_Md_wrt_board_6);

%% Extracted Target Point

target = [affine_board_wrt_portal(1,4), affine_board_wrt_portal(2,4), affine_board_wrt_portal(3,4), 0,1,0, 0,0,-1,0,0,0,-0.05,0,1,0,0,0,-1,0,5]

fprintf('%f, %f, %f, 0,1,0, 0,0,-1,0,0,0,-0.05,0,1,0,0,0,-1,0,15      \n', ...
    affine_board_wrt_portal(1,4), affine_board_wrt_portal(2,4), affine_board_wrt_portal(3,4))
fprintf('%f, %f, %f, 0,1,0, 0,0,-1,0,0,0,-0.05,0,1,0,0,0,-1,0,25      \n', ...
    affine_board_2_wrt_portal(1,4), affine_board_2_wrt_portal(2,4), affine_board_2_wrt_portal(3,4))
fprintf('%f, %f, %f, 0,1,0, 0,0,-1,0,0,0,-0.05,0,1,0,0,0,-1,0,25      \n', ...
    affine_board_3_wrt_portal(1,4), affine_board_3_wrt_portal(2,4), affine_board_3_wrt_portal(3,4))
fprintf('%f, %f, %f, 0,1,0, 0,0,-1,0,0,0,-0.05,0,1,0,0,0,-1,0,25      \n', ...
    affine_board_4_wrt_portal(1,4), affine_board_4_wrt_portal(2,4), affine_board_4_wrt_portal(3,4))
fprintf('%f, %f, %f, 0,1,0, 0,0,-1,0,0,0,-0.05,0,1,0,0,0,-1,0,25      \n', ...
    affine_board_5_wrt_portal(1,4), affine_board_5_wrt_portal(2,4), affine_board_5_wrt_portal(3,4))
fprintf('%f, %f, %f, 0,1,0, 0,0,-1,0,0,0,-0.05,0,1,0,0,0,-1,0,25      \n', ...
    affine_board_6_wrt_portal(1,4), affine_board_6_wrt_portal(2,4), affine_board_6_wrt_portal(3,4))
