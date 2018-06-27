% RN@HMS Queen Elizabeth
% 08/05/18

%% THERE ARE 1 UPDATE POINT1 THAT YOU NEED TO CHECK EVERYTIME YOU RUN THIS PROGRAMME.
% Search for 'checkpoint' to locate them. 
%%
clc
close all
clear all

%%

% @ UPDATE CHECKPOINT 1/1
FolderDir = 'Data/20180626_02/';

psm1_file_path = strcat(FolderDir, 'green_evaluation.csv')
psm2_file_path = strcat(FolderDir, 'yellow_evaluation.csv')

%% PSM1
csv = csvread(psm1_file_path);

% check if they are correctly numbered.
seq = csv(:, 1);
% should make it represent this much seconds
seq = ((seq - seq(1)) / 1000000000); % nanosecond to second


% Initialise arrarys to speed up.
n_row = size(seq,1);
max_n_col = size(csv(1,:),2);
raw_pose_x = zeros(n_row,1);
raw_pose_y = zeros(n_row,1);
raw_pose_z = zeros(n_row,1);
candidate_pose_x = zeros(n_row,max_n_col);
candidate_pose_y = zeros(n_row,max_n_col);
candidate_pose_z = zeros(n_row,max_n_col);

%% Filtering the Stray Marker points (MKII Filter)

% This selection process selects the last 3 values of each row as the stray
% marker coordinate. This is necessary as the Polaris sometimes sees ghost
% points and pushes the real marker point to the last 3 digits. 

for n = 1:size(seq,1)
    
    last_digit_found = 0;
       
    % Check which digit has the first non-zero value
    for i = 0:size(csv(n,:),2)-7 % (0 -> 15)
    
        j = size(csv(n,:),2)-i; % (22 -> 7)
        
        % Because the first 4 digits are NEVER going to be a point, must
        % make sure (j-2) is greater than 4, or j > 6. Then depending on
        % the value of j, we learn the number of points reported by the
        % Polaris at this certain sequence. We therefore need to evaluate
        % the source/root of these points because the order of the points 
        % may be completely random. Our points of interest must be
        % consistent. Primary points (points of interest) will be stored at
        % the first columns (of x, y and z). 
        
        if (csv(n,j) ~= 0) & (last_digit_found == 0) & (j > 6)
            
            last_digit_found = 1;
            n_pts = (j-4)/3; % The Polaris indicates there are n_pts points -- not necessarily real.

            if (n_pts > 1)
                
                for k = 1:n_pts
                    
                    shortest_dist_to_last_pt = 10; % An unrealistic number. 
                    
                    % Acquiring one candidate point.
                    candidate_pose_x(n,k) = csv(n, j-2-3*(k-1));
                    candidate_pose_y(n,k) = csv(n, j-1-3*(k-1));
                    candidate_pose_z(n,k) = csv(n, j-0-3*(k-1));  
                    
                    candi_pt = [candidate_pose_x(n,k) ...
                        candidate_pose_y(n,k) ...
                        candidate_pose_z(n,k)];
                    
                    % The first point has no predecessor. 
                    if (n == 1)
                        dist_to_last_pt = 0;
                    else
                        dist_to_last_pt = norm(candi_pt - last_pt); % Calculate the distance.
                    end
                                      
                    if (dist_to_last_pt < shortest_dist_to_last_pt)
                        
                        if (dist_to_last_pt < 0.1)
                            % Update the raw poses 
                            raw_pose_x(n,1) = candidate_pose_x(n,k);
                            raw_pose_y(n,1) = candidate_pose_y(n,k);
                            raw_pose_z(n,1) = candidate_pose_z(n,k);
                            shortest_dist_to_last_pt = dist_to_last_pt;
                        else    
                            % Use the last point
                            raw_pose_x(n,1) = raw_pose_x(n-1, 1);
                            raw_pose_y(n,1) = raw_pose_y(n-1, 1);
                            raw_pose_z(n,1) = raw_pose_z(n-1, 1);
                        end
                        
                        
                    end
           
                end

            else
                
                candidate_pose_x(n,1) = csv(n, j-2);
                candidate_pose_y(n,1) = csv(n, j-1);
                candidate_pose_z(n,1) = csv(n, j-0);  
                       
                candi_pt = [candidate_pose_x(n,1) ...
                    candidate_pose_y(n,1) ...
                    candidate_pose_z(n,1)];
                
                % The first point has no predecessor. 
                if (n == 1)
                    dist_to_last_pt = 0;
                else
                    dist_to_last_pt = norm(candi_pt - last_pt); % Calculate the distance.
                end
                
                if (dist_to_last_pt < 0.1)
                    raw_pose_x(n,1) = csv(n, j-2);
                    raw_pose_y(n,1) = csv(n, j-1);
                    raw_pose_z(n,1) = csv(n, j);
                else
                    % Use the last point
                    raw_pose_x(n,1) = raw_pose_x(n-1, 1);
                    raw_pose_y(n,1) = raw_pose_y(n-1, 1);
                    raw_pose_z(n,1) = raw_pose_z(n-1, 1);
                    
                end
                
            end
            
            last_pt = [raw_pose_x(n,1) raw_pose_y(n,1) raw_pose_z(n,1)];
            
            
        
        % Now consider ther is no point at all in this #n row.    
        elseif (csv(n,j) == 0) & (last_digit_found == 0) & (j == 7)

            if (n > 1)
                raw_pose_x(n,1) = NaN;
                raw_pose_y(n,1) = NaN;
                raw_pose_z(n,1) = NaN;           
                
            end                      
            
        end
        
    end
    
end

raw_points = [seq, raw_pose_x, raw_pose_y, raw_pose_z];
% WARNING: DO NOT REMOVE NAN HERE OR THE SEQUENCE WILL BE BROKEN.
%          THEY ARE TAKEN CARE OF LATER IN THE CODE.
raw_size = size(raw_points,1);


%% 
% fill in start time (second) Needs adjustment each time
time_0 = 12.5; % Use 12.5 for some reason... Not 10
time_t = time_0 + 1.5; % take 1 sec of samples equvilent of 20 pts
peroid = 8; % 4 + 4 seconds

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


% BOUNDARY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% PSM2
csv = csvread(psm2_file_path);

% check if they are correctly numbered.
seq = csv(:, 1);
% should make it represent this much seconds
seq = ((seq - seq(1)) / 1000000000); % nanosecond to second

% Initialise arrarys to speed up.
n_row = size(seq,1);
max_n_col = size(csv(1,:),2);
raw_pose_x = zeros(n_row,1);
raw_pose_y = zeros(n_row,1);
raw_pose_z = zeros(n_row,1);
candidate_pose_x = zeros(n_row,max_n_col);
candidate_pose_y = zeros(n_row,max_n_col);
candidate_pose_z = zeros(n_row,max_n_col);


%% Filtering the Stray Marker points (MKII Filter)

% This selection process selects the last 3 values of each row as the stray
% marker coordinate. This is necessary as the Polaris sometimes sees ghost
% points and pushes the real marker point to the last 3 digits. 

for n = 1:size(seq,1)
    
    last_digit_found = 0;
       
    % Check which digit has the first non-zero value
    for i = 0:size(csv(n,:),2)-7 % (0 -> 15)
    
        j = size(csv(n,:),2)-i; % (22 -> 7)
        
        % Because the first 4 digits are NEVER going to be a point, must
        % make sure (j-2) is greater than 4, or j > 6. Then depending on
        % the value of j, we learn the number of points reported by the
        % Polaris at this certain sequence. We therefore need to evaluate
        % the source/root of these points because the order of the points 
        % may be completely random. Our points of interest must be
        % consistent. Primary points (points of interest) will be stored at
        % the first columns (of x, y and z). 
        
        if (csv(n,j) ~= 0) & (last_digit_found == 0) & (j > 6)
            
            last_digit_found = 1;
            n_pts = (j-4)/3; % The Polaris indicates there are n_pts points -- not necessarily real.

            if (n_pts > 1)
                
                for k = 1:n_pts
                    
                    shortest_dist_to_last_pt = 10; % An unrealistic number. 
                    
                    % Acquiring one candidate point.
                    candidate_pose_x(n,k) = csv(n, j-2-3*(k-1));
                    candidate_pose_y(n,k) = csv(n, j-1-3*(k-1));
                    candidate_pose_z(n,k) = csv(n, j-0-3*(k-1));  
                    
                    candi_pt = [candidate_pose_x(n,k) ...
                        candidate_pose_y(n,k) ...
                        candidate_pose_z(n,k)];
                    
                    % The first point has no predecessor. 
                    if (n == 1)
                        dist_to_last_pt = 0;
                    else
                        dist_to_last_pt = norm(candi_pt - last_pt); % Calculate the distance.
                    end
                                      
                    if (dist_to_last_pt < shortest_dist_to_last_pt)
                        
                        if (dist_to_last_pt < 0.1)
                            % Update the raw poses 
                            raw_pose_x(n,1) = candidate_pose_x(n,k);
                            raw_pose_y(n,1) = candidate_pose_y(n,k);
                            raw_pose_z(n,1) = candidate_pose_z(n,k);
                            shortest_dist_to_last_pt = dist_to_last_pt;
                        else    
                            % Use the last point
                            raw_pose_x(n,1) = raw_pose_x(n-1, 1);
                            raw_pose_y(n,1) = raw_pose_y(n-1, 1);
                            raw_pose_z(n,1) = raw_pose_z(n-1, 1);
                        end
                        
                        
                    end
           
                end

            else
                
                candidate_pose_x(n,1) = csv(n, j-2);
                candidate_pose_y(n,1) = csv(n, j-1);
                candidate_pose_z(n,1) = csv(n, j-0);  
                       
                candi_pt = [candidate_pose_x(n,1) ...
                    candidate_pose_y(n,1) ...
                    candidate_pose_z(n,1)];
                
                % The first point has no predecessor. 
                if (n == 1)
                    dist_to_last_pt = 0;
                else
                    dist_to_last_pt = norm(candi_pt - last_pt); % Calculate the distance.
                end
                
                if (dist_to_last_pt < 0.1)
                    raw_pose_x(n,1) = csv(n, j-2);
                    raw_pose_y(n,1) = csv(n, j-1);
                    raw_pose_z(n,1) = csv(n, j);
                else
                    % Use the last point
                    raw_pose_x(n,1) = raw_pose_x(n-1, 1);
                    raw_pose_y(n,1) = raw_pose_y(n-1, 1);
                    raw_pose_z(n,1) = raw_pose_z(n-1, 1);
                    
                end
                
            end
            
            last_pt = [raw_pose_x(n,1) raw_pose_y(n,1) raw_pose_z(n,1)];
            
            
        
        % Now consider ther is no point at all in this #n row.    
        elseif (csv(n,j) == 0) & (last_digit_found == 0) & (j == 7)

            if (n > 1)
                raw_pose_x(n,1) = NaN;
                raw_pose_y(n,1) = NaN;
                raw_pose_z(n,1) = NaN;           
                
            end                      
            
        end
        
    end
    
end

raw_points_2 = [seq, raw_pose_x, raw_pose_y, raw_pose_z];
% WARNING: DO NOT REMOVE NAN HERE OR THE SEQUENCE WILL BE BROKEN.
%          THEY ARE TAKEN CARE OF LATER IN THE CODE.
raw_size = size(raw_points_2,1);


%% 
% fill in start time (second) Needs adjustment each time
time_0 = 12.5; % Use 12.5 for some reason... Not 10
time_t = time_0 + 1.5; % take 1 sec of samples equvilent of 20 pts
peroid = 8; % 4 + 4 seconds

% Size of data
n_pts = 20; 

for i = 0:(n_pts-1)
    
   mask_begin = time_0 + i*peroid;
   mask_end = time_t + i*peroid;
   mask = (raw_points_2(:,1) > mask_begin & raw_points_2(:,1) < mask_end);
   
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
scatter3(raw_points_2(:,2), raw_points_2(:,3), raw_points_2(:,4), '.', 'c');
axis equal;
hold off;
% 





%%%%%%%%%%%%%%%%%%%%%%%%%555
%% COMPARISON

figure('Name','PSM1 PSM2 combined pt cloud');
axis equal;
scatter3(pms2_test_pts(:,1), pms2_test_pts(:,2), pms2_test_pts(:,3), 'filled','g');
hold on;
scatter3(raw_points_2(:,2), raw_points_2(:,3), raw_points_2(:,4), '.');
axis equal;
axis equal;
scatter3(pms1_test_pts(:,1), pms1_test_pts(:,2), pms1_test_pts(:,3), 'filled','r');
scatter3(raw_points(:,2), raw_points(:,3), raw_points(:,4), '.');
axis equal;
hold off;
% 



figure('Name','PSM1 & PSM2 test points');
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

%% TEST matching (CAN IT BE FURTHER IMPROVED?)
size = size(pms1_test_pts,1);
[psm1_ret_R, psm1_ret_t] = rigid_transform_3D(pms2_test_pts, pms1_test_pts); % This should yeild a new tf.

% TEST
% psm1_ret_t = psm1_ret_t + [0.0014; 0.0004; -0.0014]

pms2_test_pts_adjusted = (psm1_ret_R*pms2_test_pts') + repmat(psm1_ret_t, 1 ,size);
pms2_test_pts_adjusted = pms2_test_pts_adjusted';

% Comparing them in the Polaris frame
psm1_err = pms2_test_pts_adjusted - pms1_test_pts;
psm1_err = psm1_err .* psm1_err; % element-wise multiply
psm1_err_mat = psm1_err;
psm1_err_mat = sum(psm1_err_mat, 2);
psm1_err_mat = sqrt(psm1_err_mat);
psm1_err = sum(psm1_err(:));
psm1_rmse = sqrt(psm1_err/size)

figure('Name','pms1_test_pts vs. pms2_test_pts_adjusted');
scatter3(pms1_test_pts(:,1), pms1_test_pts(:,2), pms1_test_pts(:,3), 'filled');
hold on;
scatter3(pms2_test_pts_adjusted(:,1), pms2_test_pts_adjusted(:,2), pms2_test_pts_adjusted(:,3));
axis equal;
hold off;



