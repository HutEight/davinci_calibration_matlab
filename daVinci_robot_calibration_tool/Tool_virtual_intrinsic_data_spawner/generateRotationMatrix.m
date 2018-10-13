% RN@HMS Queen Elizabeth
% 01/08/18
% Descriptions.
%
% Notes.
% https://en.wikipedia.org/wiki/Rotation_matrix



function [rot_mat] = generateRotationMatrix(u_x, u_y, u_z, theta)

R11 = cos(theta) + u_x^2*(1 - cos(theta));
R12 = u_x*u_y*(1 - cos(theta)) - u_z*sin(theta);
R13 = u_x*u_z*(1 - cos(theta)) + u_y*sin(theta);

R21 = u_y*u_x*(1 - cos(theta)) + u_z*sin(theta);
R22 = cos(theta) + u_y^2*(1 - cos(theta));
R23 = u_y*u_z*(1 -cos(theta)) - u_x*sin(theta);

R31 = u_z*u_x*(1 - cos(theta)) - u_y*sin(theta);
R32 = u_z*u_y*(1 - cos(theta)) + u_x*sin(theta);
R33 = cos(theta) + u_z^2*(1 - cos(theta));

rot_mat = [R11 R12 R13;
    R21 R22 R23;
    R31 R32 R33];

end