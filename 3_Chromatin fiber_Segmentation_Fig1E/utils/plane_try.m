

O = rand(1, 3) * 10; 
R = rand() * 5;       


C = rand(1, 3) * 10;


OC = C - O;
OC_unit = OC / norm(OC);


A = O + R * OC_unit;

[a, b, c, d1, d2] = computePlaneAndTangents(O, A, R);


d = (d1 + d2) / 2;


figure;


[x, y, z] = sphere(100);
surf(x * R + O(1), y * R + O(2), z * R + O(3), 'FaceColor', 'none', 'EdgeColor', 'k');
hold on;


[x_plane, y_plane] = meshgrid(O(1) - 2*R : 0.5 : O(1) + 2*R, O(2) - 2*R : 0.5 : O(2) + 2*R);
z_plane = (d - a * x_plane - b * y_plane) / c;
surf(x_plane, y_plane, z_plane, 'FaceColor', 'r', 'EdgeColor', 'none', 'FaceAlpha', 0.7);


plot3(O(1), O(2), O(3), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
plot3(A(1), A(2), A(3), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');


numPoints = 50; 
randomPoints = repmat(O, numPoints, 1) + (rand(numPoints, 3) - 0.5) * 2 * R;  


condition = a * randomPoints(:, 1) + b * randomPoints(:, 2) + c * randomPoints(:, 3) > d;


plot3(randomPoints(condition, 1), randomPoints(condition, 2), randomPoints(condition, 3), 'ro', 'MarkerSize', 6);
plot3(randomPoints(~condition, 1), randomPoints(~condition, 2), randomPoints(~condition, 3), 'bo', 'MarkerSize', 6);

xlabel('x');
ylabel('y');
zlabel('z');
axis equal;
view(3);
title('Visualization of O, A, Sphere, Plane, and Random Points');
hold off;
