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
data_folder = 'Data/20180628_01/';

load(strcat(data_folder,'affine_psm2_wrt_psm1.mat'))

affine_psm1_wrt_psm2 = inv(affine_psm2_wrt_psm1);

load(strcat(data_folder,'affine_psm2_wrt_polaris.mat'))

affine_polaris_wrt_psm2 = inv(affine_psm2_wrt_polaris);

load(strcat(data_folder,'affine_psm1_wrt_polaris.mat'))

affine_polaris_wrt_psm1 = inv(affine_psm1_wrt_polaris);

%% PSM 1 sphere (range)

% @ UPDATE CHECKPOINT 2/2
centre_x = -0.00302805656706;
centre_y = 0.0417731450507;
centre_z = -0.13409265241;


centre_in_psm1 = [centre_x centre_y centre_z];

%% Creating a cube

% @ OPTIONAL UPDATE CHECKPOINT 1/2
increment = 0.005;



% @ OPTIONAL UPDATE CHECKPOINT 2/2
% ONLY USE THIS WHEN YOU HAVE FINISHED THE EVALUATION FOR AT LEAST ONCE AND
% HENCE CAN ACUQIRE AN ADDITIONAL TRANSFORM ADJUSTMENT.

additional_affine_psm_2_init_to_2_refined_in_polaris_frame =  ...
    [...
    0.9999   -0.0088    0.0146    0.0134;
    0.0086    0.9998    0.0157    0.0150;
   -0.0148   -0.0156    0.9998   -0.0008;
         0         0         0    1.0000]
 


try
   
    load(strcat(data_folder,'additional_affine_psm_2_init_to_2_refined_in_polaris_frame.mat'));
        
catch
    
    warning('Did not found file "additional_affine_psm_2_init_to_2_refined_in_polaris_frame" ! Using identity Mat.');
    
    additional_affine_psm_2_init_to_2_refined_in_polaris_frame = ...
    [1 0 0 0;
     0 1 0 0;
     0 0 1 0;
     0 0 0 1];
 
end


% ---  
adjusted_affine_psm1_wrt_psm2 = affine_polaris_wrt_psm2 * ...
    additional_affine_psm_2_init_to_2_refined_in_polaris_frame * ...
    affine_psm1_wrt_polaris; 





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
    
   psm2_pt = adjusted_affine_psm1_wrt_psm2 * transpose(psm1_pt);

   
   psm2_pt = psm2_pt';
   psm2_pts(i,:) = psm2_pt(1,1:3);
   
   
   temp_pt = affine_psm1_wrt_psm2 * transpose(psm1_pt);
   temp_pt = temp_pt';
   temp_pts(i,:) = temp_pt(1,1:3);
    
end


%% Preview

figure('Name','Preview of psm2_pt');
scatter3(psm2_pts(:,1), psm2_pts(:,2), psm2_pts(:,3), 'filled');
hold on;
scatter3(temp_pts(:,1), temp_pts(:,2), temp_pts(:,3), 'filled');
axis equal;
hold off;



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


