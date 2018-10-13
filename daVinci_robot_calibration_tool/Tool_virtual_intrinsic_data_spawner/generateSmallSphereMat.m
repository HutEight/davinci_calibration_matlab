% RN@HMS Queen Elizabeth
% 01/08/18
% Descriptions.
%
% Notes.
% https://en.wikipedia.org/wiki/Rotation_matrix


function [mat] = generateSmallSphereMat(origin, radius)

n = 15;
increment = pi/n;
count = 1;
t0 = 19;

% Create a unit sphere first
for a = 0:(n-1)
    alpha = a*increment;

    r = sin(alpha);
   
   for b = 0:(2*n-1)
       beta = b*increment;
           
           z = radius*r*sin(beta) + origin(3);
           x = radius*r*cos(beta) + origin(1);
           y = radius*cos(alpha) + origin(2);
           
           mat(count,1:4) = [x y z (t0 + count*0.02)];
           count = count + 1;

   end
   
end




end