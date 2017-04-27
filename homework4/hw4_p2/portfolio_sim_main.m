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
Emulation of an investment portfolio over a period of 30 years.
%}
% 
% clear all; close all; clc;
% format short

%% Asset data
asset_data.n_assets = 5;
asset_data.riskless_rate= 1.01;
asset_data.mean_return	= [0.02 0.03 0.05 0.05 0.01];
asset_data.var_return	= [0.005 0.01 0.05 0.1 0.4].^2;


%% Simulation of net worth

net_worth_k		= 1;
portfolio		= zeros(30, asset_data.n_assets + 1);
net_worth		= zeros(30, 1);
asset_returns	= zeros(30, asset_data.n_assets);
for m1 = 1:30
	[net_worth_k, asset_returns_k, portfolio_k] = ...
		returns_of_the_year(net_worth_k, @investment_policy_test, asset_data);
	asset_returns(m1, :)= asset_returns_k;
	net_worth(m1)		= net_worth_k;
	portfolio(m1, :)	= portfolio_k;
end
%{
fprintf('\n =================================== \n  Final net worth: $ %4.2f M.', net_worth_k)
fprintf('\n  Final net worth adjusted for inflation of 1: $%4.2f M \n', net_worth_k/ (1.02^30) );
fprintf('\n =================================== \n\n');
%}

% fprintf('Asset return rates (percentage points).\n')
% disp( (asset_returns - 1).*100)

%{
figure;
for m1 = 1:asset_data.n_assets
	plot(1:30, (asset_returns(:, m1) - 1)*100); hold on; grid on;
end


figure;
for m1 = 1:asset_data.n_assets + 1
	plot(1:30, portfolio(:, m1)); hold on; grid on;
end
plot(1:30, net_worth, 'LineWidth', 3)
%}