function headings = necessary(threat_value_true)
    syms p1 p2 
    psi = syms()
    %assign coordinate to each threat value
    N = sqrt(length(threat_value_true));
    x = zeros(N,N);
    for i = 1:N
        for j = 1:N
            x(i,j)=threat_value_true(j+5*(i-1));
        end
    end
    
end