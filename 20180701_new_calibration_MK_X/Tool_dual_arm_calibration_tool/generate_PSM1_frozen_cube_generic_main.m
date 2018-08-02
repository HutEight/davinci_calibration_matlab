% RN@HMS Queen Elizabeth
% 01/08/18
% Descriptions.
% 
% Notes.
%

%% THERE ARE 2 UPDATE POINTS THAT YOU NEED TO CHECK EVERYTIME YOU RUN THIS PROGRAMME TO GENREATE A NEW CUBE TRAJECTORY FOR PMS1.
% Search for 'checkpoint' to locate them. 
%%
clc
close all
clear all

%% 
% Change these initial values
% centre of the cube

% @ UPDATE CHECKPOINT 1/6
centre_x = 0;
centre_y = 0;
centre_z = 1;

% @ UPDATE CHECKPOINT 2/6
data_seq = '01';

t = datetime('now');
formatOut = 'yyyymmdd';
DateString = datestr(t,formatOut);

fileDir = 'Data/';
folderName = strcat(DateString, '_', data_seq);

mkdir(strcat(fileDir, folderName));

% @ UPDATE CHECKPOINT 3/6 
travel_speed = 0.01; % m/sec

% @ UPDATE CHECKPOINT 4/6 
vertex_dist = 1; % m

% @ UPDATE CHECKPOINT 5/6 
cube_dimension = 3; % cube_dimension^3 points in total

travel_time = vertex_dist/travel_speed; % From one point to another

% @ UPDATE CHECKPOINT 6/6 
still_time = 5;

% @ OPTIONAL UPDATE CHECKPOINT 1/1
increment = vertex_dist;

psm_x = [1 0 0];

axis_vec = [centre_x centre_y centre_z];
cube_z = axis_vec/norm(axis_vec);
cube_x = cross(psm_x, cube_z)/norm(cross(psm_x, cube_z));
cube_y = cross(cube_z, cube_x)/norm(cross(cube_z, cube_x));

rot_cube_wrt_psm = transpose([cube_x; cube_y; cube_z]);

corner = [centre_x centre_y centre_z] - (fix(cube_dimension/2)+1)*increment*(cube_x + cube_y + cube_z); % Because it is 7x7 the centre is #4. 

time = 10;
count = 1;

for i = 0:(cube_dimension-1) 
    
   for j = 0:(cube_dimension-1)
       
       for k = 0:(cube_dimension-1)
     
           
           if mod(i,2) == 0 % i = 0, 2, 4,...
               
               if mod(j,2) == 0 % j = 0, 2, 4,...
                   point = corner + i*increment*cube_x + j*increment*cube_y + k*increment*cube_z;
               else % j = 1, 3, 4,...
                   point = corner + i*increment*cube_x + j*increment*cube_y + ((cube_dimension-1-k)*increment*cube_z);
               end               
 
           else  % i = 1, 3, 4,...
                
               if mod(j,2) == 0 % j = 0, 2, 4,...
                   point = corner + i*increment*cube_x + ((cube_dimension-1-j)*increment*cube_y)...
                       + k*increment*cube_z;
               else % j = 1, 3, 4,...
                   point = corner + i*increment*cube_x + ((cube_dimension-1-j)*increment*cube_y)...
                       + ((cube_dimension-1-k)*increment*cube_z);
               end    
            
           end
           

           disp( strcat(num2str(point(1)), ',  ', num2str(point(2)), ',  ' , num2str(point(3)), ',0,1,0, 0, 0, -1, -1,       0, 0, -0.05, 0,1,0, 0, 0, -1, 0,',   num2str(time)));
           disp( strcat(num2str(point(1)), ',  ', num2str(point(2)), ',  ' , num2str(point(3)), ',0,1,0, 0, 0, -1, -1,       0, 0, -0.05, 0,1,0, 0, 0, -1, 0,',   num2str(time + still_time))); 

           time = time + still_time + travel_time;
           psm1_pts_generated_cube(count,:) = [point(1) point(2) point(3)];
           count = count + 1;
      
       end
   end
    
end

save_file_name = strcat(fileDir, folderName, '/psm1_pts_generated_cube.mat');
save(save_file_name, 'psm1_pts_generated_cube');
