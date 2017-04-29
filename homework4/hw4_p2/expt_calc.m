function [J_mat,u_1,u_2,u_3,u_4,u_5] = expt_calc(x_N,u,investment_policy)
    % For risk-neutral plan
    % x_N == final net worth
    % u == investments

    investments = investment_policy(net_worth_current,asset_data);
    
    net_worth_next	= asset_rates_of_return * investments + ...
	asset_data.riskless_rate * (net_worth_current - sum(investments));
    N = length(x_N);
    J_mat = zeros(30,N);
    u_1 = zeros(30,N);
    u_2 = zeros(30,N);
    u_3 = zeros(30,N);
    u_4 = zeros(30,N);
    u_5 = zeros(30,N);
    %start the matrix J with each expected x
    for i = 1:N
       J_mat(30,i) = x_N(i) ;
    end
    
    for i = N:-1:1
        for j = 29:-1:1 
            J_mat(j,i) = J_mat(j+1,i);
        end
    end
   
end