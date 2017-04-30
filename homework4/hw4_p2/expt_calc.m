function [J_mat,u_1,u_2,u_3,u_4,u_5,pdf_n,pd] = expt_calc(x_N,u,investment_policy)
    % For risk-neutral plan
    % x_N == final net worth
    % u == investments
    net_worth_current = 1;
    %define asset_data
    asset_data.n_assets = 5;
    asset_data.riskless_rate= 1.01;
    asset_data.mean_return	= [0.02 0.03 0.05 0.05 0.01];
    asset_data.var_return	= [0.005 0.01 0.05 0.1 0.4].^2;
    
    investments = investment_policy(net_worth_current,asset_data);
    mu = asset_data.mean_return;
    sigma = (asset_data.var_return).^(1/2);
    pd = zeros(5,11);
    pdf_n = zeros(5,11);
    for n = 1:5
        pd(n,:) = [mu(n)-sigma(n)*5:sigma(n):mu(n)+sigma(n)*5];
        pdf_n(n,:)= pdf('Normal',pd(n,:),mu(n),sigma(n));
    end
    %scale the pdf
    pdf_n(1,:) = pdf_n(1,:)/2;
    pdf_n(3,:) = pdf_n(3,:)*5;
    pdf_n(4,:) = pdf_n(4,:)*10;
    pdf_n(5,:) = pdf_n(5,:)*40;
    % after the scaling, turns out the probability is the same 
    % (no idea why i bother doing that) -_-"
    P_n = zeros(1,)
    % This is where the rate of return is calculated
    asset_rates_of_return = zeros(1, asset_data.n_assets);
    % All assets assumed Gaussian with given mean and variance
    for m1 = 1:asset_data.n_assets
        asset_rates_of_return(m1) = 1 + ( ...
            asset_data.mean_return(m1) + sqrt( asset_data.var_return(m1) )*randn );
    end
    
    %calculate the next net worth
    net_worth_next = asset_rates_of_return * investments + ...
	asset_data.riskless_rate * (net_worth_current - sum(investments));

    % initialize the first J_mat with the final year (what!?)
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
        J_calc = 0;
        for j = 29:-1:1 
            for k = 1:11
                J_calc = J_calc + ((  J_mat(j+1,i))*pdf_n(k));
            end
            J_mat(j,i) = J_calc;
        end
    end
   
end