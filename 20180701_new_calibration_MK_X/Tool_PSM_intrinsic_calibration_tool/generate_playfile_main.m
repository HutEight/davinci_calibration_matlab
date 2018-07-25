% RN@HMS Queen Elizabeth
% 24/07/18
% Description.
%
% Notes.
%


%% THERE ARE 3 UPDATE POINTS THAT YOU NEED TO CHECK EVERYTIME YOU RUN THIS PROGRAMME.
% Search for 'checkpoint' to locate them. 

%%

% @ UPDATE CHECKPOINT 1/3
csv_folder_1 = 'Data/20180723_PSM1_intrinsic_3/';
arm_index = 1;


% @ UPDATE CHECKPOINT 2/3
% This is the calibration board marker in Polaris. Please make sure the
% Polaris is never moved throughout the calibration process.
% G_N_Md 
% affine_Md_wrt_polaris = [...
%  -0.9944528705503101, 0.02834320785855414, 0.1012924025903974, 0.008999999612569809;
%  -0.01358415328427183, -0.9895530074479121, 0.1435281025804421, -0.08544000238180161;
%  0.1043022484599338, 0.1413559620924399, 0.9844488472983871, -0.8303300142288208;
%  0, 0, 0, 1];

% OR you may use the following function to get the G_N_md from the
% quaternion printout on Polaris screen.


% @ UPDATE CHECKPOINT 3/3
affine_Md_wrt_polaris = convertQuaternionWithOriginTo4x4(-0.00735000008717, -0.0836400017142, -0.861490011215,...
     0.0515000000596, 0.0703999996185, 0.995999991894, -0.016799999401)
 
 
affine_base_wrt_polaris
 
 
%%

generateTestTrajectory(csv_folder_1, arm_index, affine_Md_wrt_polaris, affine_base_wrt_polaris)