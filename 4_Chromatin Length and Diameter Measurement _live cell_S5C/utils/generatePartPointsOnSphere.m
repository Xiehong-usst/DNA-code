function [X, Y, Z] = generatePartPointsOnSphere(O, R, numTheta, numPhi, ThetaChosen, PhiChosen)


    theta = linspace(ThetaChosen-pi/10, ThetaChosen+pi/10, numTheta);
    phi = linspace(PhiChosen-pi/5, PhiChosen+pi/5, numPhi);

    [Theta, Phi] = meshgrid(theta, phi);

 
    X = R .* sin(Theta) .* cos(Phi) + O(1);
    Y = R .* sin(Theta) .* sin(Phi) + O(2);
    Z = R .* cos(Theta) + O(3);
end