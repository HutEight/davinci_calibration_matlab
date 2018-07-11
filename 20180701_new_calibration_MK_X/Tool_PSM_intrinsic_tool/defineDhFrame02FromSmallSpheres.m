% RN@HMS Queen Elizabeth
% 10/07/18
% Notes.



function [affine_dh_2_wrt_polaris] = ...
    defineDhFrame02FromSmallSpheres(affine_dh_1_wrt_polaris, small_sphere_origins_line_param)


%% Get a point on Small Spheres Line.



%% Calculate the common norm of z1 and z2.



%% Acquire O2 by interseting z2 and common norm.



%% Complete Frame_2 (O_2, y2).



%% Calculate d_2 (DH) by moving O_1 along z_1 to common norm (pay attention to its sign). 
% Since it is z_1's norm, d equals the distance of O_1 to the norm. 



%% Calculate theta_2 by rotating about z_1 to align (moved) x_1 with x_2 (also the norm) direction.
% The value should equal the angle between x_1 and x_2.



%% Calculate a_2.
% a_2: the distance along the rotated x_1 between the (moved) O_1 to O_2.
% It equals the length of the norm section between z_1 and z_2, or distance
% between z_1 and z_2.



%% Calculate aplha_2.
% alpha_2: rotates about current x_1 (after translation and rotation) to
% put z_1 in z_2's orientation. 
% Its value should equal the angle between z_1 and z_2. 



%% Write DH parameters to file.




%% Fitures.




%% Save the Results.






end










