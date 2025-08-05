function spiral = plotSpiral(r_spiral, h_spiral, A, B, angle_adjust_factor, circle_factor, rotation_direction, color, style)
% plotSpiral is a function used to plot a spiral, which is on a cylindrical surface with r_spiral as the radius and AB as the central axis
%{
    input:
        r_spiral: scalar, the radius of the cylinder
        A & B: 1x3 vector, represent the two points of the axis of a cylinder
%}
        
    dir = (B - A) / norm(B - A); % Direction vector of AB

    % Define the parametric equation for the spiral
    dir_init = [0 0 1];
    t = rotation_direction * linspace(angle_adjust_factor, circle_factor * 2 * pi + angle_adjust_factor, 1000);
    x = r_spiral * cos(t);
    y = r_spiral * sin(t);
    % Calculate the range of the z-axis
    z = linspace(0, h_spiral, 1000);

    % Transfer the spiral to the position of the central axis AB
    R = rotationMatrixFromVector(dir_init, dir); % Get the rotation matrix
    spiral = R * [x; y; z]; % Rotate the spiral

    % Translate the spiral so that its axis start coincides with A
    spiral(1, :) = spiral(1, :) + A(1);
    spiral(2, :) = spiral(2, :) + A(2);
    spiral(3, :) = spiral(3, :) + A(3);

    % Draw
    plot3(spiral(1, :), spiral(2, :), spiral(3, :), 'Color', color, 'LineStyle', style, 'LineWidth', 3);
end

function R = rotationMatrixFromVector(v1, v2)
    if length(v1) ~= 3 || length(v2) ~= 3
        error('v1 and v2 should be 3D vectors');
    end
    v = cross(v1, v2);
    s = norm(v);
    c = dot(v1, v2);
    V = [0, -v(3), v(2); 
        v(3), 0, -v(1); 
        -v(2), v(1), 0];
    R = eye(3) + V + V^2 * ((1 - c) / s^2);  % eye(3) = [1 0 0; 0 1 0; 0 0 1]
end
