% RN@HMS Queen Elizabeth
% 07/08/18
% Description.
%
% Notes.
%


%%
clc
close all
clear all


%%
% @ UPDATE CHECKPOINT 1/1
file_path = 'Data/20180807_cam_fwd_kin/';

file_name = 'first_detection.csv';

csv = csvread(strcat(file_path, file_name));

base_frame_pts = [csv(:,1) csv(:,2) csv(:,3)]; % 11x7x2 cm3
cam_frame_pts = [csv(:,4) csv(:,5) csv(:,6)];

data_size = size(base_frame_pts, 1);



%% Cluster cam_frame_pts to get rid of bad data points (FAILED)
% n_cluster = 2;
% [centers,U] = fcm(cam_frame_pts, n_cluster);
% 
% maxU = max(U);
% 
% for i = 1:n_cluster
%     
%     index{i} = find(U(i,:) == maxU);
%     
% end
% 
% figure
% scatter3(cam_frame_pts(cell2mat(index(1)),1),cam_frame_pts(cell2mat(index(1)),2), cam_frame_pts(cell2mat(index(1)),3))
% hold off
% for i = 2:n_cluster
%     figure
%     scatter3(cam_frame_pts(cell2mat(index(i)),1),cam_frame_pts(cell2mat(index(i)),2), cam_frame_pts(cell2mat(index(i)),3))
% end
% hold off
% 
% C = subclust(cam_frame_pts,0.1)
% figure
% scatter3(cam_frame_pts(:,1), cam_frame_pts(:,2), cam_frame_pts(:,3), '.')
% hold on
% scatter3(C(1,1),C(1,2),C(1,3),'filled')
% scatter3(C(2,1),C(2,2),C(2,3),'filled')
% % scatter3(C(3,1),C(3,2),C(3,3),'filled')
% hold off

%% Take some sample points from both set and establish a coarse transform
% To make sure that cam sample points are valid, we need to calulcate the
% distance between those sample points to make sure they agree with the
% base frame sample points regarding dimension.

verified = 0;
trial_count = 0;
sample_size = 16;
while (verified == 0)
    
    index_sample = rand(sample_size,1);
    index_smaple = floor(index_sample*data_size) + 1;
    base_sample_pts = base_frame_pts(index_smaple,:);
    cam_sample_pts = cam_frame_pts(index_smaple,:);
    
    %% Finding the coarse tf
    % may need to inverse psm1_pts_generated_cube
    % rigid_transform_3D(target, source)
    [base_wrt_cam_rot, base_wrt_cam_trans] = rigid_transform_3D(base_sample_pts, cam_sample_pts);
    % Getting PSM1 base wrt Polaris tf

    % error analysis
    % Transforming PSM1 base pt into Polaris frame pt
    % psm1_ret_R, psm1_ret_t: PSM1 wrt Polaris
    cam_pts_filtered_converted_from_base = (base_wrt_cam_rot*base_sample_pts') + repmat(base_wrt_cam_trans, 1 ,sample_size);
    cam_pts_filtered_converted_from_base = cam_pts_filtered_converted_from_base';

    % Comparing them in the Polaris frame
    err = cam_pts_filtered_converted_from_base - cam_sample_pts;
    err = err .* err; % element-wise multiply
    err_mat = err;
    err_mat = sum(err_mat, 2);
    err_mat = sqrt(err_mat);
    err = sum(err(:));
    rmse = sqrt(err/sample_size);
    
    if (rmse < 0.005)
        disp('Coarse Transform Established');
        rmse
        
        verified = 1;
        
        coarse_affine_base_wrt_cam(1:3, 1:3) = base_wrt_cam_rot;
        coarse_affine_base_wrt_cam(1:3, 4) = base_wrt_cam_trans(:);
        coarse_affine_base_wrt_cam(4, :) = [0 0 0 1];
        
        coarse_affine_base_wrt_cam
        
        figure('name', 'Sample Points for Coarse Transform I (Camera Pt samples and converted Base Pt Samples)')
        scatter3(cam_pts_filtered_converted_from_base(:,1),cam_pts_filtered_converted_from_base(:,2),cam_pts_filtered_converted_from_base(:,3));
        hold on;
        scatter3(cam_sample_pts(:,1),cam_sample_pts(:,2),cam_sample_pts(:,3));
        axis equal;
        hold off;
        
        figure('name', 'Sample Points for Coarse Transform II (All Cam Points)')
        scatter3(cam_frame_pts(:,1),cam_frame_pts(:,2),cam_frame_pts(:,3), '.');
        hold on;
        scatter3(cam_sample_pts(:,1),cam_sample_pts(:,2),cam_sample_pts(:,3), 'filled', 'green');
        hold off;
   
        figure('name', 'Sample Points for Coarse Transform III (All Base Points)')
        scatter3(base_frame_pts(:,1),base_frame_pts(:,2),base_frame_pts(:,3), '.');
        hold on;
        scatter3(base_sample_pts(:,1),base_sample_pts(:,2),base_sample_pts(:,3), 'filled', 'green');
        axis equal;
        hold off;        
        
    end
    
    trial_count = trial_count + 1;
end

%% Use the Coarse Transform to filter out the invalid/bad camera points

% Make all Base frame points converted to cam frame
cam_frame_pts_converted_from_base = (coarse_affine_base_wrt_cam(1:3,1:3)*base_frame_pts') ...
    + repmat(coarse_affine_base_wrt_cam(1:3,4), 1 ,data_size);
cam_frame_pts_converted_from_base = transpose(cam_frame_pts_converted_from_base);

% Calculate the correspoinding points dist

diff_vec = cam_frame_pts_converted_from_base - cam_frame_pts;
dist_vec = vecnorm(transpose(diff_vec));
dist_vec = dist_vec(:);

% Get rid of those with too much error 
err_tolerance = 0.02;

mask = (dist_vec < err_tolerance);
cam_frame_pts_x = cam_frame_pts(:,1);
cam_frame_pts_y = cam_frame_pts(:,2);
cam_frame_pts_z = cam_frame_pts(:,3);
base_frame_pts_x = base_frame_pts(:,1);
base_frame_pts_y = base_frame_pts(:,2);
base_frame_pts_z = base_frame_pts(:,3);

cam_frame_pts_filtered = [cam_frame_pts_x(mask) cam_frame_pts_y(mask) cam_frame_pts_z(mask)];
base_frame_pts_filtered = [base_frame_pts_x(mask) base_frame_pts_y(mask) base_frame_pts_z(mask)];

filtered_data_size = size(cam_frame_pts_filtered,1);

valid_pt_ratio = filtered_data_size/data_size

% Inspect Filtered Result

figure('name', 'Data Filter I (Base Frame Points)')
scatter3(base_frame_pts(:,1),base_frame_pts(:,2),base_frame_pts(:,3), '.');
hold on;
scatter3(base_frame_pts_filtered(:,1),base_frame_pts_filtered(:,2),base_frame_pts_filtered(:,3), 'filled', 'red');
axis equal;
hold off;   

figure('name', 'Data Filter II (Cam Frame Points)')
scatter3(cam_frame_pts(:,1),cam_frame_pts(:,2),cam_frame_pts(:,3), '.');
hold on;
scatter3(cam_frame_pts_filtered(:,1),cam_frame_pts_filtered(:,2),cam_frame_pts_filtered(:,3), 'filled', 'red');
hold off;   


%% Get the final Transform

% rigid_transform_3D(target, source)
[base_wrt_cam_rot, base_wrt_cam_trans] = rigid_transform_3D(base_frame_pts_filtered, cam_frame_pts_filtered);
% Getting PSM1 base wrt Polaris tf

% error analysis
% Transforming PSM1 base pt into Polaris frame pt
% psm1_ret_R, psm1_ret_t: PSM1 wrt Polaris
cam_pts_filtered_converted_from_base = (base_wrt_cam_rot*base_frame_pts_filtered') + repmat(base_wrt_cam_trans, 1 ,filtered_data_size);
cam_pts_filtered_converted_from_base = cam_pts_filtered_converted_from_base';

% Comparing them in the Polaris frame
err = cam_pts_filtered_converted_from_base - cam_frame_pts_filtered;
err = err .* err; % element-wise multiply
err_mat = err;
err_mat = sum(err_mat, 2);
err_mat = sqrt(err_mat);
err = sum(err(:));
final_rmse = sqrt(err/filtered_data_size);

final_affine_base_wrt_cam(1:3, 1:3) = base_wrt_cam_rot;
final_affine_base_wrt_cam(1:3, 4) = base_wrt_cam_trans(:);
final_affine_base_wrt_cam(4, :) = [0 0 0 1];

final_affine_base_wrt_cam

final_rmse

figure('name', 'Base to Cam Transform')
scatter3(cam_pts_filtered_converted_from_base(:,1),cam_pts_filtered_converted_from_base(:,2),cam_pts_filtered_converted_from_base(:,3), 'filled');
hold on;
scatter3(cam_frame_pts_filtered(:,1),cam_frame_pts_filtered(:,2),cam_frame_pts_filtered(:,3), '+', 'red');
hold off;   

%% Statistic
err_Med = median(err_mat);
err_Mean = mean(err_mat);

figure('Name', 'Distribution of Point matching errors NORMAL');
histfit(err_mat, 20, 'normal');
hold on;
txt_med = strcat('\leftarrow Median:',num2str(err_Med));
text(err_Med+0.00001, 60, txt_med);
line([err_Med, err_Med], ylim, 'LineWidth', 2, 'Color', 'r');
txt_mean = strcat('\leftarrow Mean:',num2str(err_Mean));
text(err_Mean+0.00001, 50, txt_mean);
line([err_Mean, err_Mean], ylim, 'LineWidth', 2, 'Color', 'c');
% savefig(strcat(data_folder, 'PSM1_POISSON.fig'))
hold off;
