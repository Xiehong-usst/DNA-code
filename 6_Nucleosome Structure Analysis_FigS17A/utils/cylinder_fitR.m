function bestR = cylinder_fitR(points, A, B)
% cylinder_fitR is a function used to fit cylinder
% Input:
% points: Coordinates of points, each row is a 3D point, for example, points=[x1 y1 z1; x2 y2 z2;...]
% A, B: The two endpoints of the cylinder axis
% R: The radius of a cylinder
% Output:
% distances: A column vector containing the distance from each point to the cylinder

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
