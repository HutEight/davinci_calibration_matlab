% RN@HMS Queen Elizabeth
% 16/10/18
% Description.
% 
% Notes.
%
%

function [] = plotDavinciDHFrames(dh_frame_0, dh_frame_1, dh_frame_2, ...
    dh_frame_3, dh_frame_4, dh_frame_5) 

figure('Name', 'All Frames');
hold on;
axis equal;

% plotSingleFrame(frame_homo, index) 
plotSingleFrame(dh_frame_0, 0); 
plotSingleFrame(dh_frame_1, 1); 
plotSingleFrame(dh_frame_2, 2); 
plotSingleFrame(dh_frame_3, 3); 
plotSingleFrame(dh_frame_4, 4); 
plotSingleFrame(dh_frame_5, 5); 

hold off;

end