
clear variables; close all; clc;

search_data.quadrotor_model_parameters	= get_quadrotor_model();

search_data.us76_cruise	= std_atmosphere(...
	search_data.quadrotor_model_parameters.cruise_altitude);

ps_parameters.N	= 15;
ps_parameters.lgl_colloc= get_collocation(ps_parameters.N);  % Legendre and Lagrange polynomials; D matrix
search_data.ps_parameters	= ps_parameters;

from_coordinates = [0,0];
% from_coordinates.position.y = 0;
% from_coordinates.position.z = -1000;

to_coordinates = [2000,50];
% to_coordinates.position.y = 50;
% to_coordinates.position.z = 0;

% initial_state.position = from_coordinates; 
initial_state.airspeed = 10;
initial_state.altitude = -100;
initial_state.ang_heading = 0;
initial_state.ang_climb = 0;


results_1hop = ps_opt_method2(from_coordinates, to_coordinates, initial_state, search_data);

tf = results_1hop.tf_ps;
points = size(ps_parameters.lgl_colloc.phi_l);
data = zeros(points(1), 6);
u = zeros(points(1), 3);

for i = 1:1:ps_parameters.N+1
   phi = ps_parameters.lgl_colloc.phi_l(:, i);
   data = data + phi * results_1hop.xi_ps(i, :);
   u = u + phi * results_1hop.u_ps(i, :);
end

time = linspace(0, tf, points(1));

x = data(:, 1);
y = data(:, 2);
z = data(:, 3);
v = data(:, 4);
psi = data(:, 5);
gamma = data(:, 6);

T = u(:, 1);
L = u(:, 2);
phi = u(:, 3);

figure
plot(time, data)
grid on

figure
plot(time, T)
grid on
title('Trust')


figure
plot(time, L)
grid on
title('Lift')

figure
plot(time, -z)
title('Z path')

figure
plot(time, v)
grid on
title('Velocity')

figure
plot3(data, y, z)
grid on
title('3D path')

    
