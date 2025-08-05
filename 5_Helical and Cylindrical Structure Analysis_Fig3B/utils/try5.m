
r = 6; 
h = 25; 
theta = linspace(0, pi/2, 1000);


x1 = r * cos(theta);
y1 = r * sin(theta);
z1 = (2*h/pi) * theta;


x2 = r * cos(pi + theta);
y2 = r * sin(pi + theta);
z2 = (2*h/pi) * theta;


figure;
plot3(x1, y1, z1, 'r', 'LineWidth', 2);
hold on;
plot3(x2, y2, z2, 'b', 'LineWidth', 2);
xlabel('x');
ylabel('y');
zlabel('z');
title('t-dna');
grid on;


points = [r, 0, 0; r/sqrt(2), r/sqrt(2), h/2; 0, r, h;...
         -r, 0, 0; -r/sqrt(2), -r/sqrt(2), h/2; 0, -r, h];
plot3(points(:,1), points(:,2), points(:,3), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
hold on;

tangent_vectors = zeros(6, 3);


tangent_vectors(1,:) = [-r*sin(theta(1)), r*cos(theta(1)), 2*h/pi];
tangent_vectors(2,:) = [-r*sin(pi/4), r*cos(pi/4), 2*h/pi];
tangent_vectors(3,:) = [-r*sin(pi/2), r*cos(pi/2), 2*h/pi];


tangent_vectors(4,:) = [-r*sin(pi+theta(1)), r*cos(pi+theta(1)), 2*h/pi];
tangent_vectors(5,:) = [-r*sin(pi + pi/4), r*cos(pi + pi/4), 2*h/pi];
tangent_vectors(6,:) = [-r*sin(pi + pi/2), r*cos(pi + pi/2), 2*h/pi];

u = 5;
R = 5;
color2 = rand(3,3);
A_list = [];
B_list = [];
for k = 1:6
    [A, B] = computeAB(u, points(k,:), tangent_vectors(k,:));
    plot3([A(1) B(1)],[A(2) B(2)],[A(3) B(3)],'k');
    color1 = color2(mod(k,3)+1,:);
    plot_cylinder_with_points(A,B,R,color1);
    A_list = [A_list; A];
    B_list = [B_list; B];
end
save cylinder_num6 A_list B_list R r h
axis equal;

data1 = rand(100,3);
data1(:,1) = data1(:,1)*30-15;
data1(:,2) = data1(:,2)*30-15;
data1(:,3) = data1(:,3)*42 - 3;
inside_id = zeros(100,1);
dist_list = zeros(100,6);
for k = 1:6
    [A, B] = computeAB(u, points(k,:), tangent_vectors(k,:));
    dist_list(:,k) = dist_to_cylinder(data1, A, B, R);
end
dist_list = min(dist_list,[],2);
dist_cut = quantile(dist_list,0.3);

data2 = data1(inside_id == 0,:);
scatter3(data2(:,1),data2(:,2),data2(:,3),'k','filled');
data2 = data1(dist_list < dist_cut,:);
scatter3(data2(:,1),data2(:,2),data2(:,3),'g','filled');
