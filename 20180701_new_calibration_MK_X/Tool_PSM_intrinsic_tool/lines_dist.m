function [dist] = lines_dist(a, b, c, d, fig_name)
% If the lines are parallel and this method cannot be used.

% https://en.wikipedia.org/wiki/Skew_lines#Distance
% line_1 = a (fixed point) + t*b
% line_2 = c + t*d

n = cross(b,d);
n = (n/norm(n));

disp('Normal: from ');

temp = c - a;
dist = abs(dot(n, temp));

%% Plot

t1 = (-10:10)/10;
line1_x = a(1) + t1*b(1);
line1_y = a(2) + t1*b(2);
line1_z = a(3) + t1*b(3);
t2 = (-10:10)/10;
line2_x = c(1) + t2*d(1);
line2_y = c(2) + t2*d(2);
line2_z = c(3) + t2*d(3);
t3 = (-5:10)/20;
x_axis_x = t3; x_axis_y = 0*t3; x_axis_z = 0*t3;
y_axis_x = 0*t3; y_axis_y = t3; y_axis_z = 0*t3;
z_axis_x = 0*t3; z_axis_y = 0*t3; z_axis_z = t3;

figure('Name', strcat('Line Dist Auxiliary: ',fig_name))
plot3(line1_x,line1_y,line1_z);
hold on;
axis equal;
plot3(line2_x,line2_y,line2_z);
% Reference
plot3(x_axis_x,x_axis_y,x_axis_z);
plot3(y_axis_x,y_axis_y,y_axis_z);
plot3(z_axis_x,z_axis_y,z_axis_z);
hold off;

end
