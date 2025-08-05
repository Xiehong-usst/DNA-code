function clusters = findClusters(data)
  
    clusterIndices = dbscan(data, 5, 1);

 
    uniqueClusters = unique(clusterIndices);
  
    uniqueClusters(uniqueClusters == -1) = [];
    
    clusters = cell(length(uniqueClusters), 1);
    for k = 1:length(uniqueClusters)
        clusters{k} = data(clusterIndices == uniqueClusters(k), :);
    end
end
