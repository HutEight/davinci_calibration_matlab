rng(1234);

coords = csvread('better_sim.csv');
coords = coords(coords(:, 1) ~= -1, :);
visual = coords(:, 1 : 3);
kinematic = coords(:, 4 : 6);

shuffler  = randperm(size(visual, 1));
visual = visual(shuffler, :);
kinematic = kinematic(shuffler, :);

gaussian_noise = 0.0 : 0.00005 : 0.001;
average_errors = nan(size(gaussian_noise, 2), 10);
maximum_errors = nan(size(gaussian_noise, 2), 10);
gval = nan(size(gaussian_noise, 2), 10);

for i = 1 : size(gaussian_noise, 2)
	for k = 1 : 10
		noise_dist = makedist('Normal', 'mu', 0, 'sigma', gaussian_noise(i));
		noise_additive = random(noise_dist, size(visual));
		noised_visual = visual + noise_additive;
		[e, t] = calculate_point_transform(noised_visual, kinematic, visual, kinematic);
		average_errors(i, k) = mean(e);
		maximum_errors(i, k) = max(e);
		gval(i, k) = mean(std(noise_additive));
	end
end
average_errors = reshape(average_errors, size(average_errors, 1) * size(average_errors, 2), 1);
maximum_errors = reshape(maximum_errors, size(maximum_errors, 1) * size(maximum_errors, 2), 1);
gval = reshape(gval,  size(gval, 1) * size(gval, 2), 1);

figure('name', 'Error w. r. t. Gaussian Noise');
scatter(gval, average_errors, [], 'b');
hold on
scatter(gval, maximum_errors, [], 'r');
hold off


average_errors = nan(size(visual, 1), 1);
maximum_errors = nan(size(visual, 1), 1);
sval = nan(size(visual, 1), 1);
for i = 1 : size(visual, 1) - 3
	select_visual = visual(3 : i + 3, :);
	select_kinematic = kinematic(3 : i + 3, :);
	[e, t] = calculate_point_transform(select_visual, select_kinematic, visual, kinematic);
	average_errors(i) = mean(e);
	maximum_errors(i) = max(e);
	sval(i) = i;
end

average_errors = reshape(average_errors, size(average_errors, 1) * size(average_errors, 2), 1);
maximum_errors = reshape(maximum_errors, size(maximum_errors, 1) * size(maximum_errors, 2), 1);
sval = reshape(sval,  size(sval, 1) * size(sval, 2), 1);

figure('name', 'Error w. r. t. Sample Size');
scatter(sval, average_errors, [], 'b');
hold on
scatter(sval, maximum_errors, [], 'r');
hold off