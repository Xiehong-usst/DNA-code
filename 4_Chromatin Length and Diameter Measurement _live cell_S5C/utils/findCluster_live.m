function clusters = findCluster_live(data)

    clusterIndices = dbscan(data,10, 1);


    uniqueClusters = unique(clusterIndices);
 
    uniqueClusters(uniqueClusters == -1) = [];
    
    clusters = cell(length(uniqueClusters), 1);
    for k = 1:length(uniqueClusters)
        clusters{k} = data(clusterIndices == uniqueClusters(k), :);
    end
end
