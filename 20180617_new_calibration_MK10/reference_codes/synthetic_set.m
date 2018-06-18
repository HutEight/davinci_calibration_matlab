                                                                                                                                                                                                                                                                                                                                                                                                 x_min = - 0.05;
x_max = 0.05;
y_min = -0.03;
y_max = 0.03;
z_min = -0.02;
z_max = - 0.01;
increment = 0.005;

data = nan(((x_max - x_min) / increment) * ((y_max - y_min) / increment) * ((z_max - z_min) / increment), 6);
R = [
	-1, 0, 0;
	0, -1, 0;
	0, 0, 1
];
t = [1.2, -3.4, 5];
T = [[R, t']; [0, 0, 0, 1]];

p = 1;
for x = x_min : increment : x_max
	for y = y_min : increment : y_max
		for z = z_min : increment : z_max
			data(p, 1 : 3) = [x y z];
			
			transformed_point = T * [x y z 1]';
			data(p, 4 : 6) = transformed_point(1 : 3)';
			
			p = p + 1;
		end
	end
end

csvwrite('synthetic_data.csv', data);