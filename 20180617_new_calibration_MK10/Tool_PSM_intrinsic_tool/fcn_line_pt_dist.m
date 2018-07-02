function [dist] = fcn_line_pt_dist(p0, direction, point)

    % The line is defined by a fixed point p0 and its direction vector
    % direction.

    p1 = p0 + direction.';

    % http://mathworld.wolfram.com/Point-LineDistance3-Dimensional.html
    dist = sqrt( norm(cross((p1 - p0), (p0 - point)))^2/norm((p1 - p0))^2 );
    
end