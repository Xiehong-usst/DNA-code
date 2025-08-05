function distances = dist_to_cylinder(points, A, B, R)
    
   
    n = size(points, 1);
    distances = zeros(n, 1);

   
    AB = B - A;
    AB_length = norm(AB);
    AB_unit = AB / AB_length;  

    for i = 1:n
        P = points(i, :);  
        AP = P - A; 

       
        proj_length = dot(AP, AB_unit);
        
        Q = A + proj_length * AB_unit;
        PQ = P - Q;
        PQ_length = norm(PQ);  

       
        if proj_length >= 0 && proj_length <= AB_length
            distances(i) = abs(PQ_length - R);
        else
            dist_diff = abs(PQ_length - R);
            QA = norm(Q - A);
            QB = norm(Q - B);
            if QA < QB
                distances(i) = sqrt(QA^2 + dist_diff^2);
            else
                distances(i) = sqrt(QB^2 + dist_diff^2);
            end
        end
    end
end
