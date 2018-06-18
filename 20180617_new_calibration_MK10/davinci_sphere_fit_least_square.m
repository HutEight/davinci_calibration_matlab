function [sphere_para, residuals] = davinci_sphere_fit_least_square(pt_mat)


            sphere_pts = pt_mat;

            pc_sphere_rover = pointCloud([sphere_pts(:,1), sphere_pts(:,2), sphere_pts(:,3)]);
            
%             points_colour_yellow_rover = uint8(zeros(pc_sphere_rover.Count, 3));
%     % colour in r g b [0-255]
%             points_colour_yellow_rover(:, 1) = 255;
%             points_colour_yellow_rover(:, 2) = 210;
%             points_colour_yellow_rover(:, 3) = 0;
%             pc_sphere_rover.Color = points_colour_yellow_rover;
   
%     % colour in r g b [0-255]
%             points_colour_green_rover(:, 1) = 0;
%             points_colour_green_rover(:, 2) = 255;
%             points_colour_green_rover(:, 3) = 0;
%             pc_sphere_rover_green.Color = points_colour_green_rover;



    [center,radius,residuals_temp]  = spherefit(sphere_pts);
% RMS
% rms_sphere = @(a)sqrt(((transpose(pc_sphere(:,1) - a(1))*(pc_sphere(:,1) - a(1)))...
%     + (transpose(pc_sphere(:,2) - a(2))*(pc_sphere(:,2) - a(2)))...
%     + (transpose(pc_sphere(:,3) - a(3))*(pc_sphere(:,3) - a(3)))...
%     - size_pc*(a(4)*a(4)))/(size_pc-1));
center;
radius;
sphere_para = [transpose(center),  radius];
residuals = residuals_temp;
end