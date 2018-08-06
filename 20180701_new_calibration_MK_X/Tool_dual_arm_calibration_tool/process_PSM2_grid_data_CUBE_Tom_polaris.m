% RN@HMS Queen Elizabeth
% 04/06/18
% Major Refit 22/06/18
% Runtime: 2 sec.

%% THERE ARE 1 UPDATE POINT THAT YOU NEED TO CHECK EVERYTIME YOU RUN THIS PROGRAMME.
% Search for 'checkpoint' to locate them. 
%%
clc
close all
clear all

%%
% @ UPDATE CHECKPOINT 1/1
file_path = 'Data/20180805_01_psm1_adj_dh/';

file_name = 'yellow_frozen.csv';
csv = csvread(strcat(file_path, file_name));

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

figure('Name','Polaris Points full');
axis equal;
scatter3(raw_points(:,2), raw_points(:,3), raw_points(:,4), '.');
hold off;


%% 

% fill in start time (second) Needs adjustment each time
time_0 = 12.5; % Use 12.5 for some reason... Not 10
time_t = time_0 + 1.5; % take 1 sec of samples equvilent of 20 pts
peroid = 4; % 2 + 2 seconds

% Size of data: from a cube of 5x5x5
length = 7;
n_pts2 = length*length*length; 

for i2 = 0:(n_pts2-1)
    
   mask_begin = time_0 + i2*peroid;
   mask_end = time_t + i2*peroid;
   mask = (raw_points(:,1) > mask_begin & raw_points(:,1) < mask_end);
   
   pt_mat_0 = [seq(mask), raw_pose_x(mask), raw_pose_y(mask), raw_pose_z(mask)];
   pt_mat_0(isnan(pt_mat_0(:,2)),:)= [];
   
   pt_mat = [pt_mat_0(:,2), pt_mat_0(:,3), pt_mat_0(:,4)];
   
   x_ave = mean(pt_mat_0(:,2));
   y_ave = mean(pt_mat_0(:,3));
   z_ave = mean(pt_mat_0(:,4));
   
   psm2_pts_Polaris_cube(i2+1,:) = [x_ave y_ave z_ave];
        
end

% save('psm2_pts_Polaris_cube.mat', 'psm2_pts_Polaris_cube');

save(strcat(file_path,'psm2_pts_Polaris_cube.mat'), 'psm2_pts_Polaris_cube');


%% Cube Properties
% Added on 23/07/18 HMS Queen Elizabeth Task Force
% This section analyse the straightness of all thouse lines (49 of them) in
% the cube by their line fitting rms. It also tells the average distance
% between 2 consecutive points, which should be 10 mm. 

% Get the start-end point pairs of each rows of the cube. Rows are defined
% according to the visit sequence.
row_start_end = [1 1];
row_count = 1;


for i3 = 2:(n_pts2)
    
    dist = norm(psm2_pts_Polaris_cube(i3,:) - psm2_pts_Polaris_cube(i3-1,:) ); 
    dist_from_last_pt(i3-1,:) = dist;
    
    if (dist > 0.02)
        row_start_end(row_count,2) = i3-1;
        row_start_end(row_count+1,1) = i3;
        row_count = row_count + 1;
    end
    
    if (i3==n_pts2)
        row_start_end(row_count,2) = i3;
    end
    
end

% Then get the line fitting to see how the rms are for those rows.
total_cube_dist = 0;
for i4 = 1:row_count
    
    % From start to end inside a row
    pt_n = 1;
    total_row_dist = 0;
    
    for n = (row_start_end(i4,1)):(row_start_end(i4,2))
        row_pts(pt_n,:) = psm2_pts_Polaris_cube(n,:);
        
        if (n < row_start_end(i4,2))
            dist = norm(psm2_pts_Polaris_cube(n,:) - psm2_pts_Polaris_cube(n+1,:) );
        end
        total_row_dist = total_row_dist + dist;
        total_cube_dist = total_cube_dist + dist;
                 
        pt_n = pt_n + 1;
    end
    
    if (i4<=row_count)
        ave_vertic_dist_row(i4,:) = total_row_dist/ ( row_start_end(i4,2) - row_start_end(i4,1) + 1);
    end
    
    [row_pts_line_params, row_pts_rms] = fitLineSvd(row_pts);
    
    row_pts_rms_vec(i4,:) = row_pts_rms;
    
    
end
ave_vertic_dist = total_cube_dist/(n_pts2-1);



%% Visualise the points

figure('Name','PSM2 Polaris Points');
axis equal;
scatter3(raw_points(:,2), raw_points(:,3), raw_points(:,4), '.');
hold on;
scatter3(psm2_pts_Polaris_cube(:,1), psm2_pts_Polaris_cube(:,2), psm2_pts_Polaris_cube(:,3), 'filled', 'red');
axis equal;
hold off;

