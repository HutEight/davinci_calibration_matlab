% RN@HMS Prince of Wales
% 12/07/18
% Descriptions.
% 
% Notes.
% A line is defined by a fixed point p0 and its direction vector.

function [dist] = calculatePointLineDist(p0, direction, point)

    % The line is defined by a fixed point p0 and its direction vector
    % direction.
    try
        p1 = p0 + direction.';

        % http://mathworld.wolfram.com/Point-LineDistance3-Dimensional.html
        dist = sqrt( norm(cross((p1 - p0), (p0 - point)))^2/norm((p1 - p0))^2 );
    catch
       
        p0 = p0(:);
        direction = direction(:);
        point = point(:);
        
        p1 = p0 + direction;
        dist = sqrt( norm(cross((p1 - p0), (p0 - point)))^2/norm((p1 - p0))^2 );
        
    end
    
end