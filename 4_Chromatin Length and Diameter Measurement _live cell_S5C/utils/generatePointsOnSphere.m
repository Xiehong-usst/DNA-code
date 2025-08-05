function [X, Y, Z, Theta, Phi] = generatePointsOnSphere(O, R, numTheta, numPhi)

    theta = linspace(0, pi, numTheta);
    phi = linspace(0, 2*pi, numPhi);

    [Theta, Phi] = meshgrid(theta, phi);

  
    X = R .* sin(Theta) .* cos(Phi) + O(1);
    Y = R .* sin(Theta) .* sin(Phi) + O(2);
    Z = R .* cos(Theta) + O(3);
end