clc
close all
clear all

%% Loading csv paths

csv_folder = 'data_20180112/';
csv_folder = 'data_calibration_20180117/1/'
greenSphere01 = strcat(csv_folder,      '02_green_sphere_01.csv');
greenJ1Arc01 = strcat(csv_folder,       '03_green_j1_arc_01.csv');
greenJ2Arc01 = strcat(csv_folder,       '04_green_j2_arc_01.csv');
greenSphere02 = strcat(csv_folder,      '06_green_sphere_02.csv')
greenJ1Arc02 = strcat(csv_folder,       '07_green_j1_arc_02.csv');
greenJ2Arc02 = strcat(csv_folder,       '08_green_j2_arc_02.csv');
greenSphere03 = strcat(csv_folder,      '10_green_sphere_03.csv');
greenJ1Arc03 = strcat(csv_folder,       '11_green_j1_arc_03.csv');
greenJ2Arc03 = strcat(csv_folder,       '12_green_j2_arc_03.csv');
greenJ3Line = strcat(csv_folder,        '13_green_j3_line.csv');
greenJ3Cylinder = strcat(csv_folder,    '14_green_j3_cylinder.csv');
greenSmallSphere01 = strcat(csv_folder, '15_green_small_sphere_01.csv');
greenSmallSphere02 = strcat(csv_folder, '16_green_small_sphere_02.csv');
greenSmallSphere03 = strcat(csv_folder, '17_green_small_sphere_03.csv');
greenSmallSphere04 = strcat(csv_folder, '18_green_small_sphere_04.csv');
greenSmallSphere05 = strcat(csv_folder, '19_green_small_sphere_05.csv');
greenSmallSphere06 = strcat(csv_folder, '20_green_small_sphere_06.csv');
greenSmallSphere07 = strcat(csv_folder, '21_green_small_sphere_07.csv');
greenSmallSphere08 = strcat(csv_folder, '22_green_small_sphere_08.csv');
greenSmallSphere09 = strcat(csv_folder, '23_green_small_sphere_09.csv');


%% Preprocessing Data

[pt_cld_greenSphere01, pt_mat_greenSphere01] = load_csv_data(greenSphere01);
[pt_cld_greenJ1Arc01, pt_mat_greenJ1Arc01] = load_csv_data(greenJ1Arc01);
[pt_cld_greenJ2Arc01, pt_mat_greenJ2Arc01] = load_csv_data(greenJ2Arc01);
[pt_cld_greenSphere02, pt_mat_greenSphere02] = load_csv_data(greenSphere02);
[pt_cld_greenJ1Arc02, pt_mat_greenJ1Arc02] = load_csv_data(greenJ1Arc02);
[pt_cld_greenJ2Arc02, pt_mat_greenJ2Arc02] = load_csv_data(greenJ2Arc02);
[pt_cld_greenSphere03, pt_mat_greenSphere03] = load_csv_data(greenSphere03);
[pt_cld_greenJ1Arc03, pt_mat_greenJ1Arc03] = load_csv_data(greenJ1Arc03);
[pt_cld_greenJ2Arc03, pt_mat_greenJ2Arc03] = load_csv_data(greenJ2Arc03);
[pt_cld_greenJ3Line, pt_mat_greenJ3Line] = load_csv_data(greenJ3Line);
[pt_cld_greenJ3Cylinder, pt_mat_greenJ3Cylinder] = load_csv_data(greenJ3Cylinder);

[pt_cld_greenSmallSphere01, pt_mat_greenSmallSphere01] = load_csv_data(greenSmallSphere01);
[pt_cld_greenSmallSphere02, pt_mat_greenSmallSphere02] = load_csv_data(greenSmallSphere02);
[pt_cld_greenSmallSphere03, pt_mat_greenSmallSphere03] = load_csv_data(greenSmallSphere03);
[pt_cld_greenSmallSphere04, pt_mat_greenSmallSphere04] = load_csv_data(greenSmallSphere04);
[pt_cld_greenSmallSphere05, pt_mat_greenSmallSphere05] = load_csv_data(greenSmallSphere05);
[pt_cld_greenSmallSphere06, pt_mat_greenSmallSphere06] = load_csv_data(greenSmallSphere06);
[pt_cld_greenSmallSphere07, pt_mat_greenSmallSphere07] = load_csv_data(greenSmallSphere07);
[pt_cld_greenSmallSphere08, pt_mat_greenSmallSphere08] = load_csv_data(greenSmallSphere08);
[pt_cld_greenSmallSphere09, pt_mat_greenSmallSphere09] = load_csv_data(greenSmallSphere09);

allPtsMat = [pt_mat_greenSphere01;
%     pt_mat_greenJ1Arc01;
%     pt_mat_greenJ2Arc01;
%     pt_mat_greenSphere02;
%     pt_mat_greenJ2Arc02;
%     pt_mat_greenJ1Arc02;
%     pt_mat_greenSphere03;
%     pt_mat_greenJ1Arc03;
%     pt_mat_greenJ2Arc03;
%     pt_mat_greenJ3Line;
    pt_mat_greenSmallSphere01;
    pt_mat_greenSmallSphere02;
    pt_mat_greenSmallSphere03;
    pt_mat_greenSmallSphere04;
    pt_mat_greenSmallSphere05;
    pt_mat_greenSmallSphere06;
    pt_mat_greenSmallSphere07;
    pt_mat_greenSmallSphere08;
    pt_mat_greenSmallSphere09];

allPtClouds = pointCloud([allPtsMat(:,1), allPtsMat(:,2), allPtsMat(:,3)]);

figure('Name', 'CONFIG - All Point Clouds');
pcshow(allPtClouds);
hold off;   


%% Fitting 

[plane_1_param_1, plane_2_param_1, fval_1, rot_mat_1] = davinci_planes_fit(pt_mat_greenJ1Arc01, pt_mat_greenJ2Arc01);
[plane_1_param_2, plane_2_param_2, fval_2, rot_mat_2] = davinci_planes_fit(pt_mat_greenJ1Arc02, pt_mat_greenJ2Arc02);
[plane_1_param_3, plane_2_param_3, fval_3, rot_mat3] = davinci_planes_fit(pt_mat_greenJ1Arc03, pt_mat_greenJ2Arc03);

[sphere_param_1, residuals_1] = davinci_sphere_fit_least_square(pt_mat_greenSphere01);
[sphere_param_2, residuals_2] = davinci_sphere_fit_least_square(pt_mat_greenSphere02);
[sphere_param_3, residuals_3] = davinci_sphere_fit_least_square(pt_mat_greenSphere03);

[small_sphere_param_1, small_residuals_1] = davinci_sphere_fit_least_square(pt_mat_greenSmallSphere01);
[small_sphere_param_2, small_residuals_2] = davinci_sphere_fit_least_square(pt_mat_greenSmallSphere02);
[small_sphere_param_3, small_residuals_3] = davinci_sphere_fit_least_square(pt_mat_greenSmallSphere03);
[small_sphere_param_4, small_residuals_4] = davinci_sphere_fit_least_square(pt_mat_greenSmallSphere04);
[small_sphere_param_5, small_residuals_5] = davinci_sphere_fit_least_square(pt_mat_greenSmallSphere05);
[small_sphere_param_6, small_residuals_6] = davinci_sphere_fit_least_square(pt_mat_greenSmallSphere06);
[small_sphere_param_7, small_residuals_7] = davinci_sphere_fit_least_square(pt_mat_greenSmallSphere07);
[small_sphere_param_8, small_residuals_8] = davinci_sphere_fit_least_square(pt_mat_greenSmallSphere08);
[small_sphere_param_9, small_residuals_9] = davinci_sphere_fit_least_square(pt_mat_greenSmallSphere09);

portal_origin = [(sphere_param_1(1)+sphere_param_2(1)+sphere_param_3(1))/3 
    (sphere_param_1(2)+sphere_param_2(2)+sphere_param_3(2))/3
    (sphere_param_1(3)+sphere_param_2(3)+sphere_param_3(3))/3];
portal_origin = transpose(portal_origin);

small_origin_1 = small_sphere_param_1(:,1:3);
small_origin_2 = small_sphere_param_2(:,1:3);
small_origin_3 = small_sphere_param_3(:,1:3);
small_origin_4 = small_sphere_param_4(:,1:3);
small_origin_5 = small_sphere_param_5(:,1:3);
small_origin_6 = small_sphere_param_6(:,1:3);
small_origin_7 = small_sphere_param_7(:,1:3);
small_origin_8 = small_sphere_param_8(:,1:3);
small_origin_9 = small_sphere_param_9(:,1:3);

distance_1_0 = sqrt( (portal_origin(1)-small_origin_1(1))^2 + (portal_origin(2)-small_origin_1(2))^2 + (portal_origin(3)-small_origin_1(3))^2 );
distance_2_0 = sqrt( (portal_origin(1)-small_origin_2(1))^2 + (portal_origin(2)-small_origin_2(2))^2 + (portal_origin(3)-small_origin_2(3))^2 );
distance_3_0 = sqrt( (portal_origin(1)-small_origin_3(1))^2 + (portal_origin(2)-small_origin_3(2))^2 + (portal_origin(3)-small_origin_3(3))^2 );
distance_4_0 = sqrt( (portal_origin(1)-small_origin_4(1))^2 + (portal_origin(2)-small_origin_4(2))^2 + (portal_origin(3)-small_origin_4(3))^2 );
distance_5_0 = sqrt( (portal_origin(1)-small_origin_5(1))^2 + (portal_origin(2)-small_origin_5(2))^2 + (portal_origin(3)-small_origin_5(3))^2 );
distance_6_0 = sqrt( (portal_origin(1)-small_origin_6(1))^2 + (portal_origin(2)-small_origin_6(2))^2 + (portal_origin(3)-small_origin_6(3))^2 );
distance_7_0 = sqrt( (portal_origin(1)-small_origin_7(1))^2 + (portal_origin(2)-small_origin_7(2))^2 + (portal_origin(3)-small_origin_7(3))^2 );
distance_8_0 = sqrt( (portal_origin(1)-small_origin_8(1))^2 + (portal_origin(2)-small_origin_8(2))^2 + (portal_origin(3)-small_origin_8(3))^2 );
distance_9_0 = sqrt( (portal_origin(1)-small_origin_9(1))^2 + (portal_origin(2)-small_origin_9(2))^2 + (portal_origin(3)-small_origin_9(3))^2 );

distance_to_portal_vec = [distance_1_0 0.21; distance_2_0 0.19; distance_3_0 0.17; distance_4_0 0.15; 
    distance_5_0 0.13; distance_6_0 0.11; distance_7_0 0.09; distance_8_0 0.07; distance_9_0 0.05];

for n = 1 : 9
    distance_to_portal_vec(n,3) = distance_to_portal_vec(n,2) - distance_to_portal_vec(n,1);
end

distance_1_2 = sqrt( (small_origin_1(1)-small_origin_2(1))^2 + (small_origin_1(2)-small_origin_2(2))^2 + (small_origin_1(3)-small_origin_2(3))^2 );
distance_2_3 = sqrt( (small_origin_2(1)-small_origin_3(1))^2 + (small_origin_2(2)-small_origin_3(2))^2 + (small_origin_2(3)-small_origin_3(3))^2 );
distance_3_4 = sqrt( (small_origin_3(1)-small_origin_4(1))^2 + (small_origin_3(2)-small_origin_4(2))^2 + (small_origin_3(3)-small_origin_4(3))^2 );
distance_4_5 = sqrt( (small_origin_4(1)-small_origin_5(1))^2 + (small_origin_4(2)-small_origin_5(2))^2 + (small_origin_4(3)-small_origin_5(3))^2 );
distance_5_6 = sqrt( (small_origin_5(1)-small_origin_6(1))^2 + (small_origin_5(2)-small_origin_6(2))^2 + (small_origin_5(3)-small_origin_6(3))^2 );
distance_6_7 = sqrt( (small_origin_6(1)-small_origin_7(1))^2 + (small_origin_6(2)-small_origin_7(2))^2 + (small_origin_6(3)-small_origin_7(3))^2 );
distance_7_8 = sqrt( (small_origin_7(1)-small_origin_8(1))^2 + (small_origin_7(2)-small_origin_8(2))^2 + (small_origin_7(3)-small_origin_8(3))^2 );
distance_8_9 = sqrt( (small_origin_8(1)-small_origin_9(1))^2 + (small_origin_8(2)-small_origin_9(2))^2 + (small_origin_8(3)-small_origin_9(3))^2 );

distance_small_spheres_vec = [distance_1_2; distance_2_3; distance_3_4; distance_4_5; distance_5_6; distance_6_7; distance_7_8; distance_8_9];

ave_distance = (distance_1_2 + distance_2_3 + distance_3_4 + distance_4_5 + distance_5_6 + distance_6_7 + distance_7_8 + distance_8_9)/8;

%% Plotting

figure('Name', 'Origins');
scatter3(portal_origin(1), portal_origin(2), portal_origin(3));
hold on;
scatter3(small_origin_1(1), small_origin_1(2), small_origin_1(3), 'filled');
scatter3(small_origin_2(1), small_origin_2(2), small_origin_2(3), 'filled');
scatter3(small_origin_3(1), small_origin_3(2), small_origin_3(3), 'filled');
scatter3(small_origin_4(1), small_origin_4(2), small_origin_4(3), 'filled');
scatter3(small_origin_5(1), small_origin_5(2), small_origin_5(3), 'filled');
scatter3(small_origin_6(1), small_origin_6(2), small_origin_6(3), 'filled');
scatter3(small_origin_7(1), small_origin_7(2), small_origin_7(3), 'filled');
scatter3(small_origin_8(1), small_origin_8(2), small_origin_8(3), 'filled');
scatter3(small_origin_9(1), small_origin_9(2), small_origin_9(3), 'filled');
pcshow(allPtClouds);
hold off;

figure('Name', 'Small01');
pcshow(pt_cld_greenSmallSphere01);
hold on;
scatter3(small_origin_1(1), small_origin_1(2), small_origin_1(3), 'filled');
[x y z] = sphere;
a = [small_sphere_param_1(1), small_sphere_param_1(2), small_sphere_param_1(3),  small_sphere_param_1(4)];
s1=surf(x*a(1,4)+a(1,1),y*a(1,4)+a(1,2),z*a(1,4)+a(1,3));
hold off;

%% rms

rms_greenSphere01 = calculate_sphere_rms(pt_mat_greenSphere01, sphere_param_1(1:3), sphere_param_1(4));
sprintf('%f', rms_greenSphere01)
rms_greenSphere02 = calculate_sphere_rms(pt_mat_greenSphere02, sphere_param_2(1:3), sphere_param_2(4));
sprintf('%f', rms_greenSphere02)

rms_greenSmallSphere01 = calculate_sphere_rms(pt_mat_greenSmallSphere01, small_sphere_param_1(1:3), small_sphere_param_1(4));
sprintf('%f', rms_greenSmallSphere01)
rms_greenSmallSphere02 = calculate_sphere_rms(pt_mat_greenSmallSphere02, small_sphere_param_2(1:3), small_sphere_param_2(4));
sprintf('%f', rms_greenSmallSphere02)
rms_greenSmallSphere03 = calculate_sphere_rms(pt_mat_greenSmallSphere03, small_sphere_param_3(1:3), small_sphere_param_3(4));
sprintf('%f', rms_greenSmallSphere03)
rms_greenSmallSphere04 = calculate_sphere_rms(pt_mat_greenSmallSphere04, small_sphere_param_4(1:3), small_sphere_param_4(4));
sprintf('%f', rms_greenSmallSphere04)
rms_greenSmallSphere05 = calculate_sphere_rms(pt_mat_greenSmallSphere05, small_sphere_param_5(1:3), small_sphere_param_5(4));
sprintf('%f', rms_greenSmallSphere05)
rms_greenSmallSphere06 = calculate_sphere_rms(pt_mat_greenSmallSphere06, small_sphere_param_6(1:3), small_sphere_param_6(4));
sprintf('%f', rms_greenSmallSphere06)
rms_greenSmallSphere07 = calculate_sphere_rms(pt_mat_greenSmallSphere07, small_sphere_param_7(1:3), small_sphere_param_7(4));
sprintf('%f', rms_greenSmallSphere07)
rms_greenSmallSphere08 = calculate_sphere_rms(pt_mat_greenSmallSphere08, small_sphere_param_8(1:3), small_sphere_param_8(4));
sprintf('%f', rms_greenSmallSphere08)
rms_greenSmallSphere09 = calculate_sphere_rms(pt_mat_greenSmallSphere09, small_sphere_param_9(1:3), small_sphere_param_9(4));
sprintf('%f', rms_greenSmallSphere09)

rms_greenSmallSpheres = [rms_greenSmallSphere01; rms_greenSmallSphere02; rms_greenSmallSphere03;
    rms_greenSmallSphere04; rms_greenSmallSphere05; rms_greenSmallSphere06;
    rms_greenSmallSphere07; rms_greenSmallSphere08; rms_greenSmallSphere09];