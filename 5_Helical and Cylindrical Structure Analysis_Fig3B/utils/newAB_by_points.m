function [minPoint, maxPoint] = newAB_by_points(points, A, B)


    AB = B - A; 
    AB_normalized = AB / norm(AB); 
    
   
    min_q = inf;
    max_q = -inf;
    
   
    for i = 1:size(points, 1)
        P = points(i, :); 
        AP = P - A; 
        q = dot(AP, AB_normalized); 
        
        
        if q < min_q
            min_q = q;
            minPoint = A + AB_normalized * q; 
        end
        if q > max_q
            max_q = q;
            maxPoint = A + AB_normalized * q; 
        end
    end
end
