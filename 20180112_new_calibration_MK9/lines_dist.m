function [dist] = lines_dist(a, b, c, d)

n = cross(b,d);
n = (n/norm(n));

temp = c - a;
d = abs(dot(n, temp));

dist = d;

end
