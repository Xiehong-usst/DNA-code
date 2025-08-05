function [bestA, bestB, bestC, bestD, bestTotalVolume, bestRadiusAB, bestRadiusCD, bestpointsAB, bestpointsCD] = searchABCD(O, R, numTheta, numPhi, dataPoints)
  
    bestTotalVolume = Inf;

    
    [X, Y, Z] = generatePointsOnSphere(O, R, numTheta, numPhi);
    numd = 10;
    
   
    numPoints = numel(X);
    tempTotalVolume = Inf * ones(numPoints, 1);
    tempA = zeros(numPoints, 3);
    tempB = zeros(numPoints, 3);
    tempC = zeros(numPoints, 3);
    tempD = zeros(numPoints, 3);
    tempRadiusAB = zeros(numPoints, 1);
    tempRadiusCD = zeros(numPoints, 1);
    tempPointsAB = cell(numPoints, 1);
    tempPointsCD = cell(numPoints, 1);
    
    
    parfor idxA = 1:numPoints
        pointA = [X(idxA) Y(idxA) Z(idxA)];
        
        
        [a, b, c, d1, d2] = computePlaneAndTangents(O, pointA, R);
        
     
        u1 = dataPoints*[a b c]';
        
        d = linspace(d1, d2, numd);
       
        localBestVolume = Inf;

        
        for k = 1:numel(d)
            n1 = find(u1 > d(k));
            n2 = find(u1 <= d(k));
            pointsAB = dataPoints(n1,:);
            pointsCD = dataPoints(n2,:);

           
            if min(numel(pointsAB),numel(pointsCD)) < 3
                continue;
            end

          
            [bestA_AB, bestB_AB, bestRadius_AB] = computeBestAxisForSet(pointsAB);
            [bestA_CD, bestB_CD, bestRadius_CD] = computeBestAxisForSet(pointsCD);

            minR = 20;
            if bestRadius_AB < minR% 15
                bestRadius_AB = minR;
            end
            if bestRadius_CD < minR
                bestRadius_CD = minR;
            end

           
            volume_AB = computeCylinderVolume(bestA_AB, bestB_AB, bestRadius_AB);
            volume_CD = computeCylinderVolume(bestA_CD, bestB_CD, bestRadius_CD);
            totalVolume = volume_AB + volume_CD;

           
            if totalVolume < localBestVolume
                localBestVolume = totalVolume;
                tempA(idxA,:) = bestA_AB;
                tempB(idxA,:) = bestB_AB;
                tempC(idxA,:) = bestA_CD;
                tempD(idxA,:) = bestB_CD;
                tempRadiusAB(idxA) = bestRadius_AB;
                tempRadiusCD(idxA) = bestRadius_CD;
                tempPointsAB{idxA} = pointsAB;
                tempPointsCD{idxA} = pointsCD;
            end
        end

       
        tempTotalVolume(idxA) = localBestVolume;
    end
    
   
    [bestTotalVolume, idxBest] = min(tempTotalVolume);
    bestA = tempA(idxBest,:);
    bestB = tempB(idxBest,:);
    bestC = tempC(idxBest,:);
    bestD = tempD(idxBest,:);
    bestRadiusAB = tempRadiusAB(idxBest);
    bestRadiusCD = tempRadiusCD(idxBest);
    bestpointsAB = tempPointsAB{idxBest};
    bestpointsCD = tempPointsCD{idxBest};
end

function volume = computeCylinderVolume(A, B, radius)
   
    height = norm(A - B);
    minH = 40;
    if height < minH% 30
        height = minH;% 30
    end
    volume = pi * (radius^2) * height;
end
