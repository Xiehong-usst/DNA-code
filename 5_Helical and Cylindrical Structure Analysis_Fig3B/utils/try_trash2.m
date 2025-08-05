
points = [1 0 0; 0 1 0; 0 0 0; 1 1 1];


angle = 45 * (pi / 180);


rotated_points = rotatePointsAroundZ(points, angle);

figure;scatter3(points(:,1),points(:,2),points(:,3),'k','filled');
hold on;
scatter3(rotated_points(:,1),rotated_points(:,2),rotated_points(:,3),'r','filled');
axis equal;