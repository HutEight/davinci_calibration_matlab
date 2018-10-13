% RN@HMS Queen Elizabeth
% 09/08/18
% Description.
%
% Notes.
% 1. This can potential be useful for all similar test with joints.
% 2. This is currently a saperate test from the PSM intrinsic calibration
% test, which yields DH parameters plus a Joint 3 scale factor. Due to the
% Polaris would be placed sideway to collect the J2 scale factor data, the
% test change the Polaris to Base transform. It is recommended that one
% should do the J2 Scale factor test first, then proceed with the rest of
% the intrinsic calibration. Because of this sequence, we should add the
% recommendation for the J2 scale factor into the yaml file from the code
% of the Intrinsic calibration. And the da Vinci Kinematic package would
% then read from the same yaml to load all the necessary parameters. Or you
% can do it mannlly for the time being. 


%%
clc
close all
clear all


%% Initialise


% @ UPDATE CHECKPOINT 1/4
% Update the path and flags accordingly
csv_folder = 'Data/20180814_PSM1_intrinsic_1_j2_encoder_j/';

% @ UPDATE CHECKPOINT 2/4
test_joint_index = 2;


% @ 
%
joint_increment = 0.1;

if (test_joint_index == 1)
    arc_file = strcat(csv_folder,'02_j1_arc.csv');
    pts_file = strcat(csv_folder,'03_j1_still_samples_j4_0_deg.csv');
elseif (test_joint_index == 2)
    arc_file = strcat(csv_folder,'02_j2_arc.csv');
    pts_file = strcat(csv_folder,'03_j2_still_samples_j4_90_deg.csv');
end

data_mask_begin = 1;
data_mask_end = 1;

remove_static_flag = 1;
[pt_cld_arc, pt_mat_arc] = loadCsvFileToPointCloudAndMat(arc_file, data_mask_begin, data_mask_end, remove_static_flag);


remove_static_flag = 0;
[pt_cld_pts, pt_mat_pts] = loadCsvFileToPointCloudAndMat(pts_file, data_mask_begin, data_mask_end, remove_static_flag);

%% Data pre-processing

% Add mask to get the fixed points
% Note that although we put 10 points in the data acquistion playfile,
% there are only 8 points picked up after the data pre-processing.
n = 1;
fixed_pt_count = 0;


% @ UPDATE CHECKPOINT 3/4
% If there are some unwanted points at the beginning of the recording, you 
% can use this line to remove them.
pt_mat_pts(1:0,:) = [];


for i = 1:(size(pt_mat_pts, 1) -1)
     pt_0 = pt_mat_pts(i, 1:3);
     pt_1 = pt_mat_pts(i+1, 1:3);
     dist = norm( pt_1 - pt_0 );

     % @
     % This is what we should believe the point is not moving away from
     % its last point.
     if (dist < 0.000015) % A threshold to filter the (motion) static points.
         
        to_save(n,:) = (i+1);
        
        if (n > 1)
            
            % @ 
            % This is the required gap (in sequence) from where you found your last
            % point. 
            if (i-to_save(n-1)) > 25
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
    
static_pts_mat = pt_mat_pts(to_save,:);


% An extra filter to get rid of points that are not fixed for long enough.
i = 1;
for n = 1:size(section_end_time,1)
    
    % @
    % This is the minimum requirement for a point to be identified as a
    % static point.
    
    if (section_end_time(i) - section_begin_time(i)) < 6

        warning("removed one fixed point due to short still time");
        temp = strcat("at: ", num2str(section_begin_time(i) ));
        
        section_end_time(i)=[];
        section_begin_time(i)=[];
        
        disp(temp);
    else
        i = i + 1;
    end
    
end

fixed_pts_section_begin_and_end_time = [section_begin_time section_end_time];

mid_time = mean(fixed_pts_section_begin_and_end_time,2);

% @ UPDATE CHECKPOINT 4/4
% This is the window size that would be implemented to get the average of
% a point cloud. 
fixed_pts_section_begin_and_end_time = [(mid_time-2) (mid_time+2)];

fixed_pt_count = size(fixed_pts_section_begin_and_end_time,1);

pt_val_total = zeros(fixed_pt_count,3);
pt_count_mat = zeros(fixed_pt_count,1);
fitlered_n = 1;
for i = 1:(size(static_pts_mat, 1))
    
    found_slot = 0;
    for n = 1:fixed_pt_count
        
        if (static_pts_mat(i,4) > fixed_pts_section_begin_and_end_time(n,1)) && ...
            (static_pts_mat(i,4) < fixed_pts_section_begin_and_end_time(n,2))

            % Add to the pt total
            pt_val_total(n,:) = static_pts_mat(i,1:3) + pt_val_total(n,:);
            pt_count_mat(n) = pt_count_mat(n)+1;
            
            designated_sample_pts_mat_filtered(fitlered_n,:) = static_pts_mat(i,:);
            fitlered_n = fitlered_n + 1;
        
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




figure('name','Mask Review I: Static Points')
plot(pt_mat_pts(:,4),pt_mat_pts(:,2),'.');
hold on;
plot(static_pts_mat(:,4),static_pts_mat(:,2),'.');
hold off;


figure('name','Mask Review II: Designated Sample Poitns')
plot(pt_mat_pts(:,4),pt_mat_pts(:,2),'.');
hold on;
plot(static_pts_mat(:,4),static_pts_mat(:,2),'.');
plot(designated_sample_pts_mat_filtered(:,4),designated_sample_pts_mat_filtered(:,2),'+');
hold off;




%% Get J2 axis
% Circle and Plane fitting
[j2_arc_circle_params, j2_arc_plane_norm, j2_fval, j2_rms] =...
    fitCircleFmincon(pt_mat_arc)

arc_origin = [j2_arc_circle_params(:,1) j2_arc_circle_params(:,2) j2_arc_circle_params(:,3)];
    
figure('name','Sample Points with All static points')
scatter3(pt_mat_pts(:,1),pt_mat_pts(:,2),pt_mat_pts(:,3), '.');
hold on;
scatter3(static_pts_mat(:,1),static_pts_mat(:,2),static_pts_mat(:,3), '.', 'red');
scatter3(pt_val_average(:,1),pt_val_average(:,2),pt_val_average(:,3), 'O', 'blue');
scatter3(pt_val_average(:,1),pt_val_average(:,2),pt_val_average(:,3), 'x', 'white');
scatter3(j2_arc_circle_params(:,1),j2_arc_circle_params(:,2),j2_arc_circle_params(:,3), '+', 'black')
text(j2_arc_circle_params(:,1),j2_arc_circle_params(:,2),j2_arc_circle_params(:,3),'  Arc Origin','Color', 'black');
for n = 1:(fixed_pt_count)
   
    text(pt_val_average(n,1)+0.01,pt_val_average(n,2)+0.01,pt_val_average(n,3)+0.01,strcat('  ', int2str(n)),'Color', 'red');
    
end
% % Polaris Frame
%     text(0.01,0.01,0.01,'Polaris Origin','Color', 'red');
%     scale = 0.1;
%     % Y axis
%     yx_0 = 0;
%     yy_0 = 0;
%     yz_0 = 0;
%     yx_t = 0*scale;
%     yy_t = 1*scale;
%     yz_t = 0*scale;
%     v0_y= [yx_0 yy_0 yz_0];
%     vz_y= [yx_t yy_t yz_t];
%     v0z_y=[vz_y;v0_y];
%     plot3(v0z_y(:,1),v0z_y(:,2),v0z_y(:,3),'g');
%     % X axis
%     xx_0 = 0;
%     xy_0 = 0;
%     xz_0 = 0;
%     xx_t = 1*scale;
%     xy_t = 0*scale;
%     xz_t = 0*scale;
%     v0_y= [xx_0 xy_0 xz_0];
%     vx_y= [xx_t xy_t xz_t];
%     v0x_y=[vx_y;v0_y];
%     plot3(v0x_y(:,1),v0x_y(:,2),v0x_y(:,3),'r');       
%     % Z axis
%     zx_0 = 0;
%     zy_0 = 0;
%     zz_0 = 0;
%     zx_t = 0*scale;
%     zy_t = 0*scale;
%     zz_t = 1*scale;
%     v0_y= [zx_0 zy_0 zz_0];
%     vy_y= [zx_t zy_t zz_t];
%     v0y_y=[vy_y;v0_y];
%     plot3(v0y_y(:,1),v0y_y(:,2),v0y_y(:,3),'b');


axis equal;
hold off;

figure('name','Sample Points Only')
scatter3(pt_mat_pts(:,1),pt_mat_pts(:,2),pt_mat_pts(:,3), '.');
hold on;
scatter3(pt_val_average(:,1),pt_val_average(:,2),pt_val_average(:,3), 'filled', 'red');
scatter3(pt_val_average(:,1),pt_val_average(:,2),pt_val_average(:,3), 'x', 'white');
scatter3(j2_arc_circle_params(:,1),j2_arc_circle_params(:,2),j2_arc_circle_params(:,3), '+', 'black')
text(j2_arc_circle_params(:,1),j2_arc_circle_params(:,2),j2_arc_circle_params(:,3),'  Arc Origin','Color', 'black');
for n = 1:(fixed_pt_count)
   
    text(pt_val_average(n,1)+0.01,pt_val_average(n,2)+0.01,pt_val_average(n,3)+0.01,strcat('  ', int2str(n)),'Color', 'red');
    
end
axis equal;
hold off;

%% Get Vectors from Arc Origin to Fixed Points

arc_vec = pt_val_average(:,1:3) - repmat(arc_origin, fixed_pt_count, 1);


%% Get angles between them

angles = [];
for n = 1:(fixed_pt_count-1)
   
    a = arc_vec(n,:);
    b = arc_vec(n+1,:);
    angles(n,:) = atan2(norm(cross(a,b)), dot(a,b));
    
end

angles

angles_ratio = angles/0.2;
for n = 1:fixed_pt_count
    angles_ratio(n,2) = n;
end

figure('name', 'Ratio Plot')
plot(angles_ratio(1:fixed_pt_count-1,2),angles_ratio(1:fixed_pt_count-1,1))

angles_ratio

%% Extra Figure(s)

figure('name','Sample Points with info')
scatter3(pt_mat_pts(:,1),pt_mat_pts(:,2),pt_mat_pts(:,3), '.');
hold on;
scatter3(static_pts_mat(:,1),static_pts_mat(:,2),static_pts_mat(:,3), 'filled', 'red');
scatter3(pt_val_average(:,1),pt_val_average(:,2),pt_val_average(:,3), 'O', 'blue');
scatter3(j2_arc_circle_params(:,1),j2_arc_circle_params(:,2),j2_arc_circle_params(:,3), '+', 'black')
text(j2_arc_circle_params(:,1),j2_arc_circle_params(:,2),j2_arc_circle_params(:,3),'  Arc Origin','Color', 'black');
for n = 1:(fixed_pt_count)
   
    text(pt_val_average(n,1)+0.01,pt_val_average(n,2)+0.01,pt_val_average(n,3)+0.01,strcat('  ', int2str(n)),'Color', 'red');
    if n < fixed_pt_count
        text(pt_val_average(n,1)-0.01,pt_val_average(n,2)-0.01,pt_val_average(n,3)-0.01,strcat('  Actual:', num2str(angles(n,1))),...
            'Color', 'black');
        text(pt_val_average(n,1)-0.005,pt_val_average(n,2)-0.01,pt_val_average(n,3)-0.01,strcat('  Ratio:', num2str(angles_ratio(n,1))),...
            'Color', 'black');
    end
    
end
% Polaris Frame

    scale = 0.1;
    % Y axis

    % X axis
    xx_0 = j2_arc_circle_params(:,1);
    xy_0 = j2_arc_circle_params(:,2);
    xz_0 = j2_arc_circle_params(:,3);
    xx_t = xx_0+1*scale;
    xy_t = xy_0+0*scale;
    xz_t = xz_0+0*scale;
    v0_y= [xx_0 xy_0 xz_0];
    vx_y= [xx_t xy_t xz_t];
    v0x_y=[vx_y;v0_y];
    plot3(v0x_y(:,1),v0x_y(:,2),v0x_y(:,3),'r');       
    % Z axis

    text(xx_t+0.01,xy_t+0.01,xz_t+0.01,'Polaris X axis','Color', 'red');

axis equal;
hold off;

mean(angles)/0.2




%% Extra Analysis

for i = 1 : size(pt_val_average,1)/2
   
    pt_diff_vec(i,:) = pt_val_average(i,:) -  pt_val_average(size(pt_val_average,1)-i+1,:);
    pt_diff_norm_vec(i,1) = norm(pt_val_average(i,:) -  pt_val_average(size(pt_val_average,1)-i+1,:));
    
end

% You MUST make sure they are symmetric
angles_section_1 = angles(1:(size(angles,1)-1)/2,:);
angles_section_2 = angles((size(angles,1)-1)/2+2:size(angles,1),:);

scale_1 = mean(angles_section_1)/0.1
scale_2 = mean(angles_section_2)/0.1
