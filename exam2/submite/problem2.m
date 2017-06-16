
A = [ 0, 1; 0, 0]
B = [0;1]
Q = [1, 2;3 4]
R = 1
x_temp = [5; 2]
p = []
x = []
u = []

S_k = Q
for ii = 1:5
    S_K = transpose(A)*inv( inv(S_k) + B*inv(R)*transpose(B) )*A + Q

    p_temp = S_k*x_temp
    u_temp = -transpose(B)*p_temp
    x_temp = A*x_temp+B*u_temp

    p(:,ii) = (p_temp)
    u(:,ii) = (u_temp)
    x(:,ii) = (x_temp)
end



