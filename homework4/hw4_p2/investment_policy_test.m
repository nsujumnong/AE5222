function investments = investment_policy_test(net_worth_current,asset_data)
    %proportionally invest in the first three assets based on the mean return rate 
%     sum_return = sum(asset_data.mean_return(1:3));
    investments = zeros(asset_data.n_assets,1);
    investments(1)=net_worth_current*.2;
    investments(2)=net_worth_current*.2;
    investments(3)=net_worth_current*.25;
    investments(4)=net_worth_current*.3;
    investments(5)=net_worth_current*0.05;
    
end