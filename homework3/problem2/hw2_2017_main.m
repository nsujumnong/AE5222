clear variables; close all; clc

% Constant N_P in the expression for threat field
threat_basis_data.n_threat_parameters	= 25;

% Coefficients \theta in the expression for threat field
threat_parameters_true = [...
	1.1665    1.2128    0.4855    1.0260    0.8707   -0.3818    0.4289  ...
	-0.2991   -0.8999   0.6347	  0.0675   -0.1871    0.2917    0.9877  ...
	0.3929    0.1946    0.2798    0.0512   -0.7745    0.7868 	1.4089  ...
	-0.5341    1.9278   -0.1762   -0.2438]';

n_center_rows	= sqrt(threat_basis_data.n_threat_parameters);
center_spacing	= 2 / (n_center_rows + 1);

% Constants \bar{x}_n and \bar{y}_n in the expression for threat field
threat_basis_data.basis_parameters.mean = zeros(2, threat_basis_data.n_threat_parameters);
for m1 = 1:n_center_rows
	for m2 = 1:n_center_rows
		threat_basis_data.basis_parameters.mean(:, (m2 - 1)*n_center_rows + m1) = ...
			[-1 + m1*center_spacing; -1 + m2*center_spacing];
	end
end

% Constants \nu_n in the expression for threat field
threat_basis_data.basis_parameters.var	= (1.25 * center_spacing)^2;		% This is \sigma^2_\Psi

% Constant c_offset in the expression for threat field
threat_basis_data.offset				= 3;


%% Example of setting up a uniform grid and calculating threat value at any grid point

N_G	 = 101; % <== Change this number to get a different grid
grid_world.n_grid_points= N_G^2;
grid_world.n_grid_row	= N_G;
grid_world.spacing		= 2 / (grid_world.n_grid_row - 1);

grid_world.coordinates	= zeros(2, grid_world.n_grid_points);
for m1 = 0:(grid_world.n_grid_points - 1)	
	grid_world.coordinates(:, m1 + 1) = [...
		-1 + (mod(m1, grid_world.n_grid_row))*grid_world.spacing; ...
		-1 + floor(m1/grid_world.n_grid_row)*grid_world.spacing];
end

% Calculate threat at each grid point (at once)
threat_value_true = calc_threat(threat_basis_data, ...
	threat_parameters_true, [5;5])




