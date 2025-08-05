function [pointsAB, pointsCD] = classifyPoints(A, B, C, D, dataPoints)

    numData = size(dataPoints, 1);
    pointsAB = [];
    pointsCD = [];
    
    for i = 1:numData
        point = dataPoints(i, :);
        
    
        distToAB = pointToLineDistance(point, A, B);
        distToCD = pointToLineDistance(point, C, D);
  
        if distToAB < distToCD
            pointsAB = [pointsAB; point];
        else
            pointsCD = [pointsCD; point];
        end
    end
end

function d = pointToLineDistance(P, A, B)

    AB = B - A;
    AP = P - A;
    proj = dot(AP, AB) / dot(AB, AB);
    
    if proj < 0
       
        d = norm(AP);
    elseif proj > 1
     
        d = norm(P - B);
    else
     
        projPoint = A + proj * AB;
        d = norm(P - projPoint);
    end
end
