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


%% Load and Process Data

% Update the path and flags accordingly
csv_folder_1 = 'Data/20180625_PSM2_offset_01/';

arm_index = 2;

plot_flag = 1;

joint_12_flag = 1;

[path_map_1, pt_clds_map_1, pt_mats_map_1] = createGreenRawDataHashTablesShort(csv_folder_1, plot_flag);

[result_map_1] = createPostProcessingTEST(pt_clds_map_1, pt_mats_map_1, joint_12_flag, plot_flag);


