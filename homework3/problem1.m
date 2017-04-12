clear all
clc
options = odeset('Events',@stop);  

%%

y0 = [ -1 -1 (pi/4)]
tspan = [0 100]
[t,y] = ode45(@EQ,tspan,y0,options)
plot(y(:,1),y(:,2))
 
   