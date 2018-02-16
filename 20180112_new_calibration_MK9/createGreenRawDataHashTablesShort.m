% RN@HMS Prince of Wales
% 16/02/18
% Notes.
% This function is for GREEN arm (PSM1) only. 
% This function is the short version of the creatGreenRawDataHashTables.m
% This function is intended for a faster, and thus smaller, data
% acquisition process (not formally named yet).


function [path_map, pt_clds_map, pt_mats_map] = createGreenRawDataHashTablesShort(csv_folder, plot_flag)

%% Shared Keys 
key_ = {'greenSphere01', 'greenJ1Arc01', 'greenJ2Arc01', ...
    'greenSmallSphere01', 'greenSmallSphere02', 'greenSmallSphere03', 'greenSmallSphere04', ...
    'all'};

%% Path Map Values
path_val_ = {strcat(csv_folder, '02_green_sphere_01.csv'), ...
    strcat(csv_folder, '03_green_j1_arc_01.csv'), ...
    strcat(csv_folder, '04_green_j2_arc_01.csv'), ...
    strcat(csv_folder, '05_green_small_sphere_01.csv'), ...
    strcat(csv_folder, '06_green_small_sphere_02.csv'), ...
    strcat(csv_folder, '07_green_small_sphere_03.csv'), ...
    strcat(csv_folder, '08_green_small_sphere_04.csv'), ...
    ''};

path_map_ = containers.Map(key_, path_val_);
path_map = path_map_;

%% Point Cloud Map and Point Matrix Map 

[pt_cld_greenSphere01, pt_mat_greenSphere01] = load_csv_data(path_map_('greenSphere01'));
[pt_cld_greenJ1Arc01, pt_mat_greenJ1Arc01] = load_csv_data(path_map_('greenJ1Arc01'));
[pt_cld_greenJ2Arc01, pt_mat_greenJ2Arc01] = load_csv_data(path_map_('greenJ2Arc01'));

[pt_cld_greenSmallSphere01, pt_mat_greenSmallSphere01] = load_csv_data(path_map_('greenSmallSphere01'));
[pt_cld_greenSmallSphere02, pt_mat_greenSmallSphere02] = load_csv_data(path_map_('greenSmallSphere02'));
[pt_cld_greenSmallSphere03, pt_mat_greenSmallSphere03] = load_csv_data(path_map_('greenSmallSphere03'));
[pt_cld_greenSmallSphere04, pt_mat_greenSmallSphere04] = load_csv_data(path_map_('greenSmallSphere04'));

all_green_Pts_Mat_ = [pt_mat_greenSphere01;
    pt_mat_greenJ1Arc01;
    pt_mat_greenJ2Arc01;
    pt_mat_greenSmallSphere01;
    pt_mat_greenSmallSphere02;
    pt_mat_greenSmallSphere03;
    pt_mat_greenSmallSphere04];

all_green_Pt_Clouds_ = pointCloud([all_green_Pts_Mat_(:,1), all_green_Pts_Mat_(:,2), all_green_Pts_Mat_(:,3)]);

pt_clds_val_ = {pt_cld_greenSphere01, pt_cld_greenJ1Arc01, pt_cld_greenJ2Arc01, ...
    pt_cld_greenSmallSphere01, pt_cld_greenSmallSphere02, pt_cld_greenSmallSphere03, pt_cld_greenSmallSphere04, ...
    all_green_Pt_Clouds_};

pt_mats_val_ = {pt_mat_greenSphere01, pt_mat_greenJ1Arc01, pt_mat_greenJ2Arc01, ...
    pt_mat_greenSmallSphere01, pt_mat_greenSmallSphere02, pt_mat_greenSmallSphere03, pt_mat_greenSmallSphere04, ...
    all_green_Pts_Mat_};

pt_clds_map_ = containers.Map(key_, pt_clds_val_);
pt_mats_map_ = containers.Map(key_, pt_mats_val_);

%% Plotting
if plot_flag == 1
   figure('Name', 'CONFIG - All Point Clouds');
   pcshow(all_green_Pt_Clouds_);
   hold off;  
end


%% Return

pt_clds_map = pt_clds_map_;
pt_mats_map = pt_mats_map_;
end