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



%% set up initial conditions
SCALE = quadrotor_model_parameters.scale_posn

% initial state
xi0 = [ 0;...
        0;...
         -initial_state.altitude / SCALE;...
         initial_state.airspeed / SCALE; ...
         0;...
         0;]
       
     
xif = [ 1;...
        0;...
        -final_state.altitude / SCALE;...
        final_state.altitude / SCALE; ... ...
        0;...
        0;]

xi0
%% DESIRED INITIAL GUESS
x_1_ps0 = linspace(xi0(1),xif(1),16);
x_2_ps0 = linspace(xi0(2),xif(2),16);
x_3_ps0 = linspace(xi0(3),xif(3),16);
x_4_ps0 = linspace(xi0(4),xif(4),16);
x_5_ps0 = linspace(xi0(5),xif(5),16);
x_6_ps0 = linspace(xi0(6),xif(6),16);
u_1_ps0 =  zeros( 1,ps_N+1);
u_2_ps0 = (3 * 9.81) / SCALE * ones(1,16);   
u_3_ps0 = .29*ones(1,ps_N+1);  
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
z_lower = -1000/SCALE*ones(ps_N+1,1);
v_lower= .0001*ones(ps_N+1,1);
gamma_lower= -deg2rad(10)*ones(ps_N+1,1);
psi_lower = -2*pi*ones(ps_N+1,1);
T_lower = zeros(ps_N+1,1);
L_lower = zeros(ps_N+1,1);
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

%% Bounds
x_upper = inf*ones(ps_N+1,1);
y_upper = inf*ones(ps_N+1,1);
z_upper = zeros(ps_N+1,1);
v_upper = (50/SCALE)*ones(ps_N+1,1);
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


%% 
%----- MATLAB R2016a or higher
solver_options	= optimoptions('fmincon', 'Display','final', 'Algorithm','sqp',...
	'GradObj',use_f_gradient, 'GradObj',use_c_gradient, ...
	'MaxIter',n_max_iter, 'MaxFunEvals',n_max_fun_evals, ...
	'OptimalityTolerance', optim_tol, 'TolCon',constraint_tol, 'TolX', step_tol);


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
hold on 
figure(1)
plot(xi_ps(:,1)*SCALE)
figure(2)
plot(xi_ps(:,2)*SCALE)
figure(3)
plot(xi_ps(:,3)*SCALE) 
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
      
        cost = 0.01*tf_ps + 0.5*tf_ps*calc_energy_1hop(ps_opt_var);
	end

	%======================== ENERGY FUNCTION =============================
	function cost = calc_energy_1hop(ps_opt_var)
		m01 = 4; V	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 7; u_ps_1	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 8; u_ps_2	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		
        cost =  (V.*sqrt( (u_ps_1).^2 + (u_ps_2).^2))'*w_ps;
	end

	%======================== CONSTRAINT FUNCTION =========================
	function [c_inequality, c_equality] = calc_constraints_1hop(ps_opt_var)
		% define some things
        Fmax = 400;
        Emax = 415*10000;
        m    = 3;
        g    = 9.81;
        S    = .283;
        Cd   = .05;
        
        %----- Unpack parameters for readibility
		m01 = 1; x      = ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 2; y      = ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 3; z      = ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 4; v      = ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 5; psi	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 6; gamma	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 7; T      = ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 8; L      = ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));
		m01 = 9; phi	= ps_opt_var(((ps_N + 1)*(m01 - 1) + 1):((ps_N + 1)*m01));

		tf_ps	= ps_opt_var((ps_N + 1)*9 + 1);
		us76	= std_atmosphere(-z*SCALE );
        D       = 0.5*us76.rho'*(v).^2*S*Cd*SCALE;
        
        %% Equality constraints
		A1	= ps_D*x(1:(ps_N+1))  - ...
                (tf_ps/2)*( v.*cos(psi).*cos(gamma)  ); 
		
        A2	= ps_D*y(1:(ps_N+1)) - ...
                (tf_ps/2)*( v.*sin(psi).*cos(gamma)  ); 
		
		A3	= ps_D*z(1:(ps_N+1)) - ...
                (tf_ps/2)*( -v'*sin(gamma) ) ;
        
        A4	= ps_D*v(1:(ps_N+1))  - ...
                (tf_ps/2)*( T - D - m*g*sin(gamma))/(m*SCALE) ;
        
        A5	= ps_D*psi(1:(ps_N+1))  - ...
                (tf_ps/2)*( T'*sin(phi)*inv( m*v'*cos(gamma) ));
        
        A6	= ps_D*gamma(1:(ps_N+1)) - ...
                (tf_ps/2)*( (L).*cos(phi) - m*g*cos(gamma) )./(m*v*SCALE);
        
        A7  = xif(1) - x(end);  % x end condition
        A8  = xif(2) - y(end); % y end condition
        A9  = x(1); % x start conditions
        A10 = y(1); % y start conditions
        A11 = z(1) + xi0(3); % z start conditions
        A12 = v(1) - xi0(4); % v start condition
         
        c1 = sqrt(T.^2+L.^2)- Fmax/ SCALE;
        c2 = calc_energy_1hop(ps_opt_var) - Emax/ SCALE^2; 
         
		c_inequality= [c1;c2];	%=== INCOMPLETE
		c_equality	= [A1;A2;A3;A4;A5;A6;A7;A8;A9;A10;A11;A12]	;	%==== INCOMPLETE
		
		if any(~isreal(c_equality)) || any(~isreal(c_inequality))
			error('Complex constraints; something terrible happened.');
		end
	end
end
