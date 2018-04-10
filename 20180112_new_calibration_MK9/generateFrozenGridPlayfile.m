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

for i = 0:9
    
   for j = 0:9
       
      disp(strcat(num2str((x+i)), ',  ',num2str(y+j), ',  ' ,num2str(z), ',0,1,0, 0, 0, -1, -1,       0, 0, -0.15, 0,1,0, 0, 0, -1, 0,',   num2str(time)));
      disp(strcat(num2str((x+i)), ',  ',num2str(y+j), ',  ' ,num2str(z), ',0,1,0, 0, 0, -1, -1,       0, 0, -0.15, 0,1,0, 0, 0, -1, 0,',   num2str(time + 5))); 
       
      time = time + 10;
   end
    
end