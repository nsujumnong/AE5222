
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


results_1hop = ps_opt_method(from_coordinates, to_coordinates, initial_state, search_data);

