
file_list = dir('3d*.mat');


if ~exist('saved_figures', 'dir')
   mkdir('saved_figures');
end

if ~exist('saved_variables', 'dir')
   mkdir('saved_variables');
end



for idx = 1:length(file_list)
    file_name = file_list(idx).name;
    data1 = loadDataAndProcess(file_name);

    fprintf('Processing file: %s\n', file_name);

  
    d = 3;
    h = 10;
    q = 5;
    
  
    [X,Y,Z,gradient_magnitude] = compute_gradient_magnitude(data1, d, h, q);
    
   
    save_name_gradient = fullfile('saved_variables', [file_name(1:end-4) '_edge_d3_h10_q5.mat']);
    save(save_name_gradient, 'gradient_magnitude');

 
    cutoff = 1.2*10^(-4);
    
 
    X1 = X(gradient_magnitude > cutoff);
    Y1 = Y(gradient_magnitude > cutoff);
    Z1 = Z(gradient_magnitude > cutoff);
    new_edge = gradient_magnitude(gradient_magnitude > cutoff);
    
  
    n1 = numel(X1);
    X1 = reshape(X1,[1,n1]);
    Y1 = reshape(Y1,[1,n1]);
    Z1 = reshape(Z1,[1,n1]);
    data2 = [X1; Y1; Z1];
    
   
    clusters = findClusters(data2');
    
   
    new_clusters = [];
    k1 = 0;
    for k = 1:numel(clusters)
        if size(clusters{k},1) > 64/4*pi*8  
            k1 = k1 + 1;
            new_clusters{k1} = clusters{k};
        end
    end

  
    num_clusters = length(new_clusters);
    colors = jet(num_clusters);
    figure;
    scatter3(data1(:,1), data1(:,2), data1(:,3), [], [0 0 0], 'filled');
    hold on;
    for k = 1:num_clusters
        cluster_data = new_clusters{k};
        scatter3(cluster_data(:, 1), cluster_data(:, 2), cluster_data(:, 3), [], colors(k, :), 'filled', 'MarkerFaceAlpha', 0.9, 'MarkerEdgeAlpha', 0.9);
    end
    xlabel('X-axis');
    ylabel('Y-axis');
    zlabel('Z-axis');
    title(['3D Scatter plot of clusters from ' file_name]);
    grid on;
    view(3);
    hold off;
    
   
    fig_name = fullfile('saved_figures', [file_name(1:end-4) '_scatter_clusters.fig']);
    savefig(fig_name);
    
  
    allCylinders = {};
    for k = 1:num_clusters
        fprintf(['\n']);
        fprintf(['Cluster' num2str(k) '\n']);
        cylinders = recursiveCylinderFitting(new_clusters{k});
        allCylinders = [allCylinders, cylinders];
    end
    
    
    save_name_cylinders = fullfile('saved_variables', [file_name(1:end-4) '_multi_fit_all.mat']);
    save(save_name_cylinders, 'allCylinders');

   
    new_data1 = [];
    for k = 1:numel(allCylinders)
        datak = allCylinders{k}.dataPoints;
        for r = 1:size(datak,1)
            r1 = datak(r,:);
            d1 = (data1(:,1) - r1(1)).^2+(data1(:,2) - r1(2)).^2+(data1(:,3) - r1(3)).^2;
            if min(d1) <= 6.75
                n1 = find(d1 == min(d1));
                new_data1 = [new_data1; data1(n1,:)];
            end
        end
    end

   
    fig = figure;
    plotAllCylinders(allCylinders);
    lengths = getCylinderLengths(allCylinders);
    radii = getCylinderRadii(allCylinders);
    scatter3(new_data1(:,1), new_data1(:,2), new_data1(:,3), 'k', 'filled');
    
   
    fprintf('lengths:\n');
    disp(lengths);
    fprintf('radii\n');
    disp(radii);
    
   
    variables_filename = fullfile('saved_variables', [file_name(1:end-4) '_multi_fit_single.mat']);
    fig_filename = fullfile('saved_figures', [file_name(1:end-4) '_cylinders_visualization.fig']);
    
    
    savefig(fig, fig_filename);
    
    
    save(variables_filename, 'allCylinders', 'lengths', 'radii');
end
