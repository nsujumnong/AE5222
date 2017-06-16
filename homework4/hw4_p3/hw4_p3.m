clear all; close all; clc
load learjet24_lin.mat

t_step = 0.1;
A	= expm(A_long * t_step);
B	= ( A_long \ (A - eye(4)) )*B_long ;
C = eye(4);
D = [0];
Q	= 0.01*eye(4);
R	= 0.1*eye(2);

V	= diag([5 1 0.1 0.1])
W	= diag([5 1 0.1 0.1])
G = eye(4);
H = [0];

sys = ss(A,B,C,D)
sysKalman = ss(A,[B G],C,[])

[K,S,E] = dlqr(A,B,Q,R);

sys2 = kalman(sysKalman ,V,W,[]);

F = lqgreg(sysKalman,K);
 
clsys = feedback(sys,F,+1);
step(sysKalman,'r--',clsys,'b-',10)


