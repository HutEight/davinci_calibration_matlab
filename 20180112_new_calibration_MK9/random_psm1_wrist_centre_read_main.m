
clc
close all
clear all

%% Update these

folder_path = '20180319_psm1_random_wrists/';

affine_portal_wrt_polaris = [1 0 0 0;
    0 1 0 0;
    0 0 1 0;
    0 0 0 1];


test_path = '20180319_psm1_random_wrists/07.csv';
csv = csvread(test_path);
%% Load data

path_01 =strcat(folder_path , '01.csv');
path_02 =strcat(folder_path , '02.csv');
path_03 =strcat(folder_path , '03.csv');
path_04 =strcat(folder_path , '04.csv');
path_05 =strcat(folder_path , '05.csv');
path_06 =strcat(folder_path , '06.csv');
path_07 =strcat(folder_path , '07.csv');
path_08 =strcat(folder_path , '08.csv');
path_09 =strcat(folder_path , '09.csv');
path_10 =strcat(folder_path , '10.csv');

[pt_cld_01, pt_mat_01] = load_csv_data(path_01);
[pt_cld_02, pt_mat_02] = load_csv_data(path_02);
[pt_cld_03, pt_mat_03] = load_csv_data(path_03);
[pt_cld_04, pt_mat_04] = load_csv_data(path_04);
[pt_cld_05, pt_mat_05] = load_csv_data(path_05);
[pt_cld_06, pt_mat_06] = load_csv_data(path_06);
[pt_cld_07, pt_mat_07] = load_csv_data(path_07);
[pt_cld_08, pt_mat_08] = load_csv_data(path_08);
[pt_cld_09, pt_mat_09] = load_csv_data(path_09);
[pt_cld_10, pt_mat_10] = load_csv_data(path_10);

[small_sphere_param_01, small_residuals_01] = davinci_sphere_fit_least_square(pt_mat_01);
[small_sphere_param_02, small_residuals_02] = davinci_sphere_fit_least_square(pt_mat_02);
[small_sphere_param_03, small_residuals_03] = davinci_sphere_fit_least_square(pt_mat_03);
[small_sphere_param_04, small_residuals_04] = davinci_sphere_fit_least_square(pt_mat_04);
[small_sphere_param_05, small_residuals_05] = davinci_sphere_fit_least_square(pt_mat_05);
[small_sphere_param_06, small_residuals_06] = davinci_sphere_fit_least_square(pt_mat_06);
[small_sphere_param_07, small_residuals_07] = davinci_sphere_fit_least_square(pt_mat_07);
[small_sphere_param_08, small_residuals_08] = davinci_sphere_fit_least_square(pt_mat_08);
[small_sphere_param_09, small_residuals_09] = davinci_sphere_fit_least_square(pt_mat_09);
[small_sphere_param_10, small_residuals_10] = davinci_sphere_fit_least_square(pt_mat_10);

small_origin_01 = small_sphere_param_01(:,1:3);
small_origin_02 = small_sphere_param_02(:,1:3);
small_origin_03 = small_sphere_param_03(:,1:3);
small_origin_04 = small_sphere_param_04(:,1:3);
small_origin_05 = small_sphere_param_05(:,1:3);
small_origin_06 = small_sphere_param_06(:,1:3);
small_origin_07 = small_sphere_param_07(:,1:3);
small_origin_08 = small_sphere_param_08(:,1:3);
small_origin_09 = small_sphere_param_09(:,1:3);
small_origin_10 = small_sphere_param_10(:,1:3);

small_origins_vec = [small_origin_01; small_origin_02; small_origin_03; small_origin_04; small_origin_05;
    small_origin_06; small_origin_07; small_origin_08; small_origin_09; small_origin_10];

%% Calculate small_origins_vec_wrt_portal

temp_vec = small_origins_vec;
temp_vec(:,4) = 1;
temp_vec = transpose(inv(affine_portal_wrt_polaris) * transpose(temp_vec));
small_origins_vec_wrt_portal = temp_vec(:,1:3);


%% Print on Screen

small_origins_vec_wrt_portal
