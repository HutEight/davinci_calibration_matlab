% RN@HMS Queen Elizabeth
% 08/05/18

%% THERE ARE 1 UPDATE POINT1 THAT YOU NEED TO CHECK EVERYTIME YOU RUN THIS PROGRAMME.


%%
clc
close all
clear all

%%

FolderDir = 'Data/20180621_03/';

% UPDATE CHECKPOINT 1/1
psm1_file_path = strcat(FolderDir, 'green_evaluation.csv')
psm2_file_path = strcat(FolderDir, 'yellow_evaluation.csv')

%% PSM1
csv = csvread(psm1_file_path);

% check if they are correctly numbered.
seq = csv(:, 6);
% should make it represent this much seconds
seq = ((seq - seq(1)) / 1);
raw_pose_x = csv(:, 3);
raw_pose_y = csv(:, 4);
raw_pose_z = csv(:, 5);

raw_points = [seq, raw_pose_x, raw_pose_y, raw_pose_z];
raw_size = size(raw_points,1);

%% 
% fill in start time (second) Needs adjustment each time
time_0 = 12.5; % Use 12.5 for some reason... Not 10
time_t = time_0 + 0.5; % take 1 sec of samples equvilent of 20 pts
peroid = 8; % 2 + 2 seconds

% Size of data
n_pts = 20; 

for i = 0:(n_pts-1)
    
   mask_begin = time_0 + i*peroid;
   mask_end = time_t + i*peroid;
   mask = (raw_points(:,1) > mask_begin & raw_points(:,1) < mask_end);
   
   pt_mat_0 = [seq(mask), raw_pose_x(mask), raw_pose_y(mask), raw_pose_z(mask)];
   pt_mat_0(isnan(pt_mat_0(:,2)),:)= [];
   
   pt_mat = [pt_mat_0(:,2), pt_mat_0(:,3), pt_mat_0(:,4)];
   
   x_ave = mean(pt_mat_0(:,2));
   y_ave = mean(pt_mat_0(:,3));
   z_ave = mean(pt_mat_0(:,4));
   
   pms1_test_pts(i+1,:) = [x_ave y_ave z_ave];
    
    
end

% save('psm2_pts_Polaris_cube.mat', 'psm2_pts_Polaris_cube');

%% Visualise the points

figure('Name','PSM1--Please check the waypoints are correct');
axis equal;
scatter3(pms1_test_pts(:,1), pms1_test_pts(:,2), pms1_test_pts(:,3), 'filled','r');
hold on;
scatter3(raw_points(:,2), raw_points(:,3), raw_points(:,4), '.', 'c');
axis equal;
hold off;
% 
%%%%%%%%%%%%%%%%%%%%
%% PSM2
csv = csvread(psm2_file_path);

% check if they are correctly numbered.
seq = csv(:, 6);
% should make it represent this much seconds
seq = ((seq - seq(1)) / 1);
raw_pose_x = csv(:, 3);
raw_pose_y = csv(:, 4);
raw_pose_z = csv(:, 5);

raw_points = [seq, raw_pose_x, raw_pose_y, raw_pose_z];
raw_size = size(raw_points,1);

%% 
% fill in start time (second) Needs adjustment each time
time_0 = 12.5; % Use 12.5 for some reason... Not 10
time_t = time_0 + 0.5; % take 1 sec of samples equvilent of 20 pts
peroid = 8; % 2 + 2 seconds

% Size of data
n_pts = 20; 

for i = 0:(n_pts-1)
    
   mask_begin = time_0 + i*peroid;
   mask_end = time_t + i*peroid;
   mask = (raw_points(:,1) > mask_begin & raw_points(:,1) < mask_end);
   
   pt_mat_0 = [seq(mask), raw_pose_x(mask), raw_pose_y(mask), raw_pose_z(mask)];
   pt_mat_0(isnan(pt_mat_0(:,2)),:)= [];
   
   pt_mat = [pt_mat_0(:,2), pt_mat_0(:,3), pt_mat_0(:,4)];
   
   x_ave = mean(pt_mat_0(:,2));
   y_ave = mean(pt_mat_0(:,3));
   z_ave = mean(pt_mat_0(:,4));
   
   pms2_test_pts(i+1,:) = [x_ave y_ave z_ave];
    
    
end

% save('psm2_pts_Polaris_cube.mat', 'psm2_pts_Polaris_cube');

%% Visualise the points

figure('Name','PSM2--Please check the waypoints are correct');
axis equal;
scatter3(pms2_test_pts(:,1), pms2_test_pts(:,2), pms2_test_pts(:,3), 'filled','r');
hold on;
scatter3(raw_points(:,2), raw_points(:,3), raw_points(:,4), '.', 'c');
axis equal;
hold off;
% 





%%%%%%%%%%%%%%%%%%%%%%%%%555
%% COMPARISON

figure('Name','PSM1 & PSM2');
axis equal;
scatter3(pms1_test_pts(:,1), pms1_test_pts(:,2), pms1_test_pts(:,3), 'o');
hold on;
scatter3(pms2_test_pts(:,1), pms2_test_pts(:,2), pms2_test_pts(:,3), '+');
axis equal;
hold off;

% rms
err = pms1_test_pts - pms2_test_pts;
err = err .* err;
err_mat = err;
err_mat = sum(err_mat, 2);
err_mat = sqrt(err_mat);
err = sum(err(:));
rms = sqrt(err/n_pts);


vpa(rms,5)

