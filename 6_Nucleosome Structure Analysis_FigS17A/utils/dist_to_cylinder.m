function distances = dist_to_cylinder(points, A, B, R)
% dist_to_cylinder is a function used to calculate the distance from a point to the surface of a cylinder
% Input:
% points: Coordinates of points, each row is a 3D point, for example, points=[x1 y1 z1; x2 y2 z2;...]
% A, B: The two endpoints of the cylinder axis
% R: The radius of a cylinder
% Output:
% distances: A column vector containing the distance from each point to the cylinder

    % Initialize
    n = size(points, 1);
    distances = zeros(n, 1);

    % Calculate vector AB
    AB = B - A;
    AB_length = norm(AB);
    AB_unit = AB / AB_length;  % The unit vector of AB

    for i = 1:n
        P = points(i, :);
        AP = P - A;

        % Calculate the projection length of point P on AB
        proj_length = dot(AP, AB_unit);
        % Calculate the projection point Q
        Q = A + proj_length * AB_unit;
        PQ = P - Q;
        PQ_length = norm(PQ); 

        % Determine whether the vertical foot Q is on line segment AB
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
