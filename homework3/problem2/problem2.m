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
for ii2=0:.001:0.5*pi %ii == heading angle of starting position
    
    y02 = [ -1 -1 ii2]
    tspan2 = [0 100]
    [t2,y2,te2,ye2,ie2]  = ode45(@EQ,tspan2,y02,options);
    %plot(y(:,1),y(:,2))
    if ~isempty(te2)
        count2 = count2 +1;
        final2(count2,:) = [te2,ye2,ii2];
    end
end   
% for final [time, x,y,psi(tf)]
%% plot the threat field
threat_field2 = [3.0674    3.3055    3.0505; ...
                 3.0143    3.8205    3.2260; ...
                 3.0811    3.6606    2.9861];
x1 = -1:1;
x2 = -1:1;

contour(X1,X2,threat_field2)
hold on
%%
%     Final
%     [32.6968    0.6902    0.9192    0.2096    0.6570
%     29.6288    0.7457    0.8055    0.5874    0.6580
%     29.5741    1.0000    1.0825    1.0173    0.7150
%     26.2831    0.8661    0.7092    0.8896    0.7160
%     27.3359    0.8207    0.7348    0.1140    0.7220];
final2_sub = [];
y02_sub = [ -1 -1 0.7220];
tspan2 = [0 100]
[t2_sub,y2_sub,te2_sub,ye2_sub,ie2_sub]  = ode45(@EQ,tspan2,y02_sub,options);
    %plot(y(:,1),y(:,2))
%     if ~isempty(te2_sub)
%         count2 = count2 +1;
%         final2_sub(count2,:) = [te2_sub,ye2_sub];
%     end

%%
% plot the path
x2_final = y2_sub(:,1);
y2_final = y2_sub(:,2);
plot(x2_final,y2_final)



