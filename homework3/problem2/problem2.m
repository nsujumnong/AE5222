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
%%
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
%%
% for final [time, x,y,psi(tf)]
%% plot the threat field
%load the threat field
load('threatvaluetrue.mat');
%reshape it to 125x125
threat_field2=zeros(125,125);
for i = 1:125 
    for j = 1:125
        threat_field2(i,j)=threat_value_true(j+125*(i-1));
    end
end
x1=-1:1/62.5:1-1/62.5;
x2=-1:1/62.5:1-1/62.5;
contourf(x1,x2,threat_field2)
xlabel('x'),ylabel('y')
title('Threat field: Problem2')
hold on
%%
%     Final
%     [32.6968    0.6902    0.9192    0.2096    0.6570
%     29.6288    0.7457    0.8055    0.5874    0.6580
%     29.5741    1.0000    1.0825    1.0173    0.7150
%     26.2831    0.8661    0.7092    0.8896    0.7160
%     27.3359    0.8207    0.7348    0.1140    0.7220];
final2_sub = [];
y02_sub = [ -1 -1 0.7150];
tspan2 = [0  29.5]
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
plot(x2_final,y2_final,'r')
% plot heading angles
figure
plot(t2_sub,y2_sub(:,3))
xlabel('time')
ylabel('heading angles \psi (rad)')
title('plotting of \psi')


