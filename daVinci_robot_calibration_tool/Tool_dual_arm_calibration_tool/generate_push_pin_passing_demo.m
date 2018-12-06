% RN@HMS Prince of Wales
% 12/07/18
% Description.
%
% Notes.
%



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
% @ UPDATE CHECKPOINT 1/4
data_folder = 'Data/20181119_02/';

try 
    load(strcat(data_folder,'adjusted_affine_psm1_wrt_psm2.mat'))
    affine_psm2_wrt_psm1 = inv(adjusted_affine_psm1_wrt_psm2);
    disp('Loaded adjusted affine_psm1_wrt_psm2');
    
catch
    load(strcat(data_folder,'affine_psm2_wrt_psm1.mat'))
    disp('Loaded unadjusted affine_psm1_wrt_psm2');
end



affine_psm1_wrt_psm2 = inv(affine_psm2_wrt_psm1);



%% Preparation

% Inputs
% @ UPDATE CHECKPOINT 2/4
% pin_receive_point_wrt_psm1:
   x= 0.003348;
    y= 0.05803;
    z= -0.069535;
    
pin_receive_point_wrt_psm1 = [x; y; z];

% @ UPDATE CHECKPOINT 3/4
% PSM2 gripper will be slightly above and left to PSM1 gripper.
gipper_1_to_2_handover_offset = [0.002; 0.000; 0.001];
gipper_2_approach_offset_wrt_psm1 = 0.018 * affine_psm2_wrt_psm1(1:3, 4)/norm(affine_psm2_wrt_psm1(1:3, 4));

% @ UPDATE CHECKPOINT 4/4
% handover_pt
x = -0.0484015717481;
y =  0.0288847833232;
z = -0.0925468652779;

% centre_x = -0.0518711250804;
% centre_y = 0.0418876388639;
% centre_z = -0.0966702159603;

handover_pt = [x; y; z];



% 1. PSM1 gripper handover pose
% z:
psm1_gripper_z_wrt_psm1 = affine_psm2_wrt_psm1(1:3, 4);
psm1_gripper_z_wrt_psm1(3) = 0;
psm1_gripper_z_wrt_psm1 = psm1_gripper_z_wrt_psm1/norm(psm1_gripper_z_wrt_psm1);
% x:
psm1_gripper_x_wrt_psm1 = [0; 0; 1];
psm1_gripper_x_wrt_psm1 = psm1_gripper_x_wrt_psm1/norm(psm1_gripper_x_wrt_psm1);
% y:
psm1_gripper_y_wrt_psm1 = cross(psm1_gripper_z_wrt_psm1, psm1_gripper_x_wrt_psm1);
psm1_gripper_y_wrt_psm1 = psm1_gripper_y_wrt_psm1/norm(psm1_gripper_y_wrt_psm1);

psm1_gripper_rot_wrt_psm1 = [psm1_gripper_x_wrt_psm1 psm1_gripper_y_wrt_psm1 psm1_gripper_z_wrt_psm1];

psm1_pin_handover_pose_wrt_psm1 = eye(4);
psm1_pin_handover_pose_wrt_psm1(1:3, 1:3) = psm1_gripper_rot_wrt_psm1;
psm1_pin_handover_pose_wrt_psm1(1:3, 4) = handover_pt;


% 2. PSM2 gripper handover pose
psm1_pin_handover_pose_wrt_psm2 = affine_psm1_wrt_psm2 * psm1_pin_handover_pose_wrt_psm1;

% z:
psm2_gripper_z_wrt_psm2 = - psm1_pin_handover_pose_wrt_psm2(1:3,3);
% y:
psm2_gripper_y_wrt_psm2 =  psm1_pin_handover_pose_wrt_psm2(1:3,2);
% x:
psm2_gripper_x_wrt_psm2 = -psm1_pin_handover_pose_wrt_psm2(1:3,1);

psm2_gripper_rot_wrt_psm2 = [psm2_gripper_x_wrt_psm2 psm2_gripper_y_wrt_psm2 psm2_gripper_z_wrt_psm2];

psm2_pin_handover_pose_wrt_psm2 = eye(4);
psm2_pin_handover_pose_wrt_psm2(1:3, 1:3) = psm2_gripper_rot_wrt_psm2;
psm2_pin_handover_pose_wrt_psm2(1:3, 4) = psm1_pin_handover_pose_wrt_psm2(1:3, 4);

some_offset = -psm2_gripper_x_wrt_psm2 * 0.001 + psm2_gripper_z_wrt_psm2 * 0.003 + psm2_gripper_y_wrt_psm2 * 0.000;

psm2_pin_handover_pose_wrt_psm2(1:3, 4) = psm2_pin_handover_pose_wrt_psm2(1:3, 4) + some_offset;



psm2_pin_handover_pose_wrt_psm1 = affine_psm2_wrt_psm1 * psm2_pin_handover_pose_wrt_psm2;


% 3. PSM1 pin receive pose
pms1_pin_receive_pose_wrt_psm1 = eye(4);
pms1_pin_receive_pose_wrt_psm1(1:3, 1:3) = [...
    0 1 0; ...
    0 0 1; ...
    1 0 0];
pms1_pin_receive_pose_wrt_psm1(1:3, 4) = pin_receive_point_wrt_psm1;


% 4. PSM2 gripper approach pose
% psm2_approach_pose_wrt_psm1 = psm2_pin_handover_pose_wrt_psm1;
% psm2_approach_pose_wrt_psm1(1:3, 4) = psm2_approach_pose_wrt_psm1(1:3, 4) + gipper_2_approach_offset_wrt_psm1;
% 
% psm2_approach_pose_wrt_psm2 = affine_psm1_wrt_psm2 * psm2_approach_pose_wrt_psm1;

psm2_approach_pose_wrt_psm2 = psm2_pin_handover_pose_wrt_psm2;
psm2_approach_pose_wrt_psm2(1:3,4) = psm2_approach_pose_wrt_psm2(1:3,4) - psm2_gripper_z_wrt_psm2*0.01;


% 5. cold pose
psm_cold_pose = eye(4);
psm_cold_pose(1:3, 1:3) = [-1 0 0; 0 1 0; 0 0 -1];
psm_cold_pose(1:3, 4) = [0; 0; -0.04];


%% Sequence and Playfile
% 1. PSM1 go to receive pose and open the jaw, hold position for 10 sec so
% that a human operator can put a pin vertically in between its grippers.
% 2. PSM1 go to handover pose and standby.
% 3. PSM2 go to handover approach pose and open jaw, hold position for 3
% sec.
% 4. PSM2 go to handover pose and close jaw upon arrival.
% 5. PSM1 open jaw.
% 6. PSM2 retreat to approach pose.
% 7. PSM1 retreat to pin receive pose.

time = 10;
count = 1;

% format: position, x, z, jaw

%% 1. 
% PSM1 go to receive pose and open the jaw, hold position for 10 sec so
% that a human operator can put a pin vertically in between its grippers.
pms1_jaw = 0.4;
psm2_jaw = 0.0;
delta_time = 0;
time = time + delta_time;
disp(strcat(num2str(pms1_pin_receive_pose_wrt_psm1(1,4)), ',  ',num2str(pms1_pin_receive_pose_wrt_psm1(2,4)), ',  ' ,num2str(pms1_pin_receive_pose_wrt_psm1(3,4)), ',     ', ... % position
    num2str(pms1_pin_receive_pose_wrt_psm1(1,1)), ',  ', num2str(pms1_pin_receive_pose_wrt_psm1(2,1)), ',  ', num2str(pms1_pin_receive_pose_wrt_psm1(3,1)), ',     ',... % x
    num2str(pms1_pin_receive_pose_wrt_psm1(1,3)), ',  ', num2str(pms1_pin_receive_pose_wrt_psm1(2,3)), ',  ', num2str(pms1_pin_receive_pose_wrt_psm1(3,3)), ',     ',... % z
    num2str(pms1_jaw), ',       ',... % jaw
    num2str(psm_cold_pose(1,4)), ',  ',num2str(psm_cold_pose(2,4)), ',  ' ,num2str(psm_cold_pose(3,4)), ',     ', ... % position
    num2str(psm_cold_pose(1,1)), ',  ', num2str(psm_cold_pose(2,1)), ',  ', num2str(psm_cold_pose(3,1)), ',     ',... % x
    num2str(psm_cold_pose(1,3)), ',  ', num2str(psm_cold_pose(2,3)), ',  ', num2str(psm_cold_pose(3,3)), ',     ',... % z
    num2str(psm2_jaw), ',       ',... % jaw
    num2str(time)));    

pms1_jaw = 0.4;
psm2_jaw = 0.0;
delta_time = 10; % <<<
time = time + delta_time;
disp(strcat(num2str(pms1_pin_receive_pose_wrt_psm1(1,4)), ',  ',num2str(pms1_pin_receive_pose_wrt_psm1(2,4)), ',  ' ,num2str(pms1_pin_receive_pose_wrt_psm1(3,4)), ',     ', ... % position
    num2str(pms1_pin_receive_pose_wrt_psm1(1,1)), ',  ', num2str(pms1_pin_receive_pose_wrt_psm1(2,1)), ',  ', num2str(pms1_pin_receive_pose_wrt_psm1(3,1)), ',     ',... % x
    num2str(pms1_pin_receive_pose_wrt_psm1(1,3)), ',  ', num2str(pms1_pin_receive_pose_wrt_psm1(2,3)), ',  ', num2str(pms1_pin_receive_pose_wrt_psm1(3,3)), ',     ',... % z
    num2str(pms1_jaw), ',       ',... % jaw
    num2str(psm_cold_pose(1,4)), ',  ',num2str(psm_cold_pose(2,4)), ',  ' ,num2str(psm_cold_pose(3,4)), ',     ', ... % position
    num2str(psm_cold_pose(1,1)), ',  ', num2str(psm_cold_pose(2,1)), ',  ', num2str(psm_cold_pose(3,1)), ',     ',... % x
    num2str(psm_cold_pose(1,3)), ',  ', num2str(psm_cold_pose(2,3)), ',  ', num2str(psm_cold_pose(3,3)), ',     ',... % z
    num2str(psm2_jaw), ',       ',... % jaw
    num2str(time))); 
     
pms1_jaw = -0.4; % <<<
psm2_jaw = 0.0;
delta_time = 3;
time = time + delta_time;
disp(strcat(num2str(pms1_pin_receive_pose_wrt_psm1(1,4)), ',  ',num2str(pms1_pin_receive_pose_wrt_psm1(2,4)), ',  ' ,num2str(pms1_pin_receive_pose_wrt_psm1(3,4)), ',     ', ... % position
    num2str(pms1_pin_receive_pose_wrt_psm1(1,1)), ',  ', num2str(pms1_pin_receive_pose_wrt_psm1(2,1)), ',  ', num2str(pms1_pin_receive_pose_wrt_psm1(3,1)), ',     ',... % x
    num2str(pms1_pin_receive_pose_wrt_psm1(1,3)), ',  ', num2str(pms1_pin_receive_pose_wrt_psm1(2,3)), ',  ', num2str(pms1_pin_receive_pose_wrt_psm1(3,3)), ',     ',... % z
    num2str(pms1_jaw), ',       ',... % jaw
    num2str(psm_cold_pose(1,4)), ',  ',num2str(psm_cold_pose(2,4)), ',  ' ,num2str(psm_cold_pose(3,4)), ',     ', ... % position
    num2str(psm_cold_pose(1,1)), ',  ', num2str(psm_cold_pose(2,1)), ',  ', num2str(psm_cold_pose(3,1)), ',     ',... % x
    num2str(psm_cold_pose(1,3)), ',  ', num2str(psm_cold_pose(2,3)), ',  ', num2str(psm_cold_pose(3,3)), ',     ',... % z
    num2str(psm2_jaw), ',       ',... % jaw
    num2str(time))); 


pms1_jaw = -0.4;
psm2_jaw = 0.0;
delta_time = 5;  % <<<
time = time + delta_time;
disp(strcat(num2str(pms1_pin_receive_pose_wrt_psm1(1,4)), ',  ',num2str(pms1_pin_receive_pose_wrt_psm1(2,4)), ',  ' ,num2str(pms1_pin_receive_pose_wrt_psm1(3,4)), ',     ', ... % position
    num2str(pms1_pin_receive_pose_wrt_psm1(1,1)), ',  ', num2str(pms1_pin_receive_pose_wrt_psm1(2,1)), ',  ', num2str(pms1_pin_receive_pose_wrt_psm1(3,1)), ',     ',... % x
    num2str(pms1_pin_receive_pose_wrt_psm1(1,3)), ',  ', num2str(pms1_pin_receive_pose_wrt_psm1(2,3)), ',  ', num2str(pms1_pin_receive_pose_wrt_psm1(3,3)), ',     ',... % z
    num2str(pms1_jaw), ',       ',... % jaw
    num2str(psm_cold_pose(1,4)), ',  ',num2str(psm_cold_pose(2,4)), ',  ' ,num2str(psm_cold_pose(3,4)), ',     ', ... % position
    num2str(psm_cold_pose(1,1)), ',  ', num2str(psm_cold_pose(2,1)), ',  ', num2str(psm_cold_pose(3,1)), ',     ',... % x
    num2str(psm_cold_pose(1,3)), ',  ', num2str(psm_cold_pose(2,3)), ',  ', num2str(psm_cold_pose(3,3)), ',     ',... % z
    num2str(psm2_jaw), ',       ',... % jaw
    num2str(time))); 


%% 2.
% PSM1 go to handover pose and standby.

pms1_jaw = -0.4;
psm2_jaw = 0.0;
delta_time = 5; 
time = time + delta_time;
disp(strcat(num2str(psm1_pin_handover_pose_wrt_psm1(1,4)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,4)), ',  ' ,num2str(psm1_pin_handover_pose_wrt_psm1(3,4)), ',  ', ... % position
    num2str(psm1_pin_handover_pose_wrt_psm1(1,1)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,1)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(3,1)), ',  ',... % x
    num2str(psm1_pin_handover_pose_wrt_psm1(1,3)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,3)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(3,3)), ',  ',... % z
    num2str(pms1_jaw), ',  ',... % jaw
    num2str(psm_cold_pose(1,4)), ',  ', num2str(psm_cold_pose(2,4)), ',  ' ,num2str(psm_cold_pose(3,4)), ',  ', ... % position
    num2str(psm_cold_pose(1,1)), ',  ', num2str(psm_cold_pose(2,1)), ',  ', num2str(psm_cold_pose(3,1)), ',  ',... % x
    num2str(psm_cold_pose(1,3)), ',  ', num2str(psm_cold_pose(2,3)), ',  ', num2str(psm_cold_pose(3,3)), ',  ',... % z
    num2str(psm2_jaw), ',  ',... % jaw
    num2str(time))); 


pms1_jaw = -0.4;
psm2_jaw = 0.0;
delta_time = 5; % <<<
time = time + delta_time;
disp(strcat(num2str(psm1_pin_handover_pose_wrt_psm1(1,4)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,4)), ',  ' ,num2str(psm1_pin_handover_pose_wrt_psm1(3,4)), ',  ', ... % position
    num2str(psm1_pin_handover_pose_wrt_psm1(1,1)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,1)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(3,1)), ',  ',... % x
    num2str(psm1_pin_handover_pose_wrt_psm1(1,3)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,3)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(3,3)), ',  ',... % z
    num2str(pms1_jaw), ',  ',... % jaw
    num2str(psm_cold_pose(1,4)), ',  ', num2str(psm_cold_pose(2,4)), ',  ' ,num2str(psm_cold_pose(3,4)), ',  ', ... % position
    num2str(psm_cold_pose(1,1)), ',  ', num2str(psm_cold_pose(2,1)), ',  ', num2str(psm_cold_pose(3,1)), ',  ',... % x
    num2str(psm_cold_pose(1,3)), ',  ', num2str(psm_cold_pose(2,3)), ',  ', num2str(psm_cold_pose(3,3)), ',  ',... % z
    num2str(psm2_jaw), ',  ',... % jaw
    num2str(time))); 


%% 3.
% PSM2 go to handover approach pose and open jaw, hold position for 3
% sec.

pms1_jaw = -0.4;
psm2_jaw = 0.4;
delta_time = 10; % <<<
time = time + delta_time;
disp(strcat(num2str(psm1_pin_handover_pose_wrt_psm1(1,4)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,4)), ',  ' ,num2str(psm1_pin_handover_pose_wrt_psm1(3,4)), ',  ', ... % position
    num2str(psm1_pin_handover_pose_wrt_psm1(1,1)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,1)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(3,1)), ',  ',... % x
    num2str(psm1_pin_handover_pose_wrt_psm1(1,3)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,3)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(3,3)), ',  ',... % z
    num2str(pms1_jaw), ',  ',... % jaw
    num2str(psm2_approach_pose_wrt_psm2(1,4)), ',  ', num2str(psm2_approach_pose_wrt_psm2(2,4)), ',  ' ,num2str(psm2_approach_pose_wrt_psm2(3,4)), ',  ', ... % position
    num2str(psm2_approach_pose_wrt_psm2(1,1)), ',  ', num2str(psm2_approach_pose_wrt_psm2(2,1)), ',  ', num2str(psm2_approach_pose_wrt_psm2(3,1)), ',  ',... % x
    num2str(psm2_approach_pose_wrt_psm2(1,3)), ',  ', num2str(psm2_approach_pose_wrt_psm2(2,3)), ',  ', num2str(psm2_approach_pose_wrt_psm2(3,3)), ',  ',... % z
    num2str(psm2_jaw), ',  ',... % jaw
    num2str(time))); 

pms1_jaw = -0.4;
psm2_jaw = 0.4;
delta_time = 3; % <<<
time = time + delta_time;
disp(strcat(num2str(psm1_pin_handover_pose_wrt_psm1(1,4)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,4)), ',  ' ,num2str(psm1_pin_handover_pose_wrt_psm1(3,4)), ',  ', ... % position
    num2str(psm1_pin_handover_pose_wrt_psm1(1,1)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,1)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(3,1)), ',  ',... % x
    num2str(psm1_pin_handover_pose_wrt_psm1(1,3)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,3)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(3,3)), ',  ',... % z
    num2str(pms1_jaw), ',  ',... % jaw
    num2str(psm2_approach_pose_wrt_psm2(1,4)), ',  ', num2str(psm2_approach_pose_wrt_psm2(2,4)), ',  ' ,num2str(psm2_approach_pose_wrt_psm2(3,4)), ',  ', ... % position
    num2str(psm2_approach_pose_wrt_psm2(1,1)), ',  ', num2str(psm2_approach_pose_wrt_psm2(2,1)), ',  ', num2str(psm2_approach_pose_wrt_psm2(3,1)), ',  ',... % x
    num2str(psm2_approach_pose_wrt_psm2(1,3)), ',  ', num2str(psm2_approach_pose_wrt_psm2(2,3)), ',  ', num2str(psm2_approach_pose_wrt_psm2(3,3)), ',  ',... % z
    num2str(psm2_jaw), ',  ',... % jaw
    num2str(time))); 


%% 4.
% PSM2 go to handover pose and close jaw upon arrival.

pms1_jaw = -0.4;
psm2_jaw = 0.4;
delta_time = 2; % <<<
time = time + delta_time;
disp(strcat(num2str(psm1_pin_handover_pose_wrt_psm1(1,4)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,4)), ',  ' ,num2str(psm1_pin_handover_pose_wrt_psm1(3,4)), ',  ', ... % position
    num2str(psm1_pin_handover_pose_wrt_psm1(1,1)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,1)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(3,1)), ',  ',... % x
    num2str(psm1_pin_handover_pose_wrt_psm1(1,3)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,3)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(3,3)), ',  ',... % z
    num2str(pms1_jaw), ',  ',... % jaw
    num2str(psm2_pin_handover_pose_wrt_psm2(1,4)), ',  ', num2str(psm2_pin_handover_pose_wrt_psm2(2,4)), ',  ' ,num2str(psm2_pin_handover_pose_wrt_psm2(3,4)), ',  ', ... % position
    num2str(psm2_pin_handover_pose_wrt_psm2(1,1)), ',  ', num2str(psm2_pin_handover_pose_wrt_psm2(2,1)), ',  ', num2str(psm2_pin_handover_pose_wrt_psm2(3,1)), ',  ',... % x
    num2str(psm2_pin_handover_pose_wrt_psm2(1,3)), ',  ', num2str(psm2_pin_handover_pose_wrt_psm2(2,3)), ',  ', num2str(psm2_pin_handover_pose_wrt_psm2(3,3)), ',  ',... % z
    num2str(psm2_jaw), ',  ',... % jaw
    num2str(time))); 

pms1_jaw = -0.4;
psm2_jaw = -0.4;
delta_time = 3; % <<<
time = time + delta_time;
disp(strcat(num2str(psm1_pin_handover_pose_wrt_psm1(1,4)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,4)), ',  ' ,num2str(psm1_pin_handover_pose_wrt_psm1(3,4)), ',  ', ... % position
    num2str(psm1_pin_handover_pose_wrt_psm1(1,1)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,1)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(3,1)), ',  ',... % x
    num2str(psm1_pin_handover_pose_wrt_psm1(1,3)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,3)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(3,3)), ',  ',... % z
    num2str(pms1_jaw), ',  ',... % jaw
    num2str(psm2_pin_handover_pose_wrt_psm2(1,4)), ',  ', num2str(psm2_pin_handover_pose_wrt_psm2(2,4)), ',  ' ,num2str(psm2_pin_handover_pose_wrt_psm2(3,4)), ',  ', ... % position
    num2str(psm2_pin_handover_pose_wrt_psm2(1,1)), ',  ', num2str(psm2_pin_handover_pose_wrt_psm2(2,1)), ',  ', num2str(psm2_pin_handover_pose_wrt_psm2(3,1)), ',  ',... % x
    num2str(psm2_pin_handover_pose_wrt_psm2(1,3)), ',  ', num2str(psm2_pin_handover_pose_wrt_psm2(2,3)), ',  ', num2str(psm2_pin_handover_pose_wrt_psm2(3,3)), ',  ',... % z
    num2str(psm2_jaw), ',  ',... % jaw
    num2str(time))); 





%% 5.

pms1_jaw = 0.4;
psm2_jaw = -0.4;
delta_time = 3; % <<<
time = time + delta_time;
disp(strcat(num2str(psm1_pin_handover_pose_wrt_psm1(1,4)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,4)), ',  ' ,num2str(psm1_pin_handover_pose_wrt_psm1(3,4)), ',  ', ... % position
    num2str(psm1_pin_handover_pose_wrt_psm1(1,1)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,1)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(3,1)), ',  ',... % x
    num2str(psm1_pin_handover_pose_wrt_psm1(1,3)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,3)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(3,3)), ',  ',... % z
    num2str(pms1_jaw), ',  ',... % jaw
    num2str(psm2_pin_handover_pose_wrt_psm2(1,4)), ',  ', num2str(psm2_pin_handover_pose_wrt_psm2(2,4)), ',  ' ,num2str(psm2_pin_handover_pose_wrt_psm2(3,4)), ',  ', ... % position
    num2str(psm2_pin_handover_pose_wrt_psm2(1,1)), ',  ', num2str(psm2_pin_handover_pose_wrt_psm2(2,1)), ',  ', num2str(psm2_pin_handover_pose_wrt_psm2(3,1)), ',  ',... % x
    num2str(psm2_pin_handover_pose_wrt_psm2(1,3)), ',  ', num2str(psm2_pin_handover_pose_wrt_psm2(2,3)), ',  ', num2str(psm2_pin_handover_pose_wrt_psm2(3,3)), ',  ',... % z
    num2str(psm2_jaw), ',  ',... % jaw
    num2str(time))); 




%% 6.
% PSM2 retreat to approach pose.

pms1_jaw = 0.4;
psm2_jaw = -0.4;
delta_time = 3; % <<<
time = time + delta_time;
disp(strcat(num2str(psm1_pin_handover_pose_wrt_psm1(1,4)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,4)), ',  ' ,num2str(psm1_pin_handover_pose_wrt_psm1(3,4)), ',  ', ... % position
    num2str(psm1_pin_handover_pose_wrt_psm1(1,1)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,1)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(3,1)), ',  ',... % x
    num2str(psm1_pin_handover_pose_wrt_psm1(1,3)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,3)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(3,3)), ',  ',... % z
    num2str(pms1_jaw), ',  ',... % jaw
    num2str(psm2_approach_pose_wrt_psm2(1,4)), ',  ', num2str(psm2_approach_pose_wrt_psm2(2,4)), ',  ' ,num2str(psm2_approach_pose_wrt_psm2(3,4)), ',  ', ... % position
    num2str(psm2_approach_pose_wrt_psm2(1,1)), ',  ', num2str(psm2_approach_pose_wrt_psm2(2,1)), ',  ', num2str(psm2_approach_pose_wrt_psm2(3,1)), ',  ',... % x
    num2str(psm2_approach_pose_wrt_psm2(1,3)), ',  ', num2str(psm2_approach_pose_wrt_psm2(2,3)), ',  ', num2str(psm2_approach_pose_wrt_psm2(3,3)), ',  ',... % z
    num2str(psm2_jaw), ',  ',... % jaw
    num2str(time))); 




%% 7.
% PSM1 retreat to pin receive pose.

pms1_jaw = 0.4;
psm2_jaw = -0.4;
delta_time = 5; % <<<
time = time + delta_time;
disp(strcat(num2str(psm1_pin_handover_pose_wrt_psm1(1,4)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,4)), ',  ' ,num2str(psm1_pin_handover_pose_wrt_psm1(3,4)), ',  ', ... % position
    num2str(psm1_pin_handover_pose_wrt_psm1(1,1)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,1)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(3,1)), ',  ',... % x
    num2str(psm1_pin_handover_pose_wrt_psm1(1,3)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(2,3)), ',  ', num2str(psm1_pin_handover_pose_wrt_psm1(3,3)), ',  ',... % z
    num2str(pms1_jaw), ',  ',... % jaw
    num2str(psm2_approach_pose_wrt_psm2(1,4)), ',  ', num2str(psm2_approach_pose_wrt_psm2(2,4)), ',  ' ,num2str(psm2_approach_pose_wrt_psm2(3,4)), ',  ', ... % position
    num2str(psm2_approach_pose_wrt_psm2(1,1)), ',  ', num2str(psm2_approach_pose_wrt_psm2(2,1)), ',  ', num2str(psm2_approach_pose_wrt_psm2(3,1)), ',  ',... % x
    num2str(psm2_approach_pose_wrt_psm2(1,3)), ',  ', num2str(psm2_approach_pose_wrt_psm2(2,3)), ',  ', num2str(psm2_approach_pose_wrt_psm2(3,3)), ',  ',... % z
    num2str(psm2_jaw), ',  ',... % jaw
    num2str(time))); 




