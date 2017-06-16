% Testing 
% This script runs the "portfolio_sim_main.m" repeatly and record the final
% net worth of each iteration for further comparison and conclusion
clear all; close all; clc;
%%
Fin_networth = zeros(100,1);
Fin_inflat_networth = zeros(100,1);
%%
for i = 1:100
   run('portfolio_sim_main')
   Fin_networth(i) = net_worth_k;
   Fin_inflat_networth(i) = net_worth_k/ (1.02^30);
end
max_networth = max(Fin_networth);