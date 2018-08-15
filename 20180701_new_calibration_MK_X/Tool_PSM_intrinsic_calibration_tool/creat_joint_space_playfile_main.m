% RN@HMS Queen Elizabeth
% 14/08/18
% Descriptions.
%
% Notes.
%


%%
clc
close all
clear all

%% Initialise

save_file_path = 'Playfiles/20180814_PSM2_joint_2/';
file_name = 'PSM1_J2_test.jsp';


home_array = [0, 0, 0, 0, 0, 0, 0.139626]

% motion_mat = [0, -0.9, 0.22, 1.5708, 0, 0, 0.139626]

times_stamp = [10]

travel_time = 10;
stand_still_time = 10;

limit = 0.7;

j1_val = 0.0;
j2_val = -limit;
motion_array = [j1_val, j2_val, 0.22, 1.5708, 0, 0, 0.139626]

% PSM 1 case.



joint_delta = 0.1;

row_count = 1;
pose_count = 0;
while j2_val < (limit+0.01) 
   
    % Go to a position
    play_mat(row_count,:) = [motion_array,  home_array,  times_stamp];
    row_count = row_count + 1;
    times_stamp = times_stamp + stand_still_time;
    % Stay there
    play_mat(row_count,:) = [motion_array,  home_array,  times_stamp];
    row_count = row_count + 1;
    % Update next position to go
    times_stamp = times_stamp + travel_time;
    j2_val = j2_val + joint_delta;
    motion_array = [j1_val, j2_val, 0.22, 1.5708, 0, 0, 0.139626];
    pose_count = pose_count + 1;
    
end

% Set a middle point
    times_stamp = times_stamp + travel_time;
    j2_val = j2_val - 1.5*joint_delta;
    motion_array = [j1_val, j2_val, 0.22, 1.5708, 0, 0, 0.139626];
    pose_count = pose_count + 1;
    play_mat(row_count,:) = [motion_array,  home_array,  times_stamp];
    row_count = row_count + 1;
    times_stamp = times_stamp + travel_time;
    
% Append a reverse process   
joint_delta = -0.1;
j1_val = 0.0;
j2_val = +limit;
motion_array = [j1_val, j2_val, 0.22, 1.5708, 0, 0, 0.139626]
while j2_val > -(limit+0.01)
   
    % Go to a position
    play_mat(row_count,:) = [motion_array,  home_array,  times_stamp]
    row_count = row_count + 1;
    times_stamp = times_stamp + stand_still_time;
    % Stay there
    play_mat(row_count,:) = [motion_array,  home_array,  times_stamp]
    row_count = row_count + 1;
    % Update next position to go
    times_stamp = times_stamp + travel_time;
    j2_val = j2_val + joint_delta;
    motion_array = [j1_val, j2_val, 0.22, 1.5708, 0, 0, 0.139626];
    pose_count = pose_count + 1;
    
end




csvwrite(strcat(save_file_path,file_name),play_mat);
