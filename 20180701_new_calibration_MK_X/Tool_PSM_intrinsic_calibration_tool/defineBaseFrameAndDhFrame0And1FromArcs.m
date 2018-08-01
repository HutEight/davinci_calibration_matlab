% RN@HMS Queen Elizabeth
% 01/07/18
% Descriptions.
%
% Notes.
%
% it uses lines_dist()

function [affine_dh_0_wrt_polaris, affine_dh_1_wrt_polaris, affine_base_wrt_polaris]...
    = defineBaseFrameAndDhFrame0And1FromArcs(j1_arc_in_polairs_mat, ...
    j2_arc_in_polairs_mat, ...
    save_file_path)
 
%% Get z0 and z1 direction reference

ref = j1_arc_in_polairs_mat(1,4);

t1 = (ref < j1_arc_in_polairs_mat(:,4)) &  (j1_arc_in_polairs_mat(:,4) < ref + 0.2);
t2 = (ref + 0.2 < j1_arc_in_polairs_mat(:,4)) &  (j1_arc_in_polairs_mat(:,4) < ref + 0.4);
t3 = (ref + 0.4 < j1_arc_in_polairs_mat(:,4)) &  (j1_arc_in_polairs_mat(:,4) < ref + 0.6);
j1_x = j1_arc_in_polairs_mat(:,1);
j1_y = j1_arc_in_polairs_mat(:,2);
j1_z = j1_arc_in_polairs_mat(:,3);
j1_pt1 = [j1_x(t1) j1_y(t1) j1_z(t1)];
j1_pt1 = mean(j1_pt1);
j1_pt2 = [j1_x(t2) j1_y(t2) j1_z(t2)];
j1_pt2 = mean(j1_pt2);
j1_pt3 = [j1_x(t3) j1_y(t3) j1_z(t3)];
j1_pt3 = mean(j1_pt3);
% Note that J1 starts with q=1.5, it then moves to q=-1.5, therefore the
% first rotation is opposite its axis. 
j1_vec_ref = - cross((j1_pt2 - j1_pt1),(j1_pt3 - j1_pt1));
j1_vec_ref = j1_vec_ref/norm(j1_vec_ref)

if isnan(j1_vec_ref)
   warning('j1_vec_ref is NaA'); 
end


ref = j2_arc_in_polairs_mat(10,4);

t1 = (ref < j2_arc_in_polairs_mat(:,4)) &  (j2_arc_in_polairs_mat(:,4) < ref + 0.2);
t2 = (ref + 0.2 < j2_arc_in_polairs_mat(:,4)) &  (j2_arc_in_polairs_mat(:,4) < ref + 0.4);
t3 = (ref + 0.4 < j2_arc_in_polairs_mat(:,4)) &  (j2_arc_in_polairs_mat(:,4) < ref + 0.6);
j2_x = j2_arc_in_polairs_mat(:,1);
j2_y = j2_arc_in_polairs_mat(:,2);
j2_z = j2_arc_in_polairs_mat(:,3);
j2_pt1 = [j2_x(t1) j2_y(t1) j2_z(t1)];
j2_pt1 = mean(j2_pt1);
j2_pt2 = [j2_x(t2) j2_y(t2) j2_z(t2)];
j2_pt2 = mean(j2_pt2);
j2_pt3 = [j2_x(t3) j2_y(t3) j2_z(t3)];
j2_pt3 = mean(j2_pt3);
% Note that J1 starts with q=1.5, it then moves to q=-1.5, therefore the
% first rotation is opposite its axis. 
j2_vec_ref = - cross((j2_pt2 - j2_pt1),(j2_pt3 - j2_pt1));
j2_vec_ref = j2_vec_ref/norm(j2_vec_ref)

if isnan(j2_vec_ref)
   j2_vec_ref('j1_vec_ref is NaA'); 
end

%% Joint 1 Params

    % Circle and Plane fitting
    [j1_arc_circle_params, j1_arc_plane_norm, j1_fval, j1_rms] =...
        fitCircleFmincon(j1_arc_in_polairs_mat)
    
    % Auxilary variables
    radius_j1_circle = j1_arc_circle_params(1, 4)
    rms_j1_circle = j1_rms;
    j1_vec = j1_arc_plane_norm;
    j1_vec = j1_vec(:); % force into a column    
    j1_vec = transpose(j1_vec) % so we can make sure it is a row
    
    % Origin of j1 circle
    origin_j1_circle = j1_arc_circle_params(1, 1:3);
    
    % Adjust j1_vec direction according to the j1_vec_ref
    ang_diff_j1 = atan2(norm(cross(j1_vec, j1_vec_ref)), dot(j1_vec, j1_vec_ref))
    if (ang_diff_j1 > pi/2)
       j1_vec = -j1_vec; 
    end
    
        
    if (rms_j1_circle > 0.001)
        warning('Excessive rms_j1_circle:%f',rms_j1_circle);
    end
    

%% Joint 2 Params
  
    % Circle and Plane fitting
    [j2_arc_circle_params, j2_arc_plane_norm, j2_fval, j2_rms] =...
        fitCircleFmincon(j2_arc_in_polairs_mat)
    
    % Auxilary variables
    radius_j2_circle = j2_arc_circle_params(1, 4);
    rms_j2_circle = j2_rms;
    j2_vec = j2_arc_plane_norm;
    j2_vec = j2_vec(:);
    j2_vec = transpose(j2_vec)
    
    % Origin of DH frame 0, also the origin of the base frame.
    origin_j2_circle = j2_arc_circle_params(1, 1:3);
   
    % Adjust j2_vec direction according to the j2_vec_ref
    ang_diff_j2 = atan2(norm(cross(j2_vec, j2_vec_ref)), dot(j2_vec, j2_vec_ref))
    if (ang_diff_j2 > pi/2)
       j2_vec = -j2_vec; 
    end
    
    if (rms_j2_circle > 0.001)
        warning('Excessive rms_j2_circle:%f',rms_j2_circle);
    end
    

%% Calculate a1 and alpha_1 (from frame_0 to frame_1)

    dist_j1_2 = calculateTowLinesDist(origin_j1_circle, j1_vec, ...
        origin_j2_circle, j2_vec, 0, 'dist_j1_2')

    angle_j1_2 = atan2(norm(cross(j1_vec, j2_vec)), dot(j1_vec, j2_vec))
    
    common_norm_j1_2 = cross(j1_vec, j2_vec);
    
    theta_1 = pi
    
    alpha_1 = - angle_j1_2
    
    a_1 = dist_j1_2
    
    d_1 = 0
    
    % Adjust common_norm_j1_2 direction -- normally, it should be parallel
    % to Polaris x. Therefore its x should be positive.
%     if common_norm_j1_2(1,1) < 0
%         common_norm_j1_2 = -common_norm_j1_2;
%     end

%% Get O_0 and O_1 (by connection J1_vec and J2_vec with their common norm).
% We have the following equations --
% O_0 - origin_j1_circle = a1*j1_vec
% O_1 - origin_j2_circle = a2*j2_vec
% O_1 - O_0 = dist_j1_2*common_norm_j1_2

    A = [j2_vec(:) -j1_vec(:)]
    b = common_norm_j1_2 * dist_j1_2 + origin_j1_circle - origin_j2_circle;
    b = b(:);
    a = A \ b;
    a1 = a(2);
    a2 = a(1);
    
    O_0 = origin_j1_circle + a1*j1_vec
    O_1 = origin_j2_circle + a2*j2_vec
    
% OR --
%     A = [j2_vec(:) -j1_vec(:)]
%     b = -common_norm_j1_2 * dist_j1_2 + origin_j1_circle - origin_j2_circle;
%     b = b(:);
%     a = A \ b;
%     a1 = a(2);
%     a2 = a(1);
%     
%     O_0_2 = origin_j1_circle + a1*j1_vec
%     O_1_2 = origin_j2_circle + a2*j2_vec


%% Define DH_0 frame

dh_0_z = j1_vec/norm(j1_vec);
dh_0_x = common_norm_j1_2/norm(common_norm_j1_2);

if dh_0_x(3) < 0
   warning('dh_0_x may point to the wrong direction');
end

dh_0_y = cross(dh_0_z, dh_0_x);
dh_0_y = dh_0_y/norm(dh_0_y)

rot_mat_dh_0_wrt_polaris = [dh_0_x(:) dh_0_y(:) dh_0_z(:)];
affine_dh_0_wrt_polaris = zeros(4,4);
affine_dh_0_wrt_polaris(4,4) = 1;
affine_dh_0_wrt_polaris(1:3,1:3) = rot_mat_dh_0_wrt_polaris;
affine_dh_0_wrt_polaris(1:3,4) = O_0(:);


%% Define DH_1 frame

dh_1_x = O_1 - O_0;
dh_1_x = dh_1_x/norm(dh_1_x)

dh_1_z = j2_vec/norm(j2_vec);

dh_1_y = cross(dh_1_z, dh_1_x);
dh_1_y = dh_1_y/norm(dh_1_y)

rot_mat_dh_1_wrt_polaris = [dh_1_x(:) dh_1_y(:) dh_1_z(:)];
affine_dh_1_wrt_polaris = zeros(4,4);
affine_dh_1_wrt_polaris(4,4) = 1;
affine_dh_1_wrt_polaris(1:3,1:3) = rot_mat_dh_1_wrt_polaris;
affine_dh_1_wrt_polaris(1:3,4) = O_1(:);

%% Define base frame
% Static transform 
base_x = dh_0_y;
base_y = -dh_0_z;
base_z = -dh_0_x;
base_o = O_0;
rot_mat_base_wrt_polaris = [base_x(:) base_y(:) base_z(:)];
affine_base_wrt_polaris = zeros(4,4);
affine_base_wrt_polaris(4,4) = 1;
affine_base_wrt_polaris(1:3,1:3) = rot_mat_base_wrt_polaris;
affine_base_wrt_polaris(1:3,4) = O_0(:);



%% Visualisation



figure('Name', 'J1 and J2');
scatter3(j1_arc_in_polairs_mat(:,1),j1_arc_in_polairs_mat(:,2),j1_arc_in_polairs_mat(:,3), '.', 'red');
hold on;
axis equal;
scatter3(j1_arc_circle_params(1),j1_arc_circle_params(2),j1_arc_circle_params(3),'o','red');
scatter3(j2_arc_in_polairs_mat(:,1),j2_arc_in_polairs_mat(:,2),j2_arc_in_polairs_mat(:,3), '.', 'green');
scatter3(j2_arc_circle_params(1),j2_arc_circle_params(2),j2_arc_circle_params(3),'o','green');
scatter3(O_0(1),O_0(2),O_0(3),'filled','red');
scatter3(O_1(1),O_1(2),O_1(3),'filled','green');
% Frame_0 frame
    text(O_0(1),O_0(2),O_0(3),'  0','Color', 'red');
    text(O_1(1),O_1(2),O_1(3),'  1','Color', 'green');
    scale = 0.1;
    % Y axis
    yx_0 = O_0(1);
    yy_0 = O_0(2);
    yz_0 = O_0(3);
    yx_t = O_0(1) + dh_0_y(1)*scale;
    yy_t = O_0(2) + dh_0_y(2)*scale;
    yz_t = O_0(3) + dh_0_y(3)*scale;
    v0_y= [yx_0 yy_0 yz_0];
    vz_y= [yx_t yy_t yz_t];
    v0z_y=[vz_y;v0_y];
    plot3(v0z_y(:,1),v0z_y(:,2),v0z_y(:,3),'g');
    % X axis
    xx_0 = O_0(1);
    xy_0 = O_0(2);
    xz_0 = O_0(3);
    xx_t = O_0(1) + dh_0_x(1)*scale;
    xy_t = O_0(2) + dh_0_x(2)*scale;
    xz_t = O_0(3) + dh_0_x(3)*scale;
    v0_y= [xx_0 xy_0 xz_0];
    vx_y= [xx_t xy_t xz_t];
    v0x_y=[vx_y;v0_y];
    plot3(v0x_y(:,1),v0x_y(:,2),v0x_y(:,3),'r');       
    % Z axis
    zx_0 = O_0(1);
    zy_0 = O_0(2);
    zz_0 = O_0(3);
    zx_t = O_0(1) + dh_0_z(1)*scale;
    zy_t = O_0(2) + dh_0_z(2)*scale;
    zz_t = O_0(3) + dh_0_z(3)*scale;
    v0_y= [zx_0 zy_0 zz_0];
    vy_y= [zx_t zy_t zz_t];
    v0y_y=[vy_y;v0_y];
    plot3(v0y_y(:,1),v0y_y(:,2),v0y_y(:,3),'b');
% End of Frame_0 frame
% Frame_1 frame
    scale = 0.1;
    % Y axis
    yx_0 = O_1(1);
    yy_0 = O_1(2);
    yz_0 = O_1(3);
    yx_t = O_1(1) + dh_1_y(1)*scale;
    yy_t = O_1(2) + dh_1_y(2)*scale;
    yz_t = O_1(3) + dh_1_y(3)*scale;
    v0_y= [yx_0 yy_0 yz_0];
    vz_y= [yx_t yy_t yz_t];
    v0z_y=[vz_y;v0_y];
    plot3(v0z_y(:,1),v0z_y(:,2),v0z_y(:,3),'g');
    % X axis
    xx_0 = O_1(1);
    xy_0 = O_1(2);
    xz_0 = O_1(3);
    xx_t = O_1(1) + dh_1_x(1)*scale;
    xy_t = O_1(2) + dh_1_x(2)*scale;
    xz_t = O_1(3) + dh_1_x(3)*scale;
    v0_y= [xx_0 xy_0 xz_0];
    vx_y= [xx_t xy_t xz_t];
    v0x_y=[vx_y;v0_y];
    plot3(v0x_y(:,1),v0x_y(:,2),v0x_y(:,3),'r');       
    % Z axis
    zx_0 = O_1(1);
    zy_0 = O_1(2);
    zz_0 = O_1(3);
    zx_t = O_1(1) + dh_1_z(1)*scale;
    zy_t = O_1(2) + dh_1_z(2)*scale;
    zz_t = O_1(3) + dh_1_z(3)*scale;
    v0_y= [zx_0 zy_0 zz_0];
    vy_y= [zx_t zy_t zz_t];
    v0y_y=[vy_y;v0_y];
    plot3(v0y_y(:,1),v0y_y(:,2),v0y_y(:,3),'b');
% End of Frame_1 frame
savefig( strcat(save_file_path,'processed_arcs.fig'));
hold off;


%% Export DH parameters
t = datetime('now')
fileID = fopen( strcat(save_file_path,'DH_parameters_recommendation.txt'), 'wt' );
fprintf(fileID, '# DH PARAMETER RECOMMENDATION\n');
fprintf(fileID, '# This file is generated by matlab codes for da Vinci robot intrinsic calibration tool.\n');
fprintf(fileID, strcat('# AT: ', datestr(datetime)) );
fprintf(fileID, '\n');
fprintf(fileID, '# YOU MUST CHANGE THE FILENAME EXTENSION TO .YAML BEFORE YOU USE IT AS A DAVINCI KINEMATICS CONFIG FILE.\n');
fprintf(fileID, '# ---\n');
fprintf(fileID, '# DH_0 TO DH_1 FRAME\n');
fprintf(fileID, 'theta_1: %f \n', theta_1);
fprintf(fileID, 'alpha_1: %f \n', alpha_1);
fprintf(fileID, 'a_1: %f \n', a_1);
fprintf(fileID, 'd_1: %f \n', d_1);
fprintf(fileID, '\n');
fclose(fileID);

% The alpha is dist_lines is because the origins are defined to be on the
% common norm.


fileID = fopen( strcat(save_file_path, 'Fitting_rms_summary.txt'), 'wt');
fprintf(fileID, 'FITTING RMS SUMMARY\n');
fprintf(fileID, strcat('# GENERATED AT: ', datestr(datetime)) );
fprintf(fileID, '\n');
fprintf(fileID, '---\n');
fprintf(fileID, 'rms_j1_circle: %f\n', rms_j1_circle);
fprintf(fileID, 'rms_j2_circle: %f\n', rms_j2_circle);

fclose(fileID);


%%
% affine_dh_0_wrt_polaris, affine_dh_1_wrt_polaris, affine_base_wrt_polaris
save(strcat(save_file_path, 'affine_dh_0_wrt_polaris.mat'), 'affine_dh_0_wrt_polaris');
save(strcat(save_file_path, 'affine_dh_1_wrt_polaris.mat'), 'affine_dh_1_wrt_polaris');
save(strcat(save_file_path, 'affine_base_wrt_polaris.mat'), 'affine_base_wrt_polaris');


end