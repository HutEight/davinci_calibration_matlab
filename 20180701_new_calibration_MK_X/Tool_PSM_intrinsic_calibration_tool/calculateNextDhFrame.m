% RN@HMS Queen Elizabeth
% 09/10/18
% Description.
% This function takes the last defined frame and the z axis that follows the frame 
% and returns the definition of the new frame, with the DH parameters too.
% 
% Notes.
% frame_0_homogeneous is a known frame.
% frame_1_homogeneous is the newly define frame.
% z_1_pt and z_1_vec define the axis in the same frame.


function [frame_1_homogeneous, dh_d, dh_theta, dh_a, dh_alpha] = calculateNextDhFrame (frame_0_homogeneous, z_1_pt, z_1_vec) 

%% Preparation
O_0 = frame_0_homogeneous(1:3, 4);
x0 = frame_0_homogeneous(1:3, 1);
y0 = frame_0_homogeneous(1:3, 2);
z0 = frame_0_homogeneous(1:3, 3);

z_1_pt = z_1_pt(:);
z_1_vec = z_1_vec(:);

%% Get z0 and z1 common normal

z1 = z_1_vec/norm(z_1_vec);

common_norm = cross(z0, z1);

dist_z0_z1 = calculateTowLinesDist(O_0, z0, z_1_pt, z1, 0, 'unnamed');


%% Calculate parameter a
% a equals to the distance between 2 z axes.

dh_a = dist_z0_z1;

%% Get O1
% Acquire O_2 by interseting z2 and common norm.
% The intersection pt on z_1 with common norm is pt1.
% The known fixed point on z_2 is pt0.
% We have 3 equations --
%   pt1 - O1 = a1 * z1_vec
%   O2 - pt0 = a2 * z2_vec
%   O2 - pt1 = dist * common_norm_j2_3
% Thus --
% a2*z2_vec - a1*z1_vec = dist*common_norm_j2_3 +O1 - pt0

    A = [z1(:) -z0(:)];
    b = dist_z0_z1*common_norm + O_0 - z_1_pt;
    b = b(:);
    a = A \ b;
    a1 = a(2);
    a2 = a(1);
    
    pt1 = a1*z0 + O_0;
    O_1 = a2*z1 + z_1_pt;


%% Complete frame_1 homogeneous coordinate

x1 = common_norm;

% Check if x1 is pointing to the same hemisphere as vector O1O2
O0_O1_vec = O_1 - O_0;
ang_diff_1 = atan2(norm(cross(O0_O1_vec, x1)), dot(O0_O1_vec, x1))
if (ang_diff_1 > pi/2)
   x1 = -x1; 
end

y1 = cross(z1, x1);

rot_mat_1_wrt_spatial_frame = [x1(:) y1(:) z1(:)];
frame_1_homogeneous = zeros(4,4);
frame_1_homogeneous(4,4) = 1;
frame_1_homogeneous(1:3, 1:3) = rot_mat_1_wrt_spatial_frame;
frame_1_homogeneous(1:3, 4) = O_1(:);
    

%% Calculate parameter d
% By moving O_0 along z_0 to common norm (pay attention to its sign). 

dh_d = calculatePointLineDist(O_1, common_norm, O_0);

ang_diff_4 = atan2(norm(cross(O0_O1_vec, z0)), dot(O0_O1_vec, z0))
if (ang_diff_4 > pi/2)
    dh_d = -dh_d;
end


%% Calculate theta
% By rotating about z_0 to align (moved) x_0 with x_1 (also the norm) direction.
dh_theta = atan2(norm(cross(x0, x1)), dot(x0, x1))

temp_vec_theta_2 = cross(x0, x1);
    
ang_diff_2 = atan2(norm(cross(temp_vec_theta_2, z0)), dot(temp_vec_theta_2, z0))
if (ang_diff_2 > pi/2)
   dh_theta = -dh_theta; 
end 


%% Calculate alpha

dh_alpha = atan2(norm(cross(z0, z1)), dot(z0, z1))
    
temp_vec_alpha_2 = cross(z0, z1);
    
ang_diff_3 = atan2(norm(cross(temp_vec_alpha_2, x1)), dot(temp_vec_alpha_2, x1))
if (ang_diff_3 > pi/2)
   dh_alpha = -dh_alpha; 
end




%% Figures



%% Print

dh_d
dh_theta
dh_a
dh_alpha



end