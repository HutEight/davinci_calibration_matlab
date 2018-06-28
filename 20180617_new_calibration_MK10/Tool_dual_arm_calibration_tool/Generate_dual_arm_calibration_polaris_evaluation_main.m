% RN@HMS Queen Elizabeth
% 07/05/18

% Generate points in a sphere region of PSM1 frame, then convert the points to
% PSM2 frame. 

%% THERE ARE 2 UPDATE POINTS THAT YOU NEED TO CHECK EVERYTIME YOU RUN THIS PROGRAMME.
% Search for 'checkpoint' to locate them. 
%%
clc
close all
clear all

%% FILL IN THE TF INFO HERE
% Update every time if added mannually

% affine_psm2_wrt_psm1 = [
%    -0.1888    0.6128   -0.7674   -0.1769
%    -0.5612    0.5740    0.5964    0.0625
%     0.8059    0.5432    0.2355   -0.0981
%          0         0         0    1.0000
% ];

% Or load it from the global variable (generated bt dual_PSMs_match_CUBE.m)
% @ UPDATE CHECKPOINT 1/2
data_folder = 'Data/20180627_01/';

load(strcat(data_folder,'affine_psm2_wrt_psm1.mat'))

affine_psm1_wrt_psm2 = inv(affine_psm2_wrt_psm1);


%% PSM 1 sphere (range)

% @ UPDATE CHECKPOINT 2/2
centre_x = -0.00302805656706;
centre_y = 0.0417731450507;
centre_z = -0.13409265241;


centre_in_psm1 = [centre_x centre_y centre_z];

%% Creating a cube

% @ OPTIONAL UPDATE CHECKPOINT 1/2
increment = 0.005;

additional_affine_psm_2_init_to_2_refined = ...
    [1 0 0 0;
     0 1 0 0;
     0 0 1 0;
     0 0 0 1];

% @ OPTIONAL UPDATE CHECKPOINT 2/2
% ONLY USE THIS WHEN YOU HAVE FINISHED THE EVALUATION FOR AT LEAST ONCE AND
% HENCE CAN ACUQIRE AN ADDITIONAL TRANSFORM ADJUSTMENT.
additional_affine_psm_2_init_to_2_refined =  ...
    [ 0.9999   -0.0074    0.0152    0.0138;
    0.0072    0.9999    0.0131    0.0125;
   -0.0153   -0.0130    0.9998   -0.0009;
         0         0         0    1.0000]


psm_x = [1 0 0];

axis_vec = [centre_in_psm1(1) centre_in_psm1(2) centre_in_psm1(3)];
cube_z = axis_vec/norm(axis_vec);
cube_x = cross(psm_x, cube_z)/norm(cross(psm_x, cube_z));
cube_y = cross(cube_z, cube_x)/norm(cross(cube_z, cube_x));

rot_cube_wrt_psm = transpose([cube_x; cube_y; cube_z]);

corner = [centre_in_psm1(1) centre_in_psm1(2) centre_in_psm1(3)] ...
    - 2*increment*(cube_x + cube_y + cube_z); % Because it is 3x3 the centre is #2. 

count = 1;
for i = 0:2 % 3 x 3 x 3 cube so 0 -> 2
    
   for j = 0:2
       
       for k = 0:2
           
          point = corner + i*increment*cube_x + j*increment*cube_y + k*increment*cube_z;
          psm1_pts(count,:) = [point(1) point(2) point(3)];
          count = count + 1;
      
       end
   end
    
end

%% Convert pts into PSM2 frame

n_pts = size(psm1_pts,1);

for i = 1:n_pts
    
   psm1_pt(1,1:3) =  psm1_pts(i,:);
   psm1_pt(1,4) = 1;
    
   psm2_pt = (additional_affine_psm_2_init_to_2_refined) * affine_psm1_wrt_psm2 * transpose(psm1_pt);
   psm2_pt = psm2_pt';
   psm2_pts(i,:) = psm2_pt(1,1:3);
    
end

%% Printing on Screen
time = 10;
count = 1;
for i = 1:n_pts
    
     disp(strcat(num2str(psm1_pts(i,1)), ',  ',num2str(psm1_pts(i,2)), ',  ' ,num2str(psm1_pts(i,3)), ',0,1,0, 0, 0, -1, -1,', ...
         '0, 0, -0.05, 0,1,0, 0, 0, -1, 0,',   num2str(time)));
     disp(strcat(num2str(psm1_pts(i,1)), ',  ',num2str(psm1_pts(i,2)), ',  ' ,num2str(psm1_pts(i,3)), ',0,1,0, 0, 0, -1, -1,', ...
         '0, 0, -0.05, 0,1,0, 0, 0, -1, 0,',   num2str(time + 4)));     
     time = time + 8;

%      pts_generated_cube(count,:) = [(x+i*0.01) (y+j*0.01) (z+k*0.01)];
     count = count + 1;
    
    
end

disp('==================================================================');
disp('==================================================================');
disp('==================================================================');
%% Printing on Screen
time = 10;
count = 1;
for i = 1:n_pts
    
     disp(strcat('0,0,-0.05,     0,1,0,    0,0,-1,  -1,', ...
         num2str(psm2_pts(i,1)) ,', ', num2str(psm2_pts(i,2)), ', ', num2str(psm2_pts(i,3)), ', 0,1,0,   0,0,-1,  0,',   num2str(time)));
     disp(strcat('0,0,-0.05,     0,1,0,    0,0,-1,  -1,', ...
         num2str(psm2_pts(i,1)) ,', ', num2str(psm2_pts(i,2)), ', ', num2str(psm2_pts(i,3)), ', 0,1,0,   0,0,-1,  0,',   num2str(time + 4)));     
     time = time + 8;

%      pts_generated_cube(count,:) = [(x+i*0.01) (y+j*0.01) (z+k*0.01)];
     count = count + 1;
    
    
end


