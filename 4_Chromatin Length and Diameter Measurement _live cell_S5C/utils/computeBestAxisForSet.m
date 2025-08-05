function [bestA, bestB, bestRadius] = computeBestAxisForSet(points)
  
    theta_res = 10; 
    phi_res = 10; 
    
 
    [O, R_sphere] = enclosingBall(points);
    if R_sphere < 1
        R_sphere = 1;
    end
    [X, Y, Z, theta_list, phi_list] = generatePointsOnSphere(O, R_sphere, theta_res, phi_res);

   
    [bestA, bestB, bestRadius, besti, bestj, ~] = findBestAxis(points, X, Y, Z);
    
    
    theta_chosen = theta_list(besti);
    phi_chosen = phi_list(besti);
    [X1, Y1, Z1] = generatePartPointsOnSphere(O, R_sphere, theta_res, phi_res, theta_chosen, phi_chosen);
    theta_chosen = theta_list(bestj);
    phi_chosen = phi_list(bestj);
    [X2, Y2, Z2] = generatePartPointsOnSphere(O, R_sphere, theta_res, phi_res, theta_chosen, phi_chosen);
    [bestA, bestB, bestRadius, ~] = findPartBestAxis(points, X1, Y1, Z1, X2, Y2, Z2);
end
