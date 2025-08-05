function inside = is_inside_cylinder(points, A, B, R)

    n = size(points, 1);
    inside = zeros(n, 1);


    AB = B - A;
    AB_length = norm(AB);
    AB_unit = AB / AB_length;

    for i = 1:n
        P = points(i, :);  
        AP = P - A;  

        
        proj_length = dot(AP, AB_unit);
        
        Q = A + proj_length * AB_unit;
        PQ_length = norm(P - Q); 

     
        if proj_length >= 0 && proj_length <= AB_length
            if PQ_length < R
                inside(i) = 1;  
            end
        end
    end
end
