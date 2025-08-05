function [bestA_AB, bestB_AB, bestRadius_AB, bestA_CD, bestB_CD, bestRadius_CD, pointsAB, pointsCD, totalVolume] = evaluateABCD(A, B, C, D, dataPoints)

    [pointsAB, pointsCD] = classifyPoints(A, B, C, D, dataPoints);
    if numel(pointsAB) < 3 || numel(pointsCD) < 3
        bestA_AB = [0 0 0];
        bestB_AB = [0 0 0];
        bestRadius_AB = 0;
        bestA_CD = [0 0 0];
        bestB_CD = [0 0 0];
        bestRadius_CD = 0;
        pointsAB = [];
        pointsCD = [];
        totalVolume = Inf;
    else

       
        [bestA_AB, bestB_AB, bestRadius_AB] = computeBestAxisForSet(pointsAB);
    
      
        [bestA_CD, bestB_CD, bestRadius_CD] = computeBestAxisForSet(pointsCD);
    
        if bestRadius_AB < 10
            bestRadius_AB = 10;
        end
        if bestRadius_CD < 10
            bestRadius_CD = 10;
        end
      
        volume_AB = computeCylinderVolume(bestA_AB, bestB_AB, bestRadius_AB);
        volume_CD = computeCylinderVolume(bestA_CD, bestB_CD, bestRadius_CD);
        totalVolume = volume_AB + volume_CD;
    end
end

function volume = computeCylinderVolume(A, B, radius)
   
    height = norm(A - B);
    volume = pi * (radius^2) * height;
end
