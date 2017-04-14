clear all
clc
options = odeset('Events',@stop2);  
final = []
count = 0
t= []
y = []
te= []
ye = []
ie = []
for ii=0:.001:0.5*pi
    
    y0 = [ -1 -1 ii]
    tspan = [0 100]
    [t,y,te,ye,ie]  = ode45(@EQ,tspan,y0,options);
    %plot(y(:,1),y(:,2))
    if ~isempty(te)
        count = count +1;
        final(count,:) = [te,ye];
    end
end   

%{
final =

   34.8243    0.9000    0.9543    0.1358
   31.4679    0.9000    0.9056    0.5662
   28.2042    0.9000    1.0287    0.9853

%}

%%



