 function dydt = EQ( t,y )
%EQ Summary of this function goes here
%   Detailed explanation goes here
    V = .1;
    xdot = V*cos(y(3));
    ydot = V*sin(y(3));
    %phidot = ( getDxy(y(1),y(2))*[xdot;ydot]*cos(y(3)) - V*getDx(y(1),y(2)))/(getTreat(y(1),y(2))*sin(y(3))); 
    %phidot = ( -V*getDx(y(1),y(2)))/(getTreat(y(1),y(2))*sin(y(3))); 
     phidot = inv( getTreat(y(1),y(2))*( cos(y(3))+sin(y(3))   ))*...
                 (getDxy(y(1),y(2))*[xdot;ydot]*(cos(y(3))-sin(y(3)))...
                 -V*(getDx(y(1),y(2)) - getDy(y(1),y(2))  )  );   
    dydt = [xdot;ydot;phidot];
end

