load("cylinder3.mat");
A1 = cylinder.bestA;
B1 = cylinder.bestB;
R = cylinder.bestRadius;
points = data1;

[A2,B2] = newAB_by_points(points, A1, B1);

cutn = 22;
[pointsA, pointsB] = generateCylinders(A2, B2, R, cutn);

A3 = pointsA(50,:);
B3 = pointsB(50,:);
[newA, newB, newpoints] = translate_rotate_points(points, A3, B3);

figure;
plot_cylinder_with_points(A2, B2, R, rand(1,3));
hold on;
scatter3(A3(:,1),pointsA(:,2),pointsA(:,3),'k','filled');
scatter3(pointsB(:,1),pointsB(:,2),pointsB(:,3),'r','filled');
axis equal;
scatter3(points(:,1),points(:,2),points(:,3),'blue','filled');
scatter3(newpoints(:,1),newpoints(:,2),newpoints(:,3),'blue','filled');
scatter3(newA(:,1),newA(:,2),newA(:,3),'k','filled');
scatter3(newB(:,1),newB(:,2),newB(:,3),'r','filled');
plot_cylinder_with_points(A2, B2, R, rand(1,3));