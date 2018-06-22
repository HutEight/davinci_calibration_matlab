% RN@HMS Queen Elizabeth
% 10/04/18

%% THERE ARE 1 UPDATE POINT1 THAT YOU NEED TO CHECK EVERYTIME YOU RUN THIS PROGRAMME.
% Search for 'checkpoint' to locate them. 
%%
clc
close all
clear all

%%
% @ UPDATE CHECKPOINT 1/1
data_folder = 'Data/20180621_03/';

load(strcat(data_folder, 'psm1_pts_generated_cube.mat'))
% pts_generated
load(strcat(data_folder, 'psm1_pts_Polaris_cube.mat'))
% pts_Polaris
load(strcat(data_folder, 'psm2_pts_generated_cube.mat'))
% pts_generated
load(strcat(data_folder, 'psm2_pts_Polaris_cube.mat'))
% pts_Polaris

n = 7*7*7; % number of points

n = size(psm1_pts_Polaris_cube,1);

%% Finding the PMS1-POLARIS tf
% may need to inverse psm1_pts_generated_cube
% rigid_transform_3D(target, source)
[psm1_ret_R, psm1_ret_t] = rigid_transform_3D(psm1_pts_generated_cube, psm1_pts_Polaris_cube);
% Getting PSM1 base wrt Polaris tf

% error analysis
% Transforming PSM1 base pt into Polaris frame pt
% psm1_ret_R, psm1_ret_t: PSM1 wrt Polaris
psm1_pts_generated_2 = (psm1_ret_R*psm1_pts_generated_cube') + repmat(psm1_ret_t, 1 ,n);
psm1_pts_generated_2 = psm1_pts_generated_2';

% Comparing them in the Polaris frame
psm1_err = psm1_pts_generated_2 - psm1_pts_Polaris_cube;
psm1_err = psm1_err .* psm1_err; % element-wise multiply
psm1_err_mat = psm1_err;
psm1_err_mat = sum(psm1_err_mat, 2);
psm1_err_mat = sqrt(psm1_err_mat);
psm1_err = sum(psm1_err(:));
psm1_rmse = sqrt(psm1_err/n);

%% Statistic
psm1_Med = median(psm1_err_mat);
psm1_Mean = mean(psm1_err_mat);

%% Not-so-nice fits
j = 1;
for i = 1:n
    if (psm1_err_mat(i) > psm1_Mean)
        psm1_err_pts(j,:) = psm1_pts_Polaris_cube(i,:);
        j = j + 1;
    end

end


%% PSM1 ONLY Plotting
figure('Name','psm1_pts_generated_2 vs. psm1_pts_Polaris_cube');
scatter3(psm1_pts_Polaris_cube(:,1), psm1_pts_Polaris_cube(:,2), psm1_pts_Polaris_cube(:,3), 'filled');
hold on;
scatter3(psm1_pts_generated_2(:,1), psm1_pts_generated_2(:,2), psm1_pts_generated_2(:,3));
axis equal;
hold off;

figure('Name','pts_generated_2 vs. pts_Polaris_cube V2');
scatter3(psm1_pts_Polaris_cube(:,1), psm1_pts_Polaris_cube(:,2), psm1_pts_Polaris_cube(:,3), 'filled');
hold on;
scatter3(psm1_err_pts(:,1), psm1_err_pts(:,2), psm1_err_pts(:,3), 'filled','cyan');
scatter3(psm1_pts_generated_2(:,1), psm1_pts_generated_2(:,2), psm1_pts_generated_2(:,3),'o','red');
axis equal;
hold off;

figure('Name', 'Distribution of Point matching errors');
histfit(psm1_err_mat);
hold off;

figure('Name', 'Distribution of Point matching errors POISSON');
histfit(psm1_err_mat, 20, 'poisson');
hold on;
txt_med = strcat('\leftarrow Median:',num2str(psm1_Med));
text(psm1_Med+0.00001, 35, txt_med);
line([psm1_Med, psm1_Med], ylim, 'LineWidth', 2, 'Color', 'r');
txt_mean = strcat('\leftarrow Mean:',num2str(psm1_Mean));
text(psm1_Mean+0.00001, 30, txt_mean);
line([psm1_Mean, psm1_Mean], ylim, 'LineWidth', 2, 'Color', 'c');
hold off;




%% Finding the PMS2-POLARIS tf
% may need to inverse psm1_pts_generated_cube
% rigid_transform_3D(source, target)
[psm2_ret_R, psm2_ret_t] = rigid_transform_3D(psm2_pts_generated_cube, psm2_pts_Polaris_cube);
% Getting PSM2 base wrt Polaris tf

% error analysis
% Transforming PSM1 base pt into Polaris frame pt
% psm2_ret_R, psm2_ret_t: PSM1 wrt Polaris
psm2_pts_generated_2 = (psm2_ret_R*psm2_pts_generated_cube') + repmat(psm2_ret_t, 1 ,n);
psm2_pts_generated_2 = psm2_pts_generated_2';

psm2_err = psm2_pts_generated_2 - psm2_pts_Polaris_cube;
psm2_err = psm2_err .* psm2_err; % element-wise multiply
psm2_err_mat = psm2_err;
psm2_err_mat = sum(psm2_err_mat, 2);
psm2_err_mat = sqrt(psm2_err_mat);
psm2_err = sum(psm2_err(:));
psm2_rmse = sqrt(psm2_err/n);

%% Statistic
psm2_Med = median(psm2_err_mat);
psm2_Mean = mean(psm2_err_mat);

%% Not-so-nice fits
j = 1;
for i = 1:n
    if (psm2_err_mat(i) > psm2_Mean)
        psm2_err_pts(j,:) = psm2_pts_Polaris_cube(i,:);
        j = j + 1;
    end

end

%% PSM2 ONLY Plotting
figure('Name','psm2_pts_generated_2 vs. psm2_pts_Polaris_cube');
scatter3(psm2_pts_Polaris_cube(:,1), psm2_pts_Polaris_cube(:,2), psm2_pts_Polaris_cube(:,3), 'filled');
hold on;
scatter3(psm2_pts_generated_2(:,1), psm2_pts_generated_2(:,2), psm2_pts_generated_2(:,3));
axis equal;
hold off;

figure('Name','pts_generated_2 vs. pts_Polaris_cube V2');
scatter3(psm2_pts_Polaris_cube(:,1), psm2_pts_Polaris_cube(:,2), psm2_pts_Polaris_cube(:,3), 'filled');
hold on;
scatter3(psm2_err_pts(:,1), psm2_err_pts(:,2), psm2_err_pts(:,3), 'filled','cyan');
scatter3(psm2_pts_generated_2(:,1), psm2_pts_generated_2(:,2), psm2_pts_generated_2(:,3),'o','red');
axis equal;
hold off;

figure('Name', 'Distribution of Point matching errors');
histfit(psm2_err_mat);
hold off;

figure('Name', 'Distribution of Point matching errors POISSON');
histfit(psm2_err_mat, 20, 'poisson');
hold on;
txt_med = strcat('\leftarrow Median:',num2str(psm2_Med));
text(psm2_Med+0.00001, 35, txt_med);
line([psm2_Med, psm2_Med], ylim, 'LineWidth', 2, 'Color', 'r');
txt_mean = strcat('\leftarrow Mean:',num2str(psm2_Mean));
text(psm2_Mean+0.00001, 30, txt_mean);
line([psm2_Mean, psm2_Mean], ylim, 'LineWidth', 2, 'Color', 'c');
hold off;


%% PSM1 to PSM2

affine_psm1_wrt_polaris(1:3,1:3) = psm1_ret_R;
affine_psm1_wrt_polaris(1:3,4) = psm1_ret_t;
affine_psm1_wrt_polaris(4,:) = [0 0 0 1];

affine_psm2_wrt_polaris(1:3,1:3) = psm2_ret_R;
affine_psm2_wrt_polaris(1:3,4) = psm2_ret_t;
affine_psm2_wrt_polaris(4,:) = [0 0 0 1];


affine_psm2_wrt_psm1 = affine_psm1_wrt_polaris\affine_psm2_wrt_polaris;


% % error analysis
% psm1_pts_generated_2 = (psm1_ret_R*psm1_pts_generated_cube') + repmat(psm1_ret_t, 1 ,n);
% psm1_pts_generated_2 = psm1_pts_generated_2';

% should be the same same as inv(affine_psm1_wrt_polaris)
affine_psm2_polaris_wrt_psm1_base = affine_psm2_wrt_psm1 * inv(affine_psm2_wrt_polaris); 



%% Combined Plotting
figure('Name', 'PSM1 & PSM2 polaris pts');
axis equal;
scatter3(psm2_pts_Polaris_cube(:,1), psm2_pts_Polaris_cube(:,2), psm2_pts_Polaris_cube(:,3), 'filled');
hold on;
axis equal;
scatter3(psm1_pts_Polaris_cube(:,1), psm1_pts_Polaris_cube(:,2), psm1_pts_Polaris_cube(:,3), 'o');
axis equal;
hold off;

%% Save result

save(strcat(data_folder, 'affine_psm2_wrt_psm1.mat'), 'affine_psm2_wrt_psm1');

