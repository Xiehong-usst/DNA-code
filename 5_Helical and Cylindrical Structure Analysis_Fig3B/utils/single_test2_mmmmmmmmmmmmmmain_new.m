close all;
filename = '6100';
load('20230407area5-6100-try1');
for k = 31:31
    data3 = data3_list{k};
    findNucleosome(filename, data3);
    figure;
    data4 = [];
    for r = 1:size(data3,1)
        v1 = data3(r,:);
        v2 = data1 - v1;
        q1 = sum(v2'.^2);
        [n1] = find(q1 <= 6^2);
        data4 = [data4; data1(n1,:)];
    end
    xd1 = min(data3,[],1);
    scatter3(data4(:,1),data4(:,2),data4(:,3),'k','filled');
    hold on;
    scatter3(data3(:,1),data3(:,2),data3(:,3),'red','filled');
    axis equal;
    save_path = sprintf('./results/live/params/%s.mat', filename);
    load('./results/live/params/6100.mat');
    save(save_path, 'data4', 'data3_list', 'bestR_list', 'data_new1', 'X_cylinder', 'Y_cylinder', 'Z_cylinder', 'P1', 'P2', 'xd1');
end