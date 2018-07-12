% RN@HMS Prince of Wales
% 12/07/18
% Description.
%
% Notes.
%

%%
clc
close all
clear all

%% Load and Process Data

% Update the path and flags accordingly
csv_folder_1 = 'Data/20180625_PSM2_offset_01/';

arm_index = 2;

plot_flag = 1;

joint_12_flag = 1;

[path_map_1, pt_clds_map_1, pt_mats_map_1] = createRawDataHashTables(csv_folder_1, plot_flag);

% [result_map_1] = createPostProcessingHashTables(pt_clds_map_1, pt_mats_map_1, joint_12_flag, plot_flag, csv_folder_1);
[result_map] = createPostProcessingHashTables(pt_clds_map_1, pt_mats_map_1, plot_flag, csv_folder_1)



