function [line_params, rms] = davinci_line_fit_svd(pt_mat)
    
    avg = mean(pt_mat, 1);

    subtracted = bsxfun(@minus, pt_mat, avg);
    
    [~, ~, V] = svd(subtracted);
    
    line_params.p0 = avg;
    line_params.direction = V(:, 1);
    
    % Start calculating its rms
    pc_count = size(pt_mat, 1);
    sum_dist_sqr = 0;
    for n = 1:pc_count
        [dist] = fcn_line_pt_dist(line_params.p0, line_params.direction, pt_mat(n,:));
        sum_dist_sqr = sum_dist_sqr + dist^2;
    end
    rms = sqrt(sum_dist_sqr/n);
    
    line_params.p0 = avg;
    line_params.direction = V(:, 1);
    
end

% function [dist] = fcn_line_pt_dist(p0, direction, point)
% 
%     % The line is defined by a fixed point p0 and its direction vector
%     % direction.
% 
%     p1 = p0 + direction.';
% 
%     % http://mathworld.wolfram.com/Point-LineDistance3-Dimensional.html
%     dist = sqrt( norm(cross((p1 - p0), (p0 - point)))^2/norm((p1 - p0))^2 );
%     
% end