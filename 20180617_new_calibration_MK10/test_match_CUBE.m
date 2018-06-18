% RN@HMS Queen Elizabeth
% 10/04/18

%%
clc
close all
clear all

%%
load('pts_generated_cube.mat')
% pts_generated
load('pts_Polaris_cube.mat')
% pts_Polaris

n = 6*6*6; % number of points

n = size(pts_Polaris_cube,1);

[ret_R, ret_t] = rigid_transform_3D(pts_generated_cube, pts_Polaris_cube);

pts_generated_2 = (ret_R*pts_generated_cube') + repmat(ret_t, 1 ,n);
pts_generated_2 = pts_generated_2';

err = pts_generated_2 - pts_Polaris_cube;
err = err .* err; % element-wise multiply
err_mat = err;
err_mat = sum(err_mat, 2);
err_mat = sqrt(err_mat);
err = sum(err(:));
rmse = sqrt(err/n);

%% Statistic
Med = median(err_mat);
Mean = mean(err_mat);

%% Not-so-nice fits
j = 1;
for i = 1:n
    if (err_mat(i) > Mean)
        err_pts(j,:) = pts_Polaris_cube(i,:);
        j = j + 1;
    end

end


%% Plotting
figure('Name','pts_generated_2 vs. pts_Polaris_cube');
scatter3(pts_Polaris_cube(:,1), pts_Polaris_cube(:,2), pts_Polaris_cube(:,3), 'filled');
hold on;
scatter3(pts_generated_2(:,1), pts_generated_2(:,2), pts_generated_2(:,3));
hold off;

figure('Name','pts_generated_2 vs. pts_Polaris_cube V2');
scatter3(pts_Polaris_cube(:,1), pts_Polaris_cube(:,2), pts_Polaris_cube(:,3), 'filled');
hold on;
scatter3(err_pts(:,1), err_pts(:,2), err_pts(:,3), 'filled','cyan');
scatter3(pts_generated_2(:,1), pts_generated_2(:,2), pts_generated_2(:,3),'o','red');
hold off;

figure('Name', 'Distribution of Point matching errors');
histfit(err_mat);
hold off;

figure('Name', 'Distribution of Point matching errors POISSON');
histfit(err_mat, 20, 'poisson');
hold on;
txt_med = strcat('\leftarrow Median:',num2str(Med));
text(Med+0.00001, 35, txt_med);
line([Med, Med], ylim, 'LineWidth', 2, 'Color', 'r');
txt_mean = strcat('\leftarrow Mean:',num2str(Mean));
text(Mean+0.00001, 30, txt_mean);
line([Mean, Mean], ylim, 'LineWidth', 2, 'Color', 'c');
hold off;