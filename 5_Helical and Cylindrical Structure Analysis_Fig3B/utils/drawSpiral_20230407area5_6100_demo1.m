%{
    This script is used to Draw linker DNA
    You can test all steps by Ctrl + Enter

    Step 1 : Read data
    Step 2 : Draw spiral

Provided by ENN USST
MATLAB R2019a
%}
clc;
clear;
close all;
addpath(genpath(pwd));  % Call the functions in all folders in the current folder
%% ------------------- Step 1 : Read data
name = '20230407area5_6100_demo1';
data_path = sprintf('./dataset/%s.mat',name);
load(data_path);
data = data4 - xd1 + 1;
data = clearOverlap(data);
data = data / 3;

figure;
points_size = 30;
scatter3(data(:,1), data(:,2), data(:,3), points_size, 'r', 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 1);
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;
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
% Coloring
colors = 1:size(data_raw, 1);
point_size = 300;
scatter3(data_raw(:, 1),data_raw(:, 2),data_raw(:, 3), point_size, colors,  'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 1);
colorbar;
caxis([1 size(data_raw, 1)]);
% Numbering
for i = 1:size(data_raw, 1)
    text(data_raw(i, 1), data_raw(i, 2), data_raw(i, 3), num2str(i), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', ...
        'Color', 'w', ...
        'FontWeight', 'bold', ...
        'FontSize', 15);
end
hold on;
axis equal;
% --- Central axis
plot3([A_best(1), B_best(1)], [A_best(2), B_best(2)], [A_best(3), B_best(3)], 'k-.', 'LineWidth', 1);
hold on;
axis equal;
% --- Cylinder
[X_cylinder, Y_cylinder, Z_cylinder] = cylinder(r_spiral);
Z_cylinder = Z_cylinder * h_spiral;
% Rotate cylinder to match given points A and B
direction = (B_best - A_best) / norm(B_best - A_best);
axis_rotated = cross([0 0 1], direction);
angle_rotated = acos(dot([0 0 1], direction));
rotation = vrrotvec2mat([axis_rotated, angle_rotated]);
% Apply rotation and translation
P_proj = projectPointOntoLine(A_best, B_best, mean([data_raw(3, :); data_raw(4, :)], 1));
for i = 1:size(X_cylinder, 2)
    for j = 1:size(X_cylinder, 1)
        tmp = rotation * [X_cylinder(j, i); Y_cylinder(j, i); Z_cylinder(j, i)];
        X_cylinder(j, i) = tmp(1) + P_proj(1);
        Y_cylinder(j, i) = tmp(2) + P_proj(2);
        Z_cylinder(j, i) = tmp(3) + P_proj(3);
    end
end
surf(X_cylinder, Y_cylinder, Z_cylinder, 'FaceAlpha', 0.6, 'FaceColor', '#FFDEAD', 'EdgeColor', 'none'); % Cylinder with transparency
hold on;
axis equal;
% --- spiral
angle_adjust_factor = 8.5; % Hyperparameter
circle_factor = 1.75; % Hyperparameter
color = 'm';
style = '-';
rotation_direction = -1;  % +1 or -1
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
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
grid on;
view(3);  % 3D view
hold off;
axis equal;
save_path = sprintf('./results/%s_demo1.fig',name);
saveas(gcf, save_path);