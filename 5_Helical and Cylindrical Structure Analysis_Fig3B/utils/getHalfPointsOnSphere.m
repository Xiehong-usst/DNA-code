function [X, Y, Z] = getHalfPointsOnSphere(O, R_sphere, theta_res, phi_res)
[X, Y, Z, theta_list, phi_list] = generatePointsOnSphere(O, R_sphere, theta_res, phi_res);
nx = numel(X);
X = reshape(X,[1,nx]);
Y = reshape(Y,[1,nx]);
Z = reshape(Z,[1,nx]);
nz = find(Z >= O(3));
X = X(nz);
Y = Y(nz);
Z = Z(nz);