% RN@HMS Queen Elizabeth
% 30/07/18
% Description.
%
% Notes.
%

function [] = generateSmallSpherePlayfile(j1, j2, j3, arm_index, test_index, save_file_path)

%% Generate output csv file path
t = datetime('now');
formatOut = 'yyyymmdd_HHMM';
DateString = datestr(t,formatOut);
path_val_ = strcat(save_file_path, test_index, '_small_sphere.jsp');


j4 = -1.5;
j5 = -1.5;
i = 1;
n = 1;

dt1 = 8;
dt2 = 2;
tta = 0;

if (arm_index == 1)

    while (j4 <= 1.5)
        % go to first point
        tta = tta + dt1;
        playfile_mat(i,:) = [j1, j2, j3, j4, j5, 0,	0.139,		0,0,0,0,0,0,0,  tta];
        i = i + 1;
        % stay for 2 sec
        tta = tta + dt2;
        playfile_mat(i,:) = [j1, j2, j3, j4, j5, 0,	0.139,		0,0,0,0,0,0,0,  tta];
        i = i + 1;
        % rotate j4
        j4 = j4 + 0.2;
        tta = tta + dt2;
        playfile_mat(i,:) = [j1, j2, j3, j4, j5, 0,	0.139,		0,0,0,0,0,0,0,  tta];
        i = i + 1;
        % rotate j5
        j5 = - j5;
        tta = tta + dt1;
        playfile_mat(i,:) = [j1, j2, j3, j4, j5, 0,	0.139,		0,0,0,0,0,0,0,  tta];
        i = i + 1;
        % stay for 2 sec
        tta = tta + dt2;
        playfile_mat(i,:) = [j1, j2, j3, j4, j5, 0,	0.139,		0,0,0,0,0,0,0,  tta];
        i = i + 1;
        % rotate j4
        j4 = j4 + 0.2;
        tta = tta + dt2;
        playfile_mat(i,:) = [j1, j2, j3, j4, j5, 0,	0.139,		0,0,0,0,0,0,0,  tta];
        % rotate j5
        j5 = - j5;

    end

elseif (arm_index==2)
    
    while (j4 <= 1.5)
        % go to first point
        tta = tta + dt1;
        playfile_mat(i,:) = [0,0,0,0,0,0,0,    j1, j2, j3, j4, j5, 0,	0.139,		  tta];
        i = i + 1;
        % stay for 2 sec
        tta = tta + dt2;
        playfile_mat(i,:) = [0,0,0,0,0,0,0,    j1, j2, j3, j4, j5, 0,	0.139,		  tta];
        i = i + 1;
        % rotate j4
        j4 = j4 + 0.2;
        tta = tta + dt2;
        playfile_mat(i,:) = [0,0,0,0,0,0,0,    j1, j2, j3, j4, j5, 0,	0.139,		  tta];
        i = i + 1;
        % rotate j5
        j5 = - j5;
        tta = tta + dt1;
        playfile_mat(i,:) = [0,0,0,0,0,0,0,    j1, j2, j3, j4, j5, 0,	0.139,		  tta];
        i = i + 1;
        % stay for 2 sec
        tta = tta + dt2;
        playfile_mat(i,:) = [0,0,0,0,0,0,0,    j1, j2, j3, j4, j5, 0,	0.139,		  tta];
        i = i + 1;
        % rotate j4
        j4 = j4 + 0.2;
        tta = tta + dt2;
        playfile_mat(i,:) = [0,0,0,0,0,0,0,    j1, j2, j3, j4, j5, 0,	0.139,		  tta];
        % rotate j5
        j5 = - j5;

    end    
    
    
end



csvwrite(path_val_,playfile_mat);


end