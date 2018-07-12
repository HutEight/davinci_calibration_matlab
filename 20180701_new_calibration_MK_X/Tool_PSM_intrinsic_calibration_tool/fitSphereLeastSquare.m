% RN@HMS Prince of Wales
% 12/07/18
% Descriptions.
% 
% Notes.
% 1. Uses external source code spherefit.m 
% 2. RMS anaylsis has its own dedicated calculateSphereRms.m


function [sphere_para, residuals] = fitSphereLeastSquare(pt_mat)

    sphere_pts = pt_mat;

    pc_sphere_rover = pointCloud([sphere_pts(:,1), sphere_pts(:,2), sphere_pts(:,3)]);
            
    [centre,radius,residuals_temp]  = spherefit(sphere_pts);

    
    centre;
    radius;
    sphere_para = [transpose(centre),  radius];
    residuals = residuals_temp;
    
end