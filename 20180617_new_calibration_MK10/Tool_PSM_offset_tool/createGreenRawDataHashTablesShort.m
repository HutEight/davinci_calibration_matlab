% RN@HMS Prince of Wales
% 17/06/18
% Notes.
% This function is for both arms. 
% This function is the short version of the creatGreenRawDataHashTables.m
% This function is intended for a faster, and thus smaller, data
% acquisition process (not formally named yet).


function [path_map, pt_clds_map, pt_mats_map] = createGreenRawDataHashTablesShort(csv_folder, plot_flag)

%% Shared Keys 
key_ = {'BigSphere01', 'J1Arc01', 'J2Arc01', ...
    'SmallSphere01', 'SmallSphere02', 'SmallSphere03', 'SmallSphere04', ...
    'all'};

%% Path Map Values
try
    
    path_val_ = {strcat(csv_folder, '02_green_sphere_01.csv'), ...
    strcat(csv_folder, '03_yellow_j1_arc_01.csv'), ...
    strcat(csv_folder, '04_yellow_j2_arc_01.csv'), ...
    strcat(csv_folder, '05_yellow_small_sphere_5cm.csv'), ...
    strcat(csv_folder, '06_yellow_small_sphere_11cm.csv'), ...
    strcat(csv_folder, '07_yellow_small_sphere_17cm.csv'), ...
    strcat(csv_folder, '08_yellow_small_sphere_23cm.csv'), ...
    ''};

    path_map_ = containers.Map(key_, path_val_);
    path_map = path_map_;

    [pt_cld_Sphere01, pt_mat_Sphere01] = load_csv_data(path_map_('Sphere01'));
    [pt_cld_J1Arc01, pt_mat_J1Arc01] = load_csv_data(path_map_('J1Arc01'));
    [pt_cld_J2Arc01, pt_mat_J2Arc01] = load_csv_data(path_map_('J2Arc01'));

    [pt_cld_SmallSphere01, pt_mat_SmallSphere01] = load_csv_data(path_map_('SmallSphere01'));
    [pt_cld_SmallSphere02, pt_mat_SmallSphere02] = load_csv_data(path_map_('SmallSphere02'));
    [pt_cld_SmallSphere03, pt_mat_SmallSphere03] = load_csv_data(path_map_('SmallSphere03'));
    [pt_cld_SmallSphere04, pt_mat_SmallSphere04] = load_csv_data(path_map_('SmallSphere04'));



catch
    
    path_val_ = {strcat(csv_folder, '02_yellow_sphere_01.csv'), ...
    strcat(csv_folder, '03_yellow_j1_arc_01.csv'), ...
    strcat(csv_folder, '04_yellow_j2_arc_01.csv'), ...
    strcat(csv_folder, '05_yellow_small_sphere_5cm.csv'), ...
    strcat(csv_folder, '06_yellow_small_sphere_11cm.csv'), ...
    strcat(csv_folder, '07_yellow_small_sphere_17cm.csv'), ...
    strcat(csv_folder, '08_yellow_small_sphere_23cm.csv'), ...
    ''};

    path_map_ = containers.Map(key_, path_val_);
    path_map = path_map_;


    [pt_cld_Sphere01, pt_mat_Sphere01] = load_csv_data(path_map_('BigSphere01'));
    [pt_cld_J1Arc01, pt_mat_J1Arc01] = load_csv_data(path_map_('J1Arc01'));
    [pt_cld_J2Arc01, pt_mat_J2Arc01] = load_csv_data(path_map_('J2Arc01'));

    [pt_cld_SmallSphere01, pt_mat_SmallSphere01] = load_csv_data(path_map_('SmallSphere01'));
    [pt_cld_SmallSphere02, pt_mat_SmallSphere02] = load_csv_data(path_map_('SmallSphere02'));
    [pt_cld_SmallSphere03, pt_mat_SmallSphere03] = load_csv_data(path_map_('SmallSphere03'));
    [pt_cld_SmallSphere04, pt_mat_SmallSphere04] = load_csv_data(path_map_('SmallSphere04'));

end



%% Point Cloud Map and Point Matrix Map 

all_Pts_Mat_ = [pt_mat_Sphere01;
    pt_mat_J1Arc01;
    pt_mat_J2Arc01;];
%     pt_mat_greenSmallSphere01;
%     pt_mat_greenSmallSphere02;
%     pt_mat_greenSmallSphere03;
%     pt_mat_greenSmallSphere04

all_Pt_Clouds_ = pointCloud([all_Pts_Mat_(:,1), all_Pts_Mat_(:,2), all_Pts_Mat_(:,3)]);

pt_clds_val_ = {pt_cld_Sphere01, pt_cld_J1Arc01, pt_cld_J2Arc01, ...
    pt_cld_SmallSphere01, pt_cld_SmallSphere02, pt_cld_SmallSphere03, pt_cld_SmallSphere04, ...
    all_Pt_Clouds_};

pt_mats_val_ = {pt_mat_Sphere01, pt_mat_J1Arc01, pt_mat_J2Arc01, ...
    pt_mat_SmallSphere01, pt_mat_SmallSphere02, pt_mat_SmallSphere03, pt_mat_SmallSphere04, ...
    all_Pts_Mat_};

pt_clds_map_ = containers.Map(key_, pt_clds_val_);
pt_mats_map_ = containers.Map(key_, pt_mats_val_);

%% Plotting
if plot_flag == 1
   figure('Name', 'CONFIG - All Point Clouds');
   pcshow(all_Pt_Clouds_);
   hold off;  
end


%% Return

pt_clds_map = pt_clds_map_;
pt_mats_map = pt_mats_map_;
end