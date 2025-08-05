function sorted_points = projectAndSort(A, B, points)
% projectAndSort is a function used to project scattered points onto line AB and return sorted projection points based on relative distance
%{
    input:
        A & B: 1x3 vector, represent the two endpoints of the axis of a cylinder
        points: Nx3 matrix, each row represents a point (x, y, z)
    output:
        sorted_points: Nx3 matrix, each row represents a point (x, y, z)
%}
    num = size(points, 1);
    sort_values = zeros(num, 1);  % Sorting metric

    AB = B - A;
    
    for i = 1:num
        P = points(i, :);
        P_proj = projectPointOntoLine(A, B, P);
        % Use dot product to determine the sort value
        sort_values(i) = dot(P_proj - A, AB);
    end

    % Sort based on the sortValues
    [~, sorted_indices] = sort(sort_values);
    sorted_points = points(sorted_indices, :);
end