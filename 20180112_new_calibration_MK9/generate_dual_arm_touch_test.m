% RN@HMS Prince of Wales
% 07/05/18

% Generate points in a sphere region of PSM1 frame, then convert the points to
% PSM2 frame. 

%%
clc
close all
clear all

%% FILL IN THE TF INFO HERE

affine_psm2_wrt_psm1 = [
    0.6671    0.7449    0.0112   -0.1679
   -0.7450    0.6670    0.0125    0.0925
    0.0019   -0.0167    0.9999    0.0058
         0         0         0    1.0000
];

affine_psm1_wrt_psm2 = inv(affine_psm2_wrt_psm1);

%%
% Save this as a show case
rng(0,'twister')
rvals = 2*rand(1000,1)-1;
elevation = asin(rvals);
azimuth = 2*pi*rand(1000,1);
radii = 0.1*(rand(1000,1).^(1/3));
[x,y,z] = sph2cart(azimuth,elevation,radii);
figure
plot3(x,y,z,'.')
axis equal

%% PSM 1 sphere (range)
centre = [-0.12 0.12 -0.12];
% Use the following as actual trajectory
rng(0,'twister')
rvals = 2*rand(20,1)-1;
elevation = asin(rvals);
azimuth = 2*pi*rand(20,1);
radii = 0.05*(rand(20,1).^(1/3));
[x,y,z] = sph2cart(azimuth,elevation,radii);
psm1_pts = [x,y,z];
psm1_pts = psm1_pts + repmat(centre, 20 ,1);
figure
plot3(x,y,z,'.')
axis equal

for i = 1:20
    
   psm1_pt(1,1:3) =  psm1_pts(i,:);
   psm1_pt(1,4) = 1;
    
   psm2_pt = affine_psm1_wrt_psm2 * transpose(psm1_pt);
   psm2_pt = psm2_pt';
   psm2_pts(i,:) = psm2_pt(1,1:3);
    
end

%% Printing on Screen
time = 10;
count = 1;
for i = 1:20
    
     disp(strcat(num2str(psm1_pts(i,1)), ',  ',num2str(psm1_pts(i,2)), ',  ' ,num2str(psm1_pts(i,3)), ',0,1,0, 0, 0, -1, -1,', ...
         num2str(psm2_pts(i,1)) ,', ', num2str(psm2_pts(i,2)), ', ', num2str(psm2_pts(i,3)), ', 0,1,0, 0, 0, -1, 0,',   num2str(time)));
     disp(strcat(num2str(psm1_pts(i,1)), ',  ',num2str(psm1_pts(i,2)), ',  ' ,num2str(psm1_pts(i,3)), ',0,1,0, 0, 0, -1, -1,', ...
         num2str(psm2_pts(i,1)) ,', ', num2str(psm2_pts(i,2)), ', ', num2str(psm2_pts(i,3)), ', 0,1,0, 0, 0, -1, 0,',   num2str(time + 4)));     
     time = time + 8;

%      pts_generated_cube(count,:) = [(x+i*0.01) (y+j*0.01) (z+k*0.01)];
     count = count + 1;
    
    
end




