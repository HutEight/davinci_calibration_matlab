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
csv_folder_1 = 'Data/20180726_PSM1_intrinsic_5_j4_45deg/';
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
affine_Md_wrt_polaris = convertQuaternionWithOriginTo4x4(-0.0179099999368, -0.05974999815233, -0.952310025692,...
      0.0494000017643, 0.0529000014067, 0.997099995613,-0.0223999992013)
 
 
affine_base_wrt_polaris = [...
    0.0981    0.0194   -0.9950   -0.2185;
   -0.4212    0.9067   -0.0239   -0.0467;
    0.9017    0.4214    0.0971   -0.9061;
         0         0         0    1.0000]
 
 
%%

generateTestTrajectory(csv_folder_1, arm_index, affine_Md_wrt_polaris, affine_base_wrt_polaris)