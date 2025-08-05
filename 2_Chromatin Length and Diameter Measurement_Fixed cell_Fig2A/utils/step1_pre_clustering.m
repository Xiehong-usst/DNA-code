% close all
% clear all

% 获取当前文件夹中所有.mat文件
matFiles = dir('*.mat');

% 找到名字中包含 'area' 的文件，并提取数字
filePattern = 'area(\d+)_loc_time.mat';
for i = 1:length(matFiles)
    tokens = regexp(matFiles(i).name, filePattern, 'tokens');
    if ~isempty(tokens)
        areaNumber = tokens{1}{1};  % 提取到的数字
        break;
    end
end

% 加载对应的 .mat 文件
fileName = ['area' areaNumber '_loc_time.mat'];
load(fileName);

% 假设 areaX_loc 是你的数据集，其中包括 x、y、z 坐标3
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
set(gcf,'color','white'); %窗口背景白色
colordef white; %2D/3D图背景黑色
colormap jet

% 调整参数
epsilon = 12;  % 领域半径
minPoints = 8;  % 最小点数

% 使用 DBSCAN 算法进行聚类
idx = dbscan(pointCloud, epsilon, minPoints);

% 删除噪声点（idx 为 -1 的点）
validIndices = find(idx ~= -1);
eval(['area' areaNumber '_loc = area' areaNumber '_loc(validIndices, :);']);
eval(['area' areaNumber '_ratio = area' areaNumber '_ratio(validIndices, :);']);
idx_all = idx(validIndices, :);
eval(['area' areaNumber '_idx = idx_all;']);

% 绘制降噪前的点
figure;
scatter3(pointCloud(:,1), pointCloud(:,2), pointCloud(:,3),5, 'k.');
title('Before Noise Removal');
xlabel('X');
ylabel('Y');
zlabel('Z');
hold on;
% 构建字符串表达式
area_idx_expr = sprintf('area%s_idx', areaNumber);

% 根据 areaNumber 动态获取对应的聚类索引
eval(['area_idx = ' area_idx_expr ';']);

% 计算聚类的数量
num_clusters = max(area_idx);

% 生成随机颜色
colors = rand(num_clusters, 3);

% 根据聚类索引获取颜色
scatter_colors = colors(area_idx, :);
eval(['scatter3(area' areaNumber '_loc(:,1) * 3, area' areaNumber '_loc(:,2) * 3, area' areaNumber '_loc(:,3) * 3, 5, scatter_colors, ''filled'');']);

title('After Noise Removal and Clustering');
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal
set(gcf,'color','white'); %窗口背景白色
colordef white; %2D/3D图背景黑色
axis equal
 
% 保存结果
saveFileName = ['area' areaNumber '_loc_idx.mat'];
eval(['save(saveFileName, ''area' areaNumber '_loc'', ''area' areaNumber '_ratio'', ''area' areaNumber '_idx'', ''intersection_x'');']);
% eval(['save(saveFileName, ''area' areaNumber '_loc'', ''area' areaNumber '_ratio'', ''area' areaNumber '_idx'');']);