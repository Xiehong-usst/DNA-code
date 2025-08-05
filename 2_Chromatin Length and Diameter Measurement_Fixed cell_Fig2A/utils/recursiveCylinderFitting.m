function cylinders = recursiveCylinderFitting(dataPoints)
  
    cylinders = {};
    
  
    if size(dataPoints, 1) < 3
        return;
    end
    
    tic;
   
    [bestA, bestB, bestRadius] = computeBestAxisForSet(dataPoints);
    d1 = (sum((bestA - bestB).^2))^(1/2);
    singleCylinderVolume = pi*bestRadius^2*d1;

    
    [O, R_sphere] = enclosingBall(dataPoints);
    numTheta = 20;
    numPhi = 20;
    [bestA1, bestB1, bestA2, bestB2, bestTotalVolume, bestRadius1, bestRadius2, dataPoints1, dataPoints2] = searchABCD(O, R_sphere, numTheta, numPhi, dataPoints);
    toc;

   
    bestTotalVolume = inf;
    if bestTotalVolume < singleCylinderVolume
       
        fprintf('Cut continue...');
        cylinders1 = recursiveCylinderFitting(dataPoints1);
        cylinders2 = recursiveCylinderFitting(dataPoints2);

       
        cylinders = [cylinders1, cylinders2];
        
    else
        
        cylinder = struct('bestA', bestA, 'bestB', bestB, 'bestRadius', bestRadius, 'dataPoints', dataPoints);
        cylinders = {cylinder};
        fprintf('Stop for one.');
    end
end
