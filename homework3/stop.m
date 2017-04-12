function[value, isterminal, direction] = stop( t,y )
%STOP Summary of this function goes here
%   Detailed explanation goes here
value = double( (1 - y(1))<10e-4 && (1 - y(2))<10e-4 )
isterminal = 1;  % Halt integration 
direction = 0;   % The zero can be approached from either direction

end

