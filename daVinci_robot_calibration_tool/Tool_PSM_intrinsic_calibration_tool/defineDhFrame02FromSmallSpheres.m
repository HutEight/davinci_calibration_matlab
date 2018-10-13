% RN@HMS Queen Elizabeth
% 10/07/18
% Description.
%
% Notes.
%


function [affine_dh_2_wrt_polaris] = ...
    defineDhFrame02FromSmallSpheres(affine_dh_1_wrt_polaris, small_sphere_origins_line_param, ...
    save_file_path, virtual_flag)


%% Preparation
% small_sphere_origins_line_param.p0
    pt0 = small_sphere_origins_line_param.p0;

    O_1 = affine_dh_1_wrt_polaris(1:3, 4);
    x1_wrt_polaris = affine_dh_1_wrt_polaris(1:3, 1);
    y1_wrt_polaris = affine_dh_1_wrt_polaris(1:3, 2);
    z1_wrt_polaris = affine_dh_1_wrt_polaris(1:3, 3);
    
    
%% Test new function   
[frame_1_homogeneous, dh_d, dh_theta, dh_a, dh_alpha] = ...
    calculateNextDhFrame (affine_dh_1_wrt_polaris, pt0, small_sphere_origins_line_param.direction) 


%% Calculate the common norm of z1 and z2.
    
    z2_wrt_polaris = small_sphere_origins_line_param.direction;
    % check if z2 point down
    if virtual_flag ~= 1
        if z2_wrt_polaris(1) < 0
           z2_wrt_polaris = -z2_wrt_polaris; 
        end
    else
        % The simulation data use the Base frame as the Polaris frame,
        % therefore the z2 should be pointing anti-parallel to base_z.
        if z2_wrt_polaris(3) > 0
           z2_wrt_polaris = -z2_wrt_polaris; 
        end
    end
    
    z2_wrt_polaris = z2_wrt_polaris/norm(z2_wrt_polaris);

    common_norm_j2_3 = cross(z1_wrt_polaris, z2_wrt_polaris);

    dist_j2_3 = calculateTowLinesDist(O_1, z1_wrt_polaris, ...
            pt0, z2_wrt_polaris, 0, 'dist_j2_3');

    pt0 = pt0(:);    

%% Acquire O_2 by interseting z2 and common norm.
% The intersection pt on z_1 with common norm is pt1.
% The known fixed point on z_2 is pt0.
% We have 3 equations --
%   pt1 - O1 = a1 * z1_vec
%   O2 - pt0 = a2 * z2_vec
%   O2 - pt1 = dist * common_norm_j2_3
% Thus --
% a2*z2_vec - a1*z1_vec = dist*common_norm_j2_3 +O1 - pt0

    A = [z2_wrt_polaris(:) -z1_wrt_polaris(:)];
    b = dist_j2_3*common_norm_j2_3 + O_1 - pt0;
    b = b(:);
    a = A \ b;
    a1 = a(2);
    a2 = a(1);
    
    pt1 = a1*z1_wrt_polaris + O_1;
    O_2 = a2*z2_wrt_polaris + pt0;
    


%% Complete Frame_2 (O_2, y2) definition.

    x2_wrt_polaris = common_norm_j2_3;
    % Check if x2 is pointing to the same hemisphere as vector O1O2
    O1_O2_vec = O_2 - O_1;
    ang_diff_1 = atan2(norm(cross(O1_O2_vec, x2_wrt_polaris)), dot(O1_O2_vec, x2_wrt_polaris))
    if (ang_diff_1 > pi/2)
       x2_wrt_polaris = -x2_wrt_polaris; 
    end
    
    
    y2_wrt_polaris = cross(z2_wrt_polaris, x2_wrt_polaris);
    rot_mat_dh_2_wrt_polaris = [x2_wrt_polaris(:) y2_wrt_polaris(:) z2_wrt_polaris(:)];

    affine_dh_2_wrt_polaris = zeros(4,4);
    affine_dh_2_wrt_polaris(4,4) = 1;
    affine_dh_2_wrt_polaris(1:3,1:3) = rot_mat_dh_2_wrt_polaris;
    affine_dh_2_wrt_polaris(1:3,4) = O_2(:);
    

%% Calculate d_2 (DH) by moving O_1 along z_1 to common norm (pay attention to its sign). 
% Since it is z_1's norm, d equals the distance of O_1 to the norm. 
% function [dist] = calculatePointLineDist(p0, direction, point)
    d_2 = calculatePointLineDist(O_2, common_norm_j2_3, O_1)
    ang_diff_4 = atan2(norm(cross(O1_O2_vec, z1_wrt_polaris)), dot(O1_O2_vec, z1_wrt_polaris))
    if (ang_diff_4 > pi/2)
        d_2 = -d_2;
    end
    

%% Calculate theta_2 by rotating about z_1 to align (moved) x_1 with x_2 (also the norm) direction.
% The value should equal the angle between x_1 and x_2.
    theta_2 = atan2(norm(cross(x1_wrt_polaris, x2_wrt_polaris)), dot(x1_wrt_polaris, x2_wrt_polaris))

    temp_vec_theta_2 = cross(x1_wrt_polaris, x2_wrt_polaris);
    
    ang_diff_2 = atan2(norm(cross(temp_vec_theta_2, z1_wrt_polaris)), dot(temp_vec_theta_2, z1_wrt_polaris))
    if (ang_diff_2 > pi/2)
       theta_2 = -theta_2; 
    end 

%% Calculate a_2.
% a_2: the distance along the rotated x_1 between the (moved) O_1 to O_2.
% It equals the length of the norm section between z_1 and z_2, or distance
% between z_1 and z_2.
    a_2 = dist_j2_3


%% Calculate aplha_2.
% alpha_2: rotates about current x_1 (after translation and rotation) to
% put z_1 in z_2's orientation. 
% Its value should equal the angle between z_1 and z_2. 
    alpha_2 = atan2(norm(cross(z1_wrt_polaris, z2_wrt_polaris)), dot(z1_wrt_polaris, z2_wrt_polaris))
    
    temp_vec_alpha_2 = cross(z1_wrt_polaris, z2_wrt_polaris);
    
    ang_diff_3 = atan2(norm(cross(temp_vec_alpha_2, x2_wrt_polaris)), dot(temp_vec_alpha_2, x2_wrt_polaris))
    if (ang_diff_3 > pi/2)
       alpha_2 = -alpha_2; 
    end


%% Write DH parameters to file.




%% Figures.

figure('Name', 'J2 and J3');
hold on;
axis equal;
scatter3(O_1(1), O_1(2), O_1(3), 'filled', 'green');
scatter3(O_2(1), O_2(2), O_2(3), 'filled', 'blue');

% Frame_1 frame
    text(O_1(1),O_1(2),O_1(3),'  1', 'Color', 'green');
    scale = 0.1;
    % Y axis
    yx_0 = O_1(1);
    yy_0 = O_1(2);
    yz_0 = O_1(3);
    yx_t = O_1(1) + y1_wrt_polaris(1)*scale;
    yy_t = O_1(2) + y1_wrt_polaris(2)*scale;
    yz_t = O_1(3) + y1_wrt_polaris(3)*scale;
    v0_y= [yx_0 yy_0 yz_0];
    vz_y= [yx_t yy_t yz_t];
    v0z_y=[vz_y;v0_y];
    plot3(v0z_y(:,1),v0z_y(:,2),v0z_y(:,3),'g');
    % X axis
    xx_0 = O_1(1);
    xy_0 = O_1(2);
    xz_0 = O_1(3);
    xx_t = O_1(1) + x1_wrt_polaris(1)*scale;
    xy_t = O_1(2) + x1_wrt_polaris(2)*scale;
    xz_t = O_1(3) + x1_wrt_polaris(3)*scale;
    v0_y= [xx_0 xy_0 xz_0];
    vx_y= [xx_t xy_t xz_t];
    v0x_y=[vx_y;v0_y];
    plot3(v0x_y(:,1),v0x_y(:,2),v0x_y(:,3),'r');       
    % Z axis
    zx_0 = O_1(1);
    zy_0 = O_1(2);
    zz_0 = O_1(3);
    zx_t = O_1(1) + z1_wrt_polaris(1)*scale;
    zy_t = O_1(2) + z1_wrt_polaris(2)*scale;
    zz_t = O_1(3) + z1_wrt_polaris(3)*scale;
    v0_y= [zx_0 zy_0 zz_0];
    vy_y= [zx_t zy_t zz_t];
    v0y_y=[vy_y;v0_y];
    plot3(v0y_y(:,1),v0y_y(:,2),v0y_y(:,3),'b');
% End of Frame_1 frame

% Frame_2 frame
    text(O_2(1),O_2(2),O_2(3),'      2');
    scale = 0.1;
    % Y axis
    yx_0 = O_2(1);
    yy_0 = O_2(2);
    yz_0 = O_2(3);
    yx_t = O_2(1) + y2_wrt_polaris(1)*scale;
    yy_t = O_2(2) + y2_wrt_polaris(2)*scale;
    yz_t = O_2(3) + y2_wrt_polaris(3)*scale;
    v0_y= [yx_0 yy_0 yz_0];
    vz_y= [yx_t yy_t yz_t];
    v0z_y=[vz_y;v0_y];
    plot3(v0z_y(:,1),v0z_y(:,2),v0z_y(:,3),'g');
    % X axis
    xx_0 = O_2(1);
    xy_0 = O_2(2);
    xz_0 = O_2(3);
    xx_t = O_2(1) + x2_wrt_polaris(1)*scale;
    xy_t = O_2(2) + x2_wrt_polaris(2)*scale;
    xz_t = O_2(3) + x2_wrt_polaris(3)*scale;
    v0_y= [xx_0 xy_0 xz_0];
    vx_y= [xx_t xy_t xz_t];
    v0x_y=[vx_y;v0_y];
    plot3(v0x_y(:,1),v0x_y(:,2),v0x_y(:,3),'r');       
    % Z axis
    zx_0 = O_2(1);
    zy_0 = O_2(2);
    zz_0 = O_2(3);
    zx_t = O_2(1) + z2_wrt_polaris(1)*scale;
    zy_t = O_2(2) + z2_wrt_polaris(2)*scale;
    zz_t = O_2(3) + z2_wrt_polaris(3)*scale;
    v0_y= [zx_0 zy_0 zz_0];
    vy_y= [zx_t zy_t zz_t];
    v0y_y=[vy_y;v0_y];
    plot3(v0y_y(:,1),v0y_y(:,2),v0y_y(:,3),'b');
% End of Frame_2 frame

hold off;
savefig( strcat(save_file_path,'J2_3.fig'));

try 
    openfig(strcat(save_file_path,'processed_arcs.fig'));
    hold on; 
    scatter3(O_2(1), O_2(2), O_2(3), 'filled', 'blue');
 % Frame_2 frame
    text(O_2(1),O_2(2),O_2(3),'  2', 'Color', 'blue');
    scale = 0.1;
    % Y axis
    yx_0 = O_2(1);
    yy_0 = O_2(2);
    yz_0 = O_2(3);
    yx_t = O_2(1) + y2_wrt_polaris(1)*scale;
    yy_t = O_2(2) + y2_wrt_polaris(2)*scale;
    yz_t = O_2(3) + y2_wrt_polaris(3)*scale;
    v0_y= [yx_0 yy_0 yz_0];
    vz_y= [yx_t yy_t yz_t];
    v0z_y=[vz_y;v0_y];
    plot3(v0z_y(:,1),v0z_y(:,2),v0z_y(:,3),'g');
    % X axis
    xx_0 = O_2(1);
    xy_0 = O_2(2);
    xz_0 = O_2(3);
    xx_t = O_2(1) + x2_wrt_polaris(1)*scale;
    xy_t = O_2(2) + x2_wrt_polaris(2)*scale;
    xz_t = O_2(3) + x2_wrt_polaris(3)*scale;
    v0_y= [xx_0 xy_0 xz_0];
    vx_y= [xx_t xy_t xz_t];
    v0x_y=[vx_y;v0_y];
    plot3(v0x_y(:,1),v0x_y(:,2),v0x_y(:,3),'r');       
    % Z axis
    zx_0 = O_2(1);
    zy_0 = O_2(2);
    zz_0 = O_2(3);
    zx_t = O_2(1) + z2_wrt_polaris(1)*scale;
    zy_t = O_2(2) + z2_wrt_polaris(2)*scale;
    zz_t = O_2(3) + z2_wrt_polaris(3)*scale;
    v0_y= [zx_0 zy_0 zz_0];
    vy_y= [zx_t zy_t zz_t];
    v0y_y=[vy_y;v0_y];
    plot3(v0y_y(:,1),v0y_y(:,2),v0y_y(:,3),'b');
% End of Frame_2 frame

    hold off;
    savefig( strcat(save_file_path,'J1_2_3.fig'));
    
catch
    warning('Could not find J1 J2 fig.');    
end



%% Export DH parameters

fileID = fopen( strcat(save_file_path,'DH_parameters_recommendation.txt'), 'a' );

fprintf(fileID, '# DH_1 TO DH_2 FRAME\n');
fprintf(fileID, 'theta_2: %f \n', theta_2);
fprintf(fileID, 'alpha_2: %f \n', alpha_2);
fprintf(fileID, 'a_2: %f \n', a_2);
fprintf(fileID, 'd_2: %f \n', d_2);
fprintf(fileID, '\n');
fclose(fileID);


end










