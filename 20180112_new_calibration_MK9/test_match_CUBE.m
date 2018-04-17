% RN@HMS Queen Elizabeth
% 10/04/18

%%
clc
close all
clear all

%%
load('pts_generated_cube.mat')
% pts_generated
load('pts_Polaris.mat')
% pts_Polaris

n = 6*6*6; % number of points
[ret_R, ret_t] = rigid_transform_3D(pts_generated_cube, pts_Polaris);

pts_generated_2 = (ret_R*pts_generated_cube') + repmat(ret_t, 1 ,n);
pts_generated_2 = pts_generated_2';

err = pts_generated_2 - pts_Polaris;
err = err .* err; % element-wise multiply
err_mat = err;
err_mat = sum(err_mat, 2);
err_mat = sqrt(err_mat);
err = sum(err(:));
rmse = sqrt(err/n);

%% Plotting

figure('Name','pts_generated_2 vs. pts_Polaris');
scatter3(pts_Polaris(:,1), pts_Polaris(:,2), pts_Polaris(:,3), 'filled');
hold on;
scatter3(pts_generated_2(:,1), pts_generated_2(:,2), pts_generated_2(:,3));
hold off;

figure('Name', 'Distribution of Point matching errors');
histfit(err_mat);
hold off;
