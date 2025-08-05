function [a, b, c, d1, d2] = computePlaneAndTangents(O, pointA, R)

    OA = pointA - O;

    V = cross(OA, [0, 0, 1]);

    V_unit = V / norm(V);
    B = O + R * V_unit;
    B(3) = O(3);

 
    OB = B - O;


    N = cross(OA, OB);


    N_unit = N / norm(N);


    d = dot(N_unit, O);
    
    a = N_unit(1);
    b = N_unit(2);
    c = N_unit(3);

   
    d1 = d - R * norm(N_unit);
    d2 = d + R * norm(N_unit);

    if d1 > d2
        temp = d1;
        d1 = d2;
        d2 = temp;
    end

end
