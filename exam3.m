
tf = 10;
t = 1:1:10
v2 = 5;
v1 = 5;
g = 9.81;
x2 = 10
p3 = (tf - t) + (1/g)*(v2 + sqrt(v2 + 2*g*x2))  
p4 =v1*(tf-t)*( v2*v2 + 2*g*x2)^(-.5)+ (1/g)*( v1+v2*(v2*v2+2*g*x2)^(-.5))
plot(t,p3,t,p4)
%%

syms phi x2


c0 = -1/(1-x2*cos(phi))
c1 =  -(1 + c0*(cos(phi) - x2))/sin(phi)



angle = subs(c1/c0, x2, 1.86)
angle = solve(phi== atan(angle),phi,'PrincipalValue', true)

y0 = [ 


