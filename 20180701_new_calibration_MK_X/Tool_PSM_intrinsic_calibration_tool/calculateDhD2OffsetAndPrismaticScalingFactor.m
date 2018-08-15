% RN@HMS Queen Elizabeth
% 12/07/18
% Description.
%
% Notes.
%



function [] = calculateDhD2OffsetAndPrismaticScalingFactor(small_sphere_origins_vec, affine_dh_2_wrt_polaris, save_file_path)

    cmd_j3_values = [0.05 0.11 0.17 0.23];
    
    cmd_increment = 0.06;
    
    dh_2_origin = affine_dh_2_wrt_polaris(1:3, 4);
    
    sphere_origin_1 = small_sphere_origins_vec(1,:);
    sphere_origin_2 = small_sphere_origins_vec(2,:);
    sphere_origin_3 = small_sphere_origins_vec(3,:);
    sphere_origin_4 = small_sphere_origins_vec(4,:);
    
    dist_pt_1_to_dh_2_origin = norm(dh_2_origin - sphere_origin_1(:));
    dist_pt_2_to_dh_2_origin = norm(dh_2_origin - sphere_origin_2(:));
    dist_pt_3_to_dh_2_origin = norm(dh_2_origin - sphere_origin_3(:));
    dist_pt_4_to_dh_2_origin = norm(dh_2_origin - sphere_origin_4(:));
    
    distance_to_dh_2_origin_vec = [dist_pt_1_to_dh_2_origin cmd_j3_values(1); ...
        dist_pt_2_to_dh_2_origin cmd_j3_values(2); ...
        dist_pt_3_to_dh_2_origin cmd_j3_values(3); ...
        dist_pt_4_to_dh_2_origin cmd_j3_values(4)];
    
    % This provides the delta.
    for n = 1 : 4
        % delta = actual - cmd
        distance_to_dh_2_origin_vec(n,3) = distance_to_dh_2_origin_vec(n,2) - distance_to_dh_2_origin_vec(n,1);
    end
    
    %% Solve the linear equation of acutal joint value(y) and cmd joint value (x)
    
    A = ones(4,2);
    A(:,1) = cmd_j3_values;
    y = distance_to_dh_2_origin_vec(:,1);
    temp = A\y;
    k = temp(1);
    d = temp(2);
    
    %
     figure('Name', 'd_3 auxiliary');
     scatter(cmd_j3_values, distance_to_dh_2_origin_vec(:,1));
     axis([0 0.3 -0.1 0.3])
     hold off;
    
    
    %% Recommendation of DH parameter d_3 and j3_scale_factor
    
    d_3 = d; 
    j3_scale_factor = k;
    
    % These 2 are used in the process of solving forward kinematics. We
    % need to convert the q_vec correctly into DH_vec. These 2 affects the
    % value of d_3 in the DH ssytem. Note that Joint 3 is prismatic, so the
    % d_3 = d_3_offset + q_val, we have found d_3_offset above, and we need
    % to translate the q_cmd accurately into q_actual. We have --
    % q_actual = j3_scale_factor * q_cmd, therefore we have --
    % d_3 = d_3_offset + j3_scale_factor * q_cmd.
    % This is reflected in the fwd_kin code --
    %     dvals_DH_vec = dval_DH_offsets_map_[kinematic_set_name]; // Load
    %     the offset
    %     dvals_DH_vec(2) +=
    %     j3_scale_factor_map_[kinematic_set_name]*q_vec(2); // 
    
    
    
%     %% Recommendation of the DH parameter d_3.
%     
%     % d_3 here represents the adjustment to delta (offset)
%     % We expect cmd_d_3 = cmd_d_3 + delta + adjustment
%     % hence, adjust = -delta
%     d_3 = -mean(distance_to_dh_2_origin_vec);
%     d_3 = d_3(3)
%     
%     % Calculate the actual increments
    dist_pt_1_2 = dist_pt_2_to_dh_2_origin - dist_pt_1_to_dh_2_origin;
    dist_pt_2_3 = dist_pt_3_to_dh_2_origin - dist_pt_2_to_dh_2_origin;
    dist_pt_3_4 = dist_pt_4_to_dh_2_origin - dist_pt_3_to_dh_2_origin;
    
    actual_small_spheres_increment_vec = [dist_pt_1_2; dist_pt_2_3; dist_pt_3_4]
    
    actual_small_spheres_increment_average = mean(actual_small_spheres_increment_vec)
%     
%     %% Recommendation for the Joint 3 scaling factor.
%     
%     % actual_command = desired_command * j3_scale_factor
    j3_scale_factor_ref = actual_small_spheres_increment_average/cmd_increment
    
    
    %% 
    fileID = fopen( strcat(save_file_path,'DH_parameters_recommendation.txt'), 'a' );
     
    fprintf(fileID, '# DH_2 TO DH_3 FRAME\n');
    fprintf(fileID, 'd_3: %f \n\n', d_3);
    fprintf(fileID, 'j3_scale_factor: %f \n', j3_scale_factor);
    fprintf(fileID, '\n');
    fprintf(fileID, '# Please entre the j1 and j2 scale factor manually for the time being.');
    fprintf(fileID, '\n');
    fclose(fileID);



end