function bestR = cylinder_fitR(points, A, B)


    n = size(points, 1);


    AB = B - A;
    AB_length = norm(AB);
    AB_unit = AB / AB_length;  

    bestR = 0;
    for i = 1:n
        P = points(i, :);  
        AP = P - A;  

       
        proj_length = dot(AP, AB_unit);
        
        Q = A + proj_length * AB_unit;
        PQ = P - Q;
        PQ_length = norm(PQ); 
        bestR = bestR + PQ_length;
        
    end
    bestR = bestR/n;
end
