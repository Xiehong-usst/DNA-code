clear; close all; clc;

%% 
load('3d_cluster_area1_loc.mat'); 
pointCloud = area1_loc_with_counts(:, 1:3) * 3;  
R = 8; 
%% 
points = area1_loc_with_counts(:,1:3); 
counts = area1_loc_with_counts(:,4);   

%% 
num_points = size(points,1);
normalized_density = zeros(num_points,1);

for i = 1:num_points
    % 
    distances = sqrt(sum((points - points(i,:)).^2, 2));
  
    % 
    mask = (distances <= R/3);
  
    %
    total_count = sum(counts(mask));
  
    % 
    normalized_density(i) = total_count / (4/3 * pi * R^3);
end

%% 
figure;
scatter3(pointCloud(:,1), pointCloud(:,2), pointCloud(:,3), 5, normalized_density, 'filled');
colormap jet; colorbar; axis equal;
xlabel('X (nm)'); ylabel('Y (nm)'); zlabel('Z (nm)');
title([' (R = ', num2str(R), ' nm)']);
set(gcf, 'color', 'white');
axis equal;
colordef white;

%% 
save('area1_density_results.mat', 'points', 'counts', 'normalized_density', 'R');