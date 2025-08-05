data1 = rand(100,3);
data1(:,1) = data1(:,1)*30-15;
data1(:,2) = data1(:,2)*30-15;
data1(:,3) = data1(:,3)*42-3;
figure;
scatter3(data1(:,1),data1(:,2),data1(:,3),'r','filled');
hold on;

A = [-10 -20 -10];
B = [10 20 40];
scatter3(A(1),A(2),A(3),'g','filled');
scatter3(B(1),B(2),B(3),'g','filled');

[newB, newA, newdata1] = translate_rotate_points(data1, B, A);

scatter3(newdata1(:,1),newdata1(:,2),newdata1(:,3),'k','filled');
scatter3(newA(1),newA(2),newA(3),'b','filled');
scatter3(newB(1),newB(2),newB(3),'b','filled');
axis equal;