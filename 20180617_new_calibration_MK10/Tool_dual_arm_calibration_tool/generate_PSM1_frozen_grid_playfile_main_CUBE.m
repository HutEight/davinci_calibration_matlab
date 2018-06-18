% RN@HMS Prince of Wales
% 07/05/18

%%
clc
close all
clear all

%% 
% Change these initial values
% centre of the 7x7 cube
%  -0.0760062  0.0248539  -0.184708
centre_x =  -0.0760062;
centre_y = 0.0248539;
centre_z = -0.184708;

psm_x = [1 0 0];

axis_vec = [centre_x centre_y centre_z];
cube_z = axis_vec/norm(axis_vec);
cube_x = cross(psm_x, cube_z)/norm(cross(psm_x, cube_z));
cube_y = cross(cube_z, cube_x)/norm(cross(cube_z, cube_x));

rot_cube_wrt_psm = transpose([cube_x; cube_y; cube_z]);

corner = [centre_x centre_y centre_z] - 0.04*(cube_x + cube_y + cube_z);

time = 10;
count = 1;

for i = 0:6
    
   for j = 0:6
       
       for k = 0:6
           
          point = corner + i*0.01*cube_x + j*0.01*cube_y + k*0.01*cube_z;

          disp( strcat(num2str(point(1)), ',  ', num2str(point(2)), ',  ' , num2str(point(3)), ',0,1,0, 0, 0, -1, -1,       0, 0, -0.05, 0,1,0, 0, 0, -1, 0,',   num2str(time)));
          disp( strcat(num2str(point(1)), ',  ', num2str(point(2)), ',  ' , num2str(point(3)), ',0,1,0, 0, 0, -1, -1,       0, 0, -0.05, 0,1,0, 0, 0, -1, 0,',   num2str(time + 2))); 

          time = time + 4;

          psm1_pts_generated_cube(count,:) = [point(1) point(2) point(3)];
          count = count + 1;
      
       end
   end
    
end


save('psm1_pts_generated_cube.mat', 'psm1_pts_generated_cube');