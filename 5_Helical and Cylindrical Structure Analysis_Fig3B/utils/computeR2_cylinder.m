function R2 = computeR2_cylinder(points, A, B, cylinder_radius)
% computeR2_sphere is a function used to compute R^2 of a fitted sphere
%{
    input:
        points: Nx3 matrix, each row represents a point (x, y, z)
        A, B: 1x3 vectors, represent the two endpoints of the axis of the cylinder
        cylinder_radius: scalar, the radius of the cylinder
    output:
        R2: scalar, R^2
%} 
    AB = B - A;
    projected_points = zeros(size(points));
    
    % Project points onto a plane perpendicular to AB (the axis of the cylinder)
    for i = 1:size(points, 1)
        AP = points(i, :) - A;
        projection_scalar = dot(AP, AB) / dot(AB, AB);
        projection_vector = A + projection_scalar * AB;
        % find the point on the plane by subtracting the projection from the original point
        projected_points(i, :) = points(i, :) - (projection_vector - A);
    end
    
    % Calculate mean of the projected points
    mean_point = mean(projected_points, 1);
    
    % Calculate SST
    distances_to_mean = sqrt(sum((projected_points - mean_point).^2, 2));
    SST = sum(distances_to_mean.^2);
    
    % Calculate SSR
    residuals = zeros(size(points, 1), 1);
    for i = 1:size(points, 1)
        AP = points(i, :) - A;
        distance_to_axis = norm(cross(AP, AB)) / norm(AB);
        residuals(i) = abs(distance_to_axis - cylinder_radius);
    end
    SSR = sum(residuals.^2);
    
    % Calculate R2
    R2 = 1 - (SSR/SST);
end