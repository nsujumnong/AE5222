function [ x,P ] = Kalman( x,u, P )
%KALMAN Summary of this function goes here
%   Detailed explanation goes here
    t_step = 0.1;
    A	= expm(A_long * t_step);
    B	= ( A_long \ (A - eye(4)) )*B_long ;
    Q	= 0.01*eye(4);
    R	= 0.1*eye(2);
    V	= diag([5 1 0.1 0.1]);
    W	= diag([5 1 0.1 0.1]);
    C = eye(4);
    
    x_new = A*x+B*u;
    P_temp = A*P*A' + R;
    K = P_temp*C'*inv(C*P_temp*C' + Q); 
    x = x_new + k*(z - C*x_new);
    P = ( eye(4) - K*C)*P_temp;
    
end

