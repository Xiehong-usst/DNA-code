load("cylinder3.mat");
A1 = cylinder.bestA;
B1 = cylinder.bestB;
R_base = cylinder.bestRadius;
points = data1;

load("cylinder_num6.mat");
r_base = r;
h_base = h;
R_fit = 5;
for k = 1:6
    A_list(:,2) = -A_list(:,2);
    B_list(:,2) = -B_list(:,2);
end

[A2,B2] = newAB_by_points(points, A1, B1);
AB = norm(A2-B2);

cutn = 12;
[pointsA, pointsB] = generateCylinders(A2, B2, R_base, cutn);
angle_list = 10:10:360;
Z_list = -R_base/6:R_base/18:R_base/6;
cut_part = 0.3;

min_error_all = inf;
tic;
for xa = 1:size(pointsA,1)
    fprintf('-');
    if xa == 2
        toc;
        tic;
    end
    for xb = 1:size(pointsB,1)
        A3 = pointsA(xa,:);
        B3 = pointsB(xb,:);
        [newA, newB, newpoints] = translate_rotate_points(points, A3, B3);

        error_list = zeros(1,numel(angle_list));
        best_Z_list = zeros(1,numel(angle_list));
        parfor x_angle = 1:numel(angle_list)
            rotated_points = rotate_z(newpoints, angle_list(x_angle));
            best_error = inf;
            best_Z1 = 0;
            for xz = 1:numel(Z_list)
                rotated_points = rotated_points+Z_list(xz);
                
                
                
                dist_list = zeros(size(rotated_points,1),6);
                mid = (A_list(2,3)+B_list(2,3))/2;
                for k = 1:6
                    Ak = A_list(k,:);
                    Bk = B_list(k,:);
                    Ak(3) = Ak(3) - mid + AB/2;
                    Bk(3) = Bk(3) - mid + AB/2;
                    dist_list(:,k) = dist_to_cylinder(rotated_points, Ak, Bk, R_fit);
                end
                dist_error = 0;
                for k = 1:6
                    dist1 = dist_list(:,k);
                    dist_cut = quantile(dist1,cut_part);
                    dist_use = find(dist1 < dist_cut);
                    dist_error = dist_error + sum(dist_use.^2)^2;
                end
                if best_error > dist_error
                    best_error = dist_error;
                    best_Z1 = Z_list(xz);
                end
            end
            error_list(x_angle) = best_error;
            best_Z_list(x_angle) = best_Z1;
        end
        [min_error, n1] = min(error_list);
        if min_error_all > min_error
            min_error_all = min_error;
            n1 = n1(1);
            best_A3 = pointsA(xa,:);
            best_B3 = pointsB(xb,:);
            best_Angle = angle_list(n1);
            best_Z = best_Z_list(n1);
        end
    end
end

save best_fit_set min_error_all best_Z best_Angle best_A3 best_B3 r_base h_base A_list B_list
toc;
%%
[newA, newB, newpoints] = translate_rotate_points(points, A3, B3);
newpoints = rotate_z(newpoints, best_Angle);
newpoints = newpoints + best_Z;

figure;
hold on;

color2 = rand(3,3);
mid = (A_list(2,3)+B_list(2,3))/2;
for k = 1:6
    Ak = A_list(k,:);
    Bk = B_list(k,:);
    Ak(3) = Ak(3) - mid + AB/2;
    Bk(3) = Bk(3) - mid + AB/2;
    color1 = color2(mod(k,3)+1,:);
    plot_cylinder_with_points(Ak,Bk,R_fit,color1);
end

scatter3(newpoints(:,1),newpoints(:,2),newpoints(:,3),'blue','filled');
plot_cylinder_with_points(newA, newB, R_base, rand(1,3));
axis equal;