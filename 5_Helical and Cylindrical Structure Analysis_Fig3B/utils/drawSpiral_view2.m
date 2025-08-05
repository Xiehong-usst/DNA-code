%{
    This script is used to Draw linker DNA
    You can test all steps by Ctrl + Enter

    Step 1 : Read data
    Step 2 : Draw spiral

Provided by ENN USST
MATLAB R2019a
%}
clc;
addpath(genpath(pwd));  % Call the functions in all folders in the current folder
%% ------------------- Step 1 : Read data

data = data4 - xd1 + 1;
data = clearOverlap(data);
data = data / 3;

data_raw = data;
%% ------------------- Step 2 : Draw spiral
r_spiral = bestR_list / 3;
h_spiral = 4.7 / 3;
A_best = P1 / 3;
B_best = P2 / 3;
data = projectAndSort(A_best, B_best, data);
data_raw = projectAndSort(A_best, B_best, data_raw);

figure;
% --- Points 
colors = 1:size(data_raw, 1);
point_size = 300;
scatter3(data_raw(:, 1)*3, data_raw(:, 2)*3, data_raw(:, 3)*3, point_size, colors,  'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 1);
colorbar;
caxis([1 size(data_raw, 1)]);
hold on;
axis equal;
% --- Central axis 
plot3([A_best(1)*3, B_best(1)*3], [A_best(2)*3, B_best(2)*3], [A_best(3)*3, B_best(3)*3], 'k-.', 'LineWidth', 1);
hold on;
axis equal;
% --- Cylinder 
[X_cylinder, Y_cylinder, Z_cylinder] = cylinder(r_spiral);
Z_cylinder = Z_cylinder * h_spiral;
direction = (B_best - A_best) / norm(B_best - A_best);
axis_rotated = cross([0 0 1], direction);
angle_rotated = acos(dot([0 0 1], direction));
rotation = vrrotvec2mat([axis_rotated, angle_rotated]);
P_proj = projectPointOntoLine(A_best, B_best, mean([data_raw(3, :); data_raw(4, :)], 1));
for i = 1:size(X_cylinder, 2)
    for j = 1:size(X_cylinder, 1)
        tmp = rotation * [X_cylinder(j, i); Y_cylinder(j, i); Z_cylinder(j, i)];
        
        X_cylinder(j, i) = tmp(1)*3 + P_proj(1)*3;  
        Y_cylinder(j, i) = tmp(2)*3 + P_proj(2)*3;
        Z_cylinder(j, i) = tmp(3)*3 + P_proj(3)*3;
    end
end
surf(X_cylinder, Y_cylinder, Z_cylinder, 'FaceAlpha', 0.6, 'FaceColor', '#FFDEAD', 'EdgeColor', 'none');
hold on;
axis equal;
% --- spiral 
angle_adjust_factor = 8.5;
circle_factor = 1.75;
color = 'm';
style = '-';
rotation_direction = -1;
spiral = plotSpiral(r_spiral, h_spiral, P_proj, B_best, angle_adjust_factor, circle_factor, rotation_direction, color, style);
hold on;
axis equal;

% --- labels
title({num2str(name),...
['Linker DNA Fitting'],... 
['d = ', num2str(2 * r_spiral * 3), ' nm'],...
['h = ', num2str(h_spiral * 3), ' nm'],...
['circle num = ', num2str(circle_factor)],...
['R^2 = ', num2str(computeR2_cylinder(data(4:9, :), A_best, B_best, r_spiral))]
});
legend('linker DNA nodes', 'central axis', 'protein', 'fitted linker DNA');
xlabel('X (nm)');
ylabel('Y (nm)');
zlabel('Z (nm)');
axis equal;
grid on;
view(3);
view([-120.467387534067 8.78432003516308]);
hold off;
axis equal;
save_path = sprintf('./%s_demo1_view2.fig',name);
saveas(gcf, save_path);

%% ================
function spiral = plotSpiral(r_spiral, h_spiral, A, B, angle_adjust_factor, circle_factor, rotation_direction, color, style)
    dir = (B - A) / norm(B - A); 
    dir_init = [0 0 1];
    t = rotation_direction * linspace(angle_adjust_factor, circle_factor * 2 * pi + angle_adjust_factor, 1000);
    x = r_spiral * cos(t);
    y = r_spiral * sin(t);
    z = linspace(0, h_spiral, 1000);
    
    R = rotationMatrixFromVector(dir_init, dir);
    spiral = R * [x; y; z];
    
    spiral(1, :) = spiral(1, :) + A(1);
    spiral(2, :) = spiral(2, :) + A(2);
    spiral(3, :) = spiral(3, :) + A(3);
    
    % ==========================
    spiral = spiral * 3;
    
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
    R = eye(3) + V + V^2 * ((1 - c) / s^2);
end