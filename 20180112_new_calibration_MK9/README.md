## da Vinci Calibration Auxiliary Tool 

Version: MK9

### Main Programmes

1. [davincI_repeatability_main.m](https://github.com/HutEight/davinci_calibration_matlab/blob/master/20180112_new_calibration_MK9/davincI_repeatability_main.m)

It is designed for the 2-hour version data. [Repo_of_that_automated_calibration_stuffs]()

It takes 4 csv paths and thus can process 4 groups of data at the same time. This helps you compare the differences between several groups and identify the factors affecting your calibration results.

All the results are stored in the hash-tables: result_map_1, result_map_2, result_map_3, and result_map_1.

2. [single_data_set_main.m](https://github.com/HutEight/davinci_calibration_matlab/blob/master/20180112_new_calibration_MK9/single_data_set_main.m)

It is designed for the 2-hour version data. [Repo_of_that_automated_calibration_stuffs]()

It is basically the same as the repeatability main, but it takes and anaylses just one data group. All the results are stored in the hash-tables: result_map.

3. [arcs_and_big_sphere_only_main.m](https://github.com/HutEight/davinci_calibration_matlab/blob/master/20180112_new_calibration_MK9/arcs_and_big_sphere_only_main.m)

It is designed for the 20-min version data. [Repo_of_that_automated_calibration_stuffs]()

It also produces the Affine_portal_wrt_polaris. When provided with the 'base-marker'([affine_Md_wrt_board](https://github.com/HutEight/davinci_calibration_matlab/blob/master/20180112_new_calibration_MK9/arcs_and_big_sphere_only_main.m#L52)) you can also get the test points at the end of the programme.

### Key Functions

1. [createGreenRawDataHashTables.m](https://github.com/HutEight/davinci_calibration_matlab/blob/master/20180112_new_calibration_MK9/createGreenRawDataHashTables.m)

It is designed for preprocessing the 2-hour version data groups. It sorts the information and store them in to hashtables: path_map, pt_clds_map, and pt_mats_map, which are then passed to createPostProcessingHashTables.m for analysis.

2 [createPostProcessingHashTables.m](https://github.com/HutEight/davinci_calibration_matlab/blob/master/20180112_new_calibration_MK9/createPostProcessingHashTables.m)

It is the main analysis function for the 2-hour data groups.

Its Keys shows what it dose:
```
key_ = {'plane_1_param_1', 'plane_2_param_1', 'plane_1_param_2', 'plane_2_param_2', 'plane_1_param_3', 'plane_2_param_3', ...
    'portal_rotation_wrt_polaris', ...
    'sphere_param_1', 'sphere_param_2', 'sphere_param_3', ...
    'small_sphere_param_1', 'small_sphere_param_2', 'small_sphere_param_3', 'small_sphere_param_4', ...
    'small_sphere_param_5', 'small_sphere_param_6', 'small_sphere_param_7', 'small_sphere_param_8', 'small_sphere_param_9', ...
    'portal_origin_wrt_polaris', 'small_origins_vec', 'distance_to_portal_vec', ...
    'actual_small_ori_increments', 'ave_actual_small_ori_increment', 'rms_Sphere_vec', 'rms_Small_Spheres_vec', ...
    'j3_line_param', 'j3_line_rms', 'small_sphere_origins_line_param', 'small_sphere_origins_line_rms', ...
    'affine_portal_wrt_polaris', ...
    'joint_1_param', 'joint_2_param',...
    'small_origins_vec_wrt_portal'}
```

To toggle plotting, change the 'plot_flag' in ```function [result_map] = createPostProcessingHashTables(pt_clds_map, pt_mats_map, plot_flag)```.

To toggle the Joint 1 & 2 analysis, you need to goto (this line)[https://github.com/HutEight/davinci_calibration_matlab/blob/master/20180112_new_calibration_MK9/createPostProcessingHashTables.m#L143] to manually comment in these section. This is because it is extremely time consuming to do a round of test like this.





