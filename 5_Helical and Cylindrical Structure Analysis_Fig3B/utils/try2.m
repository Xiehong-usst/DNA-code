
A = [10, 20, 30];
B = [40, 50, 60];
R = 20;


cutn = 12;
[points1, points2] = generateCylinders(A, B, R, cutn);

figure;
plot_cylinder_with_points(A, B, R, rand(1,3));
hold on;
scatter3(points1(:,1),points1(:,2),points1(:,3),'k','filled');
scatter3(points2(:,1),points2(:,2),points2(:,3),'r','filled');
axis equal;