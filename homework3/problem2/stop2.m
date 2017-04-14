function[value, isterminal, direction] = stop2( t,y )
%STOP Summary of this function goes here
%   Detailed explanation goes here
value = double(tan(y(3))-(y(2)-1)/(y(1)-1)<.1 && (y(1)-1)^2+(y(2)-1)^2-0.05^2<0.1)
isterminal = 1;  % Halt integration 
direction = 0;   % The zero can be approached from either direction

end

