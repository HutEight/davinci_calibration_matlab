% RN@HMS Queen Elizabeth
% 01/08/18
% Descriptions.
%
% Notes.
%


function [arc_mat] = generateArcMat(arc_axis_vec, arc_centre, arc_radius, pt_0, angle_1, angle_2)

% axix_vec and centre should give a defintion of the joint in space. 

%% Initialisation

arc_axis_vec = arc_axis_vec/norm(arc_axis_vec);

u_x = arc_axis_vec(1);
u_y = arc_axis_vec(2);
u_z = arc_axis_vec(3);

resolution = 0.01; % rad

if angle_2 < angle_1
    resolution = -resolution; % signed
end

n_sample = (angle_2 - angle_1)/resolution; % signed

% Check arc_radius

if arc_radius ~= norm(arc_centre - pt_0)
    warning("[generateArcMat] check your input");
    disp("arc_radius should be:") 
    norm(arc_centre - pt_0)
    disp("Your input is:")
    arc_radius
end

arc_radius = norm(arc_centre - pt_0);

% You must first do this translation 
pt_0 = pt_0 - arc_centre;

%%
t0 = 19; % sec
for i = 0:(n_sample-1)
    
    seq = t0 + 0.02*i;

    theta = angle_1 + resolution*i;
    [rot_mat] = generateRotationMatrix(u_x, u_y, u_z, theta);
    
    % Get transform as well
    tf(1:3, 1:3) = rot_mat;
    tf(1:3, 4) = arc_centre;
    tf(4, 1:4) = [0 0 0 1];
    
    % Get the rotated point
    pt(1:3,1) = pt_0;
    pt(4,1) = 1;
    
    pt_aft = tf*pt;
    pt_aft = pt_aft(1:3,1);
    
    % Store the point
    arc_mat(i+1,1:3) = transpose(pt_aft(:));
    arc_mat(i+1,4) = seq;



end