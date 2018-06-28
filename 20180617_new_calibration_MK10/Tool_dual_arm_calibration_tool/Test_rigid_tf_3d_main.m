% RN@HMS Prince of Wales
% 27/06/18

%%
clc
close all
clear all

%%

%
pt_mat_0 = randn(20, 3);

        figure('Name', 'Original Random pt_mat_0');
        axis equal;
        scatter3(pt_mat_0(:,1), pt_mat_0(:,2), pt_mat_0(:,3), 'filled');
        hold off;
        
noise_mat = randn(20, 3) * 0.01;

test_affine = [
   -0.1888    0.6128   -0.7674   -0.1769
   -0.5612    0.5740    0.5964    0.0625
    0.8059    0.5432    0.2355   -0.0981
         0         0         0    1.0000
];




% 
for i = 1:20
    
   pt_0(1,1:3) =  pt_mat_0(i,:);
   pt_0(1,4) = 1;
    
   pt_1 = test_affine * transpose(pt_0);
   pt_1 = pt_1';
   pt_mat_1(i,:) = pt_1(1,1:3);
    
end
pt_mat_1 = pt_mat_1 + noise_mat;

        figure('Name', 'pt_mat_0 & pt_mat_1');
        axis equal;
        scatter3(pt_mat_1(:,1), pt_mat_1(:,2), pt_mat_1(:,3), 'filled');
        hold off;
        
        
        figure('Name', 'pt_mat_1');
        axis equal;
        scatter3(pt_mat_1(:,1), pt_mat_1(:,2), pt_mat_1(:,3), 'filled');
        hold on;
        scatter3(pt_mat_0(:,1), pt_mat_0(:,2), pt_mat_0(:,3), 'filled');
        hold off;       
        
 
 %% Matching Test
 
size = 20;
[psm1_ret_R, psm1_ret_t] = rigid_transform_3D(pt_mat_1, pt_mat_0); % This should yeild a new tf from pt1 to pt0. Therefore
% subsequent operation involves adding that tf onto pt1, not pt0.

% TEST
% psm1_ret_t = psm1_ret_t + [0.0014; 0.0004; -0.0014]

pt_mat_1_adjusted = (psm1_ret_R*pt_mat_1') + repmat(psm1_ret_t, 1 ,size);
pt_mat_1_adjusted = pt_mat_1_adjusted';

% Comparing them in the Polaris frame
psm1_err = pt_mat_1_adjusted - pt_mat_0;
psm1_err = psm1_err .* psm1_err; % element-wise multiply
psm1_err_mat = psm1_err;
psm1_err_mat = sum(psm1_err_mat, 2);
psm1_err_mat = sqrt(psm1_err_mat);
psm1_err = sum(psm1_err(:));
psm1_rmse = sqrt(psm1_err/size)

figure('Name','pms1_test_pts vs. pms2_test_pts_adjusted');
scatter3(pt_mat_0(:,1), pt_mat_0(:,2), pt_mat_0(:,3), 'filled');
hold on;
scatter3(pt_mat_1_adjusted(:,1), pt_mat_1_adjusted(:,2), pt_mat_1_adjusted(:,3));
axis equal;
hold off;
 
        
        