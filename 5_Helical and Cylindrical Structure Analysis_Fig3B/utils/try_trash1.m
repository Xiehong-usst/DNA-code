
center = [5, 6, 3];
radius = 3;


points = generate_sphere_points(center, radius, 40);
figure;scatter3(points(:,1),points(:,2),points(:,3),'k');
rotated_points = rotate_z(points, 90);
hold on;
scatter3(rotated_points(:,1),rotated_points(:,2),rotated_points(:,3),'r');
axis equal;
