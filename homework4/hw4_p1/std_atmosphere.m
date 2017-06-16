function us76 = std_atmosphere(altitude)
% Works in SI units; valid for altitude less than 11km

if (altitude > 11e3)
	error('This model is valid only for altitudes less than 11km');
end

temp_sl		= 288.16;		% K
rho_sl		= 1.225;		% kg/m^3
pressure_sl	= 1.01325e5;	% Pa = N/m^2

%----- Constants
g	= 9.8;			% m/s^2, gravitational acceleration
R	= 287;			% 
a_1	= -6.5e-3;		% K/m, temperature gradient below 11km

temperature = temp_sl + a_1.*altitude;
tmp1	= temperature ./ temp_sl;
tmp2	= g/(a_1*R);

density		= rho_sl .* (tmp1.^(-1 - tmp2 ));
pressure	= pressure_sl .* (tmp1.^(-tmp2));

us76.g		= g;
us76.T		= temperature;
us76.P		= pressure;
us76.rho	= density;

%------ Technically, this is not part of the standard atmosphere model, but
% convenient code-wise to define wind conditions here
us76.wind	= [3; 0]; 