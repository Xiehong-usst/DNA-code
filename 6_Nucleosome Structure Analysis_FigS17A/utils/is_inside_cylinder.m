function inside = is_inside_cylinder(points, A, B, R)
% is_inside_cylinder is a function used to check if the point is inside the cylinder
% Input:
% points: Coordinates of points, each row is a 3D point, for example, points=[x1 y1 z1; x2 y2 z2;...]
% A, B: The two endpoints of the cylinder axis

% R: The radius of a cylinder

% Output:
% inside: A column vector, where 1 indicates that the point is inside the cylinder and 0 indicates that the point is not inside the cylinder

    % Initialize
    n = size(points, 1);
    inside = zeros(n, 1);

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
        PQ_length = norm(P - Q);  % The length of PQ

        % Determine whether the vertical foot Q is on line segment AB
        if proj_length >= 0 && proj_length <= AB_length
            if PQ_length < R
                inside(i) = 1;  % Inside the cylinder
            end
        end
    end
end
