clear all; close all;
load('3d_cluster_area1_loc.mat'); 
data=area1_loc_ori;
data_ori = data;
epsilon =5;
minPts = 20;
[idx, C] = dbscan(data_ori, epsilon, minPts);

num_clusters = max(idx);

outters=find(idx==-1)
data(outters,:)=[];
idx_ori=idx;
idx(outters,:)=[];
area1_loc = data; 
idx640 = idx; 
%all_labels = idx_ori; 
save('3d_cluster_area1_loc.mat', 'area1_loc', 'idx640', '-append');
disp('saved into 3d_cluster_area1_loc.mat');

%colors = rand(num_clusters, 3);
%figure;
%scatter_colors = colors(idx, :);
%scatter3(data_ori(:,1)*3, data_ori(:,2)*3, data_ori(:,3)*3, 10, 'filled','black');    
%hold on
%scatter3(data(:,1)*3, data(:,2)*3, data(:,3)*3, 10, scatter_colors, 'filled');
%text(0.02, 0.98, 0.98, sprintf('\\epsilon = %d\nminPts = %d', epsilon, minPts), ...
    %'Units', 'normalized', ...
    %'VerticalAlignment', 'top', ...
    %'HorizontalAlignment', 'left', ...
    %'FontSize', 11, ...
    %'BackgroundColor', 'white', ...
    %'EdgeColor', 'black');
%axis equal

%figure;
%scatter3(data(:,1)*3, data(:,2)*3, data(:,3)*3, 10, scatter_colors, 'filled');
%text(0.02, 0.98, 0.98, sprintf('\\epsilon = %d\nminPts = %d', epsilon, minPts), ...
    %'Units', 'normalized', ...
    %'VerticalAlignment', 'top', ...
    %'HorizontalAlignment', 'left', ...
    %'FontSize', 11, ...
    %'BackgroundColor', 'white', ...
    %'EdgeColor', 'black');
%axis equal

% 加上彩色注释条



