function [dist] = lines_dist(a, b, c, d)

% https://en.wikipedia.org/wiki/Skew_lines#Distance
% line_1 = a (fixed point) + λ*b
% line_2 = c + λ*d

n = cross(b,d);
n = (n/norm(n));

temp = c - a;
d = abs(dot(n, temp));

dist = d;

end
