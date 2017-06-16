clear all
clc
options = odeset('Events',@stop);  
final = []
count = 0
t= []
y = []
te= []
ye = []
ie = []

%%
for ii=0:.00001:0.5*pi
    
    y0 = [ -1 -1 ii]
    tspan = [0 50]
    [t,y,te,ye,ie]  = ode45(@EQ,tspan,y0,options);
    %plot(y(:,1),y(:,2))
    if ~isempty(te)
        count = count +1;
        final(count,:) = [te,ye,ii];
    end
end   

%{
final =

   34.2970181	0.933097775	0.9	0.452611036	0.6537
34.82425612	0.9	0.954270647	0.13578923	0.657
33.65301829	1.044869976	0.9	0.620337565	0.6575
31.46788552	0.9	0.905565046	0.566235568	0.658
31.48157901	0.9	0.924469218	0.544902129	0.6581
31.48720056	0.9	0.942963286	0.528264246	0.6583
31.60976171	0.9	0.970641121	0.515395831	0.6584
28.96123538	0.925163505	0.9	1.31293598	0.6613
28.46334181	0.9	1.083667472	0.924877736	0.7131
28.43676283	0.9	1.078662258	0.931906624	0.7132
28.38756711	0.9	1.06820366	0.946619855	0.7134
28.36142876	0.9	1.062586218	0.953909601	0.7135
28.33280067	0.9	1.056349201	0.960846606	0.7136
28.30288029	0.9	1.049861278	0.967625457	0.7137
28.2680927	0.9	1.043144871	0.973172927	0.7138
28.20416231	0.9	1.028737738	0.985331	0.714
28.01803874	0.9	0.989805341	1.007277554	0.7144%USE THIS ONE
27.82789802	0.924535087	0.9	1.006736027	0.7154
28.06310827	0.948375277	0.9	0.991256244	0.7156
28.2037164	0.962176732	0.9	0.981596063	0.7157
29.11112235	0.9	0.943212888	0.094059039	0.7226
29.43723139	0.9	1.020726309	0.210075121	0.7227


%}

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
title('Threat field: Problem 1')
hold on

%% compute the path
final_sub = [];
y0_sub = [-1 -1 0.7144];
tspan = [0 28];
[t_sub,y_sub,te_sub,ye_sub,ie_sub] = ode45(@EQ,tspan,y0_sub,options);

%%
% plot the path
x_final = y_sub(:,1);
y_final = y_sub(:,2);
plot(x_final,y_final,'r')
%plot the heading angles
figure
plot(t_sub,y_sub(:,3))
xlabel('time')
ylabel('heading angles \psi (rad)')
title('plotting of \psi')


