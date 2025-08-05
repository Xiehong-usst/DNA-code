% close all
% clear all
matFiles = dir('*.mat');


filePattern = 'area(\d+)_loc_time.mat';
for i = 1:length(matFiles)
    tokens = regexp(matFiles(i).name, filePattern, 'tokens');
    if ~isempty(tokens)
        areaNumber = tokens{1}{1};  
        break;
    end
end


fileName = ['area' areaNumber '_loc_time.mat'];
load(fileName);


eval(['pointCloud = area' areaNumber '_loc * 3;']);
eval(['area' areaNumber '_loc_ori = area' areaNumber '_loc;']);

a=pointCloud;
R=30;  % 25nm
normalized_Free_Energy_map=[];
for idx=1:length(a(:,1))
Distances = sqrt( sum( (a-a(idx,:)).^2 ,2) );
Ninside   = length( find(Distances<=R) );
normalized_Free_Energy_map(idx) = Ninside/(4*pi*R.^3/3);
end
figure
scatter3(a(:,1),a(:,2),a(:,3),5,normalized_Free_Energy_map','filled');
axis equal
set(gcf,'color','white'); 
colordef white; 
colormap jet


epsilon = 12; 
minPoints = 8;  


idx = dbscan(pointCloud, epsilon, minPoints);


validIndices = find(idx ~= -1);
eval(['area' areaNumber '_loc = area' areaNumber '_loc(validIndices, :);']);
eval(['area' areaNumber '_ratio = area' areaNumber '_ratio(validIndices, :);']);
idx_all = idx(validIndices, :);
eval(['area' areaNumber '_idx = idx_all;']);


figure;
scatter3(pointCloud(:,1), pointCloud(:,2), pointCloud(:,3),5, 'k.');
title('Before Noise Removal');
xlabel('X');
ylabel('Y');
zlabel('Z');
hold on;

area_idx_expr = sprintf('area%s_idx', areaNumber);


eval(['area_idx = ' area_idx_expr ';']);


num_clusters = max(area_idx);


colors = rand(num_clusters, 3);


scatter_colors = colors(area_idx, :);
eval(['scatter3(area' areaNumber '_loc(:,1) * 3, area' areaNumber '_loc(:,2) * 3, area' areaNumber '_loc(:,3) * 3, 5, scatter_colors, ''filled'');']);

title('After Noise Removal and Clustering');
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal
set(gcf,'color','white'); 
colordef white;
axis equal
 
saveFileName = ['area' areaNumber '_loc_idx.mat'];
eval(['save(saveFileName, ''area' areaNumber '_loc'', ''area' areaNumber '_ratio'', ''area' areaNumber '_idx'', ''intersection_x'');']);
% eval(['save(saveFileName, ''area' areaNumber '_loc'', ''area' areaNumber '_ratio'', ''area' areaNumber '_idx'');']);