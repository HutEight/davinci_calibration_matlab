% RN@HMS Prince of Wales
% 10/04/18

%%
clc
close all
clear all

%% 
% Change these initial values
x = 0;
y = 0;
z = 0;

time = 10;
count = 1;

for i = 0:9
    
   for j = 0:9
       
      disp(strcat(num2str((x+i*0.01)), ',  ',num2str(y+j*0.01), ',  ' ,num2str(z), ',0,1,0, 0, 0, -1, -1,       0, 0, -0.15, 0,1,0, 0, 0, -1, 0,',   num2str(time)));
      disp(strcat(num2str((x+i*0.01)), ',  ',num2str(y+j*0.01), ',  ' ,num2str(z), ',0,1,0, 0, 0, -1, -1,       0, 0, -0.15, 0,1,0, 0, 0, -1, 0,',   num2str(time + 5))); 
       
      time = time + 10;
      
      pts_generated(count,:) = [(x+i*0.01) (y+j*0.01) (z)];
      count = count + 1;
   end
    
end

save('savePts_generated.mat', 'pts_generated');