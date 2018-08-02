% RN@HMS Queen Elizabeth
% 01/08/18
% Descriptions.
% 
% Notes.
%


function [pt_cld, pt_mat] = loadStrayMarkerCsvFileToPointCloudAndMat(file_path)

%% Loading Data
csv = csvread(file_path);

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

%% Applying Mask and Removing NANs
mask_begin = 11;
mask_end = raw_points(raw_size, 1) - 15;
mask = (raw_points(:,1) > mask_begin & raw_points(:,1) < mask_end);

pt_mat_0 = [seq(mask), raw_pose_x(mask), raw_pose_y(mask), raw_pose_z(mask)];

pt_mat_0(isnan(pt_mat_0(:,2)),:)= [];

pt_mat = [pt_mat_0(:,2), pt_mat_0(:,3), pt_mat_0(:,4), pt_mat_0(:,1)]; % (x y z seq)

%% Add mask that removes the consecutive static points.
% Note that this would reduce the point number dramatically, from about
% 13,000 to 2,000. 
n = 1;
for i = 1:(size(pt_mat, 1) -1)
    pt_0 = pt_mat(i, 1:3);
    pt_1 = pt_mat(i+1, 1:3);
    dist = norm( pt_1 - pt_0 );
    
    if (dist < 0.00035)
       to_delete(n,:) = (i+1);
       n = n+1;
    end
    
end
pt_mat(to_delete,:) = [];


%% Checking the Masked data
% Only use this section when you need to config your mask settings
%     figure('Name', 'CONFIG - Masked Data x');
%     plot(raw_points(:,1), raw_points(:,2));
%     hold on;
%     plot(pt_mat(:,4), pt_mat(:,1), '.');
%     xlabel('Time (sec)');
%     ylabel('X-Displacement (m)');
%     hold off;
    
%% Point Cloud

pt_cld = pointCloud([pt_mat_0(:,2), pt_mat_0(:,3), pt_mat_0(:,4)]);
    
% figure('Name', 'CONFIG - Point Cloud');
% pcshow(pt_cld);
% hold off;    
    
    

end