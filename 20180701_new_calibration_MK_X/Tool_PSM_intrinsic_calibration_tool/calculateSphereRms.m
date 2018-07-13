% RN@HMS Prince of Wales
% 12/07/18
% Description.
%
% Notes.
%


function [rms] = calculateSphereRms(pt_mat, centre, radius)
rms = 1;
square_sum = 0;
dist_pt_to_centre = 0;
mat_size = size(pt_mat, 1);
for n = 1:mat_size
    
    dist_pt_to_centre = sqrt( (pt_mat(n,1)-centre(1))^2 + (pt_mat(n,2)-centre(2))^2 + ((pt_mat(n,3)-centre(3))^2));
    
    square_sum = square_sum + (dist_pt_to_centre - radius)^2;
    
end

rms = sqrt(square_sum/mat_size);

end