function plot_cylinder_with_points(A, B, radius, color1)
% plot_cylinder_with_points is a function used to plot cylinder based on
%{
    A, B are the endpoints of the cylinder's axis, e.g., A = [1, 2, 3] and B = [4, 5, 6]
    radius is the cylinder's radius
    points is a matrix where each row represents a 3D point, e.g., points = [x1 y1 z1; x2 y2 z2; ...]
%}
    % Generate cylinder
    [X, Y, Z] = cylinder(radius);
    Z = Z * norm(B - A);
    direction = (B - A) / norm(B - A);

    % Rotate cylinder to match given points A and B
    rotAxis = cross([0 0 1], direction);
    rotAngle = acos(dot([0 0 1], direction));

    R = vrrotvec2mat([rotAxis, rotAngle]);

    % Apply rotation and translation
    for i = 1:size(X, 2)
        for j = 1:size(X, 1)
            tmp = R * [X(j, i); Y(j, i); Z(j, i)];
            X(j, i) = tmp(1) + A(1);
            Y(j, i) = tmp(2) + A(2);
            Z(j, i) = tmp(3) + A(3);
        end
    end

    % Plot
    surf(X, Y, Z, 'FaceAlpha', 0.2, 'FaceColor', color1, 'EdgeColor', 'none'); % Cylinder with transparency
    hold on;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    axis equal;
    grid on;
    view(3);  % 3D view
    plot_two_circle_surfaces(A, B, radius, color1);

end

function plot_two_circle_surfaces(A, B, radius, color1)
    % Compute the unit vector of AB
    d = (B - A) / norm(B - A);
    
    % Compute two vectors n1 and n2 that are perpendicular to AB
    n1 = cross(d, [0, 0, 1]);
    n1 = n1 / norm(n1);
    
    n2 = cross(d, n1);
    n2 = n2 / norm(n2);
    
    % Parameterize the circle for point A
    u = linspace(0, 2*pi, 100);
    X_A = A(1) + radius * (cos(u) * n1(1) + sin(u) * n2(1));
    Y_A = A(2) + radius * (cos(u) * n1(2) + sin(u) * n2(2));
    Z_A = A(3) + radius * (cos(u) * n1(3) + sin(u) * n2(3));

    % Circle surface for point A
    fill3(X_A, Y_A, Z_A, color1, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    hold on;
    plot3(X_A, Y_A, Z_A, 'Color', color1, 'LineWidth', 2);

    % Parameterize the circle for point B
    X_B = B(1) + radius * (cos(u) * n1(1) + sin(u) * n2(1));
    Y_B = B(2) + radius * (cos(u) * n1(2) + sin(u) * n2(2));
    Z_B = B(3) + radius * (cos(u) * n1(3) + sin(u) * n2(3));
    
    % Circle surface for point B
    fill3(X_B, Y_B, Z_B, color1, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    plot3(X_B, Y_B, Z_B, 'Color', color1, 'LineWidth', 2);
end
