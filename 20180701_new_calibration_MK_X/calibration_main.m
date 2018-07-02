clc
close all
clear all

global G_N_Pg G_N_Mg   % these gloabal values are for arm calibration
global G_C_D_l G_C_D_r G_C_Mc_l G_C_Mc_r G_Md_Mc G_N_Mc G_N_Md
load G_C_D_l.mat G_C_D_l
load G_C_D_r.mat G_C_D_r
load G_N_Mc.mat G_N_Mc
load G_N_Md.mat G_N_Md
load G_Md_Mc.mat G_Md_Mc
load G_C_Mc_l.mat G_C_Mc_l
load G_C_Mc_r.mat G_C_Mc_r


%% G_N_Pg: Calculate Portal frame (Pg) interms of Polaris (N) 
for i=1:15
csv_folder = strcat('20170828_arm_calibration_cvs/',int2str(i),'/');

colour = 'g'; % Colour of the robor arm for calibration
% green_sphere = davinci_sphere_fit(csv_folder,'g') % Developped by Will

[green_sphere_info, green_sphere_residuals] = davinci_sphere_fit_least_square(csv_folder,colour); % Developped by Will

[green_plane_1_param, green_plane_2_param, green_planes_fval, green_planes_mat] = davinci_planes_fit(csv_folder,colour); % Developped by Will

%green_planes_rms =
%davinci_planes_rms(green_plane_1_param,green_plane_2_param,csv_folder,colour); % Developped by Will

p_Tg = davinci_polaris_transform(green_sphere_info(1:3),green_planes_mat); % Developped by Will
G_N_Pg{i}=p_Tg; % Store the frames for optimization

% Uncomment below to display individual result or error % Developped by Will
% disp(strcat('Portal Frame interms of Polaris: ' , int2str(i)));
%disp(p_Tg);
% green_sphere_rms = davinci_sphere_rms(green_sphere_info(1:4),'ArmCalibrationDataCheck/1/','g');
% disp('Error (rms): ');
% disp(green_sphere_rms);

end


%% G_N_Mg : Load Robot Base Marker (Mg) interms of Polaris (N)
% This data is collected by Orhan and Will on 8/28/2017
G_N_Mg = loadArmBaseMarkerData();



%% G_Pg_Mg : Optimize Arm Base (Mg) Portal (Pg) transformation
G_Pg_Mg = optimizeArmBasePortal(G_N_Mg,G_N_Pg);


%% Calculate mean and variance of the Portal(Pg) to Arm Base (Mg)
% This is for anaylysis purpose
% for i=1:15
%     G_PM{i} = inv(G_N_Pg{i})*G_N_Mg{i};
%     p{i} = G_PM{i}(1:3,4:4);
%     temp =G_PM{i}(1:3,1:3); 
%     R_eul = rotm2eul(temp);
%     R{i} = rotm2quat(temp);
%     
%     X(i) = p{i}(1);
%     Y(i) = p{i}(2);
%     Z(i) = p{i}(3);
%     
%     Rz(i) = R_eul(1);
%     Ry(i) = R_eul(2);
%     Rx(i) = R_eul(3);
%     I(i) = i;
% end
% R_mean = [0 0 0 0];
% for i=1:15
%     t = R{i};
%     R_mean = R_mean+t;
% end
% R_mean = R_mean/15;
% R_mean = R_mean/norm(R_mean);
% R_mean = quat2eul(R_mean);
% 
% R_opt = G_Pg_Mg(1:3,1:3);
% R_opt = rotm2eul(R_opt);
% 
% mean_x = mean(X);
% var_x = var(X);
% mean_Rx = mean(Rx);
% var_Rx = var(Rx);
% mean_y = mean(Y);
% var_y = var(Y);
% mean_Ry = mean(Ry);
% var_Ry = var(Ry);
% mean_z = mean(Z);
% var_z = var(Z);
% mean_Rz = mean(Rz);
% var_Rz = var(Rz);
% 
% figure(1);
% subplot(3,1,1);
% plot(I,X,'g',I,G_Pg_Mg(1,4),'b--*');
% title('X axis over data in (m)');
% legend('Individual ','Optimized');
% 
% subplot(3,1,2);
% plot(I,Y,'g',I,G_Pg_Mg(2,4),'b--*');
% title('Y axis over data in (m)');
% legend('Individual ','Optimized');
% 
% 
% subplot(3,1,3); 
% plot(I,Z,'g',I,G_Pg_Mg(3,4),'b--*');
% title('Z axis over data in (m)');
% suptitle('Translation over Portal to Robot Arm Base Marker Data ');
% legend('Individual ','Optimized');
% 
% 
% figure(2);
% subplot(3,1,1);
% plot(I,Rx,'g',I,R_opt(3),'b--*');
% title('Rx  over data in (rad)');
% legend('Individual ','Optimized');
% 
% subplot(3,1,2);
% plot(I,Ry,'g',I,R_opt(2),'b--*');
% title('Ry over data in (rad)');
% legend('Individual ','Optimized');
% 
% subplot(3,1,3); 
% plot(I,Rz,'g',I,R_opt(1),'b--*');
% title('Rz over data in (rad)');
% suptitle('Rotation over Portal to Robot Arm Base Marker Data ');
% legend('Individual ','Optimized');



%% Test Arm Calibration: to test the calbration result
% points in the board frame (D) transformed into Portal frame (Pg)
% Pg_p = testArmCalibration(G_Pg_Mg);

%% Load Camera calibration data 
% run this line ones to create .mat file then use load at the beginnning of the script
% This data is collected by Orhan and Will on 8/28/2017
loadCameraCalibrationData();

%% Optimize camera(C) to marker on the camera (Mc)
G_Mc_C = optimizeCameraToMarker(G_C_D_l,G_C_Mc_l,G_Md_Mc);


%% Final Calibration Result
% G_Mg_Mc: manually obtained each time camera or robot arm is moved
 G_Mg_Mc = [0.8777080131360452, -0.4750734722725654, -0.06272032859978234, 0.4390876519969589;
           0.1892234530438281, 0.2233552207838277, 0.9561939814529157, -0.3818347948428166;
           -0.440253482092927, -0.8511272767873765, 0.2859357099306717, 0.03785108086772654;
           0, 0, 0, 1];

 G_Pg_C = G_Pg_Mg*G_Mg_Mc*G_Mc_C; % Transformation: Camera interms of Portal
 G_C_Pg = inv(G_Pg_C); % Transformation: Portal interms of Camera

 % G_C_Pg = inv(G_Pg_C);
% p = G_C_Pg(1:3,4:4)';
% r = rotationMatrixToVector(G_C_Pg(1:3,1:3));

%% Test Full Calibration
% This function takes individual calibrations (Camera to Marker on the camera and Portal to the marker on the robot arm base) and finds point
% Uncomment below line to print cartesian space coordinates for the play
% file reader. Copy the lines and use it directly in a jsp and ask the
% robot visit points
%Pg_p = testFullCalibration(G_Mc_C,G_Pg_Mg);

%% Test Global Calibration Calibration
% % This function takes individual calibrations (Camera to Marker on the camera and Portal to the marker on the robot arm base) and finds point
% G_C_Pg =[-0.8815450947560767, 0.4659751432193188, -0.07579849479531263, -0.1672848407764371;
%   0.4720605418289373, 0.8679649425787017, -0.1542585599003189, 0.01615673601627588;
%   -0.006090218359791386, -0.1717673553271557, -0.9851187161374231, 0.07612422173078343;
%   0, 0, 0, 1];% This is the transformation matrix produced by global optimizer
% G_Pg_C_global = inv(G_C_Pg); % Inverse of global optimization
% % This function takes global calibration result and produces points on the
% % board coordinates interns of portal frame
% % To do that Board (D) to Camera (C) transformation (G_C_D) is needed. This
% % transformation needs to be refreshed when the board moves (only left camera is used)
% G_C_D = [0.9827951519548332, -0.1030490767763953, 0.1532794084983651, -0.007573721980867055;
%  0.08720106263272692, 0.9904532862398076, 0.1067626453985152, -0.03049766033612527;
%  -0.1628178859026223, -0.0915596830067604, 0.9823986769524388, 0.2199624206194504;
%  0, 0, 0, 1];
% Pg_p = testGlobalCalibration(G_Pg_C_global, G_C_D);
% 
% % At this Camera to Board transformation, the first corner in portal
% % coordinate frame is
% % belief = Pg_p(1:3,1)';
% %  trueRobotPose = [-0.159, 0.009, -0.1388];
% %  error = (belief-trueRobotPose)*1000 % convert into mm
% %  Xerr = error(1);
% %  Yerr = error(2);
% %  Zerr = error(3);
% %  RMSerr = sqrt(Xerr*Xerr+Yerr*Yerr+Zerr*Zerr)
 
 


