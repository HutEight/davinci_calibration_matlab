% RN@HMS Queen Elizabeth
% 12/07/18
% Descriptions.
%
% Notes.

% PENDING REFACTORING

function [] = generateTestTrajectory(output_folder_path, arm_index, affine_Md_wrt_polaris, affine_base_wrt_polaris)
%% Generate output csv file path
t = datetime('now');
formatOut = 'yyyymmdd_HHMM';
DateString = datestr(t,formatOut);
path_val_ = strcat(output_folder_path, DateString, '_full_traj.psp');

%% Extra TF
% affine_Md_wrt_board_0_0 =  [0, -1,  0,    -0.08;
%                         0,  0,  1,        0;
%                        -1,  0,  0, -0.00877;
%                         0,  0,  0,     1];
%                     
% affine_Md_wrt_board_0_1 =  [0, -1,  0,    -0.095;
%                         0,  0,  1,        0;
%                        -1,  0,  0, -0.00877;
%                         0,  0,  0,     1];  
%                     
% affine_Md_wrt_board_0_2 =  [0, -1,  0,    -0.11;
%                         0,  0,  1,        0;
%                        -1,  0,  0, -0.00877;
%                         0,  0,  0,     1]; 
%                     
% affine_Md_wrt_board_1_0 =  [0, -1,  0,    -0.08;
%                         0,  0,  1,        -0.015;
%                        -1,  0,  0, -0.00877;
%                         0,  0,  0,     1];
%                     
% affine_Md_wrt_board_1_1 =  [0, -1,  0,    -0.095;
%                         0,  0,  1,        -0.015;
%                        -1,  0,  0, -0.00877;
%                         0,  0,  0,     1];  
%                     
% affine_Md_wrt_board_1_2 =  [0, -1,  0,    -0.11;
%                         0,  0,  1,        -0.015;
%                        -1,  0,  0, -0.00877;
%                         0,  0,  0,     1];                    
%                     
% affine_Md_wrt_board_2_0 =  [0, -1,  0,    -0.08;
%                         0,  0,  1,        -0.03;
%                        -1,  0,  0, -0.00877;
%                         0,  0,  0,     1];
%                     
% affine_Md_wrt_board_2_1 =  [0, -1,  0,    -0.095;
%                         0,  0,  1,        -0.03;
%                        -1,  0,  0, -0.00877;
%                         0,  0,  0,     1];  
%                     
% affine_Md_wrt_board_2_2 =  [0, -1,  0,    -0.11;
%                         0,  0,  1,        -0.03;
%                        -1,  0,  0, -0.00877;
%                         0,  0,  0,     1];    


affine_Md_wrt_board_0_0 =  [0, -1,  0,    -0.08;
                            0,  0,  1,        -0.015;
                           -1,  0,  0, -0.00877;
                            0,  0,  0,         1];
                    
affine_Md_wrt_board_0_1 =  [0, -1,  0,    -0.095;
                            0,  0,  1,        -0.015;
                           -1,  0,  0, -0.00877;
                            0,  0,  0,     1];  
                    
affine_Md_wrt_board_0_2 =  [0, -1,  0,    -0.11;
                            0,  0,  1,        -0.015;
                           -1,  0,  0, -0.00877;
                            0,  0,  0,     1]; 
                    
affine_Md_wrt_board_1_0 =  [0, -1,  0,    -0.08;
                            0,  0,  1,        -0.03;
                           -1,  0,  0, -0.00877;
                            0,  0,  0,     1];
                    
affine_Md_wrt_board_1_1 =  [0, -1,  0,    -0.095;
                            0,  0,  1,        -0.03;
                           -1,  0,  0, -0.00877;
                            0,  0,  0,     1];  
                    
affine_Md_wrt_board_1_2 =  [0, -1,  0,    -0.11;
                            0,  0,  1,        -0.03;
                           -1,  0,  0, -0.00877;
                            0,  0,  0,     1];                    
                    
affine_Md_wrt_board_2_0 =  [0, -1,  0,    -0.08;
                            0,  0,  1,        -0.045;
                           -1,  0,  0, -0.00877;
                            0,  0,  0,     1];
                    
affine_Md_wrt_board_2_1 =  [0, -1,  0,    -0.095;
                            0,  0,  1,        -0.045;
                           -1,  0,  0, -0.00877;
                            0,  0,  0,     1];  
                    
affine_Md_wrt_board_2_2 =  [0, -1,  0,    -0.11;
                            0,  0,  1,        -0.045;
                           -1,  0,  0, -0.00877;
                            0,  0,  0,     1];  
%% TF calculation

% affine_Md_wrt_portal = affine_polaris_wrt_portal * affine_Md_wrt_polaris
affine_Md_wrt_portal = inv(affine_base_wrt_polaris)*affine_Md_wrt_polaris;

% affine_board_wrt_portal = affine_Md_wrt_portal * affine_board_wrt_Md
affine_board_wrt_portal_0_0 = affine_Md_wrt_portal * inv(affine_Md_wrt_board_0_0);
affine_board_wrt_portal_0_1 = affine_Md_wrt_portal * inv(affine_Md_wrt_board_0_1);
affine_board_wrt_portal_0_2 = affine_Md_wrt_portal * inv(affine_Md_wrt_board_0_2);
affine_board_wrt_portal_1_0 = affine_Md_wrt_portal * inv(affine_Md_wrt_board_1_0);
affine_board_wrt_portal_1_1 = affine_Md_wrt_portal * inv(affine_Md_wrt_board_1_1);
affine_board_wrt_portal_1_2 = affine_Md_wrt_portal * inv(affine_Md_wrt_board_1_2);
affine_board_wrt_portal_2_0 = affine_Md_wrt_portal * inv(affine_Md_wrt_board_2_0);
affine_board_wrt_portal_2_1 = affine_Md_wrt_portal * inv(affine_Md_wrt_board_2_1);
affine_board_wrt_portal_2_2 = affine_Md_wrt_portal * inv(affine_Md_wrt_board_2_2);

affine_board_wrt_portal_origin = [...
    affine_board_wrt_portal_0_0(1,4), affine_board_wrt_portal_0_0(2,4), affine_board_wrt_portal_0_0(3,4); ...
    affine_board_wrt_portal_0_1(1,4), affine_board_wrt_portal_0_1(2,4), affine_board_wrt_portal_0_1(3,4); ...
    affine_board_wrt_portal_0_2(1,4), affine_board_wrt_portal_0_2(2,4), affine_board_wrt_portal_0_2(3,4); ...
    affine_board_wrt_portal_1_0(1,4), affine_board_wrt_portal_1_0(2,4), affine_board_wrt_portal_1_0(3,4); ...
    affine_board_wrt_portal_1_1(1,4), affine_board_wrt_portal_1_1(2,4), affine_board_wrt_portal_1_1(3,4); ...
    affine_board_wrt_portal_1_2(1,4), affine_board_wrt_portal_1_2(2,4), affine_board_wrt_portal_1_2(3,4); ...
    affine_board_wrt_portal_2_0(1,4), affine_board_wrt_portal_2_0(2,4), affine_board_wrt_portal_2_0(3,4); ...
    affine_board_wrt_portal_2_1(1,4), affine_board_wrt_portal_2_1(2,4), affine_board_wrt_portal_2_1(3,4); ...
    affine_board_wrt_portal_2_2(1,4), affine_board_wrt_portal_2_2(2,4), affine_board_wrt_portal_2_2(3,4)    
    ]



%% Generating .psp
t0 = 10;
dt = 2.5;
count = 1;

if (arm_index == 1)

    for i = 1:9

         playfile_mat(count,:) = [affine_board_wrt_portal_origin(i,1), ...
         affine_board_wrt_portal_origin(i,2), ...
         affine_board_wrt_portal_origin(i,3) + 0.01, ...
         0,1,0, 0,0,-1, 0, 0,0,-0.05, 0,1,0, 0,0,-1, 0, ...
         t0 + count*dt];

        count = count + 1;

        for n = 1:2

           playfile_mat(count,:) = [...
                affine_board_wrt_portal_origin(i,1), ...
                affine_board_wrt_portal_origin(i,2), ...
                affine_board_wrt_portal_origin(i,3), ...
                0,1,0, 0,0,-1, 0, 0,0,-0.05, 0,1,0, 0,0,-1, 0, ...
                t0 + count*dt];

           count = count + 1;

        end

    end

        playfile_mat(count,:) = [...
            affine_board_wrt_portal_origin(9,1), ...
            affine_board_wrt_portal_origin(9,2), ...
            affine_board_wrt_portal_origin(9,3) + 0.01, ...
            0,1,0, 0,0,-1, 0, 0,0,-0.05, 0,1,0, 0,0,-1 ,0, ...
            t0 + count*dt];       
        count = count + 1;

        playfile_mat(count,:) = [...
            affine_board_wrt_portal_origin(1,1), ...
            affine_board_wrt_portal_origin(1,2), ...
            affine_board_wrt_portal_origin(1,3) + 0.01, ...
            0,1,0, 0,0,-1, 0, 0,0,-0.05, 0,1,0, 0,0,-1, 0, ...
            t0 + count*dt + 7.5];       
        count = count + 1;

elseif (arm_index == 2)
    
    for i = 1:9

         playfile_mat(count,:) = [0,0,-0.05, 0,1,0, 0,0,-1, 0, ...
         affine_board_wrt_portal_origin(i,1), ...
         affine_board_wrt_portal_origin(i,2), ...
         affine_board_wrt_portal_origin(i,3) + 0.01, ...
         0,1,0, 0,0,-1, -1, ...
         t0 + count*dt];

        count = count + 1;

        for n = 1:2

           playfile_mat(count,:) = [0,0,-0.05, 0,1,0, 0,0,-1, 0, ...
                affine_board_wrt_portal_origin(i,1), ...
                affine_board_wrt_portal_origin(i,2), ...
                affine_board_wrt_portal_origin(i,3), ...
                0,1,0, 0,0,-1, -1, ...
                t0 + count*dt];

           count = count + 1;

        end

    end

        playfile_mat(count,:) = [...
            0,0,-0.05, 0,1,0, 0,0,-1, 0, ...
            affine_board_wrt_portal_origin(9,1), ...
            affine_board_wrt_portal_origin(9,2), ...
            affine_board_wrt_portal_origin(9,3) + 0.01, ...   
            0,1,0, 0,0,-1, -1, ...
            t0 + count*dt];       
        count = count + 1;

        playfile_mat(count,:) = [...
            0,0,-0.05, 0,1,0, 0,0,-1, 0, ...
            affine_board_wrt_portal_origin(1,1), ...
            affine_board_wrt_portal_origin(1,2), ...
            affine_board_wrt_portal_origin(1,3) + 0.01, ...    
            0,1,0, 0,0,-1, -1, ...
            t0 + count*dt + 7.5];       
        count = count + 1;
    
end

csvwrite(path_val_,playfile_mat);

%% Save a copy of affine_base_wrt_polaris

save(strcat(output_folder_path, 'affine_base_wrt_polaris.mat') ,'affine_base_wrt_polaris');

%% Printing result on screen

% fprintf('%f, %f, %f, 0,1,0, 0,0,-1,0,0,0,-0.05,0,1,0,0,0,-1,0,10      \n', ...
%     affine_board_wrt_portal_0_0(1,4), affine_board_wrt_portal_0_0(2,4), affine_board_wrt_portal_0_0(3,4))
% fprintf('%f, %f, %f, 0,1,0, 0,0,-1,0,0,0,-0.05,0,1,0,0,0,-1,0,25      \n', ...
%     affine_board_wrt_portal_0_1(1,4), affine_board_wrt_portal_0_1(2,4), affine_board_wrt_portal_0_1(3,4))
% fprintf('%f, %f, %f, 0,1,0, 0,0,-1,0,0,0,-0.05,0,1,0,0,0,-1,0,25      \n', ...
%     affine_board_wrt_portal_0_2(1,4), affine_board_wrt_portal_0_2(2,4), affine_board_wrt_portal_0_2(3,4))
% fprintf('%f, %f, %f, 0,1,0, 0,0,-1,0,0,0,-0.05,0,1,0,0,0,-1,0,25      \n', ...
%     affine_board_wrt_portal_1_0(1,4), affine_board_wrt_portal_1_0(2,4), affine_board_wrt_portal_1_0(3,4))
% fprintf('%f, %f, %f, 0,1,0, 0,0,-1,0,0,0,-0.05,0,1,0,0,0,-1,0,25      \n', ...
%     affine_board_wrt_portal_1_1(1,4), affine_board_wrt_portal_1_1(2,4), affine_board_wrt_portal_1_1(3,4))
% fprintf('%f, %f, %f, 0,1,0, 0,0,-1,0,0,0,-0.05,0,1,0,0,0,-1,0,25      \n', ...
%     affine_board_wrt_portal_1_2(1,4), affine_board_wrt_portal_1_2(2,4), affine_board_wrt_portal_1_2(3,4))
% fprintf('%f, %f, %f, 0,1,0, 0,0,-1,0,0,0,-0.05,0,1,0,0,0,-1,0,25      \n', ...
%     affine_board_wrt_portal_2_0(1,4), affine_board_wrt_portal_2_0(2,4), affine_board_wrt_portal_2_0(3,4))
% fprintf('%f, %f, %f, 0,1,0, 0,0,-1,0,0,0,-0.05,0,1,0,0,0,-1,0,25      \n', ...
%     affine_board_wrt_portal_2_1(1,4), affine_board_wrt_portal_2_1(2,4), affine_board_wrt_portal_2_1(3,4))
% fprintf('%f, %f, %f, 0,1,0, 0,0,-1,0,0,0,-0.05,0,1,0,0,0,-1,0,25      \n', ...
%     affine_board_wrt_portal_2_2(1,4), affine_board_wrt_portal_2_2(2,4), affine_board_wrt_portal_2_2(3,4))




end
