% RN@HMS Queen Elizabeth
% 15/10/18
% Descriptions.
%
% Notes.
%
% it uses lines_dist()


function [affine_dh_04_wrt_polaris, affine_dh_05_wrt_polaris, dh_4, dh_5] = ... 
        defineDhFrame04And05FromArcsWithJ3Offset(j5_arc_in_polairs_mat, j6_arc_in_polairs_mat, ...
        affine_dh_03_wrt_polaris, j3_offset, d_3_offset, j3_scale_factor, save_file_path)
    
    
    %% Transform Frame 3 after applying a d_3 offset.
    % Calculate d_3 first.
    d_3 = d_3_offset + j3_offset*j3_scale_factor;
    
    % This transform will change every frame after Frame 03. Therefore we
    % can use its inverse to get the zero config as well.  
    transform_d3 = eye(4, 4);
    transform_d3(1:3, 4) = d_3 * affine_dh_03_wrt_polaris(1:3, 3);
    
    % This will be used to calculate the DH params to frame 04.
    affine_dh_03_wrt_polaris_with_d3_offset = transform_d3 * affine_dh_03_wrt_polaris;
    
    
    %% Get z4 and z5 direction reference

    ref = j5_arc_in_polairs_mat(5,4);

    t1 = (ref < j5_arc_in_polairs_mat(:,4)) &  (j5_arc_in_polairs_mat(:,4) < ref + 0.2);
    t2 = (ref + 0.2 < j5_arc_in_polairs_mat(:,4)) &  (j5_arc_in_polairs_mat(:,4) < ref + 0.4);
    t3 = (ref + 0.4 < j5_arc_in_polairs_mat(:,4)) &  (j5_arc_in_polairs_mat(:,4) < ref + 0.6);
    j5_x = j5_arc_in_polairs_mat(:,1);
    j5_y = j5_arc_in_polairs_mat(:,2);
    j5_z = j5_arc_in_polairs_mat(:,3);
    j5_pt1 = [j5_x(t1) j5_y(t1) j5_z(t1)];
    j5_pt1 = mean(j5_pt1);
    j5_pt2 = [j5_x(t2) j5_y(t2) j5_z(t2)];
    j5_pt2 = mean(j5_pt2);
    j5_pt3 = [j5_x(t3) j5_y(t3) j5_z(t3)];
    j5_pt3 = mean(j5_pt3);
    % Note that J1 starts with q=1.5, it then moves to q=-1.5, therefore the
    % first rotation is opposite its axis. 
    j5_vec_ref = - cross((j5_pt2 - j5_pt1),(j5_pt3 - j5_pt1));
    j5_vec_ref = j5_vec_ref/norm(j5_vec_ref);

    if isnan(j5_vec_ref)
       warning('j5_vec_ref calculation is NaA. Using y_3 vector instead.'); 
       j5_vec_ref = transpose(affine_dh_03_wrt_polaris(1:3,2));
    end
    
    
    ref = j6_arc_in_polairs_mat(5,4);

    t1 = (ref < j6_arc_in_polairs_mat(:,4)) &  (j6_arc_in_polairs_mat(:,4) < ref + 0.2);
    t2 = (ref + 0.2 < j6_arc_in_polairs_mat(:,4)) &  (j6_arc_in_polairs_mat(:,4) < ref + 0.4);
    t3 = (ref + 0.4 < j6_arc_in_polairs_mat(:,4)) &  (j6_arc_in_polairs_mat(:,4) < ref + 0.6);
    j6_x = j6_arc_in_polairs_mat(:,1);
    j6_y = j6_arc_in_polairs_mat(:,2);
    j6_z = j6_arc_in_polairs_mat(:,3);
    j6_pt1 = [j6_x(t1) j6_y(t1) j6_z(t1)];
    j6_pt1 = mean(j6_pt1);
    j6_pt2 = [j6_x(t2) j6_y(t2) j6_z(t2)];
    j6_pt2 = mean(j6_pt2);
    j6_pt3 = [j6_x(t3) j6_y(t3) j6_z(t3)];
    j6_pt3 = mean(j6_pt3);
    % Note that J1 starts with q=1.5, it then moves to q=-1.5, therefore the
    % first rotation is opposite its axis. 
    j6_vec_ref = - cross((j6_pt2 - j6_pt1),(j6_pt3 - j6_pt1));
    j6_vec_ref = j6_vec_ref/norm(j6_vec_ref);

    if isnan(j6_vec_ref)
       warning('j6_vec_ref calculation is NaA. Using x_3 vector instead.'); 
       j6_vec_ref = transpose(affine_dh_03_wrt_polaris(1:3,1));
    end

    
    %% Get Joint 5 (Joint 5 after a d3 transform).
    
    % Circle and Plane fitting
    [j5_arc_circle_params, j5_arc_plane_norm, j5_fval, j5_rms] =...
        fitCircleFmincon(j5_arc_in_polairs_mat)
    
    % Auxilary variables
    radius_j5_circle = j5_arc_circle_params(1, 4);
    rms_j5_circle = j5_rms;
    j5_vec = j5_arc_plane_norm;
    j5_vec = j5_vec(:); % force into a column    
    j5_vec = transpose(j5_vec); % so we can make sure it is a row
    
    % Origin of j5 circle
    origin_j5_circle = j5_arc_circle_params(1, 1:3);
    
    origin_j5_circle = origin_j5_circle(:);
    
    % Adjust j5_vec direction according to the j5_vec_ref
    ang_diff_j5 = atan2(norm(cross(j5_vec, j5_vec_ref)), dot(j5_vec, j5_vec_ref));
    if (ang_diff_j5 > pi/2)
       j5_vec = -j5_vec; 
    end

    if (rms_j5_circle > 0.001)
        warning('Excessive rms_j5_circle:%f',rms_j5_circle);
    end

    % Enforce that Joint 5 (z4) passes through the origin of frame_3 (after d3 transform).
    current_O3 = affine_dh_03_wrt_polaris_with_d3_offset(1:3, 4);
    [dist_1] = calculatePointLineDist(origin_j5_circle, j5_vec, current_O3);
    
    if (dist_1 < 0.0005)
        current_04 = current_O3;
        j5_fixed_pt = current_O3;
        fprintf('The distance from Joint 5 to Joint 4 is:%f',dist_1);
    else
        warning('The distance from Joint 5 to Joint 4 is too big:%f',dist_1);
        j5_fixed_pt = origin_j5_circle;
    end
    
    j5_fixed_pt = origin_j5_circle;
    
    
    
    %% Get Joint 6
    
    % Circle and Plane fitting
    [j6_arc_circle_params, j6_arc_plane_norm, j6_fval, j6_rms] =...
        fitCircleFmincon(j6_arc_in_polairs_mat)
    
    % Auxilary variables
    radius_j6_circle = j6_arc_circle_params(1, 4);
    rms_j6_circle = j6_rms;
    j6_vec = j6_arc_plane_norm;
    j6_vec = j6_vec(:); % force into a column    
    j6_vec = transpose(j6_vec) % so we can make sure it is a row
    
    % Origin of j5 circle
    origin_j6_circle = j6_arc_circle_params(1, 1:3);
    
    origin_j6_circle = origin_j6_circle(:);
    
    % Adjust j5_vec direction according to the j5_vec_ref
    ang_diff_j6 = atan2(norm(cross(j6_vec, j6_vec_ref)), dot(j6_vec, j6_vec_ref));
    if (ang_diff_j6 > pi/2)
       j6_vec = -j6_vec; 
    end
    
    j6_fixed_pt = origin_j6_circle;

    if (rms_j6_circle > 0.001)
        warning('Excessive rms_j6_circle:%f',rms_j6_circle);
    end
    
   
    
    %% Calculate Frame 4 (with a non-zero d3)
    
    [affine_dh_04_wrt_polaris_with_d3_offset, d_4, theta_4, a_4, alpha_4] = ...
        calculateNextDhFrame (affine_dh_03_wrt_polaris_with_d3_offset, j5_fixed_pt, j5_vec); 
    
    affine_dh_04_wrt_polaris =  inv(transform_d3) * affine_dh_04_wrt_polaris_with_d3_offset;
    

    
    %% Calculate Frame 5 (with a non-zero d3)
    [affine_dh_05_wrt_polaris_with_d3_offset, d_5, theta_5, a_5, alpha_5] = ...
        calculateNextDhFrame (affine_dh_04_wrt_polaris_with_d3_offset, j6_fixed_pt, j6_vec);  
    
    affine_dh_05_wrt_polaris = inv(transform_d3) * affine_dh_05_wrt_polaris_with_d3_offset;
    
    %% DH params
    dh_4.theta = theta_4;
    dh_4.d = d_4;
    dh_4.a = a_4;
    dh_4.alpha = alpha_4;
    
    dh_5.theta = theta_5;
    dh_5.d = d_5;
    dh_5.a = a_5;
    dh_5.alpha = alpha_5;
    
    
    %% Figures
    figure('Name', 'J5 arc')
    scatter3(j5_arc_in_polairs_mat(:,1), j5_arc_in_polairs_mat(:,2), j5_arc_in_polairs_mat(:,3));
    figure('Name', 'J6 arc')
    scatter3(j6_arc_in_polairs_mat(:,1), j6_arc_in_polairs_mat(:,2), j6_arc_in_polairs_mat(:,3));

    
    %% Export 

    fileID = fopen( strcat(save_file_path, 'Fitting_rms_summary.txt'), 'a');
    fprintf(fileID, 'rms_j5_circle: %f\n', j5_rms);
    fprintf(fileID, 'rms_j6_circle: %f\n', j6_rms);
    fclose(fileID);

    save(strcat(save_file_path, 'affine_dh_04_wrt_polaris.mat'), 'affine_dh_04_wrt_polaris');
    save(strcat(save_file_path, 'affine_dh_05_wrt_polaris.mat'), 'affine_dh_05_wrt_polaris');

    
end