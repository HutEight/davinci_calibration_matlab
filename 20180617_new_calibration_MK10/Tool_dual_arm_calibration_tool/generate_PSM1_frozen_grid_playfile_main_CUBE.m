% RN@HMS Prince of Wales
% 07/05/18

%% THERE ARE 2 UPDATE POINTS THAT YOU NEED TO CHECK EVERYTIME YOU RUN THIS PROGRAMME TO GENREATE A NEW CUBE TRAJECTORY FOR PMS1.

%%
clc
close all
clear all

%% 
% Change these initial values
% centre of the 7x7 cube

% UPDATE CHECKPOINT 1/2
centre_x = 0.0715516166826;
centre_y = 0.131224898598;
centre_z = -0.0838271241528;

% UPDATE CHECKPOINT 2/2
data_seq = '03';

t = datetime('now');
formatOut = 'yyyymmdd';
DateString = datestr(t,formatOut);

fileDir = 'Data/';
folderName = strcat(DateString, '_', data_seq);

mkdir(strcat(fileDir, folderName));



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

save_file_name = strcat(fileDir, folderName, '/psm1_pts_generated_cube.mat');
save(save_file_name, 'psm1_pts_generated_cube');