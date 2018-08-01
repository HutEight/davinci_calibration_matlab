% RN@HMS Queen Elizabeth
% 30/07/18
% Descriptions.
%
% Notes.


%%
clc
close all
clear all

%% Generate Small Sphere Playfiles

save_file_path = 'Qulaity_test_small_spheres/';
j1 = 0.177442;
j2 = -0.132006;
j3 = 0.160757;
arm_index = 1;
test_index = '1';
% affine_wrist_wrt_base: 
% 0.0268252 0.0175642  -0.14112
generateSmallSpherePlayfile(j1, j2, j3, arm_index, test_index, save_file_path);


j1 = -0.0705975;
j2 = -0.133879;
j3 = 0.15827;
arm_index = 1;
test_index = '2';
% affine_wrist_wrt_base: 
% -0.00844263   0.0175283   -0.140923
generateSmallSpherePlayfile(j1, j2, j3, arm_index, test_index, save_file_path);


j1 = 0.179779;
j2 = -0.355985;
j3 = 0.170062 ;
arm_index = 1;
test_index = '3';
% affine_wrist_wrt_base: 
% 0.0269933 0.0533732 -0.142126
generateSmallSpherePlayfile(j1, j2, j3, arm_index, test_index, save_file_path);


j1 = -0.0682173;
j2 = -0.360812;
j3 = 0.167706;
arm_index = 1;
test_index = '4';
% affine_wrist_wrt_base: 
% -0.00852877   0.0532858   -0.141967
generateSmallSpherePlayfile(j1, j2, j3, arm_index, test_index, save_file_path);


j1 = 0.144435;
j2 = -0.10812;
j3 = 0.200429;
arm_index = 1;
test_index = '5';
% affine_wrist_wrt_base: 
% 0.0274391 0.0180221 -0.180974
generateSmallSpherePlayfile(j1, j2, j3, arm_index, test_index, save_file_path);


j1 = -0.0545546;
j2 = -0.109107;
j3 = 0.198428;
arm_index = 1;
test_index = '6';
% affine_wrist_wrt_base: 
% -0.00874929   0.0180031   -0.180845
generateSmallSpherePlayfile(j1, j2, j3, arm_index, test_index, save_file_path);


j1 = 0.146338;
j2 = -0.293052;
j3 = 0.20814;
arm_index = 1;
test_index = '7';
% affine_wrist_wrt_base: 
% 0.0275624 0.0545145  -0.18175
generateSmallSpherePlayfile(j1, j2, j3, arm_index, test_index, save_file_path);


j1 = -0.052625;
j2 = -0.295687;
j3 = 0.20621;
arm_index = 1;
test_index = '8';
% affine_wrist_wrt_base: 
% -0.0087818  0.0544665  -0.181643
generateSmallSpherePlayfile(j1, j2, j3, arm_index, test_index, save_file_path);

