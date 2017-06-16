function quadrotor_model_parameters = get_quadrotor_model()

%----- Battery specs
battery_v	= 6*3.7;	% V; typical 6 cell LiPo
battery_c	= 5.2;		% A.h; typical


quadrotor_model_parameters.mass	= 2;										% kg; unloaded mass

quadrotor_model_parameters.CD0	= 0.05;
quadrotor_model_parameters.S	= 4*pi*(0.15^2);							% m^2
quadrotor_model_parameters.cruise_altitude	= 100;							% m
quadrotor_model_parameters.cruise_airspeed	= 15;							% m/s

us76	= std_atmosphere(quadrotor_model_parameters.cruise_altitude);
quadrotor_model_parameters.cruise_drag	=  0.5 * us76.rho * ...
	(quadrotor_model_parameters.cruise_airspeed^2) * ...
	quadrotor_model_parameters.S*quadrotor_model_parameters.CD0;
quadrotor_model_parameters.weight	= quadrotor_model_parameters.mass * us76.g;
quadrotor_model_parameters.max_n	= 1.5;								% Load factor

quadrotor_model_parameters.payload		= 0;
quadrotor_model_parameters.max_payload	= 1.5;								% kg
quadrotor_model_parameters.max_energy	= battery_v * battery_c * 3600;		% J

trajectory_bounds.altitude		= [50 1e3];			% m
trajectory_bounds.altitude_hover= [0 50];			% m
trajectory_bounds.airspeed		= [2 50];			% m/s
trajectory_bounds.airspeed_hover= [0 1];			% m/s
trajectory_bounds.ang_climb		= [-10 10]*pi/180;	% rad
trajectory_bounds.ang_roll		= [-30 30]*pi/180;	% rad
trajectory_bounds.force			= 400;				% N

quadrotor_model_parameters.trajectory_bounds = trajectory_bounds;