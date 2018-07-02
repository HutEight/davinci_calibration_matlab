% RN@HMS Prince of Wales
% 16/02/18
% Notes.
% Each arm should create its own hash table for results. The following
% codes are not related with colour. If the new data is added (e.g. extra
% spheres, arcs, or small spehres), then the keys must get updated too.


function [result_map] = createPostProcessingTEST(pt_clds_map, pt_mats_map, joint_12_flag, plot_flag)


%% Fittings

% [plane_1_param_1, plane_2_param_1, fval_1, rot_mat_1] = davinci_planes_fit(pt_mats_map('J1Arc01'), pt_mats_map('J2Arc01'));

defineBaseFrameAndDhFrame0And1FromArcs(pt_mats_map('J1Arc01'), pt_mats_map('J2Arc01'))

result_map = 0;

end