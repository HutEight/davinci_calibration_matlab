% RN@HMS Queen Elizabeth
% 01/08/18
% Description.
%
% Notes.
%

%% THERE ARE 3 UPDATE POINTS THAT YOU NEED TO CHECK EVERYTIME YOU RUN THIS PROGRAMME.
% Search for 'checkpoint' to locate them. 


%%
clc
close all
clear all


%% Load and Process Data

% @ UPDATE CHECKPOINT 2/3
% Update the path and flags accordingly
csv_folder_1 = 'Data/20180801_Sim_intrinsic/';

arm_index = 1;

plot_flag = 1;

load(strcat(csv_folder_1,'j1_arc_mat.mat'), 'j1_arc_mat');
load(strcat(csv_folder_1,'j2_arc_mat.mat'), 'j2_arc_mat');
load(strcat(csv_folder_1,'small_sphere_01_mat.mat'), 'small_sphere_01_mat');
load(strcat(csv_folder_1,'small_sphere_02_mat.mat'), 'small_sphere_02_mat');
load(strcat(csv_folder_1,'small_sphere_03_mat.mat'), 'small_sphere_03_mat');
load(strcat(csv_folder_1,'small_sphere_04_mat.mat'), 'small_sphere_04_mat');

[result_map] = createPostProcessingHashTablesSimulation(j1_arc_mat, j2_arc_mat, small_sphere_01_mat, ...
    small_sphere_02_mat, small_sphere_03_mat, small_sphere_04_mat, ...
    plot_flag, csv_folder_1)

