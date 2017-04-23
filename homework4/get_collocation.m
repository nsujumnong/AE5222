function lgl_colloc = get_collocation(ps_N)

if (mod(ps_N, 2) == 0)		% even number
	ps_K= ps_N / 2;
else
	ps_K= (ps_N - 1)/2;
end

t_guess_array	= -1:2/(ps_N*2):1;
tm_calc		= zeros(1,numel(t_guess_array));

n_t_ps_grid = 200;
t_ps_grid	= -1;
tm_idx_grid = 1;
for m1 = 1:numel(tm_calc)
    tm_calc(1, m1) = round(fzero(@legendre_poly_dot, t_guess_array(m1)), 5);
end
lgl_colloc.tk	= unique(tm_calc,'stable');
tm				= [-1,lgl_colloc.tk,1];
lgl_colloc.tm	= tm;
lgl_colloc.LN_tm= legendre_poly(tm);

dt_ps	= ( tm(2) - tm(1) ) / n_t_ps_grid;

for ell = 0:(ps_N - 1)
	t_ps_grid	= [t_ps_grid; ...
		( (tm(ell + 1) + dt_ps):dt_ps:(tm(ell + 2) - dt_ps) )'; tm(ell + 2)];
	tm_idx_grid = [tm_idx_grid; numel(t_ps_grid)];
end



if ( numel(lgl_colloc.tm) ~= ps_N+1 )
    error('Error in calculating collocation points.')
end

ps_D = zeros(ps_N + 1);
for m = 1:(ps_N + 1)
    for l = 1:(ps_N + 1)
        if m == l
            ps_D(m,l) = 0;
        else
            ps_D(m,l) = ( legendre_poly(tm(m)) / legendre_poly(tm(l)) ) * ...
				(1/(tm(m) - tm(l)));
        end
    end
end
ps_D(1,1)			= -ps_N*(ps_N+1)/4;
ps_D(ps_N+1,ps_N+1) = ps_N*(ps_N+1)/4;
lgl_colloc.D	= ps_D;
lgl_colloc.t_grid	= t_ps_grid;
lgl_colloc.tm_idx	= tm_idx_grid;
lgl_colloc.phi_l	= zeros(numel(t_ps_grid), ps_N + 1);
% lgl_colloc.phi_l	= zeros(numel(tm), ps_N + 1);
for ell = 0:ps_N
	lgl_colloc.phi_l(:, (ell + 1)) = lagrange_poly(ell);
	lgl_colloc.phi_l(tm_idx_grid, (ell + 1))			= 0;
	lgl_colloc.phi_l(tm_idx_grid(ell + 1), (ell + 1))	= 1;
end


	function ln_dot = legendre_poly_dot(t)
		ln_dot	= zeros(size(t));
		for k1 = 0:(ps_K - 1)
			ln_dot = ln_dot + ( ((-1)^k1 * factorial(2*ps_N - 2*k1) * (ps_N - 2*k1)) / ...
				(2^ps_N * factorial(k1) * factorial(ps_N - k1) * ...
				factorial(ps_N - 2*k1)) ) * t.^(ps_N - 2*k1 - 1);
		end
		if (mod(ps_N, 2) ~= 0)		% odd number
			k1	= ps_K;
			ln_dot = ln_dot + ( ((-1)^k1 * factorial(2*ps_N - 2*k1) * (ps_N - 2*k1)) / ...
				(2^ps_N * factorial(k1) * factorial(ps_N - k1) * ...
				factorial(ps_N - 2*k1)) ) * t.^(ps_N - 2*k1 - 1);
		end
		
		
% 		if ps_N == 1
% 			ln_dot = (1/(2^ps_N*factorial(ps_N)))*(2);
% 		elseif ps_N == 2
% 			ln_dot = (1/(2^ps_N*factorial(ps_N)))*(24*t);
% 		elseif ps_N == 3
% 			ln_dot = (1/(2^ps_N*factorial(ps_N)))*(360*t.^2 - 72);
% 		elseif ps_N == 4
% 			ln_dot = (1/(2^ps_N*factorial(ps_N)))*(2880*t.*(t.^2 - 1) + 3840*t.^3);
% 		elseif ps_N == 5
% 			ln_dot = (1/(2^ps_N*factorial(ps_N)))*(86400*t.^2*(t.^2 - 1) ...
% 				+ 7200*(t.^2 - 1).^2 + 57600*t.^4);
% 		elseif ps_N == 6
% 			ln_dot = (1/(2^ps_N*factorial(ps_N)))*(604800*t.*(t.^2 - 1).^2 ...
% 				+ 2419200*t.^3.*(t.^2 - 1) + 967680*t.^5);
% 		elseif ps_N == 7
% 			ln_dot = (1/(2^ps_N*factorial(ps_N)))*(67737600*t.^4.*(t.^2 - 1) + ...
% 				1411200*(t.^2 - 1).^3 + 33868800*t.^2.*(t.^2 - 1).^2 + 18063360*t.^6);
% 		elseif ps_N == 8
% 			ln_dot = (1/(2^ps_N*factorial(ps_N)))*(203212800*t.*(t.^2 - 1).^3 + ...
% 				1950842880*t.^5.*(t.^2 - 1) + 1625702400*t.^3.*(t.^2 - 1).^2 + 371589120*t.^7);
% 		elseif ps_N == 9
% 			ln_dot = (1/(2^ps_N*factorial(ps_N))).*(58525286400*t.^6.*(t.^2 - 1) + ...
% 				457228800*(t.^2 - 1).^4 + 18289152000*t.^2.*(t.^2 - 1).^3 + ...
% 				73156608000*t.^4.*(t.^2 - 1).^2 + 8360755200*t.^8);
% 		elseif ps_N == 10
% 			ln_dot = (1/(2^ps_N*factorial(ps_N)))*(100590336000*t.*(t.^2 - 1).^4 + ...
% 				1839366144000*t.^7.*(t.^2 - 1) + 1341204480000*t.^3.*(t.^2 - 1).^3 + ...
% 				3218890752000*t.^5.*(t.^2 - 1).^2 + 204374016000*t.^9);
% 		else
% 			error('N value not calculated in LN_dot function')
% 		end
	end

	function ln = legendre_poly(t)
		ln	= zeros(size(t));
		for k1 = 0:ps_K
			ln = ln + ( ((-1)^k1 * factorial(2*ps_N - 2*k1)) / ...
				(2^ps_N * factorial(k1) * factorial(ps_N - k1) * ...
				factorial(ps_N - 2*k1)) ) * t.^(ps_N - 2*k1);
		end
		
% 		if ps_N == 1
% 			ln = (1/(2^ps_N*factorial(ps_N)))*(2*t);
% 		elseif ps_N == 2
% 			ln = (1/(2^ps_N*factorial(ps_N)))*(12*t.^2 - 4);
% 		elseif ps_N == 3
% 			ln = (1/(2^ps_N*factorial(ps_N)))*(72*t.*(t.^2 - 1) + 48*t.^3);
% 		elseif ps_N == 4
% 			ln = (1/(2^ps_N*factorial(ps_N)))*(1152*t.^2.*(t.^2 - 1) + ...
% 				144*(t.^2 - 1).^2 + 384*t.^4);
% 		elseif ps_N == 5
% 			ln = (1/(2^ps_N*factorial(ps_N)))*(7200*t.*(t.^2 - 1).^2 + ...
% 				19200*t.^3.*(t.^2 - 1) + 3840*t.^5);
% 		elseif ps_N == 6
% 			ln = (1/(2^ps_N*factorial(ps_N)))*(345600*t.^4.*(t.^2 - 1) + ...
% 				14400*(t.^2 - 1).^3 + 259200*t.^2.*(t.^2 - 1).^2 + 46080*t.^6);
% 		elseif ps_N == 7
% 			ln = (1/(2^ps_N*factorial(ps_N)))*(1411200*t.*(t.^2 - 1).^3 + ...
% 				6773760*t.^5.*(t.^2 - 1) + 8467200*t.^3.*(t.^2 - 1).^2 + 645120*t.^7);
% 		elseif ps_N == 8
% 			ln = (1/(2^ps_N*factorial(ps_N)))*(144506880*t.^6.*(t.^2 - 1) + ...
% 				2822400*(t.^2 - 1).^4 + 90316800*t.^2.*(t.^2 - 1).^3 + ...
% 				270950400*t.^4.*(t.^2 - 1).^2 + 10321920*t.^8);
% 		elseif ps_N == 9
% 			ln = (1/(2^ps_N*factorial(ps_N)))*(457228800*t.*(t.^2 - 1).^4 + ...
% 				3344302080*t.^7.*(t.^2 - 1) + 4877107200*t.^3.*(t.^2 - 1).^3 + ...
% 				8778792960*t.^5.*(t.^2 - 1).^2 + 185794560*t.^9);
% 		elseif ps_N == 10
% 			ln = (1/(2^ps_N*factorial(ps_N)))*(83607552000*t.^8.*(t.^2 - 1) + ...
% 				914457600*(t.^2 - 1).^5 + 45722880000*t.^2.*(t.^2 - 1).^4 + ...
% 				243855360000*t.^4.*(t.^2 - 1).^3 + 292626432000*t.^6.*(t.^2 - 1).^2 + ...
% 				3715891200*t.^10);
% 		else
% 			error('N value not calculated in LN_dot function')
% 		end
	end

	function phi = lagrange_poly(ell)
		phi = ( 1/( ps_N * (ps_N + 1) *  legendre_poly(tm(ell + 1)) ) ) * ...
			( ((t_ps_grid.^2-1).*legendre_poly_dot(t_ps_grid)) ./ ...
			(t_ps_grid - tm(ell + 1)) );
	end

end
