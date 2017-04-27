%{
Copyright (c) 2017 Raghvendra V. Cowlagi. All rights reserved.

Copyright notice: 
=================
No part of this work may be reproduced without the written permission of
the copyright holder, except for non-profit and educational purposes under
the provisions of Title 17, USC Section 107 of the United States Copyright
Act of 1976. Reproduction of this work for commercial use is a violation of
copyright.


Disclaimer:
===========
This software program is intended for educational and research purposes.
The author and the institution with which the author is affiliated are not
liable for damages resulting the application of this program, or any
section thereof, which may be attributed to any errors that may exist in
this program.


Author information:
===================
Raghvendra V. Cowlagi, Ph.D,
Assistant Professor, Aerospace Engineering Program,
Department of Mechanical Engineering, Worcester Polytechnic Institute.
 
Higgins Laboratories, 247,
100 Institute Road, Worcester, MA 01609.
Phone: +1-508-831-6405
Email: rvcowlagi@wpi.edu
Website: http://www.wpi.edu/~rvcowlagi

The author welcomes questions, comments, suggestions for improvements, and
reports of errors in this program.


Program description:
====================
Emulation of an investment portfolio: calculate annual returns.
%}

function [net_worth_next, asset_rates_of_return, portfolio] = ...
	returns_of_the_year(net_worth_current, investment_policy, asset_data)

investments = investment_policy(net_worth_current, asset_data);
%%
% This part basically rearrange investments and catch errors 
if (size(investments, 1) ~= 1) && (size(investments, 2) ~= 1)
	error('Investment policy function must return a row or column vector.')
end

if (size(investments, 1) == 1)
	investments = investments';
end

if numel(investments) > asset_data.n_assets
	fprintf('\n Invalid investment: number of investments greater than number of assets.\n');
	fprintf('\n Ignoring all investments beyond #%i.\n', asset_data.n_assets);
	
	investments = investments(1:asset_data.n_assets);
end

if sum(investments) - net_worth_current > 1e-6
	fprintf('\n Policy tried to invest more than current net worth. \n');
	fprintf('Investments scaled accordingly; zero investment in riskless asset.\n');
	
	investments	= investments * net_worth_current / sum(investments);
end

if numel(investments) < asset_data.n_assets
	fprintf('\n Policy did not specify investments in assets # %i through %i; assumed zero.\n', ...
		numel(investments) + 1, asset_data.n_assets);
end
%%
% This is where the rate of return is calculated
asset_rates_of_return = zeros(1, asset_data.n_assets);
% All assets assumed Gaussian with given mean and variance
for m1 = 1:asset_data.n_assets
	asset_rates_of_return(m1) = 1 + ( ...
		asset_data.mean_return(m1) + sqrt( asset_data.var_return(m1) )*randn );
end
%calculate the next net worth
net_worth_next	= asset_rates_of_return * investments + ...
	asset_data.riskless_rate * (net_worth_current - sum(investments));

portfolio		= [investments' (net_worth_current - sum(investments))];
