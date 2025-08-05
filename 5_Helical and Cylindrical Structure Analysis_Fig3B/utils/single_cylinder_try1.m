A = rand(1,3)*3;
B1 = rand(1,3) - [.5,.5,.5];
B1 = B1/norm(B1)*10;
B = A + B1;
R = 5.5;
figure;
points = A;
color1 = rand(1,3);
[X, Y, Z] = plot_cylinder_with_points(A, B, R, points, color1);
n2 = size(X,2);
U_list = [];
for k = 1:10
    r1 = round(rand(1)*n2 + 0.5);
    k1 = rand(1);
    U1 = [X(1,r1)*k1+X(2,r1)*(1-k1),Y(1,r1)*k1+Y(2,r1)*(1-k1),Z(1,r1)*k1+Z(2,r1)*(1-k1)];
    U1 = round(U1/3)*3;
    U_list = [U_list; U1];
end
scatter3(U_list(:,1),U_list(:,2),U_list(:,3),'k','filled');

save('exp6_cylinder','U_list','A','B');