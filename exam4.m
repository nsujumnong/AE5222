
syms r a x0 x1 x2 T u0 u1 J1 J2 J0


x1 = (1 - a)*x0 + a*u0;
x2 = (1 - a)*x1 + a*u1;

J2 = r*(x2 - T)^2;
J1 = (u1^2 + J2);
J0 =  (u0^2 + J1)
du1 = diff(J0,u1);
du0 = diff(J0,u0);
U = solve( du0==0,du1==0, [ u0, u1])

u0_star = U.u0
u1_star = U.u1

