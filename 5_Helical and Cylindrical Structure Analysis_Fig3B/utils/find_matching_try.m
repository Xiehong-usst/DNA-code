load('3d_cluster_Fig3B20230407area5_6100_demo1.mat', 'data');
data_new1 = data([2 3 4 6 7 8 12 13],:);
findNucleosome(filename, data_new1);


figure;
scatter3(data(:,1),data(:,2),data(:,3));
figure;
scatter3(data_new1(:,1),data_new1(:,2),data_new1(:,3));

[matched_points, transform_info] = find_matching_points(data, data_new1);

