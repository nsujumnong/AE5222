clear all
clc
options = odeset('Events',@stop2);  
final2 = []
count2 = 0
t2= []
y2 = []
te2= []
ye2 = []
ie2 = []
for ii2=0:.001:0.5*pi
    
    y02 = [ -1 -1 ii2]
    tspan2 = [0 100]
    [t2,y2,te2,ye2,ie2]  = ode45(@EQ,tspan2,y02,options);
    %plot(y(:,1),y(:,2))
    if ~isempty(te2)
        count2 = count2 +1;
        final2(count2,:) = [te2,ye2];
    end
end   

%%



