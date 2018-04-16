% RN@HMS Queen Elizabeth
% 10/04/18

%%
clc
close all
clear all

%%
load('savePts_generated.mat')
% pts_generated
load('savePts_polaris.mat')
% pts_Polaris

n = 100; % number of points
[ret_R, ret_t] = rigid_transform_3D(pts_generated, pts_Polaris);

pts_generated_2 = (ret_R*pts_generated') + repmat(ret_t, 1 ,n);
pts_generated_2 = pts_generated_2';

err = pts_generated_2 - pts_Polaris;
err = err .* err;
err = sum(err(:));
rmse = sqrt(err/n);

%% Plotting

figure('Name','pts_generated_2 vs. pts_Polaris');
scatter3(pts_Polaris(:,1), pts_Polaris(:,2), pts_Polaris(:,3), 'filled');
hold on;
scatter3(pts_generated_2(:,1), pts_generated_2(:,2), pts_generated_2(:,3));
hold off;
