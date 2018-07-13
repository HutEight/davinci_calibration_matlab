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
    
    dist_pt_1_to_dh_2_origin = sqrt( (dh_2_origin(1)-sphere_origin_1(1))^2 + (dh_2_origin(2)-sphere_origin_1(2))^2 + (dh_2_origin(3)-sphere_origin_1(3))^2 );
    dist_pt_2_to_dh_2_origin = sqrt( (dh_2_origin(1)-sphere_origin_2(1))^2 + (dh_2_origin(2)-sphere_origin_2(2))^2 + (dh_2_origin(3)-sphere_origin_2(3))^2 );
    dist_pt_3_to_dh_2_origin = sqrt( (dh_2_origin(1)-sphere_origin_3(1))^2 + (dh_2_origin(2)-sphere_origin_3(2))^2 + (dh_2_origin(3)-sphere_origin_3(3))^2 );
    dist_pt_4_to_dh_2_origin = sqrt( (dh_2_origin(1)-sphere_origin_4(1))^2 + (dh_2_origin(2)-sphere_origin_4(2))^2 + (dh_2_origin(3)-sphere_origin_4(3))^2 );
    
    distance_to_dh_2_origin_vec = [dist_pt_1_to_dh_2_origin cmd_j3_values(1); ...
        dist_pt_2_to_dh_2_origin cmd_j3_values(2); ...
        dist_pt_3_to_dh_2_origin cmd_j3_values(3); ...
        dist_pt_4_to_dh_2_origin cmd_j3_values(4)];
    
    % This provides the delta.
    for n = 1 : 4
        % delta = actual - cmd
        distance_to_dh_2_origin_vec(n,3) = distance_to_dh_2_origin_vec(n,2) - distance_to_dh_2_origin_vec(n,1);
    end
    
    %% Recommendation of the DH parameter d_3.
    
    % d_3 here represents the adjustment to delta (offset)
    % We expect cmd_d_3 = cmd_d_3 + delta + adjustment
    % hence, adjust = -delta
    d_3 = -mean(distance_to_dh_2_origin_vec);
    d_3 = d_3(3)
    
    % Calculate the actual increments
    dist_pt_1_2 = dist_pt_2_to_dh_2_origin - dist_pt_1_to_dh_2_origin;
    dist_pt_2_3 = dist_pt_3_to_dh_2_origin - dist_pt_2_to_dh_2_origin;
    dist_pt_3_4 = dist_pt_4_to_dh_2_origin - dist_pt_3_to_dh_2_origin;
    
    actual_small_spheres_increment_vec = [dist_pt_1_2; dist_pt_2_3; dist_pt_3_4]
    
    actual_small_spheres_increment_average = mean(actual_small_spheres_increment_vec)
    
    %% Recommendation for the Joint 3 scaling factor.
    
    % actual_command = desired_command * j3_scaling_factor
    j3_scaling_factor = cmd_increment/actual_small_spheres_increment_average
    
    fileID = fopen( strcat(save_file_path,'DH_parameters_recommendation.txt'), 'a' );

    fprintf(fileID, 'd_3: %f \n', d_3);
    fprintf(fileID, 'j3_scaling_factor: %f \n', j3_scaling_factor);
    fprintf(fileID, '\n');
    fclose(fileID);



end