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
data_folder = 'Data/20181112_01/';

load(strcat(data_folder,'affine_psm2_wrt_psm1.mat'))

affine_psm1_wrt_psm2 = inv(affine_psm2_wrt_psm1);



load(strcat(data_folder,'affine_psm1_wrt_polaris.mat'))

affine_polaris_wrt_psm1 = inv(affine_psm1_wrt_polaris);


try
    load(strcat(data_folder,'adjusted_affine_psm2_wrt_polaris.mat'))
    
    affine_psm2_wrt_polaris = adjusted_affine_psm2_wrt_polaris;
catch
    load(strcat(data_folder,'affine_psm2_wrt_polaris.mat'))
end
affine_polaris_wrt_psm2 = inv(affine_psm2_wrt_polaris);


%% PSM 1 sphere (range)

% @ UPDATE CHECKPOINT 2/2
centre_x = -0.0455987799161;
centre_y = 0.0545839901624;
centre_z = -0.106131420145;


centre_in_psm1 = [centre_x centre_y centre_z];

%% Creating a cube

% @ OPTIONAL UPDATE CHECKPOINT 1/2
increment = 0.02;



% @ OPTIONAL UPDATE CHECKPOINT 2/2
% ONLY USE THIS WHEN YOU HAVE FINISHED THE EVALUATION FOR AT LEAST ONCE AND
% HENCE CAN ACUQIRE AN ADDITIONAL TRANSFORM ADJUSTMENT.

% additional_affine_psm_2_init_to_2_refined_in_polaris_frame =  ...
%     [...
%     0.9999   -0.0088    0.0146    0.0134;
%     0.0086    0.9998    0.0157    0.0150;
%    -0.0148   -0.0156    0.9998   -0.0008;
%          0         0         0    1.0000]
 

    
    additional_affine_psm_2_init_to_2_refined_in_polaris_frame = ...
    [1 0 0 0;
     0 1 0 0;
     0 0 1 0;
     0 0 0 1];
 



% ---  
% adjusted_affine_psm1_wrt_psm2 = affine_polaris_wrt_psm2 * ...
%     additional_affine_psm_2_init_to_2_refined_in_polaris_frame * ...
%     affine_psm1_wrt_polaris; 

adjusted_affine_psm2_wrt_polaris = additional_affine_psm_2_init_to_2_refined_in_polaris_frame * ...
    affine_psm2_wrt_polaris;

adjusted_affine_psm1_wrt_psm2 = inv(adjusted_affine_psm2_wrt_polaris) * affine_psm1_wrt_polaris;




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

offset = [-0.003 0 0];

for i = 1:n_pts
    
   psm1_pt(1,1:3) =  psm1_pts(i,:);
   psm1_pt(1,4) = 1;
    
   psm2_pt = adjusted_affine_psm1_wrt_psm2 * transpose(psm1_pt);

   
   psm2_pt = psm2_pt';
   psm2_pts(i,:) = psm2_pt(1,1:3) + offset;
   

    
end





%%

time = 10;
count = 1;
for i = 1:n_pts
    
    % PSM1 goes to a point first
    disp(strcat(num2str(psm1_pts(i,1)), ',  ',num2str(psm1_pts(i,2)), ',  ' ,num2str(psm1_pts(i,3)), ',0,1,0, 0, 0, -1, -1,', ...
        '0, 0, -0.05, 0,1,0, 0, 0, -1, 0,',   num2str(time)));
    disp(strcat(num2str(psm1_pts(i,1)), ',  ',num2str(psm1_pts(i,2)), ',  ' ,num2str(psm1_pts(i,3)), ',0,1,0, 0, 0, -1, -1,', ...
        '0, 0, -0.05, 0,1,0, 0, 0, -1, 0,',   num2str(time + 4)));  
    
    % Then PSM2 follow
    disp(strcat(num2str(psm1_pts(i,1)), ',  ',num2str(psm1_pts(i,2)), ',  ' ,num2str(psm1_pts(i,3)), ',0,1,0, 0, 0, -1, -1,', ...
        num2str(psm2_pts(i,1)) ,', ', num2str(psm2_pts(i,2)), ', ', num2str(psm2_pts(i,3)), ', 0,1,0,   0,0,-1,  0,',   num2str(time + 8)));
    disp(strcat(num2str(psm1_pts(i,1)), ',  ',num2str(psm1_pts(i,2)), ',  ' ,num2str(psm1_pts(i,3)), ',0,1,0, 0, 0, -1, -1,', ...
        num2str(psm2_pts(i,1)) ,', ', num2str(psm2_pts(i,2)), ', ', num2str(psm2_pts(i,3)), ', 0,1,0,   0,0,-1,  0,',   num2str(time + 12)));
     
    % Both return
    disp(strcat('0,0,-0.05,     0,1,0,    0,0,-1,  -1,', ...
        '0, 0, -0.05, 0,1,0, 0, 0, -1, 0,',   num2str(time + 16)));
    disp(strcat('0,0,-0.05,     0,1,0,    0,0,-1,  -1,', ...
        '0, 0, -0.05, 0,1,0, 0, 0, -1, 0,',   num2str(time + 20))); 
     
     
    time = time + 24;

%     pts_generated_cube(count,:) = [(x+i*0.01) (y+j*0.01) (z+k*0.01)];
    count = count + 1;
        
end



