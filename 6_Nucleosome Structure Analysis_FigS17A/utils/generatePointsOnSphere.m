function [X, Y, Z, Theta, Phi] = generatePointsOnSphere(O, R, numTheta, numPhi)
% generatePointsOnSphere is a function used to generate coordinates of points on a sphere

% Input:
% A vector of O-1x3, representing the coordinates of the center of the sphere
% R - scalar, representing the radius of the ball
% NumTheta - \ theta's sampling quantity
% Number of samples for numPhi - \ phi

% Output:
% The coordinate matrix of points on the corresponding sphere for X, Y, Z -

    % Initialize Theta and Phi
    theta = linspace(0, pi, numTheta);
    phi = linspace(0, 2*pi, numPhi);

    [Theta, Phi] = meshgrid(theta, phi);

    % Convert Theta and Phi to coordinates
    X = R .* sin(Theta) .* cos(Phi) + O(1);
    Y = R .* sin(Theta) .* sin(Phi) + O(2);
    Z = R .* cos(Theta) + O(3);
end