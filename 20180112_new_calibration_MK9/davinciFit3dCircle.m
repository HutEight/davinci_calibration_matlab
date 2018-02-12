function [circle_params, fval] = davinciFit3dCircle(pt_mat)
% circle params: x, y, z, r
% pt_mat should be nx3

%% Extracting 3 random pts from mat to find an initial circle in 3d space
mat_size = size(pt_mat, 1);

x_mat = pt_mat(:,1);
y_mat = pt_mat(:,2);
z_mat = pt_mat(:,3);

% Must NOT take the same points again
rnd = randperm(mat_size,3);
init_pt_1 =  pt_mat(rnd(1),:);
init_pt_2 =  pt_mat(rnd(2),:);
init_pt_3 =  pt_mat(rnd(3),:);

[init_center,init_rad,init_v1n,init_v2nb] = circlefit3d(init_pt_1,init_pt_2,init_pt_3);


%% Constructing fmin function for 3d circle

circle_fitting_error = @(a) sqrt((...
    transpose(x_mat - ones(mat_size,1)*[a(1)]) * (x_mat - ones(mat_size,1)*[a(1)]) + ...
    transpose(y_mat - ones(mat_size,1)*[a(2)]) * (y_mat - ones(mat_size,1)*[a(2)]) + ...
    transpose(z_mat - ones(mat_size,1)*[a(3)]) * (z_mat - ones(mat_size,1)*[a(3)]) + ...
    - mat_size * a(4) * a(4))/mat_size);

lb = [-2, -2, -2, 0];
ub = [2, 2, 2, 2];
a0 = [init_center(1), init_center(2), init_center(3), init_rad];
A= [];
b = [];
Aeq = [];
beq = [];
nonlcon = [];
size_max = 3000000;
options = optimoptions('fmincon','MaxFunctionEvaluations',size_max,'MaxIterations',30000);

[a, fval] = fmincon(circle_fitting_error,a0,A,b,Aeq,beq,lb,ub,nonlcon,options);


%% Output check

circle_params = a;



end