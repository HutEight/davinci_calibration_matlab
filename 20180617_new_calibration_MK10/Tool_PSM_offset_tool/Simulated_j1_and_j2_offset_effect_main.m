% RN@HMS Queen Elizabeth 
% 23/06/18
%%
clc
close all
clear all

%% 

a1 = 0.03 ;
alpha1 = pi/4; % TODO conside alpha as well..

rotation = [cos(alpha1) -sin(alpha1) 0; ...
            sin(alpha1) cos(alpha1)  0; ...
            0           0            1];

n_step = 50;

phi_0 = -pi/2.4;
phi_t = pi/2.4;
delta_angle = (phi_t - phi_0)/n_step;

l1 = 0.3; % 30 cm
l2 = l1 - a1;

% Mimic the following process --
% Rotate J2 first, from its minimum. for delta_theta degrees, then let the
% arm to rotate about J1 axis from its minimum to maximum angles. This
% should yeild a circle with ite centre on the J1 axis. Suppose the origin
% of the base frame is (0 0 0), then the centre of the above mentioned
% circle should be (0, x*sin(theta), 0). Its radius should be
% DH_a1+x*sin(theta). 

pt_mat = [0 0 0];
n_row = 1;

for j2_step = 0:(n_step)
    
    % J2 rotation angle
    theta_2 = phi_0 + j2_step*delta_angle;
    
    % First work out the centre and the radius
    centre = [0 l2*sin(theta_2) -a1-l2*cos(theta_2)];
    radius = abs(a1+l2*cos(theta_2));
    
    y = l2*sin(theta_2);
    
    % Acuqire (x? y z?) by rotation about J1.
    for j1_step = 0:(n_step)
        
        theta_1 = phi_0 + j1_step*delta_angle;
        
        x = - radius*sin(theta_1);
        z = - radius*cos(theta_1);
        
        pt_mat(n_row,:) = [x y z];
        n_row = n_row + 1;
        
    end
        
end

n_row = n_row - 1; % one step back to reflect the size of pt_mat


%% Without taking the alpha_1

% Reference frame auxiliary
t3 = (-5:10)/200;
x_axis_x = t3; x_axis_y = 0*t3; x_axis_z = 0*t3;
y_axis_x = 0*t3; y_axis_y = t3; y_axis_z = 0*t3;
z_axis_x = 0*t3; z_axis_y = 0*t3; z_axis_z = t3;

        % Visualise the simulated point cloud
        figure('Name', 'Point cloud a1');
        scatter3(pt_mat(:,1), pt_mat(:,2), pt_mat(:,3));
        axis equal;
        hold on;
        hold off;

% Try to fit a sphere
[sphere_param, residuals] = davinci_sphere_fit_least_square(pt_mat);
rms_Sphere = calculate_sphere_rms(pt_mat, sphere_param(1:3), sphere_param(4));    

        figure('Name', 'Pt Cloud & its fitted sphere');
        scatter3(pt_mat(:,1), pt_mat(:,2), pt_mat(:,3),'.');
        hold on;
        
        [x y z] = sphere;
        a = [sphere_param(1), sphere_param(2), sphere_param(3),  sphere_param(4)];
        s1=surf(x*a(1,4)+a(1,1), y*a(1,4)+a(1,2), z*a(1,4)+a(1,3));
        scatter3(sphere_param(1), sphere_param(2), sphere_param(3), 'filled');
        
        [x2 y2 z2] = sphere;
        a2 = [0, 0, 0, l1];
        s2=surf(x2*a2(1,4)+a2(1,1), y2*a2(1,4)+a2(1,2), z*a2(1,4)+a2(1,3));
        
        
        plot3(x_axis_x,x_axis_y,x_axis_z);
        plot3(y_axis_x,y_axis_y,y_axis_z);
        plot3(z_axis_x,z_axis_y,z_axis_z);
        axis equal;

%% After taking the alpha_a

for row=1:n_row
    
   pt_mat_rot(row,:) = transpose(rotation*transpose(pt_mat(row,:)));
    
end
        
        % Visualise the simulated point cloud
        figure('Name', 'Point Cloud a1 alpha1');
        scatter3(pt_mat_rot(:,1), pt_mat_rot(:,2), pt_mat_rot(:,3), '.');
        axis equal;
        hold on;
        hold off;  
        
 % Try to fit a sphere
[sphere_param_2, residuals_2] = davinci_sphere_fit_least_square(pt_mat_rot);
rms_Sphere_2 = calculate_sphere_rms(pt_mat_rot, sphere_param_2(1:3), sphere_param_2(4));         

        figure('Name', 'Pt Cloud & its fitted sphere (a1 + alpha1)');
        scatter3(pt_mat_rot(:,1), pt_mat_rot(:,2), pt_mat_rot(:,3),'.');
        hold on;
        
        [x y z] = sphere;
        a = [sphere_param_2(1), sphere_param_2(2), sphere_param_2(3),  sphere_param_2(4)];
        s1=surf(x*a(1,4)+a(1,1), y*a(1,4)+a(1,2), z*a(1,4)+a(1,3));
        scatter3(sphere_param_2(1), sphere_param_2(2), sphere_param_2(3), 'filled');
        
        [x2 y2 z2] = sphere;
        a2 = [0, 0, 0, l1];
        s2=surf(x2*a2(1,4)+a2(1,1), y2*a2(1,4)+a2(1,2), z*a2(1,4)+a2(1,3));
        
        
        plot3(x_axis_x,x_axis_y,x_axis_z);
        plot3(y_axis_x,y_axis_y,y_axis_z);
        plot3(z_axis_x,z_axis_y,z_axis_z);
        axis equal;
