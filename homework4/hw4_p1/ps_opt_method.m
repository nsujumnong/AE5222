function results_1hop = ps_opt_method(...
	from_coordinates, to_location, initial_dyn_state, search_data)

quadrotor_model_parameters	= search_data.quadrotor_model_parameters;
quadrotor_model_parameters.mass = quadrotor_model_parameters.mass + quadrotor_model_parameters.payload;
trajectory_bounds			= quadrotor_model_parameters.trajectory_bounds;
ps_parameters				= search_data.ps_parameters;
ps_N= ps_parameters.N;
ps_D= ps_parameters.lgl_colloc.D;
const_trav_time = 0.5;
w_ps= ( ( 2 / ps_N*(ps_N + 1) ) * (1 ./ ((ps_parameters.lgl_colloc.LN_tm).^2) ) )';

%% Boundary conditions
initial_state			= initial_dyn_state;
initial_state.position	= from_coordinates;

final_state.position	= to_location;
final_state.altitude	= -100;			% m
final_state.airspeed	= 0;			% m/s
final_state.ang_climb	= 0;			% rad

%% Initial guess generation (INCOMPLETE)

quadrotor_model_parameters.scale_posn	= norm( final_state.position - initial_state.position );
quadrotor_model_parameters.bias_posn	= initial_state.position;
quadrotor_model_parameters.rotn_posn	= ...
	atan2( final_state.position(2) - initial_state.position(2), ...
	final_state.position(1) - initial_state.position(1) );
rotmat		= [...
	cos(quadrotor_model_parameters.rotn_posn) -sin(quadrotor_model_parameters.rotn_posn); ...
	sin(quadrotor_model_parameters.rotn_posn) cos(quadrotor_model_parameters.rotn_posn)];

%----- xi0 and xif are in scaled, rotated coordinates
xi0		= [0; 0];
if isfield(initial_state, 'altitude')
	xi0	= [xi0; -initial_state.altitude / quadrotor_model_parameters.scale_posn];
else
	xi0	= [xi0; -trajectory_bounds.altitude_hover(1) / quadrotor_model_parameters.scale_posn];
end

if isfield(initial_state, 'airspeed')
	xi0	= [xi0; initial_state.airspeed / quadrotor_model_parameters.scale_posn];
else
	xi0	= [xi0; trajectory_bounds.airspeed_hover(1) / quadrotor_model_parameters.scale_posn];
end
if isfield(initial_state, 'ang_climb')
	xi0	= [xi0; initial_state.ang_climb];
else
	xi0	= [xi0; 0];
end
if isfield(initial_state, 'ang_heading')
	xi0	= [xi0; deg2rad(initial_state.ang_heading - quadrotor_model_parameters.rotn_posn)];
else
	xi0	= [xi0; 0];
end

xif		= [1; 0];
if isfield(final_state, 'altitude')
	xif	= [xif; -final_state.altitude / quadrotor_model_parameters.scale_posn];
else
	xif	= [xif; -trajectory_bounds.altitude_hover(2) / quadrotor_model_parameters.scale_posn];
end

if isfield(final_state, 'airspeed')
	xif	= [xif; final_state.airspeed / quadrotor_model_parameters.scale_posn];
else
	xif	= [xif; trajectory_bounds.airspeed_hover(2) / quadrotor_model_parameters.scale_posn];
end

if isfield(final_state, 'ang_climb')
	xif	= [xif; final_state.ang_climb];
else
	xif	= [xif; 0];
end
if isfield(final_state, 'ang_heading')
	xif	= [xif; rad2pi(final_state.ang_heading - quadrotor_model_parameters.rotn_posn)];
else
	xif	= [xif; 0];
end 


% DESIRED INITIAL GUESS
x_1_ps0 = linspace(0,2000,16);
x_2_ps0 = linspace(0,50,16);
x_3_ps0 = linspace(-100,xif(3),16);
x_4_ps0 = linspace(10,xif(4),16);
x_5_ps0 = linspace(xi0(5),xif(5),16);
x_6_ps0 = linspace(xi0(6),xif(6),16);
u_1_ps0 = linspace(40,40,16);
u_2_ps0 = linspace(40,40,16);
u_3_ps0 = linspace(.034,.453,16)
init_gs_tf = 300;
ps_opt_var0 = [x_1_ps0'; x_2_ps0'; x_3_ps0';...
	x_4_ps0'; x_5_ps0'; x_6_ps0'; u_1_ps0'; u_2_ps0'; u_3_ps0'; init_gs_tf'];

%% Nonlinear program for pseudospectral optimization

use_f_gradient	= 'off';
use_c_gradient	= 'off';
constraint_tol  = 1e-4;
optim_tol		= 1e-4;
step_tol		= 1e-9	;
n_max_fun_evals = 1e6;
n_max_iter      = 1e4;

%----- State and input bounds

x_lower = zeros(ps_N+1,1);
y_lower = zeros(ps_N+1,1);
z_lower = -1000*ones(ps_N+1,1);
v_lower= .01*ones(ps_N+1,1);
gamma_lower= -deg2rad(10)*ones(ps_N+1,1);
psi_lower = -2*pi*ones(ps_N+1,1);
T_lower = -400*ones(ps_N+1,1);
L_lower = -400*ones(ps_N+1,1);
phi_lower =  -deg2rad(30)*ones(ps_N+1,1);

lower_bounds = [x_lower;...
                y_lower;...
                z_lower;...
                v_lower;...
                gamma_lower;...
                psi_lower;...
                T_lower;...
                L_lower;...
                phi_lower;
                0];	%=== INCOMPLETE


x_upper = 2000*ones(ps_N+1,1);
y_upper = 50*ones(ps_N+1,1);
z_upper = zeros(ps_N+1,1);
v_upper = 50*ones(ps_N+1,1);
gamma_upper= deg2rad(10)*ones(ps_N+1,1);
psi_upper = 2*pi*ones(ps_N+1,1);
T_upper = 400*ones(ps_N+1,1);
L_upper = 400*ones(ps_N+1,1);
phi_upper =  deg2rad(30)*ones(ps_N+1,1);

upper_bounds = [x_upper;...
                y_upper;...
                z_upper;...
                v_upper;...
                gamma_upper;...
                psi_upper;...
                T_upper;...
                L_upper;...
                phi_upper;
                inf];	%=== INCOMPLETE



%----- MATLAB R2016a or higher
solver_options	= optimoptions('fmincon', 'Display','final', 'Algorithm','sqp',...
	'GradObj',use_f_gradient, 'GradObj',use_c_gradient, ...
	'MaxIter',n_max_iter, 'MaxFunEvals',n_max_fun_evals, ...
	'OptimalityTolerance', optim_tol, 'TolCon',constraint_tol, 'TolX', step_tol);

%----- MATLAB R2016a or lower
% solver_options	= optimoptions('fmincon', 'Display','iter', 'Algorithm','sqp',...
% 	'GradObj',use_f_gradient, 'GradObj',use_c_gradient, ...
% 	'MaxIter',n_max_iter, 'MaxFunEvals',n_max_fun_evals, ...
% 	'TolCon',constraint_tol, 'TolX', step_tol);

% A = zeros(6,9*(ps_N+1)+1);
% b = zeros([6 1]);
% A(1,1) = 1
% A(2, (ps_N +1)+1) = 1;
% A(3, (ps_N +1)*2+1) = 1;
% A(4, (ps_N +1)-1) = 1;
% A(5, (ps_N +1)*2-1) = 1;
% A(6, (ps_N +1)*3-1) = 1;
% b(1:3) = xi0(1:3);
% b(4:6) = xif(4:6);

[ps_opt_var_calc, ~, exit_flag, ~] = ...
	fmincon( @calc_cost_1hop, ps_opt_var0, [], [], [], [], ...
	lower_bounds, upper_bounds, @calc_constraints_1hop, solver_options);
exit_flag
if any( exit_flag == [0 -1 -2 -3] )
	[tmp1, tmp2] = calc_constraints_1hop(ps_opt_var_calc);
    size(ps_opt_var_calc);
    size(upper_bounds);
	tmp3 = ps_opt_var_calc <= upper_bounds + constraint_tol;
	tmp4 = ps_opt_var_calc >= lower_bounds - constraint_tol;
	fprintf('Parameters \n');
	reshape(ps_opt_var_calc(1:end-1), ps_N + 1, 9)
	
	fprintf('Upper bounds \n')
	reshape(tmp3(1:end-1), ps_N + 1, 9)
	tmp3(end);
	
	fprintf('Lower bounds \n');
	reshape(tmp4(1:end-1), ps_N + 1, 9)
	tmp4(end)
	
	fprintf('Inequality \n')
	tmp1'	
	
	fprintf('Equality \n')
	reshape(tmp2(1:6*(ps_N + 1)), ps_N + 1, 6)
	(tmp2(6*(ps_N + 1) + 1:end))'
		
    exit_flag
	%error('Fatal error in trajectory generator');	
end

try_again = any(exit_flag == [2 3 4 5]);
n_attempts=	1;
while try_again && (n_attempts <= 7)
	ps_opt_var0 = ps_opt_var_calc;
	for m1 = 1:9    
		ps_opt_var0( ((ps_N + 1)*(m1 - 1) + 2):((ps_N + 1)*m1 - 1) ) = ...
			ps_opt_var0( ((ps_N + 1)*(m1 - 1) + 2):((ps_N + 1)*m1 - 1) ) + ...
			0.2*randn(ps_N - 1, 1);
	end
	[ps_opt_var_calc_new, ~, exit_flag, ~] = ...
		fmincon( @calc_cost_1hop, ps_opt_var0, [], [], [], [], ...
		lower_bounds, upper_bounds, @calc_constraints_1hop, solver_options);
	if exit_flag == 1, ps_opt_var_calc = ps_opt_var_calc_new; break; end
	try_again	= any(exit_flag == [2 3 4 5]);
	if try_again
		ps_opt_var_calc = ps_opt_var_calc_new;
	else
		try_again = true;
	end
	n_attempts = n_attempts + 1;
end

if any( exit_flag == [0 -1 -2 -3] )
%	error('Fatal error in trajectory generator');
end

%% Results

 disp('size ps_pst_var_calc')
 size(ps_opt_var_calc(1:end-1))
 disp(ps_N + 1)
 
ps_opt_xiu	= reshape( ps_opt_var_calc(1: end-1), [ps_N + 1, 9] );
xi_ps = ps_opt_xiu(:,1:6);
u_ps = ps_opt_xiu(:,7:end);
ps_opt_tf	= ps_opt_var_calc(end);


plot3(xi_ps(:,1),xi_ps(:,2),xi_ps(:,3)) 

%% Scale results to usual time

%% Results

results_1hop.cost	= calc_cost_1hop(ps_opt_var_calc);
results_1hop.energy = calc_energy_1hop(ps_opt_var_calc);
results_1hop.flag	= exit_flag;
results_1hop.xi_ps	= xi_ps; % RESULTANT TRAJECTORY (COEFFICIENTS a_k)
results_1hop.u_ps	= u_ps;		% RESULTANT CONTROL (COEFFICIENTS b_k)
results_1hop.tf_ps	= ps_opt_tf;




%% Cost and constraint functions

	%======================== COST FUNCTION ===============================
	function cost = calc_cost_1hop(ps_opt_var)
		m01 = 4; x_ps_4	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 7; u_ps_1	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 8; u_ps_2	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
% 		m01 = 9; u_ps_3	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		
		tf_ps	= ps_opt_var((ps_N + 1)*9 + 1);
        
        cost = 0.01*tf_ps + 0.5*tf_ps*calc_energy_1hop(ps_opt_var)'*w_ps;
% % % 		INCOMPLETE
		
	end

	%======================== ENERGY FUNCTION =============================
	function cost = calc_energy_1hop(ps_opt_var)
		m01 = 4; V	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 7; u_ps_1	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 8; u_ps_2	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		tf_ps	= ps_opt_var((ps_N + 1)*9 + 1);
        cost =  V.*sqrt( (u_ps_1*.5*tf_ps).^2 + (u_ps_2*.5*tf_ps).^2);
% % % 		INCOMPLETE
	end

	%======================== CONSTRAINT FUNCTION =========================
	function [c_inequality, c_equality] = calc_constraints_1hop(ps_opt_var)
		% define some things
        Fmax = 400;
        Emax = 415;
        m = 3;
        g = 9.81;
        S = .283;
        Cd = .05;
        
        %----- Unpack parameters for readibility
		m01 = 1; x_ps_1	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 2; x_ps_2	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 3; x_ps_3	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 4; x_ps_4	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 5; x_ps_5	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 6; x_ps_6	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 7; u_ps_1	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 8; u_ps_2	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 9; u_ps_3	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));

		tf_ps	= ps_opt_var((ps_N + 1)*9 + 1);
       %
		us76	= std_atmosphere(-x_ps_3 );
        
        D = 0.5*us76.rho'*(x_ps_4/tf_ps).^2*S*Cd;
        
		A1	= ps_D*x_ps_1(1:(ps_N+1))  - ...
			(tf_ps/2)*( x_ps_4.*cos(x_ps_5).*cos(x_ps_6)  ); %% EXAMPLE
		
        A2	= ps_D*x_ps_2(1:(ps_N+1)) - ...
			(tf_ps/2)*( x_ps_4.*sin(x_ps_5).*cos(x_ps_6)  ); 
		
		A3	= ps_D*x_ps_3(1:(ps_N+1)) - ...
			(tf_ps/2)*( -x_ps_4'*sin(x_ps_6) ) ;
        
        A4	= ps_D*x_ps_4(1:(ps_N+1))  - ...
			(tf_ps/2)*( u_ps_1 - D - m*g*sin(x_ps_6))/m ;
        
        A5	= ps_D*x_ps_5(1:(ps_N+1))  - ...
			(tf_ps/2)*( u_ps_1'*sin(u_ps_3)*inv( m*x_ps_4'*cos(x_ps_6) ));
        
        A6	= ps_D*x_ps_6(1:(ps_N+1)) - ...
			  (tf_ps/2)*( (u_ps_2).*cos(u_ps_3) - m*g*cos(x_ps_6) )./(m*x_ps_4);
        
         A7  = 2000 - x_ps_1(end);
         A8  = 50 - x_ps_2(end);
         A9  = x_ps_1(1);
         A10 = x_ps_2(1);
         A11 = x_ps_3(1) + 100;
         A12 = x_ps_4(1) - 10;
         
         
         
         
% % % % 		INCOMPLETE
		
        c1 = sqrt(u_ps_1.^2+u_ps_2.^2)-400;
        c2 = calc_energy_1hop(ps_opt_var) - 415*1000; 
         
		
		c_inequality= [c1;c2];	%=== INCOMPLETE
		c_equality	= [A1;A2;A3;A4;A5;A6;A7;A8;A9;A10;A11;A12]	;	%==== INCOMPLETE
		
		if any(~isreal(c_equality)) || any(~isreal(c_inequality))
			error('Complex constraints; something terrible happened.');
		end
	end
end