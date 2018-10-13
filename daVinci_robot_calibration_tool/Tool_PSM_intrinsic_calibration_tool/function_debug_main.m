% RN@HMS Queen Elizabeth
% 30/07/18
% Description.
%
% Notes.
%


mat = [0 0 2; sqrt(2) 0 sqrt(2); 2 0 0]


    % Circle and Plane fitting
    [j1_arc_circle_params, j1_arc_plane_norm, j1_fval, j1_rms] =...
        fitCircleFmincon(mat)5