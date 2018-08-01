% RN@HMS Prince of Wales
% 12/07/18
% Descriptions.
% 
% Notes.
%


function [pt_cld, pt_mat] = loadCsvFileToPointCloudAndMat(file_path)

%% Loading Data
csv = csvread(file_path);

seq = csv(:, 2);
seq = ((seq - seq(1)) / 100);
raw_pose_x = csv(:, 4);
raw_pose_y = csv(:, 5);
raw_pose_z = csv(:, 6);

raw_points = [seq, raw_pose_x, raw_pose_y, raw_pose_z];
raw_size = size(raw_points,1);

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