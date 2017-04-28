function expected = expt_calc(x_N,u,returns_of_the_year)
    % For risk-neutral plan
    % x_N == final net worth
    % u == investments
    x = u*1;
    [net_worth_next, ~, ~] = ...
	returns_of_the_year(net_worth_current, @investment_policy, asset_data);
    N = length(x_N);
    J_mat = zeros(30,N);
    for i = N:1:1
        J_mat(30,i) = x_N(N);
        for j = 29:1:1
            J_mat(j,i) = J_mat(j+1,i) ;
        end
    end
    expected = 1;
        
end