% RN@HMS Queen Elizabeth
% 16/04/18

%%
clc
close all
clear all

%%
% fill in the blank
file_path = '20180507_frozen_data_01/yellow_frozen.csv'
csv = csvread(file_path);

% check if they are correctly numbered.
seq = csv(:, 6);
% should make it represent this much seconds
seq = ((seq - seq(1)) / 1);
raw_pose_x = csv(:, 3);
raw_pose_y = csv(:, 4);
raw_pose_z = csv(:, 5);

raw_points = [seq, raw_pose_x, raw_pose_y, raw_pose_z];
raw_size = size(raw_points,1);

figure('Name','Polaris Points');
axis equal;
scatter3(raw_points(:,2), raw_points(:,3), raw_points(:,4), 'filled');
hold off;

%% 
% fill in start time (second) Needs adjustment each time
time_0 = 12.5; % Use 12.5 for some reason... Not 10
time_t = time_0 + 0.5; % take 1 sec of samples equvilent of 20 pts
peroid = 4; % 2 + 2 seconds

% Size of data: from a cube of 5x5x5
length = 7;
n_pts = length*length*length; 

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
   
   psm2_pts_Polaris_cube(i+1,:) = [x_ave y_ave z_ave];
    
    
end

save('psm2_pts_Polaris_cube.mat', 'psm2_pts_Polaris_cube');


%% Fit planes and plot
figure('Name','Polaris Points Plane Fitted');
axis equal;
hold on;
for i=1:length
    
    pm = plane(psm2_pts_Polaris_cube((length^0 + (i-1)*(length^2)):(length^2 + (i-1)*(length^2)),1), ...
               psm2_pts_Polaris_cube((length^0 + (i-1)*(length^2)):(length^2 + (i-1)*(length^2)),2), ...
               psm2_pts_Polaris_cube((length^0 + (i-1)*(length^2)):(length^2 + (i-1)*(length^2)),3)); 
    
    a = pm.Parameters(1);
    b = pm.Parameters(2);
    c = pm.Parameters(3);
    d = pm.Parameters(4);
    
    % RMS
    for n = 1:(length^2)

        dist_square = ((a*psm2_pts_Polaris_cube(n,1)+b*psm2_pts_Polaris_cube(n,2)+c*psm2_pts_Polaris_cube(n,3)+d)^2)/(a^2 + b^2 + c^2);
        
    end
    
    rms(i) = sqrt(dist_square/length^2);
    scatter3(psm2_pts_Polaris_cube(:,1), psm2_pts_Polaris_cube(:,2), psm2_pts_Polaris_cube(:,3), 'filled');

    axis equal;
    pm.plot;
end
axis equal;
hold off;

disp('plane rms:');
rms

%% Visualise the points

figure('Name','Polaris Points');
axis equal;
scatter3(psm2_pts_Polaris_cube(:,1), psm2_pts_Polaris_cube(:,2), psm2_pts_Polaris_cube(:,3), 'filled');
axis equal;
hold off;
% 




% figure('Name', 'Distribution of plane fitting errors');
% histfit(rms);
% hold off;