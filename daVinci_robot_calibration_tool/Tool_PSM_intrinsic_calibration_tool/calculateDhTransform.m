% RN@HMS Queen Elizabeth
% 02/10/18
% Description.
%
% Notes.
%


% Param@g_current_to_next: the return is a 4x4.
function [g_current_to_next] = calculateDhTransform(theta, d, a, alpha)

    % Initialise
    rot_z_theta = eye(4);
    trans_z_d = eye(4);
    trans_x_a = eye(4);
    rot_x_alpha = eye(4);
    
    % Fill in params
    rot_z_theta(1:2,1:2) = [cos(theta) -sin(theta);
        sin(theta) cos(theta)];
    trans_z_d(3,4) = d;
    trans_x_a(1,4) = a;
    rot_x_alpha(2:3,2:3) = [cos(alpha) -sin(alpha);
        sin(alpha) cos(alpha)];
    
    % Get the result
    g_current_to_next= rot_z_theta*trans_z_d*trans_x_a*rot_x_alpha;
    
end