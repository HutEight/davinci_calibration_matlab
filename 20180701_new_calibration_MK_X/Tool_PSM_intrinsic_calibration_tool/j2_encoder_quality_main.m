% RN@HMS Queen Elizabeth
% 09/08/18
% Description.
%
% Notes.
%


%%
clc
close all
clear all


%% Initialise


% @ UPDATE CHECKPOINT 2/3
% Update the path and flags accordingly
csv_folder = 'Data/20180809_PSM2_j2_encoder_test/';


arc_file = strcat(csv_folder,'02_j2_arc.csv');
pts_file = strcat(csv_folder,'03_j2_still_samples_j4_90_deg.csv');


remove_static_flag = 1;
[pt_cld_arc, pt_mat_arc] = loadCsvFileToPointCloudAndMat(arc_file,remove_static_flag);


remove_static_flag = 0;
[pt_cld_pts, pt_mat_pts] = loadCsvFileToPointCloudAndMat(pts_file,remove_static_flag);

%% Data pre-processing

% Add mask to get the fixed points
% Note that although we put 10 points in the data acquistion playfile,
% there are only 8 points picked up after the data pre-processing.
n = 1;
fixed_pt_count = 0;
for i = 1:(size(pt_mat_pts, 1) -1)
     pt_0 = pt_mat_pts(i, 1:3);
     pt_1 = pt_mat_pts(i+1, 1:3);
     dist = norm( pt_1 - pt_0 );

     if (dist < 0.00006) % A threshold to filter the (motion) static points.
        to_save(n,:) = (i+1);
        
        if (n > 1)
            if (i-to_save(n-1)) > 100
               fixed_pt_count = fixed_pt_count + 1;
               section_begin_time(fixed_pt_count,:) = pt_mat_pts(i, 4);
               section_begin_seq(fixed_pt_count,:) = i;
            else
               section_end_time(fixed_pt_count,:) = pt_mat_pts(i, 4);
               section_end_seq(fixed_pt_count,:) = i;
            end
        else
            fixed_pt_count = fixed_pt_count + 1;
            section_begin_time(fixed_pt_count,:) = pt_mat_pts(i, 4);
        end
              
        n = n+1;
        
     end
     
end
    
fixed_pts_mat = pt_mat_pts(to_save,:);

fixed_pts_section_begin_and_end_time = [section_begin_time section_end_time];
mid_time = mean(fixed_pts_section_begin_and_end_time,2);
fixed_pts_section_begin_and_end_time = [(mid_time-3.5) (mid_time+3.5)];

pt_val_total = zeros(fixed_pt_count,3);
pt_count_mat = zeros(fixed_pt_count,1);
for i = 1:(size(fixed_pts_mat, 1))
    
    found_slot = 0;
    for n = 1:fixed_pt_count
        
        if (fixed_pts_mat(i,4) > fixed_pts_section_begin_and_end_time(n,1)) && ...
            (fixed_pts_mat(i,4) < fixed_pts_section_begin_and_end_time(n,2))

            % Add to the pt total
            pt_val_total(n,:) = fixed_pts_mat(i,1:3) + pt_val_total(n,:);
            pt_count_mat(n) = pt_count_mat(n)+1;
        
            found_slot = 1;
            
        end
        
        if found_slot == 1
            break;
        end
        
    end     
    
end

% Finally, the fixed points are stored here.
pt_val_average = zeros(fixed_pt_count,3);
pt_val_average = pt_val_total./pt_count_mat;




figure
plot(pt_mat_pts(:,4),pt_mat_pts(:,1),'.');
hold on;
plot(fixed_pts_mat(:,4),fixed_pts_mat(:,1),'.');
hold off;


%% Get J2 axis
% Circle and Plane fitting
[j2_arc_circle_params, j2_arc_plane_norm, j2_fval, j2_rms] =...
    fitCircleFmincon(pt_mat_arc)
    
figure
scatter3(pt_mat_pts(:,1),pt_mat_pts(:,2),pt_mat_pts(:,3), '.');
hold on;
scatter3(fixed_pts_mat(:,1),fixed_pts_mat(:,2),fixed_pts_mat(:,3), 'filled', 'red');
scatter3(pt_val_average(:,1),pt_val_average(:,2),pt_val_average(:,3), 'O', 'blue');
scatter3(j2_arc_circle_params(:,1),j2_arc_circle_params(:,2),j2_arc_circle_params(:,3), '+', 'black')
axis equal;
hold off;




