function J_expt = expected_calc(x_N,u,investment_policy)
    net_worth_current = x_N;
    % Asset data
    asset_data.n_assets = 5;
    asset_data.riskless_rate= 1.01;
    asset_data.mean_return	= [0.02 0.03 0.05 0.05 0.01];
    asset_data.var_return	= [0.005 0.01 0.05 0.1 0.4].^2;
    
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
    
    investments = investment_policy(net_worth_current, asset_data);
    asset_rates_of_return = zeros(1, asset_data.n_assets);
    % All assets assumed Gaussian with given mean and variance
    for m1 = 1:asset_data.n_assets
        asset_rates_of_return(m1) = 1 + (asset_data.mean_return(m1) + sqrt( asset_data.var_return(m1) )*randn );
    end

    net_worth_next	= asset_rates_of_return * investments + asset_data.riskless_rate * (net_worth_current - sum(investments));
    net_worth_previous = (net_worth_current - asset_rates_of_return * investments)/asset_data.riskless_rate + sum(investments);
    
    
end