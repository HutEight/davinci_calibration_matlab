% RN@HMS Prince of Wales
% 12/07/18
% Descriptions.
% 
% Notes.
% 1. Joint 1 and 2 sphere fitting has been removed from Mark X due to the
% fact that there is an a offset between DH_0 and DH_1 frames.

function [result_map] = createPostProcessingHashTables(pt_clds_map, pt_mats_map, plot_flag, save_file_path)

%% Keys.



%% Fitting.

    % Small spheres fitting
    [small_sphere_param_1, small_residuals_1] = fitSphereLeastSquare(pt_mats_map('SmallSphere01'));
    [small_sphere_param_2, small_residuals_2] = fitSphereLeastSquare(pt_mats_map('SmallSphere02'));
    [small_sphere_param_3, small_residuals_3] = fitSphereLeastSquare(pt_mats_map('SmallSphere03'));
    [small_sphere_param_4, small_residuals_4] = fitSphereLeastSquare(pt_mats_map('SmallSphere04'));

    small_origin_1 = small_sphere_param_1(:,1:3);
    small_origin_2 = small_sphere_param_2(:,1:3);
    small_origin_3 = small_sphere_param_3(:,1:3);
    small_origin_4 = small_sphere_param_4(:,1:3);

    small_origins_vec = [small_origin_1; small_origin_2; small_origin_3; small_origin_4];

    % Small sphere centres line fitting
    [small_sphere_origins_line_param, small_sphere_origins_line_rms] = fitLineSvd(small_origins_vec);



%% Define DH frames 0, 1 and 2.

    [affine_dh_0_wrt_polaris, affine_dh_1_wrt_polaris, affine_base_wrt_polaris] = ...
        defineBaseFrameAndDhFrame0And1FromArcs(pt_mats_map('J1Arc01'), pt_mats_map('J2Arc01'), save_file_path);

    [affine_dh_2_wrt_polaris] = ...
        defineDhFrame02FromSmallSpheres(affine_dh_1_wrt_polaris, small_sphere_origins_line_param, save_file_path);

    
%% RMS

    rms_Sphere_vec = [rms_Sphere01];

    rms_SmallSphere01 = calculate_sphere_rms(pt_mats_map('SmallSphere01'), small_sphere_param_1(1:3), small_sphere_param_1(4));
    rms_SmallSphere02 = calculate_sphere_rms(pt_mats_map('SmallSphere02'), small_sphere_param_2(1:3), small_sphere_param_2(4));
    rms_SmallSphere03 = calculate_sphere_rms(pt_mats_map('SmallSphere03'), small_sphere_param_3(1:3), small_sphere_param_3(4));
    rms_SmallSphere04 = calculate_sphere_rms(pt_mats_map('SmallSphere04'), small_sphere_param_4(1:3), small_sphere_param_4(4));

    rms_Small_Spheres_vec = [rms_SmallSphere01; rms_SmallSphere02; rms_SmallSphere03;
        rms_SmallSphere04];





result_map = 1;

end