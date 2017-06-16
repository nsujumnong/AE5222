clear all

syms v h t pho C S beta pDpv pDpv2 pDph f g m c

D = 0.5*pho*C*S*(v^2)*exp(-beta*h);
vdot = ( f - D)/m  - g;
hdot = v;
mdot = -f/c;

pDpv = diff(D,v);
pDpv2 = diff(D,v,2);
pDph = diff(D,h);
pDphpv = diff(pDph,v);
%%
eq(1) = pDpv*vdot + pDph*hdot;

eq(2) = mdot*g;

eq(3) = vdot*(pDpv + D/c);

eq(4) = v*(pDpv2*vdot + pDphpv*hdot) ;

eq(5) = (v/c)*(pDpv*vdot + pDph*hdot);



Hdot = sum(eq)
Hdot = subs(Hdot,0.5*pho*C*S*(v^2)*exp(-beta*h),D)
solve(Hdot==0,f)

 
