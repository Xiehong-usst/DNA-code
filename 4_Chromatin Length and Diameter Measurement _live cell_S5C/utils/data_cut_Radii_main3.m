clear;
close all;


file_list = dir('*.mat');
cover_weight = 0.98;

for idx = 1:length(file_list)
    file_name = file_list(idx).name;
    data1 = loadDataAndProcess(file_name);
    k = loadDataAndProcess2(file_name);
    
    file_name2 = ['.\saved_variables\3d_cluster_area' num2str(k) '_loc_multi_fit_single.mat'];
    load(file_name2);
    
    
    tic;
   
    cut_set = 40;
    
    new_data1 = [];
    
    newCylinders = [];
    nn1 = 0;
    for k = 1:numel(allCylinders)
        A1 = allCylinders{k}.bestA;
        B1 = allCylinders{k}.bestB;
        R1 = allCylinders{k}.bestRadius;
        inside = is_inside_cylinder(data1, A1, B1, R1+2);
        n1 = find(inside == 1);
        new_data1 = [new_data1; data1(n1,:)];
    
        new_datak = data1(n1,:);
        d1 = norm(B1 - A1);
        % nd = floor(d1/cut_set);
        nd = 1;
        cutd = d1/nd;
        groupedPoints = [];
        Alist = [];
        Blist = [];
        if nd > 1
            AB = B1 - A1;
            AB_length = norm(AB);
            AB_unit = AB / AB_length;
            for r = 1:nd
                Alist{r} = A1 + (r - 1)*cutd*AB_unit;
                Blist{r} = A1 + r*cutd*AB_unit;
            end
            cleaned_data = removeDuplicatePoints(new_datak);
            groupedPoints = groupPointsByDistance(cleaned_data, A1, B1, cutd);
        else
            Alist{1} = A1;
            Blist{1} = B1;
            cleaned_data = removeDuplicatePoints(new_datak);
            groupedPoints{1} = cleaned_data;
        end
        for r = 1:numel(Alist)
            [Rbest, newA1, newB1] = calculate95PercentileDistance(groupedPoints{r}, Alist{r}, Blist{r}, cover_weight);
            cylinder1 = [];
            cylinder1.bestA = newA1;
            cylinder1.bestB = newB1;
            cylinder1.bestRadius = Rbest;
            cylinder1.dataPoints = groupedPoints{r};
            nn1 = nn1 + 1;
            newCylinders{nn1} = cylinder1;
        end
    end
    toc;
    
   
    fig = figure;
    scatter3(data1(:,1), data1(:,2), data1(:,3), 'k', 'filled');
    hold on;
    plotAllCylinders(newCylinders);
    lengths = getCylinderLengths(newCylinders);
    radii = getCylinderRadii(newCylinders);
    % scatter3(new_data1(:,1), new_data1(:,2), new_data1(:,3), 'k', 'filled');
    set(gcf,'color','white'); 
 
     colordef white; %2D/
    
    save_name_gradient = fullfile('saved_variables', [file_name(1:end-4) '_d_stats.mat']);
    save(save_name_gradient, 'lengths','radii','newCylinders');
    fig_name = fullfile('saved_figures', [file_name(1:end-4) '_cut_main3.fig']);
    savefig(fig_name);

    %% 
    fig2 = copyobj(fig, 0);
    set(fig2, 'Name', 'Local Cylinder Views');
    
  
    allPoints = [];
    for i = 1:numel(newCylinders)
        allPoints = [allPoints; newCylinders{i}.dataPoints];
    end
    margin = max(range(allPoints)) * 0.2; % 
    xlims = [min(allPoints(:,1))-margin, max(allPoints(:,1))+margin];
    ylims = [min(allPoints(:,2))-margin, max(allPoints(:,2))+margin];
    zlims = [min(allPoints(:,3))-margin, max(allPoints(:,3))+margin];
    
    % 
    tiledlayout_handle = tiledlayout(fig2, 'flow', 'TileSpacing', 'tight', 'Padding', 'tight');
    title(tiledlayout_handle, [file_name(1:end-4) ' - Cylinder Local Views'], 'FontSize', 12);
    
    for cylIdx = 1:numel(newCylinders)
        cyl = newCylinders{cylIdx};
        
        % 
        ax = nexttile(tiledlayout_handle);
        
        % 
        cylPoints = cyl.dataPoints;
        cylMargin = max(range(cylPoints)) * 1; % 
        
        % 
        scatter3(ax, data1(:,1), data1(:,2), data1(:,3), 10, [0.7 0.7 0.7], 'filled', 'MarkerEdgeAlpha', 0.1, 'MarkerFaceAlpha', 0.1);
        hold(ax, 'on');
        
        % 
        scatter3(ax, cylPoints(:,1), cylPoints(:,2), cylPoints(:,3), 20, 'r', 'filled');
        
        % 
        [cylX, cylY, cylZ] = cylinderMesh(cyl.bestA, cyl.bestB, cyl.bestRadius, 20);
        surf(ax, cylX, cylY, cylZ, 'FaceColor', 'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
        
        % 
        for otherIdx = 1:numel(newCylinders)
            if otherIdx == cylIdx, continue; end
            otherCyl = newCylinders{otherIdx};
            [otherX, otherY, otherZ] = cylinderMesh(otherCyl.bestA, otherCyl.bestB, otherCyl.bestRadius, 10);
            surf(ax, otherX, otherY, otherZ, 'FaceColor', 'c', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
        end
        
        % 
        midPoint = (cyl.bestA + cyl.bestB)/2;
        axis(ax, 'equal');
        xlim(ax, [midPoint(1)-cylMargin, midPoint(1)+cylMargin]);
        ylim(ax, [midPoint(2)-cylMargin, midPoint(2)+cylMargin]);
        zlim(ax, [midPoint(3)-cylMargin, midPoint(3)+cylMargin]);
        
        % 
        length = norm(cyl.bestB - cyl.bestA);
        title(ax, sprintf('Cyl %d: L=%.1f, R=%.1f', cylIdx, length, cyl.bestRadius), 'FontSize', 10);
        
        % 
        view(ax, -30, 30);  
        grid(ax, 'on');
        box(ax, 'on');
    end
    
    
    local_fig_name = fullfile('saved_figures', [file_name(1:end-4) '_cut_local_views.fig']);
    savefig(fig2, local_fig_name);
    % close(fig2);
end

%%

[unique_coords, ~, ic] = unique(data1, 'rows', 'stable'); 
counts = accumarray(ic, 1); 


area1_loc_with_counts = [unique_coords, counts]; 
pointCloud = area1_loc_with_counts(:, 1:3) * 3;  
R = 10; 

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

%% 保存结果
save('.\saved_variables\area1_density_results.mat', 'points', 'counts', 'normalized_density', 'R');

%% 
function [X, Y, Z] = cylinderMesh(A, B, R, n)
    
    direction = B - A;
    height = norm(direction);
    if height < eps  
        direction = [0 0 1];
        height = 1;
    end
    z_unit = direction / height;
    
  
    [cx, cy, cz] = cylinder(R, n);
    cz = cz * height; 
    

    X = zeros(size(cx));
    Y = zeros(size(cy));
    Z = zeros(size(cz));
    
    for i = 1:size(cx, 1)
        for j = 1:size(cx, 2)
        
            local_point = [cx(i,j), cy(i,j), cz(i,j)];
            
  
            up = [0 0 1];
            axis = cross(up, z_unit);
            if norm(axis) < eps
                axis = [1 0 0];
            end
            axis = axis / norm(axis);
            angle = acos(dot(up, z_unit));
            
           
            rotated_point = local_point*cos(angle) + ...
                           cross(axis, local_point)*sin(angle) + ...
                           axis*dot(axis, local_point)*(1-cos(angle));
            
            final_point = rotated_point + A;
            
            X(i,j) = final_point(1);
            Y(i,j) = final_point(2);
            Z(i,j) = final_point(3);
        end
    end
end

function cleaned_data = removeDuplicatePoints(new_datak)

    
 
    tol = 1e-5;
    
  
    rounded_points = round(new_datak * (1/tol)) * tol;
    

    [~, unique_indices] = unique(rounded_points, 'rows', 'stable');
    
   
    cleaned_data = new_datak(sort(unique_indices), :);
end