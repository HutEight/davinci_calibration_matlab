% RN@HMS Prince of Wales
% 10/04/18

%%
clc
close all
clear all

%%
% fill in the blank
file_path = '20180319_psm2_offset_data_01/02_green_sphere_01.csv'
csv = csvread(file_path);

% check if they are correctly numbered.
seq = csv(:, 2);
% should make it represent this much seconds
seq = ((seq - seq(1)) / 100);
raw_pose_x = csv(:, 4);
raw_pose_y = csv(:, 5);
raw_pose_z = csv(:, 6);

raw_points = [seq, raw_pose_x, raw_pose_y, raw_pose_z];
raw_size = size(raw_points,1);

%% 
% fill in start time (second)
time_0 = 5
time_t = time_0 + 1;

for i = 0:99
    
   mask_begin = time_0 + i*10;
   mask_end = time_t + i*10;
   mask = (raw_points(:,1) > mask_begin & raw_points(:,1) < mask_end);
   
   pt_mat_0 = [seq(mask), raw_pose_x(mask), raw_pose_y(mask), raw_pose_z(mask)];
   pt_mat_0(isnan(pt_mat_0(:,2)),:)= [];
   
   pt_mat = [pt_mat_0(:,2), pt_mat_0(:,3), pt_mat_0(:,4)];
   
   x_ave = mean(pt_mat_0(:,2));
   y_ave = mean(pt_mat_0(:,3));
   z_ave = mean(pt_mat_0(:,4));
   
   pts(i+1,:) = [x_ave y_ave z_ave];
    
    
end

