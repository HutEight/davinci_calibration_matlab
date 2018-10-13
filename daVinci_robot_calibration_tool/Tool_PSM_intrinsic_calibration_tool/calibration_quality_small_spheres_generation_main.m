% RN@HMS Queen Elizabeth
% 30/07/18
% Descriptions.
%
% Notes.

% Steps to run the quality test
% 1. You should get the DH paramters from the Intrinsic Calibration. Update
% the Kinematic package with the latest DH parameters.
% 2. Use this programme to get you a playfile that would always ask the
% robot to going to the following joint states.
% 3. Then you should run the psm_intrinsic_calibration_auxiliary.cpp which
% would give you the wrist points in Cartesian space.
% 4. Then you run the data collection programme on the machine which would
% give you their small sphere point clouds.
% 5. Finally you load the .csv files in the calibration_quality_main.m with
% the pasted calculated wrist points from the
% psm_intrinsic_calibration_auxiliary.cpp. You should be able to measure
% the difference.

%% THERE ARE 1 UPDATE POINT1 THAT YOU NEED TO CHECK EVERYTIME YOU RUN THIS PROGRAMME.
% Search for 'checkpoint' to locate it. 

%%
clc
close all
clear all

%% Generate Small Sphere Playfiles

% @ UPDATE CHECKPOINT 1/1
save_file_path = 'Playfiles/20180813_PSM1_intrinsic_1_quality/';


j1 = 0.177;
j2 = -0.132;
j3 = 0.160;
arm_index = 1;
test_index = '1';

generateSmallSpherePlayfile(j1, j2, j3, arm_index, test_index, save_file_path);


j1 = -0.070;
j2 = -0.133;
j3 = 0.158;

test_index = '2';

generateSmallSpherePlayfile(j1, j2, j3, arm_index, test_index, save_file_path);


j1 = 0.179;
j2 = -0.355;
j3 = 0.170 ;

test_index = '3';

generateSmallSpherePlayfile(j1, j2, j3, arm_index, test_index, save_file_path);


j1 = -0.068;
j2 = -0.360;
j3 = 0.167;

test_index = '4';

generateSmallSpherePlayfile(j1, j2, j3, arm_index, test_index, save_file_path);


j1 = 0.144;
j2 = -0.108;
j3 = 0.200;

test_index = '5';

generateSmallSpherePlayfile(j1, j2, j3, arm_index, test_index, save_file_path);


j1 = -0.054;
j2 = -0.109;
j3 = 0.198;

test_index = '6';

generateSmallSpherePlayfile(j1, j2, j3, arm_index, test_index, save_file_path);


j1 = 0.146;
j2 = -0.293;
j3 = 0.208;

test_index = '7';

generateSmallSpherePlayfile(j1, j2, j3, arm_index, test_index, save_file_path);


j1 = -0.052;
j2 = -0.295;
j3 = 0.206;

test_index = '8';

generateSmallSpherePlayfile(j1, j2, j3, arm_index, test_index, save_file_path);

